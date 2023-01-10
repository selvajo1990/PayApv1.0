codeunit 50026 "HRMS Job Management"
{
    TableNo = "Job Queue Entry";
    trigger OnRun()
    begin
        UpdateLeaveBalanceSummary();
    end;

    local procedure UpdateLeaveBalanceSummary()
    var
        EmployeeL: Record Employee;
        LeaveBalanceSummaryL: Record "Leave Balance Summary";
        EmployeeEarningHistoryL: Record "Employee Earning History";
        EmployeeLevelAbsenceL: Record "Employee Level Absence";
        PayPeriodLineL: Record "Pay Period Line";
        AbsenceL: Record Absence;
        CarryForwardDaysL: Decimal;
        StartDateL: date;
        EndDateL: date;
    begin
        EmployeeL.SetFilter("Absence Group", '<>%1', '');
        if not EmployeeL.FindFirst() then
            exit;
        repeat
            EmployeeEarningHistoryL.SetRange("Employee No.", EmployeeL."No.");
            EmployeeEarningHistoryL.SetRange("Group Code", EmployeeL."Absence Group");
            EmployeeEarningHistoryL.SetFilter("From Date", '<=%1', Today());
            EmployeeEarningHistoryL.SetFilter("To Date", '>=%1', Today());
            if EmployeeEarningHistoryL.FindFirst() then begin
                EmployeeLevelAbsenceL.SetRange("Group Code", EmployeeL."Absence Group");
                EmployeeLevelAbsenceL.SetRange("From Date", EmployeeEarningHistoryL."From Date");
                if EmployeeLevelAbsenceL.FindFirst() then
                    repeat
                        AbsenceL.GetStartDateAndEndDate(EmployeeL."Leave Accrual Start Date", Today(), EmployeeLevelAbsenceL."Accrual Basis", StartDateL, EndDateL);
                        if EndDateL = Today() then begin
                            AbsenceL.Get(EmployeeLevelAbsenceL."Absence Code");
                            PayPeriodLineL."Period Start Date" := StartDateL;
                            PayPeriodLineL."Period End Date" := EndDateL;
                            LeaveBalanceSummaryL.Get(EmployeeL."No.", EmployeeLevelAbsenceL."Absence Code");
                            CarryForwardDaysL := AbsenceL."Maximum Carry Forward Days";
                            if (LeaveBalanceSummaryL."Leave Balance" < AbsenceL."Maximum Carry Forward Days") and (AbsenceL."Maximum Carry Forward Days" > 0) then
                                CarryForwardDaysL := LeaveBalanceSummaryL."Leave Balance";
                            LeaveBalanceSummaryL.ClearLeaveBalance(EmployeeL."No.", EmployeeLevelAbsenceL."Absence Code", EmployeeLevelAbsenceL."Assigned Days", CarryForwardDaysL, PayPeriodLineL);
                        end;
                    until EmployeeLevelAbsenceL.Next() = 0;
            end;
        until EmployeeL.next() = 0;
    end;

    local procedure UpdateEmployeeEarning()
    var
        EmployeeL: Record Employee;
        EmpGrpHistoryL: Record "Employee Earning History";
    begin
        EmployeeL.FindFirst();
        repeat
            EmpGrpHistoryL.SetRange("Employee No.", EmployeeL."No.");
            if not EmpGrpHistoryL.IsEmpty() then begin
                EmployeeL.CreateUpdateEarningGroupLines(EmployeeL."Employment Date");
                EmployeeL.CreateUpdateAbsenceGroupLine(EmployeeL."Employment Date");
            end;
        until EmployeeL.Next() = 0;
    end;
}