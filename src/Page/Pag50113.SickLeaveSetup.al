page 50113 "Sick Leave Setup"
{
    PageType = ListPart;
    SourceTable = "Sick leave Setup";
    DelayedInsert = true;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("From Days"; Rec."From Days")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the From Days';

                }
                field("To Days"; Rec."To Days")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the To Days';
                }
                field("No. of Days"; Rec."No. of Days")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the No. of Days';

                }
                field(Percentage; Rec.Percentage)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Percentage';
                }
            }
        }
    }

}