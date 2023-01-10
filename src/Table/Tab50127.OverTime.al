table 50127 "Over Time"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "OT No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'OT No.';
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
                if EmployeeL.Get("Employee No.") Then
                    Rec."Employee Name" := EmployeeL."First Name";
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
        field(5; "Over Tme Hours"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Over Time Hours';
        }
        field(6; "Status"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = " ",Open,Approved,"Pending Approval",Rejected,Delegated;
            OptionCaption = ' ,Open,Approved,Pending Approval,Rejected,Delegated';
            Caption = 'Status';
        }
    }

    keys
    {
        key(PK; "OT No.")
        {
            Clustered = true;
        }
    }

    var
        HumanResource: Record "Human Resources Setup";
        NoseriesMgmt: Codeunit NoSeriesManagement;

    trigger OnInsert()
    begin
        HumanResource.Get();
        "OT No." := NoseriesMgmt.GetNextNo(HumanResource."Over Time Nos.", Today, true);
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
