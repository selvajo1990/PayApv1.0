page 50044 "Earning Group List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Earning Group";
    Caption = 'Earning Groups';
    CardPageId = "Earning Group";
    Editable = false;
    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Earning Group Code"; Rec."Earning Group Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Earning Group Code';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description';
                }
            }
        }
        area(Factboxes)
        {

        }
    }

}