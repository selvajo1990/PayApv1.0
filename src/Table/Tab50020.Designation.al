table 50020 "Designation"
{
    DataClassification = CustomerContent;
    Caption = 'Designation';
    LookupPageId = Designation;
    DataPerCompany = false;
    fields
    {
        field(1; "Designation Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Designation Code';
        }

        field(21; "Description"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Description';
        }
        field(22; "Start Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Start Date';
        }
        field(23; "End Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'End Date';
        }
        field(24; Department; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Department';
            TableRelation = Department;
            trigger OnValidate()
            begin
                UpdateEmployeeLevelDesignation();
            end;
        }
        field(25; "Reporting To"; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Reporting To';
            TableRelation = "Designation";
            trigger OnValidate()
            var
                HrmsLogL: Record "HRMS Log";
            begin
                UpdateEmployeeLevelDesignation();
                HrmsLogL.InsertLog(RecordId(), FieldCaption("Reporting To"), "Reporting To");
            end;
        }

        field(26; "Position Assigned"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Position Assigned';
            Editable = false;
        }
        field(27; "Employee No."; Code[20])
        {
            DataClassification = CustomerContent;
            // FieldClass = FlowField;
            Caption = 'Employee No.';
            // CalcFormula = lookup ("Employee Level Designation"."Employee No." where ("Designation Code" = field ("Designation Code"), "Position Closed" = filter (false)));
        }
        field(28; "Position Start Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Position Start Date';
            Description = 'For Developer usage';
        }
    }

    keys
    {
        key(PK; "Designation Code", Description)
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

    local procedure UpdateEmployeeLevelDesignation()
    var
        EmployeeLevelDesignationL: Record "Employee Level Designation";
    begin
        // CalcFields("Employee No.");
        EmployeeLevelDesignationL.SetRange("Designation Code", "Designation Code");
        EmployeeLevelDesignationL.SetRange("Employee No.", "Employee No.");
        EmployeeLevelDesignationL.SetRange("Position Closed", false);
        if EmployeeLevelDesignationL.FindFirst() then begin
            EmployeeLevelDesignationL.Department := Department;
            EmployeeLevelDesignationL."Reporting To" := "Reporting To";
            EmployeeLevelDesignationL.Modify();
        end;
    end;
}