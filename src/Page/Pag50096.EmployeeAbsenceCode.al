page 50096 "Employee Absence Code"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Employee Level Absence";
    Caption = 'Employee Absence Codes';
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {

                field("Absence Code"; Rec."Absence Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Absence Code';

                }
                field("Description"; Rec."Absence Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Absence Description';
                }
            }
        }
    }
}
