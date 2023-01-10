tableextension 54107 "Reason Code" extends "Reason Code"
{
    fields
    {
        field(60000; Percentage; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Percentage';
            MaxValue = 100;
            MinValue = 0;
        }
    }
}