page 50074 "Disciplinary Action List"
{
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "Disciplinary Action";
    Caption = 'Disciplinary Actions';
    CardPageId = "Disciplinary Action Card";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Reason Code"; Rec."Reason Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Reason Code';
                }
                field("Reason Description"; Rec."Reason Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Reason Description';
                }
                field("Disciplinary Code"; Rec."Disciplinary Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Disciplinary Code';
                }
                field("No. of Days"; Rec."No. of Days")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. of Days';
                }
            }
        }
        area(Factboxes)
        {

        }
    }
}