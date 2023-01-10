table 50076 "Leave Encashment"
{
    DataClassification = CustomerContent;
    Caption = 'Leave Encashment';
    fields
    {
        field(1; "Leave Compensation ID"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Leave Compensation ID';
            Editable = false;
            trigger OnValidate()
            begin
                IF "Leave Compensation ID" <> xRec."Leave Compensation ID" THEN BEGIN
                    HrSetupG.Get();
                    NoSeriesMgtG.TestManual(HrSetupG."Leave Encashment No.");
                END;
            end;
        }
        field(21; "Employee No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Employee No.';
            TableRelation = Employee;
            trigger OnValidate()
            begin
                CalcFields("Employee Name");
            end;
        }
        field(22; "Employee Name"; Text[50])
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Employee."First Name" where("No." = field("Employee No.")));
            Caption = 'Employee Name';
        }
        field(23; "Compensation Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Compensation Date';
            trigger OnValidate()
            var
                EmployeeL: Record Employee;
                PayPeriodLinesL: Record "Pay Period Line";
            begin
                EmployeeL.Get("Employee No.");
                EmployeeL.TestField("Pay Cycle");
                PayPeriodLinesL.SetRange("Pay Cycle", EmployeeL."Pay Cycle");
                PayPeriodLinesL.SetFilter("Period Start Date", '<=%1', WorkDate());
                PayPeriodLinesL.SetFilter("Period End Date", '>=%1', WorkDate());
                if PayPeriodLinesL.FindFirst() then
                    if ("Compensation Date" < PayPeriodLinesL."Period Start Date") Or ("Compensation Date" > PayPeriodLinesL."Period End Date") then
                        Error(CompensationDateErr, TableCaption());
            end;
        }
        field(24; "Leave Type"; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Leave Type';
            TableRelation = Absence."Absence Code" where("Encashment computation" = filter(<> ''));
        }
        field(25; "Encashment Days"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Encashment Days';
            trigger OnValidate()
            var
                LeaveBalanceL: Record "Leave Balance Summary";
                EmployeeLevelAbsenceL: Record "Employee Level Absence";
                AbsenceL: Record Absence;
                EmployeeL: Record Employee;
                NoOfWorkingDaysL: Decimal;
                PerDayLeaveL: Decimal;
                BalanceAsOnCompensationDateL: Decimal;
                StartDateL: Date;
                EndDateL: Date;
            begin
                EmployeeL.Get("Employee No.");
                EmployeeL.TestField("Leave Accrual Start Date");
                LeaveBalanceL.Get("Employee No.", "Leave Type");
                EmployeeLevelAbsenceL.SetCurrentKey("From Date");
                EmployeeLevelAbsenceL.SetRange("Employee No.", "Employee No.");
                EmployeeLevelAbsenceL.SetRange("Absence Code", "Leave Type");
                EmployeeLevelAbsenceL.SetFilter("From Date", '<=%1', "Compensation Date");
                EmployeeLevelAbsenceL.FindLast();
                AbsenceL.GetStartDateAndEndDate(EmployeeL."Leave Accrual Start Date", "Compensation Date", EmployeeLevelAbsenceL."Accrual Basis", StartDateL, EndDateL);
                HRMSManagementG.GetNoOfLeaveTakenForThePeriod("Employee No.", "Leave Type", StartDateL, EndDateL);
                NoOfWorkingDaysL := ("Compensation Date" - StartDateL) + 1;
                if EmployeeLevelAbsenceL."Accrual Basis" = EmployeeLevelAbsenceL."Accrual Basis"::Biennial then
                    PerDayLeaveL := EmployeeLevelAbsenceL."Assigned Days" / 730
                else
                    PerDayLeaveL := EmployeeLevelAbsenceL."Assigned Days" / 365;
                if StartDateL = EmployeeL."Leave Accrual Start Date" then
                    BalanceAsOnCompensationDateL := (NoOfWorkingDaysL * PerDayLeaveL) + HRMSManagementG.GetNoOfLeaveTakenForThePeriod("Employee No.", "Leave Type", StartDateL, "Compensation Date")
                else
                    BalanceAsOnCompensationDateL := LeaveBalanceL."Carry Forward Days" + (NoOfWorkingDaysL * PerDayLeaveL) + HRMSManagementG.GetNoOfLeaveTakenForThePeriod("Employee No.", "Leave Type", StartDateL, "Compensation Date");
                if "Encashment Days" > BalanceAsOnCompensationDateL then
                    Error(LeaveBalanceErr, BalanceAsOnCompensationDateL);
                CalculateEncashmentAmount();

            end;
        }
        field(26; "Encashment Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Encashment Amount';
            Editable = false;
        }
        field(27; "Pay with Salary"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Pay with Salary';
        }
        field(28; "Status"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = Created,Open,Canceled,Rejected,Approved;
            OptionCaption = 'Created,Open,Canceled,Rejected,Approved';
            Caption = 'Status';
        }
    }
    keys
    {
        key(PK; "Leave Compensation ID")
        {
            Clustered = true;
        }
    }
    var
        HrSetupG: Record "Human Resources Setup";
        NoSeriesMgtG: Codeunit NoSeriesManagement;
        HRMSManagementG: Codeunit "HRMS Management";
        NoSeriesG: Code[20];
        CompensationDateErr: Label '%1 can be applied only in the current month.';
        LeaveBalanceErr: Label 'You can''t take more than %1 days.';

    trigger OnInsert()
    begin
        IF "Leave Compensation ID" = '' THEN BEGIN
            HrSetupG.Get();
            HrSetupG.TESTFIELD("Leave Encashment No.");
            NoSeriesMgtG.InitSeries(HrSetupG."Leave Encashment No.", '', 0D, "Leave Compensation ID", NoSeriesG);
        END;
    end;

    trigger OnModify()
    var
        LeaveBalanaceSummaryL: Record "Leave Balance Summary";
    begin
        if (Status = Status::Approved) and (Status <> xRec.Status) then
            LeaveBalanaceSummaryL.UpdateLeaveBalance("Employee No.", "Leave Type", "Encashment Days");
    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin
    end;

    procedure AssisEdit(): Boolean
    begin
        HrSetupG.Get();
        HrSetupG.TESTFIELD("Leave Encashment No.");
        IF NoSeriesMgtG.SelectSeries(HrSetupG."Leave Encashment No.", '', NoSeriesG) THEN BEGIN
            NoSeriesMgtG.SetSeries("Leave Compensation ID");
            EXIT(TRUE);
        END;
    end;

    local procedure CalculateEncashmentAmount()
    var
        AbsenceL: Record Absence;
        ComputationLineDetailL: Record "Computation Line Detail";
        EmployeeEarningHistoryL: Record "Employee Earning History";
        EmployeeLevelEarningL: Record "Employee Level Earning";
    begin
        AbsenceL.Get("Leave Type");
        EmployeeEarningHistoryL.SetRange("Employee No.", "Employee No.");
        EmployeeEarningHistoryL.SetFilter("From Date", '..%1', "Compensation Date");
        EmployeeEarningHistoryL.SetFilter("To Date", '%1..', "Compensation Date");
        EmployeeEarningHistoryL.SetRange("Component Type", EmployeeEarningHistoryL."Component Type"::Earning);//
        if not EmployeeEarningHistoryL.FindFirst() then
            exit;
        "Encashment Amount" := 0;
        ComputationLineDetailL.SetRange("Computation Code", AbsenceL."Encashment computation");
        if ComputationLineDetailL.FindSet() then
            repeat
                EmployeeLevelEarningL.SetRange("Group Code", EmployeeEarningHistoryL."Group Code");
                EmployeeLevelEarningL.SetRange("From Date", EmployeeEarningHistoryL."From Date");
                EmployeeLevelEarningL.SetRange("Earning Code", ComputationLineDetailL."Earning Code");
                if EmployeeLevelEarningL.FindFirst() then
                    "Encashment Amount" += ((EmployeeLevelEarningL."Pay Amount" * 12) / 365) * (ComputationLineDetailL.Percentage / 100);
            until ComputationLineDetailL.Next() = 0;
        "Encashment Amount" := "Encashment Amount" * "Encashment Days";
    end;

}
