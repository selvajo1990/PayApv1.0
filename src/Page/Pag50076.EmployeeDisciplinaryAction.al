page 50076 "Employee Disciplinary Action"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Employee Disciplinary Action";
    Caption = 'Employee Disciplinary Action';
    //CardPageId = "Disciplinary Action Card";
    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Employee No."; Rec."Employee No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Employee No.';
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Employee Name';
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Date';
                }
                field("Reason Code"; Rec."Reason Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Reason Code';
                }
                field("Disciplinary"; Rec."Disciplinary Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Disciplinary Code';
                }
                field("Occurance No."; Rec."Occurance No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Occurance No.';
                }
                field("Line Manager Comment"; "Line Manager Comment")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Line Manager Comment';
                }
                field("HR Comment"; Rec."HR Comment")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the HR Comment';
                }
            }
        }
        area(Factboxes)
        {

        }
    }

}