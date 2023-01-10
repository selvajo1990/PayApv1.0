page 50053 "Computation Subpage"
{
    PageType = ListPart;
    SourceTable = "Computation Line Detail";
    Caption = 'Computation Line Subpage';
    AutoSplitKey = true;
    DelayedInsert = true;
    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Earning Code"; Rec."Earning Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Earning Code';
                }
                field("Earning Description"; Rec."Earning Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Earning Description';
                }
                field(Percentage; Rec.Percentage)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Percentage';
                }
            }
        }
    }

}