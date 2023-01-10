pageextension 54109 "Countries / Regions List" extends "Countries/Regions"
{
    layout
    {
        addafter(Name)
        {
            field("Air Fare"; "Air Fare")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Air Fare';
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}