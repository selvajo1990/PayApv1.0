page 50079 "Absence Group Line List"
{
    PageType = List;
    SourceTable = "Absence Group Line";
    Caption = 'Absence Group Line List';
    Editable = false;
    UsageCategory = None;
    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Absence Code"; Rec."Absence Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Absence Code';
                }
                field("Absence Description"; Rec."Absence Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Absence Description';
                }
            }
        }
        area(Factboxes)
        {

        }
    }

}