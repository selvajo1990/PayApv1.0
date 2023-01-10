pageextension 54104 "Human Resources Setup" extends "Human Resources Setup"
{
    layout
    {
        addafter("Employee Nos.")
        {
            field("Leave Request Nos."; Rec."Leave Request Nos.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Leave Request Nos.';
            }
            field("Adhoc Payment Nos."; Rec."Adhoc Payment Nos.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Adhoc Payment Nos.';
            }
            field("Loan Request Nos."; Rec."Loan Request Nos.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Loan Request Nos.';
            }
            field("Withhold Salary Nos."; Rec."Withhold Salary Nos.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Withhold Salary Nos.';
            }
            field("Salary Computation Nos."; Rec."Salary Computation Nos.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Salary Computation Nos.';
            }
            field("Leave Encashment No."; Rec."Leave Encashment No.")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Leave Encashment No.';
            }
            field("Timing Nos."; Rec."Timing Nos.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Timing Nos.';
            }
            field("End of Service Nos."; Rec."End of Service Nos.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the End of Service Nos.';
            }
            field("Air Ticket Request Nos."; Rec."Air Ticket Request Nos.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Air Ticket Request Nos.';
            }
            field("Salary Increment Nos."; Rec."Salary Increment Nos.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Salary Increment Nos.';
            }
            field("Employee Asset Nos."; Rec."Employee Asset Nos.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Employee Asset Nos.';
            }
            field("Over Time Nos."; Rec."Over Time Nos.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the OT Nos.';
            }
        }
        addbefore(Numbering)
        {
            group(General)
            {
                field("HR Rounding Type"; Rec."HR Rounding Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the HR Rounding Type';
                }
                field("HR Rounding Precision"; Rec."HR Rounding Precision")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the HR Rounding Precision';
                }
                field("Enable Salary Cut-off"; Rec."Enable Salary Cut-off")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Enable Salary Cut-off';
                }
                field("Salary Cut-off Start Date"; Rec."Salary Cut-off Start Date")
                {
                    ApplicationArea = All;
                    Editable = Rec."Enable Salary Cut-off";
                    ToolTip = 'Specifies the value of the Salary Cut-off Start Date';
                }
                field("Salary Cut-off End Date"; Rec."Salary Cut-off End Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Salary Cut-off End Date';
                }
                field("Gratuity Accrual Days"; Rec."Gratuity Accrual Days")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Gratuity Accrual Days';
                }
                field("Bank Account"; Rec."Bank Account")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Bank Account';
                }
                field("Bank Name"; Rec."Bank Name")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Bank Name';
                }
                field("Company ID"; Rec."Company ID")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Company ID';
                }
                field("Working Hours"; Rec."Working Hours")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Working Hours';
                }
                field("HR Manager"; "HR Manager")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the HR Manger';
                }
            }
        }
        movebefore("HR Rounding Type"; "Base Unit of Measure")
        addafter(Numbering)
        {
            group(Others)
            {
                field("Salary Comp. Jnl. Template"; Rec."Salary Comp. Jnl. Template")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Salary Comp. Jnl. Template';
                }
                field("Accurals Jnl. Template"; Rec."Accurals Jnl. Template")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Accurals Jnl. Template';
                }
                field("EOS Jnl. Template"; Rec."EOS Jnl. Template")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the EOS Jnl. Template';
                }
                field("Employee Level Posting"; Rec."Employee Level Posting")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Employee Level Posting';
                }
                field("Employee Dimension Code"; Rec."Employee Dimension Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Employee Dimension Code';
                }
            }
        }
    }
}
