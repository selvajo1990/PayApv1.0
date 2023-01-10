page 50118 "Gratuity Formula"
{
    PageType = List;
    SourceTable = "Gratuity Formula";
    UsageCategory = None;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Days Upto"; Rec."Days Upto")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Days Upto';
                }
                field("No. of Days"; Rec."No. of Days")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the No. of Days';
                }
            }
        }
    }

}