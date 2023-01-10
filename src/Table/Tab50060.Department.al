table 50060 "Department"
{
    DataClassification = CustomerContent;
    Caption = 'Department';
    LookupPageId = Departments;
    fields
    {
        field(1; "Department Code"; Code[20])
        {
            Caption = 'Department Code';
            DataClassification = CustomerContent;
        }
        field(2; "Description"; Text[50])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(3; "Department Head"; Code[20])
        {
            Caption = 'Department Head';
            DataClassification = CustomerContent;
            TableRelation = Employee."No.";

            trigger OnValidate()
            var
                EmployeeL: Record Employee;
            begin
                EmployeeL.Reset();
                EmployeeL.SetRange("No.", "Department Head");
                if EmployeeL.FindFirst() then
                    Rec."Department Head Name" := EmployeeL."First Name";
            end;
        }
        field(4; "No. of Employee"; Integer)
        {
            Caption = 'No. of Employee';
            FieldClass = FlowField;
            CalcFormula = count("Designation" where(Department = field("Department Code"), "Position Assigned" = filter(true)));
            Editable = false;
        }
        field(5; "Department Head Name"; Text[50])
        {
            Caption = 'Department Head Name';
            FieldClass = FlowField;
            CalcFormula = lookup(Employee."First Name" where("No." = field("Department Head")));
        }
        field(6; "HR Manager"; Code[20])
        {
            Caption = 'HR Manager';
            DataClassification = CustomerContent;
            TableRelation = Employee."No.";
        }
    }

    keys
    {
        key(PK; "Department Code")
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