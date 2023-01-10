page 50075 "Conduct List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = Conduct;
    Caption = 'Conducts';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Conduct Code"; Rec."Conduct Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Conduct Code';
                }
                field("Conduct Description"; Rec."Conduct Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Conduct Description';
                }
            }
        }
        area(Factboxes)
        {

        }
    }
}