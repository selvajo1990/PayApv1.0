table 50129 "Weekly Off"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Employee No."; code[20])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                EmployeeL: Record Employee;
            begin
                if EmployeeL.Get("Employee No.") Then
                    Rec."Employee Name" := EmployeeL."First Name";
            end;
        }
        field(2; "Employee Name"; Text[100])
        {
            //DataClassification = ToBeClassified;
            FieldClass = FlowField;
            CalcFormula = lookup(Employee."First Name" where("No." = field("Employee No.")));
        }
        field(3; "Week Off Date"; Date)
        {

            DataClassification = ToBeClassified;
        }
        field(4; Updated; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Employee No.", "Week Off Date")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

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