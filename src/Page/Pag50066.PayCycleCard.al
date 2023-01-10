page 50066 "Pay Cycle Card"
{
    PageType = Card;
    SourceTable = "Pay Cycle";
    Caption = 'Pay Cycle Card';
    UsageCategory = None;
    layout
    {
        area(Content)
        {
            group(General)
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
            part("Pay Period Lines"; "Pay Period Subpage")
            {
                SubPageLink = "Pay Cycle" = field("Pay Cycle");
                Caption = 'Pay Period Lines';
                ApplicationArea = all;
            }
        }
    }
}