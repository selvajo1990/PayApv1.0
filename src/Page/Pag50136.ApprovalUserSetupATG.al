page 50136 "Approval User Setup ATG"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Approval User Setup ATG";
    Caption = 'Approval User Setup ATG';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Employee No."; Rec."Employee No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Employee No.';
                }
                field("Approval For"; Rec."Approval For")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Approval For';
                }
                field("Approver ID"; Rec."Approver ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Approver ID';
                }
                field("Leave Request Limit"; Rec."Leave Request Limit")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Leave Request Limit';
                }
                field("Unlimited Leave Request"; Rec."Unlimited Leave Request")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Unlimited Leave Request';
                }
                field(Email; Rec.Email)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Email';
                }
                field("Approval Administrator"; Rec."Approval Administrator")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Approval Administrator';
                }
                field("Template Code"; Rec."Template Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Template Code';
                }
            }
        }
    }

}