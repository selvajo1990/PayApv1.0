page 50048 "Absence Group List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Absence Group";
    Caption = 'Absence Groups';
    CardPageId = "Absence Group";
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Absence Group Code"; Rec."Absence Group Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Absence Group Code';
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