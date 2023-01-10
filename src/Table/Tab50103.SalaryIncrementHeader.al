table 50103 "Salary Increment Header"
{
    DataClassification = CustomerContent;
    Caption = 'Salary Increment Header';

    fields
    {
        field(1; "No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'No.';
            trigger OnValidate()
            begin
                if "No." <> xRec."No." then begin
                    HumanResSetup.Get();
                    NoSeriesMgt.TestManual(HumanResSetup."Salary Increment Nos.");
                end;
            end;
        }
        field(21; "Document Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Document Date';
            trigger OnValidate()
            begin
                if "Document Date" > 0D then
                    Validate("Effective Date");
            end;
        }
        field(22; "Effective Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Effective Date';
            trigger OnValidate()
            begin
                if "Effective Date" > 0D then begin
                    TestField("Document Date");
                    if "Effective Date" < "Document Date" then
                        Error(DateErr, FieldCaption("Effective Date"), FieldCaption("Document Date"));
                end;
            end;
        }
        field(23; "Status"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = Open,Approved,"Pending Approval",Rejected;
            OptionCaption = 'Open,Approved,Pending Approval,Rejected';
            Caption = 'Status';
            trigger OnValidate()
            var
                IncrementLine: Record "Salary Increment Line";
                Employee: Record Employee;
                EmployeeLevelEarning: Record "Employee Level Earning";
                EmployeeLevelEarning2: Record "Employee Level Earning";
                xEmployeeNo: Code[20];
                FromDateValidationErr: Label '%1 should not be earlier than %2: %3';
            begin
                if Status = Status::Approved then begin
                    TestField("Effective Date");
                    TestField("Approved Date");
                    IncrementLine.SetRange("Document No.", Rec."No.");
                    if IncrementLine.FindSet() then
                        repeat
                            if xEmployeeNo <> IncrementLine."Employee No." then begin
                                Employee.Get(IncrementLine."Employee No.");
                                if "Effective Date" < Employee."Employment Date" then
                                    Error(FromDateValidationErr, EmployeeLevelEarning.FieldCaption("From Date"), Employee.FieldCaption("Employment Date"), Employee."Employment Date");
                                IncrementLine.TestField(Value);
                                Employee.CreateUpdateEarningGroupLines("Effective Date");
                            end;
                            EmployeeLevelEarning.Get(IncrementLine."Employee No.", IncrementLine."Earning Group Code", "Effective Date", IncrementLine."Earning Code");
                            case true of
                                IncrementLine."Payment Type" = IncrementLine."Payment Type"::Amount:
                                    EmployeeLevelEarning.Validate("Pay Amount", IncrementLine."New Amount");
                                IncrementLine."Payment Type" = IncrementLine."Payment Type"::Percentage:
                                    EmployeeLevelEarning.Validate("Pay Percentage", IncrementLine.Value + EmployeeLevelEarning."Pay Percentage");
                            end;
                            EmployeeLevelEarning.Modify(true);
                            if xEmployeeNo <> IncrementLine."Employee No." then begin
                                EmployeeLevelEarning2.SetRange("Employee No.", Employee."No.");
                                EmployeeLevelEarning2.SetRange("Group Code", IncrementLine."Earning Group Code");
                                EmployeeLevelEarning2.SetRange("From Date", "Effective Date");
                                if EmployeeLevelEarning2.FindSet() then
                                    repeat
                                        EmployeeLevelEarning.SetRange("Employee No.", Employee."No.");
                                        EmployeeLevelEarning.SetRange("Group Code", EmployeeLevelEarning2."Group Code");
                                        EmployeeLevelEarning.SetRange("Earning Code", EmployeeLevelEarning2."Earning Code");
                                        EmployeeLevelEarning.SetRange("To Date", "Effective Date" - 1);
                                        if EmployeeLevelEarning.IsEmpty() then
                                            EmployeeLevelEarning2.Delete(true);
                                    until EmployeeLevelEarning2.Next() = 0;
                            end;
                            xEmployeeNo := IncrementLine."Employee No.";
                        until IncrementLine.Next() = 0;
                end;
            end;
        }
        field(24; "Approved Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Approved Date';
            trigger OnValidate()
            begin
                if "Approved Date" > 0D then begin
                    TestField("Document Date");
                    TestField("Effective Date");
                    if "Approved Date" < "Document Date" then
                        Error(DateErr, FieldCaption("Approved Date"), FieldCaption("Document Date"));
                end;
            end;
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
        HumanResSetup: Record "Human Resources Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        NoSeriesG: Code[20];
        DateErr: Label '%1 can''t be earlier than %2';

    trigger OnInsert()
    begin
        HumanResSetup.Get();
        if "No." = '' then begin
            HumanResSetup.TestField("Salary Increment Nos.");
            NoSeriesMgt.InitSeries(HumanResSetup."Salary Increment Nos.", '', 0D, "No.", NoSeriesG)
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
    end;

    trigger OnRename()
    begin

    end;

    procedure AssistEdit(): Boolean
    begin
        HumanResSetup.Get();
        HumanResSetup.TestField("Salary Increment Nos.");
        if NoSeriesMgt.SelectSeries(HumanResSetup."Salary Increment Nos.", '', NoSeriesG) then begin
            NoSeriesMgt.SetSeries("No.");
            exit(true);
        end;
    end;
}