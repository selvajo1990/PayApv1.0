report 50060 "Leave Balance Summary"
{
    UsageCategory = Lists;
    ApplicationArea = All;
    Caption = 'Leave Balance Summary';
    RDLCLayout = './res/LeaveBalanceSummary.rdl';

    dataset
    {
        dataitem(Employee_DI; Employee)
        {
            RequestFilterFields = "No.", "Salary Class", "Date Filter";
            RequestFilterHeading = 'Leave Balance (as on date)';
            MaxIteration = 0;
            DataItemTableView = sorting("No.");
        }
        dataitem(LeaveBalance; "Salary Computation Line")
        {
            UseTemporary = true;
            DataItemTableView = sorting("Computation No.");
            column(EmployeeNo; "Computation No.")
            {

            }
            column(EmployeeName; "Free Text 1")
            {

            }
            column(AbsenceCode; Comments)
            {

            }
            column(JobTitle; Description)
            {

            }
            column(Balance; Amount)
            {

            }
        }
        dataitem("Company Information"; "Company Information")
        {
            DataItemTableView = sorting("Primary Key");
            column(Name; Name)
            {

            }
            column(Picture; Picture)
            {
                AutoCalcField = true;
            }
            column(DateFilter; Employee_DI.GetRangeMin("Date Filter"))
            {

            }
        }
    }
    requestpage
    {
        SaveValues = true;
    }
    labels
    {
        ReportTitle = 'Leave Balance Summary', Comment = 'Balance', MaxLength = 50, Locked = true;
        EmployeeNolbl = 'Employee No.';
        EmployeeNamelbl = 'Employee Name';
        AbsenceCodelbl = 'Absence Code';
        JobTitlelbl = 'Designation';
    }

    var
        Employee: Record Employee;
        DateErr: Label 'Date filter is mandatory';

    trigger OnPreReport()
    begin
        LeaveBalance.DeleteAll();
        if Employee_DI.GetFilter("Date Filter") = '' then
            Error(DateErr);
        Employee.SetView(Employee_DI.GetView());
        if Employee.FindSet() then
            repeat
                InsertLeaveBalance(Employee);
            until Employee.Next() = 0;
    end;

    procedure InsertLeaveBalance(Employee: Record Employee)
    var
        EmployeeGroupHistroy: Record "Employee Earning History";
        EmployeeAbsence: Record "Employee Level Absence";
        Counter: Integer;
    begin
        Employee.TestField("Absence Group");
        EmployeeGroupHistroy.SetRange("Employee No.", Employee."No.");
        EmployeeGroupHistroy.SetRange("Group Code", Employee."Absence Group");
        EmployeeGroupHistroy.SetRange("Component Type", EmployeeGroupHistroy."Component Type"::Absence);
        EmployeeGroupHistroy.FindLast();

        EmployeeAbsence.SetRange("Employee No.", EmployeeGroupHistroy."Employee No.");
        EmployeeAbsence.SetRange("Group Code", EmployeeGroupHistroy."Group Code");
        EmployeeAbsence.SetRange("From Date", EmployeeGroupHistroy."From Date");
        EmployeeAbsence.FindSet();
        repeat
            Counter += 1;
            LeaveBalance.Init();
            LeaveBalance."Computation No." := Employee."No.";
            LeaveBalance."Free Text 1" := CopyStr(Employee.FullName(), 1, 50);
            LeaveBalance.Description := Employee."Job Title";
            LeaveBalance."Line No." := Counter;
            LeaveBalance.Comments := EmployeeAbsence."Absence Description";
            LeaveBalance.Amount := CalculateLeaveBalance(EmployeeAbsence, Employee_DI.GetRangeMin("Date Filter"));
            LeaveBalance.Insert();
        until EmployeeAbsence.Next() = 0;
    end;

    local procedure CalculateLeaveBalance(EmployeeLevelAbsenceP: Record "Employee Level Absence"; AsOnDate: date): Decimal
    var
        LeaveBalanceL: Record "Leave Balance Summary";
        EmployeeL: Record Employee;
        AbsenceL: Record Absence; // using absence wrong it should be emp level absence
        HRMSManagement: Codeunit "HRMS Management";
        NoOfWorkingDaysL: Integer;
        PerDayLeaveL: Decimal;
        CurrentBalance: Decimal;
        BalanceAsDate: Decimal;
        StartDateL: Date;
        EndDateL: Date;
        AdditionaDaysErr: Label 'Additional day are not allowed';
    begin
        if AsOnDate = 0D then
            Error(DateErr);
        EmployeeL.Get(EmployeeLevelAbsenceP."Employee No.");
        LeaveBalanceL.get(EmployeeLevelAbsenceP."Employee No.", EmployeeLevelAbsenceP."Absence Code");
        if (LeaveBalanceL."Leave Taken" > EmployeeLevelAbsenceP."Assigned Days") Then
            if not EmployeeLevelAbsenceP."Additional Days" then
                Error(AdditionaDaysErr);

        if EmployeeLevelAbsenceP.Accrual then begin
            EmployeeL.TestField("Leave Accrual Start Date");
            AbsenceL.GetStartDateAndEndDate(EmployeeL."Leave Accrual Start Date", AsOnDate, EmployeeLevelAbsenceP."Accrual Basis", StartDateL, EndDateL);
            NoOfWorkingDaysL := (AsOnDate - StartDateL) + 1;
            if EmployeeLevelAbsenceP."Accrual Basis" = EmployeeLevelAbsenceP."Accrual Basis"::Biennial then
                PerDayLeaveL := EmployeeLevelAbsenceP."Assigned Days" / 730
            else
                PerDayLeaveL := EmployeeLevelAbsenceP."Assigned Days" / 365;
            if StartDateL = EmployeeL."Leave Accrual Start Date" then
                CurrentBalance := (NoOfWorkingDaysL * PerDayLeaveL) + HRMSManagement.GetNoOfLeaveTakenForThePeriod(EmployeeLevelAbsenceP."Employee No.", EmployeeLevelAbsenceP."Absence Code", StartDateL, AsOnDate)
            else
                CurrentBalance := LeaveBalanceL."Carry Forward Days" + (NoOfWorkingDaysL * PerDayLeaveL) + HRMSManagement.GetNoOfLeaveTakenForThePeriod(EmployeeLevelAbsenceP."Employee No.", EmployeeLevelAbsenceP."Absence Code", StartDateL, AsOnDate);
            AbsenceL.GetStartDateAndEndDate(EmployeeL."Leave Accrual Start Date", AsOnDate, EmployeeLevelAbsenceP."Accrual Basis", StartDateL, EndDateL);
            NoOfWorkingDaysL := (AsOnDate - StartDateL) + 1;
            if StartDateL = EmployeeL."Leave Accrual Start Date" then
                BalanceAsDate := (NoOfWorkingDaysL * PerDayLeaveL) + HRMSManagement.GetNoOfLeaveTakenForThePeriod(EmployeeLevelAbsenceP."Employee No.", EmployeeLevelAbsenceP."Absence Code", StartDateL, AsOnDate)
            else
                BalanceAsDate := LeaveBalanceL."Carry Forward Days" + (NoOfWorkingDaysL * PerDayLeaveL) + HRMSManagement.GetNoOfLeaveTakenForThePeriod(EmployeeLevelAbsenceP."Employee No.", EmployeeLevelAbsenceP."Absence Code", StartDateL, AsOnDate);
            exit(BalanceAsDate);
        end else begin
            AbsenceL.GetStartDateAndEndDate(EmployeeL."Employment Date", AsOnDate, EmployeeLevelAbsenceP."Accrual Basis", StartDateL, EndDateL);
            CurrentBalance := LeaveBalanceL."Leave Balance";
            BalanceAsDate := CurrentBalance;
            exit(BalanceAsDate);
        end;
    end;

}
