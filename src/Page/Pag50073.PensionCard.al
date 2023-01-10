page 50073 "Pension Card"
{
    PageType = Card;
    SourceTable = Pension;
    Caption = 'Pension/PASI/GOSI';
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            group(General)
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
                field("Minimum Age"; Rec."Minimum Age")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Minimum Age';
                }
                field("Maximum Age"; Rec."Maximum Age")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Maximum Age';
                }
            }
            group(Computation)
            {
                field("Employer Deduction"; Rec."Employer Deduction")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Employer Deduction';
                }
                field("Employee Deduction"; Rec."Employee Deduction")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Employee Deduction';
                }
                field("Employer Difference"; Rec."Employer Difference")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Employer Difference';
                }
                field("Employee Difference"; Rec."Employee Difference")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Employee Difference';
                }
                field("Minimum Salary"; Rec."Minimum Salary")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Minimum Salary';
                }
                field("Maximum Salary"; Rec."Maximum Salary")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Maximum Salary';
                }
            }
        }
    }

}