page 50085 "Accrual Setup Line"
{
    PageType = ListPart;
    SourceTable = "Accrual Setup Line";
    Caption = 'Accrual Setup Line';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("From Days"; Rec."From Days")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the From Days';
                }
                field("To Days"; Rec."To Days")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the To Days';
                }
                field("No. Of Days"; Rec."No. Of Days")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. Of Days';
                }
                field("No. of Years"; Rec."No. of Years")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. of Years';
                }
            }
        }
    }

}