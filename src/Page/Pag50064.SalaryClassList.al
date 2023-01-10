page 50064 "Salary Class List"
{
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "Salary Class";
    Caption = 'Salary Class List';
    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Salary Class Code"; Rec."Salary Class Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Salary Class';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description';
                }
            }
        }
        area(Factboxes)
        {

        }
    }
}