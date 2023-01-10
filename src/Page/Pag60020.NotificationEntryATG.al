page 60020 "Notification Entry ATG"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Notification Entry ATG";
    Caption = 'Notification Entry ATG';
    Editable = false;
    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("ID ATG"; Rec."ID ATG")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the ID';
                }
                field("Recipient Employee No. ATG"; Rec."Recipient Employee No. ATG")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Recipient Employee No.';
                }
                field("Created Date-Time ATG"; Rec."Created Date-Time ATG")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Created Date-Time';
                }
                field("Created By ATG"; Rec."Created By ATG")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Created By';
                }
                field("Error Message ATG"; Rec."Error Message ATG")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Error Message';
                }
            }
        }
    }
}