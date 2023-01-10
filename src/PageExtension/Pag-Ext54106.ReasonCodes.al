pageextension 54106 "Reason Codes" extends "Reason Codes"
{
    layout
    {
        addafter(Description)
        {
            field(Percentage; Rec.Percentage)
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Percentage';
            }
        }
    }


}