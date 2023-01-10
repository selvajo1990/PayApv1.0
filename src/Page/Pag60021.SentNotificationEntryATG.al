page 60021 "Sent Notification Entry ATG"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Sent Notification Entry ATG";
    Caption = 'Sent Notification Entry ATG';
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
                field("Sent Date-Time ATG"; Rec."Sent Date-Time ATG")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Sent Date-Time';
                }
                field("Notification Method ATG"; Rec."Notification Method ATG")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Notification Method';
                }
            }
        }
    }
}