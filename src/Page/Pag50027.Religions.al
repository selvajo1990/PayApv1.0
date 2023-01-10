page 50027 "Religions"
{
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = Religion;
    Caption = 'Religions';
    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Religion Code"; Rec."Religion Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Religion Code';
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