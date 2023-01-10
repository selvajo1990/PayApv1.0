tableextension 54102 "Employee Relative" extends "Employee Relative"
{
    fields
    {
        modify("Relative Code")
        {
            trigger OnAfterValidate()
            var
                Relatives: Record "Employee Relative";
                RelativeCodeErr: Label 'You have already selected the code %1';
            begin
                if "Relative Code" > '' then begin
                    Relatives.SetRange("Employee No.", "Employee No.");
                    Relatives.SetRange("Relative Code", "Relative Code");
                    if not Relatives.IsEmpty() then
                        Error(RelativeCodeErr, "Relative Code");
                end;
            end;
        }
        modify("Birth Date")
        {
            trigger OnAfterValidate()
            var
                AgeGroupL: Record "Age Group";
                AgeL: Integer;
            begin
                if "Birth Date" = 0D then begin
                    "Age Group" := '';
                    Modify();
                    exit;
                end;
                "Age Group" := '';
                Modify();
                // Avi : Commented the code coz it should work on Age.
                AgeL := Today() - "Birth Date";
                AgeGroupL.SetFilter("From Age", '<=%1', AgeL);
                AgeGroupL.SetFilter("To Age", '>=%1', AgeL);
                if AgeGroupL.FindFirst() then begin
                    "Age Group" := AgeGroupL."Age Group Code";
                    Modify();
                end;
            end;
        }
        modify("First Name")
        {
            Caption = 'Full Name';
        }
        field(60000; Gender; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = " ","Male","Female";
            OptionCaption = ' ,Male,Female';
            Caption = 'Gender';
        }
        field(60001; "Emergency Contact"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Emergency Contact';
        }
        field(60002; Dependent; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Dependent';
        }
        field(60003; "Air Ticket"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Air Ticket';
            trigger OnValidate()
            var
                Employee: Record Employee;
                AirTicketGroup: Record "Air Ticket Group";
                EmployeeRelative: Record "Employee Relative";
                DependentErr: Label 'Only %1 dependent are allowed for Air Ticket';
            begin
                if "Air Ticket" then begin
                    Employee.Get("Employee No.");
                    Employee.TestField("Air Ticket Group");
                    AirTicketGroup.Get(Employee."Air Ticket Group");
                    EmployeeRelative.SetRange("Employee No.", "Employee No.");
                    EmployeeRelative.SetRange("Air Ticket", true);
                    if EmployeeRelative.Count() >= AirTicketGroup."Dependent Allowed" then
                        Error(DependentErr, AirTicketGroup."Dependent Allowed");
                end;
            end;
        }
        field(60004; "Age Group"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Age Group';
            Editable = false;
            TableRelation = "Age Group";
        }
        field(60005; "Passport No"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Passport No';
        }
        field(60006; "Passport Expiry"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Passport Expiry';
        }
        field(60007; "Visa No"; Code[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Visa No';
        }
        field(60008; "Visa Expiry"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Visa Expiry';
        }
        field(60009; "Policy No"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Policy No';
        }
        field(60010; "Policy Expiration"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Policy Expiration';
        }
        field(60011; "Visa Cost"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Visa Cost';
        }
        field(60012; "Air Fare"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Air Fare';
        }
        field(60013; "Insurance Cost"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Insurance Cost';
        }
    }

}