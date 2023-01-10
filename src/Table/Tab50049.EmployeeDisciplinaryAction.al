table 50049 "Employee Disciplinary Action"
{
    DataClassification = CustomerContent;
    Caption = 'Employee Disciplinary Action';
    LookupPageId = "Employee Disciplinary Action";
    fields
    {
        field(1; "Employee No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Employee No.';
            TableRelation = Employee;
            trigger OnValidate()

            begin
                employeeL.Get("Employee No.");
                "Employee Name" := employeeL."First Name";
            end;
        }
        field(2; "Employee Name"; Text[50])
        {
            Caption = 'Employee Name';
            FieldClass = FlowField;
            CalcFormula = lookup(Employee."First Name" where("No." = field("Employee No.")));
        }
        field(3; "Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Date';
            trigger OnValidate()
            begin
                employeeL.Get("Employee No.");
                if employeeL."Employment Date" > rec.Date then
                    Error(DateErr, employeeL."Employment Date");
            end;
        }
        field(4; "Reason Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Reason Code';
            TableRelation = "Reason Code";
            trigger OnValidate()
            begin
                "Disciplinary Code" := '';
            end;
        }
        field(5; "Disciplinary Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Disciplinary Code';
            TableRelation = "Disciplinary Action"."Disciplinary Code" where("Reason Code" = field("Reason Code"));
            trigger OnValidate()
            var
                DisciplinaryActionL: record "Disciplinary Action";
                EmployeeDisciplinaryActionL: Record "Employee Disciplinary Action";
                DateFormulaLbl: Label '<-%1D>';
            begin
                TestField(Date);
                DisciplinaryActionL.Get("Reason Code", "Disciplinary Code");
                DisciplinaryActionL.TestField("No. of Days");

                EmployeeDisciplinaryActionL.SetRange("Employee No.", Rec."Employee No.");
                EmployeeDisciplinaryActionL.SetRange("Reason Code", "Reason Code");
                EmployeeDisciplinaryActionL.SetRange("Disciplinary Code", "Disciplinary Code");
                EmployeeDisciplinaryActionL.SetFilter(Date, '%1..%2', CalcDate(StrSubstNo(DateFormulaLbl, DisciplinaryActionL."No. of Days"), Date), Rec.Date);
                if EmployeeDisciplinaryActionL.Findset() then begin
                    if EmployeeDisciplinaryActionL.Count() > 9 then
                        "Occurance No." := EmployeeDisciplinaryActionL."Occurance No."::Ten
                    else
                        "Occurance No." := EmployeeDisciplinaryActionL.Count();
                end else
                    "Occurance No." := EmployeeDisciplinaryActionL."Occurance No."::One;
            end;
        }
        field(6; "Occurance No."; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = "One","Two","Three","Four","Five","Six","Seven","Eight","Nine","Ten";
            OptionCaption = 'One,Two,Three,Four,Five,Six,Seven,Eight,Nine,Ten';
            Caption = 'Occurance No.';
            Editable = false;
        }
        field(7; "HR Comment"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'HR Comment';
        }
        field(8; "Line Manager Comment"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Line Manager Comment';
        }

    }

    keys
    {
        key(PK; "Employee No.", Date, "Reason Code", "Disciplinary Code", "Occurance No.")
        {
            Clustered = true;
        }
    }
    var
        employeeL: record "Employee";
        DateErr: Label 'Date should be greater than Employement date %1';

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