page 50112 "Leave Salary Subpage"
{
    PageType = ListPart;
    SourceTable = "Salary Computation Line";
    DeleteAllowed = false;
    InsertAllowed = false;
    Caption = 'Leave Salary';
    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Earning Group"; Rec."Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Code';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Description';
                }
                field("Pay Period"; Rec."Pay Period")
                {
                    ApplicationArea = all;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Pay Period';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Amount';
                }
                field("Computation Type"; Rec."Computation Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Computation Type';
                }
                field("No. of Working Days"; Rec."No. of Working Days")
                {
                    ApplicationArea = all;
                    Editable = false;
                    Caption = 'No. of Days';
                    ToolTip = 'Specifies the value of the No. of Days';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Calculate Leave Salary")
            {
                Image = Calculate;
                Caption = 'Calculate Leave Salary';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = all;
                ToolTip = 'Executes the Calculate Leave Salary action.';
                trigger OnAction()
                var
                    SalaryComputationLineL: Record "Salary Computation Line";
                    EmployeeL: Record Employee;
                    SalaryComputationL: Report "Salary Computation";
                    CalculationEndDateL: Date;
                    CalculationStartDateL: Date;
                begin
                    LeaveRequestG.Get(Rec."Computation No.");
                    AbsenceG.Get(LeaveRequestG."Absence Code");
                    AbsenceG.TestField("Leave Salary Computation");
                    EmployeeL.Get(LeaveRequestG."Employee No.");
                    if not Confirm(LeaveSalaryCalcQst, false) then
                        exit;
                    SalaryComputationLineL.SetRange("Computation No.", Rec."Computation No.");
                    if not SalaryComputationLineL.IsEmpty() then
                        SalaryComputationLineL.DeleteAll();
                    //Error(LeaveSalaryExistErr); --> Error if already calculated.
                    PayPeriodLineG.SetRange("Pay Cycle", EmployeeL."Pay Cycle");
                    PayPeriodLineG.SetFilter("Period Start Date", '<=%1', LeaveRequestG."Start Date");
                    PayPeriodLineG.SetFilter("Period End Date", '>=%1', LeaveRequestG."Start Date");
                    PayPeriodLineG.FindFirst();
                    repeat
                        GetStartEndDate(CalculationStartDateL, CalculationEndDateL, SalaryComputationLineL."Computation Type");
                        SalaryComputationL.SetParametersForLeaveSalary(PayPeriodLineG."Period Start Date", PayPeriodLineG."Period End Date", LeaveRequestG."No.", EmployeeL."No.", CalculationStartDateL, CalculationEndDateL, ComputationCodeG, SalaryComputationLineL."Computation Type");
                        SalaryComputationL.UseRequestPage(false);
                        SalaryComputationL.Run();
                    until LeaveRequestG."End Date" = CalculationEndDateL;
                end;
            }
        }

    }
    var
        PayPeriodLineG: Record "Pay Period Line";
        LeaveRequestG: Record "Leave Request";
        AbsenceG: Record Absence;
        ComputationCodeG: Code[20];
        LeaveSalaryCalcQst: Label 'Do you want to calculate Leave Salary?';

    local procedure GetStartEndDate(var CalculationStartDateP: Date; var CalculationEndDateP: Date; var ComputationType: Option)
    var
        SalaryComputationLineL: Record "Salary Computation Line";
        LeaveRequestL: Record "Leave Request";
    begin
        if (CalculationStartDateP = 0D) and (CalculationEndDateP = 0D) then begin
            SalaryComputationLineL.SetRange("Employee No.", LeaveRequestG."Employee No.");
            SalaryComputationLineL.SetRange("Pay Period", PayPeriodLineG."Pay Period");
            SalaryComputationLineL.SetRange("Computation Type", SalaryComputationLineL."Computation Type"::"Leave Days");
            if SalaryComputationLineL.FindLast() then begin
                LeaveRequestL.Get(SalaryComputationLineL."Computation No.");
                CalculationStartDateP := LeaveRequestL."End Date" + 1;
            end else
                CalculationStartDateP := PayPeriodLineG."Period Start Date";
            CalculationEndDateP := LeaveRequestG."Start Date" - 1;
            ComputationType := 1;
            ComputationCodeG := '';
            if CalculationEndDateP < CalculationStartDateP then begin
                if LeaveRequestG."End Date" > PayPeriodLineG."Period End Date" then
                    CalculationEndDateP := PayPeriodLineG."Period End Date"
                else
                    CalculationEndDateP := LeaveRequestG."End Date";
                ComputationType := 2;
                ComputationCodeG := AbsenceG."Leave Salary Computation";
            end;
        end else begin
            ComputationType := 2;
            ComputationCodeG := AbsenceG."Leave Salary Computation";
            CalculationStartDateP := CalculationEndDateP + 1;
            if CalculationStartDateP > PayPeriodLineG."Period End Date" then begin
                PayPeriodLineG.SetFilter("Period Start Date", '<=%1', CalculationStartDateP);
                PayPeriodLineG.SetFilter("Period End Date", '>=%1', CalculationStartDateP);
                PayPeriodLineG.FindFirst();
            end;
            if (LeaveRequestG."End Date" > PayPeriodLineG."Period End Date") then
                CalculationEndDateP := PayPeriodLineG."Period End Date"
            else
                CalculationEndDateP := LeaveRequestG."End Date";
        end;
    end;
}