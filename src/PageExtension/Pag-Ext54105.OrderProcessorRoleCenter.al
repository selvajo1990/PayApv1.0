pageextension 54105 "Order Processor Role Center" extends "Order Processor Role Center"
{
    layout
    {
        addlast(RoleCenter)
        {
            part("My Notes"; "My Notes")
            {
                AccessByPermission = tabledata "Record Link" = R;
                ApplicationArea = Basic, Suite;
            }
        }
    }
}
