table 50066 "Employee Earning History"
{
    DataClassification = CustomerContent;
    Caption = 'Employee Group History';
    LookupPageId = "Employee Group History";
    fields
    {
        field(1; "Employee No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Employee No.';
        }
        field(2; "Group Code"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Group Code';
        }
        field(3; "From Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'From Date';
        }
        field(4; "Component Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = Earning,Absence,Loan,"Air Ticket";
            OptionCaption = 'Earning,Absence,Loan,Air Ticket';
            Caption = 'Component Type';
        }
        field(21; "To Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'To Date';
        }
        field(22; "No. of Earning Components"; Integer)
        {
            Caption = 'No. of Earning Components';
            FieldClass = FlowField;
            CalcFormula = count("Employee Level Earning" where("Employee No." = field("Employee No."), "Group Code" = field("Group Code"), "From Date" = field("From Date")));
            Editable = false;
        }

        field(23; "No. of Absence Components"; Integer)
        {
            Caption = 'No. of Absence Components';
            FieldClass = FlowField;
            CalcFormula = count("Employee Level Absence" where("Employee No." = field("Employee No."), "Group Code" = field("Group Code"), "From Date" = field("From Date")));
            Editable = false;
        }
        field(24; "No. of Loan Components"; Integer)
        {
            Caption = 'Loan Types';
            FieldClass = FlowField;
            CalcFormula = count("Employee Level Loan" where("Employee No." = field("Employee No."), "Loan Group Code" = field("Group Code"), "From Date" = field("From Date")));
            Editable = false;
        }
        field(25; "Air Ticket Component"; Integer)
        {
            Caption = 'Air Ticket Component';
            FieldClass = FlowField;
            CalcFormula = count("Employee Level Air Ticket" where("Employee No." = field("Employee No."), "Air Ticket Group Code" = field("Group Code"), "From Date" = field("From Date")));
            Editable = false;
        }

    }

    keys
    {
        key(PK; "Employee No.", "Group Code", "From Date", "Component Type")
        {
            Clustered = true;
        }
        key(SK; "From Date", "To Date")
        {

        }
    }

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    var
        EmployeeLevelEarningL: Record "Employee Level Earning";
        EmployeeLevelAbsenceL: Record "Employee Level Absence";
    begin
        if "Component Type" = "Component Type"::Earning then begin
            EmployeeLevelEarningL.SetRange("Employee No.", "Employee No.");
            EmployeeLevelEarningL.SetRange("Group Code", Rec."Group Code");
            EmployeeLevelEarningL.SetRange("From Date", "From Date");
            EmployeeLevelEarningL.DeleteAll();
        end else begin
            EmployeeLevelAbsenceL.SetRange("Employee No.", "Employee No.");
            EmployeeLevelAbsenceL.SetRange("Group Code", Rec."Group Code");
            EmployeeLevelAbsenceL.SetRange("From Date", "From Date");
            EmployeeLevelAbsenceL.DeleteAll();
        end;
    end;

    trigger OnRename()
    begin

    end;

}