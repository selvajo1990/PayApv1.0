table 50091 "Travel & Expense Advance"
{
    DataClassification = CustomerContent;
    Caption = 'Travel & Expense Advance';
    LookupPageId = 60023;
    DrillDownPageId = 60023;

    fields
    {
        field(1; "No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'No.';
        }
        field(21; "Document Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Document Date';
            trigger OnValidate()
            var
                LoanRequest: Record "Loan Request";
                Employee: Record Employee;
            begin
                if ("Amount (FCY)" > 0) and ("Document Date" > 0D) and ("Currency Code" > '') then
                    "Amount (LCY)" := GetConvertedCurrencyAmount("Amount (FCY)", "Currency Code", "Document Date");

                if "Document Date" > 0D then begin
                    LoanRequest.IsPayPeriodClosed("Document Date", "Employee No.", '');
                    Employee.Get(Rec."Employee No.");
                    Employee.TestField("Employment Date");
                    if "Document Date" < Employee."Employment Date" then
                        Error(StrSubstNo(DateErr, FieldCaption("Document Date"), Employee.FieldCaption("Employment Date")));
                    if ("Document Date" < "Approved Date") and ("Approved Date" > 0D) then
                        Error(StrSubstNo(DateErr, FieldCaption("Document Date"), FieldCaption("Approved Date")));
                end;
            end;
        }
        field(22; "Employee No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Employee No.';
            TableRelation = Employee;
            trigger OnValidate()
            begin
                CalcFields("Employee Name");
            end;
        }
        field(23; "Employee Name"; Text[250])
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Employee."First Name" where("No." = field("Employee No.")));
            Editable = false;
        }
        field(24; "Destination Code"; Code[20])
        {
            Caption = 'Destination Code';
            TableRelation = Destination;
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                Destinations: Record Destination;
            begin
                if Destinations.Get("Destination Code") then;
                Destination := Destinations.City;
            end;
        }
        field(25; "Destination"; Text[100])
        {
            Caption = 'Destination';
            DataClassification = CustomerContent;
        }
        field(26; "Purpose of Visit"; Code[20])
        {
            Caption = 'Purpose of Visit';
            DataClassification = CustomerContent;
            TableRelation = "Purpose of Visit";
            trigger OnValidate()
            var
                PurposeVisit: Record "Purpose of Visit";
            begin
                if PurposeVisit.Get("Purpose of Visit") then;
                "Purpose of Visit Description" := PurposeVisit.Description;
            end;
        }
        field(27; "Purpose of Visit Description"; Text[250])
        {
            Caption = 'Purpose of Visit Description';
            DataClassification = CustomerContent;
        }
        field(28; "Expense Category Code"; Code[20])
        {
            Caption = 'Expense Category Code';
            DataClassification = CustomerContent;
            TableRelation = "Expense Category" where("Travel Type" = filter(Advance));
            trigger OnValidate()
            var
                ExpenseCategory: Record "Expense Category";
            begin
                if ExpenseCategory.Get("Expense Category Code") then;
                "Expense Category Description" := ExpenseCategory.Description;
            end;
        }
        field(29; "Expense Category Description"; Text[100])
        {
            Caption = 'Expense Category Description';
            DataClassification = CustomerContent;
        }
        field(30; "Amount (LCY)"; Decimal)
        {
            Caption = 'Amount (LCY)';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(31; "Pay With Salary"; Boolean)
        {
            Caption = 'Pay With Salary';
            DataClassification = CustomerContent;
        }
        field(32; "Assigned in Claim"; Boolean)
        {
            Description = 'For develpment usage only';
            DataClassification = CustomerContent;
        }
        field(33; "Currency Code"; Code[20])
        {
            Description = 'Currency Code';
            DataClassification = CustomerContent;
            TableRelation = Currency;
            trigger OnValidate()
            begin
                TestField("Document Date");
                if (("Amount (FCY)" > 0) and ("Currency Code" > '')) then
                    "Amount (LCY)" := GetConvertedCurrencyAmount("Amount (FCY)", "Currency Code", "Document Date");
            end;
        }
        field(34; "Amount (FCY)"; Decimal)
        {
            Description = 'Amount (FCY)';
            DataClassification = CustomerContent;
            MinValue = 0;
            trigger OnValidate()
            begin
                if "Amount (FCY)" > 0 then begin
                    TestField("Currency Code");
                    TestField("Document Date");
                    "Amount (LCY)" := GetConvertedCurrencyAmount("Amount (FCY)", "Currency Code", "Document Date");
                end;
            end;
        }
        field(35; "Approved Date"; Date)
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                TestField("Document Date");
                TestField("Approved Date");
                if ("Approved Date" < "Document Date") then
                    Error(StrSubstNo(DateErr, FieldCaption("Approved Date"), FieldCaption("Document Date")));
            end;
        }
        field(36; "Journal Created"; Boolean)
        {
            DataClassification = CustomerContent;
            Description = 'Development usage';
        }
        field(37; "Status"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = Open,Approved,"Pending Approval",Rejected;
            OptionCaption = 'Open,Approved,Pending Approval,Rejected';
            Caption = 'Status';
        }
    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; "No.", Destination, "Purpose of Visit Description")
        {

        }
        fieldgroup(Brick; "No.", Destination, "Purpose of Visit Description")
        {

        }
    }
    var
        TravelSetupG: Record "Travel & Expense Setup";
        NoSeriesMgtG: Codeunit NoSeriesManagement;
        NoSeriesG: Code[20];
        AdvanceExistErr: Label 'Advance No. %1 is attached with Claim No. %2. You are not allowed to delete';
        DateErr: Label '%1 can''t be earlier than %2';

    trigger OnInsert()
    begin
        if "No." = '' then begin
            TravelSetupG.Get();
            TravelSetupG.TESTFIELD("Travel & Expense Advance Nos.");
            NoSeriesMgtG.InitSeries(TravelSetupG."Travel & Expense Advance Nos.", '', 0D, "No.", NoSeriesG);
        end;
    end;

    trigger OnModify()
    begin
        if xRec.Status <> xRec.Status::Open then
            TestField(Status, Status::Open);
    end;

    trigger OnDelete()
    begin
        TestField(Status, Status::Open);
        ClaimHdr.SetRange("Advance No.", Rec."No.");
        if ClaimHdr.FindFirst() then
            Error(StrSubstNo(AdvanceExistErr, Rec."No.", ClaimHdr."No."));
    end;

    trigger OnRename()
    begin

    end;

    var
        ClaimHdr: Record "Travel Req & Expense Claim";

    procedure GetConvertedCurrencyAmount(Amount: Decimal; FromCurrency: Code[10]; Date: Date): Decimal
    var
        ExchangeRate: Record "Currency Exchange Rate";
        GeneralLedgerSetup: Record "General Ledger Setup";
        Currency: Record Currency;
    begin
        GeneralLedgerSetup.Get();
        GeneralLedgerSetup.TestField("LCY Code");
        Currency.get(GeneralLedgerSetup."LCY Code");
        exit(Round(ExchangeRate.ExchangeAmount(Amount, FromCurrency, GeneralLedgerSetup."LCY Code", Date), Currency."Amount Rounding Precision"));
    end;

    procedure AssisEdit(): Boolean
    begin
        TravelSetupG.Get();
        TravelSetupG.TESTFIELD("Travel & Expense Advance Nos.");
        IF NoSeriesMgtG.SelectSeries(TravelSetupG."Travel & Expense Advance Nos.", '', NoSeriesG) THEN BEGIN
            NoSeriesMgtG.SetSeries(TravelSetupG."Travel & Expense Advance Nos.");
            EXIT(TRUE);
        END;
    end;
}