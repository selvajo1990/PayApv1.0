page 50023 "Grades"
{
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = Grade;
    Caption = 'Grades';
    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Grade Code"; Rec."Grade Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Grade Code';
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