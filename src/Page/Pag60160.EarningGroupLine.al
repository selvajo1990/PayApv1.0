page 54229 "Earning Group Line"
{

    PageType = List;
    SourceTable = "Earning Group Line";
    Caption = 'Earning Group Line';
    UsageCategory = None;
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(General)
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
            }
        }
    }

}
