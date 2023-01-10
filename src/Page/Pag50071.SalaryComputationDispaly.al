page 50071 "Salary Computation Dispaly"
{
    PageType = Card;
    SourceTable = "Salary Computation Header";
    Caption = 'Salary Computation Dispaly';
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = true;
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
                field("No. of Employee"; Rec."No. of Employee")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. of Employee';
                }
                field("Total Net Pay"; Rec."Total Net Pay")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Total Net Pay';
                }
                field("Pay Period"; Rec."Pay Period")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Pay Period';
                }
                field("From Date"; Rec."From Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the From Date';
                }
                field("To Date"; Rec."To Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the To Date';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Sal. Comp. Posting Status';
                }
                field("Created DateTime"; Rec."Created DateTime")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Created DateTime';
                }
            }
            part("Salary Computation Lines"; "Salary Computation Subpage")
            {
                Caption = 'Salary Computation Lines';
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
                    Rec.TestField(Status, Rec.Status::Open);
                    SalCompL.Reset();
                    SalCompL.SetRange("Computation No.", Rec."Computation No.");
                    clear(RepPayCalc);
                    RepPayCalc.SetParameters(1);
                    RepPayCalc.SetTableView(SalCompL);
                    RepPayCalc.Run();
                    CurrPage.Update();
                end;
            }

        }
    }
}