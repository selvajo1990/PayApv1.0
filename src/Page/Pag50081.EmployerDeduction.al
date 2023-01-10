page 50081 "Employer Deduction"
{
    PageType = Document;
    SourceTable = "Salary Computation Header";
    Caption = 'Accrual & Employer Deduction';
    InsertAllowed = false;
    ModifyAllowed = false;
    UsageCategory = None;
    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Computation No."; Rec."Computation No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Computation No.';
                }
                field("Pay Period"; Rec."Pay Period")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Pay Period';
                }
                field("Total Net Pay"; Rec."Total Net Pay")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Total Net Pay';
                }
                field("Accrual Posting Status"; Rec."Accrual Posting Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Accrual Posting Status';
                }

            }
            part("Employee Deduction Line"; "Employer Deduction Subpage")
            {
                Caption = 'Accrual & Employee Deduction Line';
                SubPageLink = "Computation No." = field("Computation No.");
                ApplicationArea = all;
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Create Journal Lines")
            {
                ApplicationArea = All;
                Image = Calculate;
                Caption = 'Create Journal Entries';
                ToolTip = 'Executes the Create Journal Entries action.';

                trigger OnAction();
                var
                    SalCompL: Record "Salary Computation Header";
                    RepPayCalc: Report "Payroll Jnl. Calculate";
                begin
                    if Rec.Status = Rec.Status::Open then
                        error('Sal. Comp Posting Status must not be Open.');

                    SalCompL.Reset();
                    SalCompL.SetRange("Computation No.", Rec."Computation No.");
                    clear(RepPayCalc);
                    RepPayCalc.SetParameters(2);
                    RepPayCalc.SetTableView(SalCompL);
                    RepPayCalc.Run();
                    CurrPage.Update();
                end;
            }

        }
    }

}