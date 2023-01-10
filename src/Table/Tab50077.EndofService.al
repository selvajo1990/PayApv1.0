table 50077 "End of Service"
{
    DataClassification = CustomerContent;
    Caption = 'End of Service';
    fields
    {
        field(1; "End of Service No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'End of Service No.';
        }
        field(21; "Employee No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Employee No.';
            TableRelation = Employee;
            trigger OnValidate()
            begin
                CalcFields("Employee Name");
            end;
        }
        field(22; "Employee Name"; Text[50])
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Employee."First Name" where("No." = field("Employee No.")));
            Editable = false;
        }
        field(23; "Reason Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Reason Code';
            TableRelation = "Reason Code";
        }
        field(24; "Last Working Day"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Last Working Day';
            Editable = false;
        }
        field(25; "Total Earnings"; Decimal)
        {
            FieldClass = FlowField;
            Caption = 'Total Earning';
            CalcFormula = sum("Salary Computation Line".Amount where("Computation No." = field("End of Service No."), "Affects Salary" = filter(true)));
            Editable = false;
        }
        field(26; "Total Accurals"; Decimal)
        {
            FieldClass = FlowField;
            Caption = 'Total Accruals';
            CalcFormula = sum("Salary Computation Line".Amount where("Computation No." = field("End of Service No."), Type = filter("Employer Contribution" | " "), Category = filter(Deduction | Absence | Earning)));
            Editable = false;
        }
        field(27; "Total Pay"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Total Pay';
        }
        field(28; "Posting Status"; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Posting Status';
            OptionMembers = "Open","Journal Created","Posted";
            Editable = false;
        }
    }

    keys
    {
        key(PK; "End of Service No.")
        {
            Clustered = true;
        }
    }

    var
        HrSetupG: Record "Human Resources Setup";
        NoSeriesMgtG: Codeunit NoSeriesManagement;
        NoSeriesG: Code[20];

    trigger OnInsert()
    begin
        IF "End of Service No." = '' THEN BEGIN
            HrSetupG.Get();
            HrSetupG.TESTFIELD("End of Service Nos.");
            NoSeriesMgtG.InitSeries(HrSetupG."End of Service Nos.", '', 0D, "End of Service No.", NoSeriesG);
        END;
    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    var
        Employee: Record Employee;
    begin
        if "Employee No." > '' then begin
            Employee.Get("Employee No.");
            Employee."Notice Period Start Date" := 0D;
            Clear(Employee."Notice Period");
            Employee."Termination Date" := 0D;
            Employee.Modify(true);
        end;
    end;

    trigger OnRename()
    begin

    end;

    procedure AssisEdit(): Boolean
    begin
        HrSetupG.Get();
        HrSetupG.TESTFIELD("End of Service Nos.");
        IF NoSeriesMgtG.SelectSeries(HrSetupG."End of Service Nos.", '', NoSeriesG) THEN BEGIN
            NoSeriesMgtG.SetSeries("End of Service No.");
            EXIT(TRUE);
        END;
    end;
}