page 50024 "Departments"
{
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = Department;
    Caption = 'Departments';
    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Department Code"; Rec."Department Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Department Code';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description';
                }
                field("Department Head"; Rec."Department Head")
                {
                    Caption = 'Department Head';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Department Head';
                }
                field("Department Head Name"; "Department Head Name")
                {
                    Caption = 'Department Head Name';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Department Head Name';
                }
            }
        }
        area(Factboxes)
        {

        }
    }
}