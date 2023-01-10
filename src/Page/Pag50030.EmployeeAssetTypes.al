page 50030 "Employee Asset Types"
{
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "Employee Asset Type";
    Caption = 'Employee Asset Types';
    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Loan Type Code"; Rec."Asset Type Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Loan Type Code';
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