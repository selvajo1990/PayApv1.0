table 50106 "Approval User Setup ATG"
{
    DataClassification = CustomerContent;
    Caption = 'Approval User Setup ATG';
    fields
    {
        field(1; "Employee No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Employee ATG";
            Caption = 'Employee No.';
        }
        field(2; "Approval For"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = "Leave Request";
            Caption = 'Approval For';
        }
        field(21; "Approver ID"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Employee ATG";
            Caption = 'Approver ID';
        }
        field(22; "Leave Request Limit"; Decimal)
        {
            DataClassification = CustomerContent;
            BlankZero = true;
            Caption = 'Leave Request Limit';
        }
        field(23; "Unlimited Leave Request"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Unlimited Leave Request';
        }
        field(24; Email; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Email';
        }
        field(25; Substitute; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Substitute';
        }
        field(26; "Approval Administrator"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Approval Administrator';
        }
        field(27; "Template Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Template Code';
            TableRelation = "Approval Setup ATG";
        }
    }

    keys
    {
        key(PK; "Employee No.", "Approval For")
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

    procedure CreateUpdateRecord(EmployeeNoP: Code[20]; ApprovalForP: Option; ApproverIDP: code[20]; RequestLimitP: Integer; UnlimitedLeaveRequestP: Boolean; TemplateCodeP: Code[20])
    begin
        if not Get(EmployeeNoP, ApprovalForP) then begin
            Init();
            "Employee No." := EmployeeNoP;
            "Approval For" := ApprovalForP;
            Insert();
        end;
        "Approver ID" := ApproverIDP;
        "Leave Request Limit" := RequestLimitP;
        "Unlimited Leave Request" := UnlimitedLeaveRequestP;
        "Template Code" := TemplateCodeP;
        Modify();
    end;

    procedure UpdateApproverId(DesignationCodeP: code[20]; ApproverIdP: Code[20])
    var
        EmployeeLevelDesignationL: Record "Employee Level Designation";
        ApproverUserSetupL: Record "Approval User Setup ATG";
    begin
        EmployeeLevelDesignationL.SetRange("Reporting To", DesignationCodeP);
        EmployeeLevelDesignationL.SetRange("Primary Position", true);
        EmployeeLevelDesignationL.SetRange("Position Closed", false);
        if EmployeeLevelDesignationL.FindSet() then
            repeat
                if ApproverUserSetupL.Get(EmployeeLevelDesignationL."Employee No.", ApproverUserSetupL."Approval For"::"Leave Request") then begin
                    ApproverUserSetupL."Approver ID" := ApproverIdP;
                    ApproverUserSetupL.Modify();
                end;
            until EmployeeLevelDesignationL.Next() = 0;
    end;
}