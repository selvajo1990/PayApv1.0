page 50072 "Pension List"
{
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = Pension;
    Caption = 'Pension/PASI/GOSI List';
    CardPageId = "Pension Card";
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Employer Country"; Rec."Employer Country")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Employer Country';
                }
                field("Employee Country"; Rec."Employee Country")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Employee Country';
                }
                field("Effective From"; Rec."Effective From")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Effective From';
                }
                field("Effective Till"; Rec."Effective Till")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Effective Till';
                }
            }
        }
        area(Factboxes)
        {

        }
    }

}