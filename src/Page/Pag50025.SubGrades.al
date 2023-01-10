page 50025 "Sub Grades"
{
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "Sub Grade";
    Caption = 'Sub Grades';
    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(Grade; Rec.Grade)
                {
                    ApplicationArea = All;
                    LookupPageId = Grades;
                    ToolTip = 'Specifies the value of the Grade';

                }
                field("Sub Grade"; Rec."Sub Grade")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Sub Grade';
                }
                field("Sub Grade Description"; Rec."Sub Grade Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Sub Grade Description';
                }
                field("Salary Class"; Rec."Salary Class")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                    ToolTip = 'Specifies the value of the Salary Class';
                }
                field("Earning Group"; Rec."Earning Group")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                    ToolTip = 'Specifies the value of the Earning Group';
                }
                field("Absence Group"; Rec."Absence Group")
                {
                    ApplicationArea = all;
                    ShowMandatory = true;
                    ToolTip = 'Specifies the value of the Absence Group';
                }
                field("Loan & Advance Group"; Rec."Loan & Advance Group")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                    ToolTip = 'Specifies the value of the Loan & Advance Group';
                }
                field(Calendar; Rec.Calendar)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Calendar';
                }
                field("Pay Period"; Rec."Pay Cycle")
                {
                    ApplicationArea = all;
                    ShowMandatory = true;
                    ToolTip = 'Specifies the value of the Pay Cycle';
                }
                field("Air Ticket Group"; Rec."Air Ticket Group")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Air Ticket Group';
                }
            }
        }
        area(Factboxes)
        {

        }
    }
}