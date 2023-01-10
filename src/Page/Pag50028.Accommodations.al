page 50028 "Accommodations"
{
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = Accommodation;
    Caption = 'Accommodation';
    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Accommodation Code"; Rec."Accommodation Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Accommodation Code';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description';
                }
                field(Notes; Rec.Notes)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Notes';
                }
            }
        }
        area(Factboxes)
        {

        }
    }
}