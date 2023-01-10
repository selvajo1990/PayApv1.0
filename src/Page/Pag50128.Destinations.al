page 50128 "Destinations"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = Destination;
    Caption = 'Destinations';

    layout
    {
        area(Content)
        {
            repeater(Destinations)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Code';
                }
                field(City; Rec.City)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the City';
                }
                field("Destination Type Code"; Rec."Destination Type Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Destination Type Code';
                }
                field("Destination Type Description"; Rec."Destination Type Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Destination Type Description';
                }
            }
        }
    }
}