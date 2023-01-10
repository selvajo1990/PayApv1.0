page 50108 "End of Service"
{
    PageType = Document;
    SourceTable = "End of Service";
    Caption = 'End of Service';
    UsageCategory = None;
    layout
    {
        area(Content)
        {
            group(General)
            {
                field("End of Service No."; Rec."End of Service No.")
                {
                    ApplicationArea = All;
                    AssistEdit = true;
                    ToolTip = 'Specifies the value of the End of Service No.';
                    trigger OnAssistEdit()
                    begin
                        Rec.AssisEdit();
                    end;
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Employee No.';
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Employee Name';
                }
                field("Reason Code"; Rec."Reason Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Reason Code';
                }
                field("Last Working Day"; Rec."Last Working Day")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Last Working Day';
                }
                field("Total Earnings"; Rec."Total Earnings")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Total Earning';
                }
                field("Total Accurals"; Rec."Total Accurals")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Total Accruals';
                }
                field("Posting Status"; Rec."Posting Status")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Posting Status';
                }
            }
            part("EOS Calculation"; "EOS Calculation Line Subpage")
            {
                Caption = 'Calculation Line';
                SubPageLink = "Computation No." = field("End of Service No."), "Show in Payslip" = filter(true), Type = filter(<> Adhoc);
                ApplicationArea = all;
            }
            part("Accrual And Deduction"; "EOS Calculation Line Subpage")
            {
                Caption = 'Gratuity and Accrual';
                SubPageLink = "Computation No." = field("End of Service No."), Type = filter("Employer Contribution" | " "), Category = filter(Deduction | Absence | Earning);
                ApplicationArea = all;
            }
            part("EOS Adhoc Payment"; "EOS Adhoc Payment")
            {
                Caption = 'Adhoc Payment';
                SubPageLink = "Computation No." = field("End of Service No."), Type = filter(Adhoc);
                ApplicationArea = all;
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Calculate EOS")
            {
                Image = Calculate;
                Caption = 'Calculate EOS';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = all;
                ToolTip = 'Executes the Calculate EOS action.';
                trigger OnAction()
                var
                    SalaryComputationLineL: Record "Salary Computation Line";
                    SalaryComputationL: Report "Salary Computation";
                    EosConfirmQst: Label 'Do you want to calculate End of Service for employee %1';
                begin
                    Rec.TestField("Employee No.");
                    Rec.TestField("Reason Code");
                    if not Confirm(EosConfirmQst, false, Rec."Employee No.") then
                        exit;
                    SalaryComputationLineL.SetRange("Computation No.", Rec."End of Service No.");
                    SalaryComputationLineL.DeleteAll();
                    PayPeriodLineG.SetFilter("Period Start Date", '<=%1', Rec."Last Working Day");
                    PayPeriodLineG.SetFilter("Period End Date", '>=%1', Rec."Last Working Day");
                    PayPeriodLineG.FindFirst();
                    SalaryComputationL.SetDefaultValueForEndofService(PayPeriodLineG."Period Start Date", PayPeriodLineG."Period End Date", Rec."End of Service No.", Rec."Employee No.", Rec."Reason Code");
                    SalaryComputationL.UseRequestPage(false);
                    SalaryComputationL.Run();
                end;
            }
            action("Create Journal Lines")
            {
                ApplicationArea = All;
                Image = Calculate;
                Caption = 'Create Journal Entries';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Executes the Create Journal Entries action.';


                trigger OnAction();
                var
                    SalCompL: Record "Salary Computation Header";
                    RepPayCalc: Report "Payroll Jnl. eos Calculate";
                begin
                    Rec.TestField("Posting Status", Rec."Posting Status"::Open);
                    SalCompL.Reset();
                    SalCompL.SetRange("Computation No.", Rec."End of Service No.");
                    clear(RepPayCalc);
                    RepPayCalc.SetTableView(SalCompL);
                    RepPayCalc.Run();
                    CurrPage.Update();
                end;
            }
            action("F&F Report")
            {
                ApplicationArea = All;
                Image = Report;
                Caption = 'F&F Report';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Executes the F&F Report action.';

                trigger OnAction();
                var
                    SalaryComputationLineL: record "Salary Computation Line";
                    EmployeeL: record Employee;
                    FinalReport: report "Full & Final";
                begin
                    EmployeeL.Get(Rec."Employee No.");
                    SalaryComputationLineL.Reset();
                    SalaryComputationLineL.SetRange("Computation No.", Rec."End of Service No.");
                    if SalaryComputationLineL.FindFirst() then begin
                        clear(FinalReport);
                        FinalReport.SetReportFilter(SalaryComputationLineL."Salary Class", SalaryComputationLineL."Pay Period", Rec."Employee No.");
                        FinalReport.RunModal();
                    end;
                end;
            }

        }
    }
    trigger OnAfterGetRecord()
    begin
        // if "Last Working Day" = 0D then
        //     CurrPage."EOS Adhoc Payment".Page.ShowEosAdhocPayment(0D, 0D)
        // else begin
        //     PayPeriodLineG.SetFilter("Period Start Date", '<=%1', "Last Working Day");
        //     PayPeriodLineG.SetFilter("Period End Date", '>=%1', "Last Working Day");
        //     PayPeriodLineG.FindFirst();
        //     CurrPage."EOS Adhoc Payment".Page.ShowEosAdhocPayment(PayPeriodLineG."Period Start Date", "Last Working Day");
        // end;
        // CurrPage."EOS Adhoc Payment".Page.Update(true);
    end;

    var
        PayPeriodLineG: Record "Pay Period Line";
}