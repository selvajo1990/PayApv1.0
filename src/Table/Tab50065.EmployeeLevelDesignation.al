table 50065 "Employee Level Designation"
{
    DataClassification = CustomerContent;
    Caption = 'Employee Level Designation';
    LookupPageId = Designation;
    fields
    {
        field(1; "Designation Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Designation Code';
            TableRelation = Designation."Designation Code" where("Position Assigned" = filter('No'));
            trigger OnValidate()
            var
                DesignationL: Record Designation;
            begin
                DesignationL.Get("Designation Code");
                DesignationL."Position Assigned" := true;
                DesignationL.Modify();
                "Designation Code" := DesignationL."Designation Code";
                Description := DesignationL.Description;
                //Evaluate("Employee No.", GetFilter("Employee No."));
                Department := DesignationL.Department;
                "Reporting To" := DesignationL."Reporting To";
                "Position Closed" := false;
                Validate("Work Assignment Start Date", Today());
            end;
        }

        field(2; "Line No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Line No.';
        }
        field(21; Department; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Department';
            TableRelation = Department;
            trigger OnValidate()
            begin
                UpdateMasterDesgination();
            end;
        }
        field(22; "Reporting To"; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Reporting To';
            TableRelation = "Designation";
            trigger OnValidate()
            begin
                UpdateMasterDesgination();
            end;
        }
        field(23; "Work Assignment Start Date"; date)
        {
            DataClassification = CustomerContent;
            Caption = 'Work Assignment Start Date';
            trigger OnValidate()
            begin
                ValidateFields();
                TestField("Work Assignment Start Date");
            end;
        }
        field(24; "Work Assignment End Date"; date)
        {
            DataClassification = CustomerContent;
            Caption = 'Work Assignment End Date';
            trigger OnValidate()
            var
                DesignationL: Record Designation;
            begin
                if "Work Assignment End Date" > 0D then begin
                    ValidateFields();
                    "Position Closed" := true;
                    DesignationL.Get("Designation Code");
                    DesignationL."Position Assigned" := false;
                    DesignationL."Position Start Date" := "Work Assignment End Date";
                    DesignationL.Modify();
                end;
            end;
        }
        field(25; "Description"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Description';
        }
        field(26; "Employee No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Employee No.';
            TableRelation = Employee;
        }
        field(27; "Position Closed"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Position Closed';
            Description = 'This field is for developer usage';
        }
        field(29; "Employee Name"; Text[50])
        {
            FieldClass = FlowField;
            Caption = 'Employee Name';
            CalcFormula = lookup(Employee."First Name" where("No." = field("Employee No.")));
        }
        field(30; "Primary Position"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Primary Position';
            trigger OnValidate()
            var
                EmployeeDesignationL: Record "Employee Level Designation";
                EmployeeL: Record Employee;
            begin
                EmployeeDesignationL.SetFilter("Designation Code", '<>%1', "Designation Code");
                EmployeeDesignationL.SetRange("Employee No.", Rec."Employee No.");
                EmployeeDesignationL.ModifyAll("Primary Position", false);
                if EmployeeL.Get("Employee No.") then;
                EmployeeL."Job Title" := Rec.Description;
                EmployeeL."Job Code" := Rec."Designation Code";
                EmployeeL.Modify();
            end;
        }

    }

    keys
    {
        key(PK; "Designation Code", "Line No.")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin
        UpdateMasterDesgination();
    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    var
        DesignationL: Record Designation;
    begin
        DesignationL.Get("Designation Code");
        DesignationL."Position Assigned" := false;
        DesignationL."Employee No." := '';
        DesignationL.Modify();
    end;

    trigger OnRename()
    begin

    end;

    local procedure ValidateFields()
    var
        DesignationL: Record Designation;
        EmployeeL: Record Employee;
        PositionValidationErr: Label '%1 should be greater then previous %2: %3';
        WorkAssignmentStartValidationErr: Label 'Designation: %1 is starting from %2. %3 cannot be earlier than %4';
        WorkAssignmentEndValidationErr: Label '%1: %2 cannot be earlier than %3: %4';
        EmployementDateErr: Label '%1 can''t be lesser than %2';
    begin
        DesignationL.Get("Designation Code");
        DesignationL.TestField("Designation Code");
        DesignationL.TestField(Department);
        TestField("Designation Code");
        TestField(Department);
        EmployeeL.Get("Employee No.");
        EmployeeL.TestField("Employment Date");

        if "Work Assignment Start Date" < EmployeeL."Employment Date" then
            Error(EmployementDateErr, FieldCaption("Work Assignment Start Date"), EmployeeL.FieldCaption("Employment Date"));
        if (DesignationL."Position Start Date" > 0D) and ("Work Assignment Start Date" < DesignationL."Position Start Date") then
            Error(PositionValidationErr, FieldCaption("Work Assignment Start Date"), FieldCaption("Work Assignment End Date"), DesignationL."Position Start Date");

        if DesignationL."Start Date" > "Work Assignment Start Date" then
            Error(WorkAssignmentStartValidationErr, DesignationL."Designation Code", DesignationL."Start Date", FieldCaption("Work Assignment Start Date"), DesignationL.FieldCaption("Start Date"));

        if ("Work Assignment End Date" > 0D) and ("Work Assignment End Date" < "Work Assignment Start Date") then
            Error(WorkAssignmentEndValidationErr, FieldCaption("Work Assignment End Date"), "Work Assignment End Date", FieldCaption("Work Assignment Start Date"), "Work Assignment Start Date");
    end;

    local procedure UpdateMasterDesgination()
    var
        DesignationL: Record Designation;
        HrmsLogL: Record "HRMS Log";
    begin
        DesignationL.Get("Designation Code");
        DesignationL.Department := Department;
        DesignationL."Reporting To" := "Reporting To";
        DesignationL."Employee No." := "Employee No.";
        DesignationL.Modify();
        HrmsLogL.InsertLog(DesignationL.RecordId(), FieldCaption("Reporting To"), "Reporting To")
    end;

}