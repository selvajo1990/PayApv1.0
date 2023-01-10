query 50012 "Employee by Notification Type"
{
    QueryType = Normal;
    Caption = 'Employee by Notification Type';

    elements
    {
        dataitem(DataItemName; "Notification Entry ATG")
        {
            column(Recipient_Employee_No__ATG; "Recipient Employee No. ATG")
            {

            }
            column(Totals)
            {
                Method = Count;
            }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}