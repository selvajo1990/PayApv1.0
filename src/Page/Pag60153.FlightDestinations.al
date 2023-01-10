page 60153 "Flight Destinations"
{

    PageType = List;
    SourceTable = "Flight Destination";
    Caption = 'Flight Destinations';
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Flight Destination Code"; Rec."Flight Destination Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Flight Destination Code';
                }
                field(City; Rec.City)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the City';
                }
                field("Country Code"; Rec."Country Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Country Code';
                }
                field(Country; Rec.Country)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Country';
                }
            }
        }
    }

}
