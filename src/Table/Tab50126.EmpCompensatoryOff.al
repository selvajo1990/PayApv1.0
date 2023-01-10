table 50126 "Employee Compensatory Off"
{
    DataClassification = ToBeClassified;
    LookupPageId = "Employee Comp Off";

    fields
    {
        field(1; "Entry No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Entry No.';
        }
        field(2; "Employee No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Employee No.';
            TableRelation = Employee;

            trigger OnValidate()
            var
                EmployeeL: Record Employee;
            begin
                EmployeeL.Reset();
                EmployeeL.SetRange("No.", "Employee No.");
                if EmployeeL.FindFirst() then begin
                    Rec."Employee Name" := EmployeeL."First Name";
                    Rec."Approver ID" := EmployeeL."Line Manager";
                end;
            end;
        }
        field(3; "Employee Name"; Text[50])
        {
            Caption = 'Employee Name';
            FieldClass = FlowField;
            CalcFormula = lookup(Employee."First Name" where("No." = field("Employee No.")));
        }
        field(4; "Source Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Source Date';
        }
        field(5; "No of Comp Days"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'No of Comp Days';
        }
        field(6; "Status"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = " ",Open,Approved,"Pending Approval",Rejected,Delegated;
            OptionCaption = ' ,Open,Approved,Pending Approval,Rejected,Delegated';
            Caption = 'Status';
        }
        field(7; "Approver ID"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Approver ID';
        }
    }

    keys
    {
        key(PK; "Employee No.", "Source Date")
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