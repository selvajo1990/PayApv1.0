table 50046 "Pension"
{
    DataClassification = CustomerContent;
    Caption = 'Pension/PASI/GOSI';
    LookupPageId = "Pension List";
    fields
    {
        field(1; "Employer Country"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Employer Country';
            TableRelation = "Country/Region";
            trigger OnValidate()
            begin
                "Effective From" := 0D;
                "Effective Till" := 0D;
            end;
        }
        field(2; "Employee Country"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Employee Country';
            TableRelation = "Country/Region";
            trigger OnValidate()
            begin
                "Effective From" := 0D;
                "Effective Till" := 0D;
            end;
        }
        field(3; "Effective From"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Effective From';
            trigger OnValidate()
            var
                PensionL: Record Pension;
            begin
                TestField("Employer Country");
                TestField("Employee Country");
                PensionL.SetRange("Employer Country", "Employer Country");
                PensionL.SetRange("Employee Country", "Employee Country");
                if PensionL.FindFirst() then begin
                    PensionL."Effective Till" := CalcDate('<-1D>', Rec."Effective From");
                    PensionL.Modify()
                end;
            end;
        }
        field(4; "Effective Till"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Effective Till';
            Editable = false;
        }
        field(5; "Employer Computation"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Employer Computation';
        }
        field(6; "Employee Computation"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Employee Computation';
        }
        field(7; "Minimum Age"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Minimum Age';
            MinValue = 0;
            MaxValue = 100;
        }
        field(8; "Maximum Age"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Maximum Age';
            MinValue = 0;
            MaxValue = 100;
        }
        field(9; "Employer Deduction"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Employer Deduction';
            MinValue = 0;
        }
        field(10; "Employee Deduction"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Employee Deduction';
            MinValue = 0;
        }
        field(11; "Employer Difference"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Employer Difference';
            MinValue = 0;
        }
        field(12; "Employee Difference"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Employee Difference';
            MinValue = 0;
        }
        field(13; "Minimum Salary"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Minimum Salary';
            MinValue = 0;
        }
        field(14; "Maximum Salary"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Maximum Salary';
            MinValue = 0;
        }
    }

    keys
    {
        key(PK; "Employer Country", "Employee Country", "Effective From")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin

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

}