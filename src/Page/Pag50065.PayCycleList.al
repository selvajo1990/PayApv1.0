page 50065 "Pay Cycle List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Pay Cycle";
    Editable = false;
    Caption = 'Pay Cycles';
    CardPageId = "Pay Cycle Card";
    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Pay Cycle"; Rec."Pay Cycle")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Pay Cycle';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description';
                }
                field("Pay Cycle Frequency"; Rec."Pay Cycle Frequency")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Pay Cycle Frequency';
                }
            }
        }
        area(Factboxes)
        {

        }
    }
}