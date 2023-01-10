table 50087 "Travel Req & Expense Claim"
{
    DataClassification = ToBeClassified;
    Caption = 'Travel Requisition & Expense Claim';
    LookupPageId = 50130;
    DrillDownPageId = 50130;
    fields
    {
        field(1; "No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'No.';
        }
        field(21; "Employee No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Employee No.';
            TableRelation = Employee;
            trigger OnValidate()
            var
                Employee: Record Employee;
                ClaimLine: Record "Travel Req. & Exp. Claim Line";
                ConfirmationErr: Label 'Realted Claim lines will be removed for employee no. %1. Do you want to continue ?';
            begin
                CalcFields("Employee Name");
                "Travel & Expense Group Code" := '';
                "Advance No." := '';

                if Rec."Employee No." <> xRec."Employee No." then begin
                    if (xRec."Advance No." > '') and ("Advance No." = '') then
                        Validate("Advance No.");
                    ClaimLine.SetRange("Document No.", "No.");
                    if not ClaimLine.IsEmpty() then
                        if not Confirm(ConfirmationErr, true, xRec."Employee No.") then
                            Error('')
                        else
                            ClaimLine.DeleteAll(true);
                end;

                if Employee.Get("Employee No.") then begin
                    Employee.TestField("Travel & Expense Group");
                    "Travel & Expense Group Code" := Employee."Travel & Expense Group";
                end;
            end;
        }
        field(22; "Employee Name"; Text[100])
        {
            Caption = 'Employee Name';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup(Employee."First Name" where("No." = field("Employee No.")));
        }
        field(23; "Advance No."; Code[20])
        {
            Caption = 'Advance No.';
            DataClassification = CustomerContent;
            TableRelation = "Travel & Expense Advance" where("Employee No." = field("Employee No."), "Assigned in Claim" = filter('No'));
            trigger OnValidate()
            var
                Advance: Record "Travel & Expense Advance";
            begin
                if "Advance No." = '' then begin
                    if Advance.Get(xRec."Advance No.") then
                        Advance."Assigned in Claim" := false;
                end else begin
                    Advance.Get("Advance No.");
                    Advance."Assigned in Claim" := true;
                end;
                Advance.Modify();
            end;
        }
        field(24; "From Date"; Date)
        {
            Caption = 'From Date';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                "To Date" := 0D;
            end;
        }
        field(25; "To Date"; Date)
        {
            Caption = 'To Date';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                TestField("From Date");
                if ("From Date" > "To Date") then
                    Error(StrSubstNo(DateErr, FieldCaption("From Date"), FieldCaption("To Date")));

                "No. of Days" := "To Date" - "From Date" + 1;
            end;
        }
        field(26; "Pay with Salary"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(27; "No. of Days"; Integer)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(28; "Claim Date"; Date)
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                LoanRequest: Record "Loan Request";
                Employee: Record employee;
                Advance: Record "Travel & Expense Advance";
            begin
                if "Claim Date" > 0D then begin
                    LoanRequest.IsPayPeriodClosed("Claim Date", "Employee No.", '');
                    Employee.Get(Rec."Employee No.");
                    Employee.TestField("Employment Date");
                    if "Claim Date" < Employee."Employment Date" then
                        Error(StrSubstNo(DateErr, FieldCaption("Claim Date"), Employee.FieldCaption("Employment Date")));
                    if ("Claim Date" < "Approved Date") and ("Approved Date" > 0D) then
                        Error(StrSubstNo(DateErr, FieldCaption("Claim Date"), FieldCaption("Approved Date")));

                    if Advance.Get("Advance No.") then begin
                        Advance.TestField("Approved Date");
                        if "Claim Date" < Advance."Approved Date" then
                            Error(StrSubstNo(DateErr, FieldCaption("Claim Date"), 'Advance ' + Advance.FieldCaption("Approved Date")));
                    end;
                end;
            end;

        }
        field(29; "Approved Date"; Date)
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                TestField("Claim Date");
                TestField("Approved Date");
                if ("Approved Date" < "Claim Date") then
                    Error(StrSubstNo(DateErr, FieldCaption("Approved Date"), FieldCaption("Claim Date")));

            end;

        }
        field(30; "Amount Payable"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Travel Req. & Exp. Claim Line"."Payable Amount (LCY)" where("Document No." = field("No.")));
            Editable = false;
        }
        field(31; "Journal Created"; Boolean)
        {
            DataClassification = CustomerContent;
            Description = 'Development usage';
        }
        field(32; "Travel & Expense Group Code"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Travel & Expense Group";
        }
        field(33; "Amount Claimed (LCY)"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Travel Req. & Exp. Claim Line"."Amount (LCY)" where("Document No." = field("No.")));
            Editable = false;
        }
        field(34; "Amount Payable (LCY)"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Travel Req. & Exp. Claim Line"."Payable Amount (LCY)" where("Document No." = field("No.")));
            Editable = false;
        }
        field(35; "Outstanding Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(36; "Status"; Option)
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

    var
        TravelSetupG: Record "Travel & Expense Setup";
        Advance: Record "Travel & Expense Advance";
        NoSeriesMgtG: Codeunit NoSeriesManagement;
        NoSeriesG: Code[20];
        DateErr: Label '%1 can''t be earlier than %2';

    trigger OnInsert()
    begin
        if "No." = '' then begin
            TravelSetupG.Get();
            TravelSetupG.TESTFIELD("Travel Req. & Exp. Claim Nos.");
            NoSeriesMgtG.InitSeries(TravelSetupG."Travel Req. & Exp. Claim Nos.", '', 0D, "No.", NoSeriesG);
        END;
    end;

    trigger OnModify()
    begin
        if xRec.Status <> xRec.Status::Open then
            TestField(Status, Status::Open);
    end;

    trigger OnDelete()
    begin
        TestField(Status, Status::Open);
        if Rec."Advance No." > '' then begin
            Advance.Get("Advance No.");
            Advance."Assigned in Claim" := false;
            Advance.Modify();
        end;
    end;

    trigger OnRename()
    begin

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