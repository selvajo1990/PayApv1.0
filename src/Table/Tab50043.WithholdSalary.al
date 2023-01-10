table 50043 "Withhold Salary"
{
    DataClassification = CustomerContent;
    Caption = 'Withhold Salary';
    LookupPageId = "Withhold Salary";
    fields
    {
        field(1; "Withhold No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Withhold No.';
        }
        field(2; "Employee No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Employee No.';
            TableRelation = Employee;
        }
        field(3; "From Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'From Date';
        }
        field(21; "Employee Name"; Text[50])
        {
            Caption = 'Employee Name';
            FieldClass = FlowField;
            CalcFormula = lookup(Employee."First Name" where("No." = field("Employee No.")));
        }
        field(22; "To Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'To Date';
        }
        field(23; Comments; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Comments';
        }

    }

    keys
    {
        key(PK; "Withhold No.", "Employee No.", "From Date")
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
        IF "Withhold No." = '' THEN BEGIN
            HrSetupG.Get();
            HrSetupG.TESTFIELD("Withhold Salary Nos.");
            NoSeriesMgtG.InitSeries(HrSetupG."Withhold Salary Nos.", '', 0D, "Withhold No.", NoSeriesG);
        END;
    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

    procedure AssisEdit(): Boolean
    begin
        HrSetupG.Get();
        HrSetupG.TESTFIELD("Withhold Salary Nos.");
        IF NoSeriesMgtG.SelectSeries(HrSetupG."Withhold Salary Nos.", '', NoSeriesG) THEN BEGIN
            NoSeriesMgtG.SetSeries("Withhold No.");
            EXIT(TRUE);
        END;
    end;
}