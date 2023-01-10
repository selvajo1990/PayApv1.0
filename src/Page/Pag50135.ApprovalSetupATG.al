page 50135 "Approval Setup ATG"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Approval Setup ATG";
    Caption = 'Approval Setup ATG';
    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Approval Code"; Rec."Approval Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Approval Code';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description';
                }
                field("Approver Type"; Rec."Approver Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Approver Type';
                }
                field("Approver Limit Type"; Rec."Approver Limit Type")
                {
                    ApplicationArea = All;
                    Editable = Rec."Approver Type" <> Rec."Approver Type"::"Workflow User Group";
                    ToolTip = 'Specifies the value of the Approver Limit Type';
                }
                field("Workflow User Group Code"; Rec."Workflow User Group Code")
                {
                    ApplicationArea = All;
                    Editable = Rec."Approver Type" = Rec."Approver Type"::"Workflow User Group";
                    ToolTip = 'Specifies the value of the Workflow Group Code';
                }
            }
        }
    }

    actions
    {

    }
}