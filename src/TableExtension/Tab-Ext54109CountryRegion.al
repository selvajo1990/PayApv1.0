tableextension 54109 "Country / Region" extends "Country/Region"
{
    fields
    {
        field(54101; "Air Fare"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Air Fare';
        }
    }

    var
        myInt: Integer;
}