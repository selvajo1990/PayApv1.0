report 50062 "Salary Slip"
{
    UsageCategory = Lists;
    ApplicationArea = All;
    Caption = 'Salary Slip';
    RDLCLayout = './res/SalarySlip.rdl';
    DefaultLayout = RDLC;
    dataset
    {
        dataitem(Employee; Employee)
        {
            RequestFilterHeading = 'Salary Slip';
            DataItemTableView = sorting("No.");
            column(CompanyInformationG_Name; CompanyInformationG.Name)
            { }
            column(CompanyInformationG_Picture; CompanyInformationG.Picture)
            { }
            column(CompanyInformationG_Address; CompanyInformationG.Address)
            { }
            column(CompanyInformationG_Address2; CompanyInformationG."Address 2")
            { }
            column(CompanyInformationG_Phone; CompanyInformationG."Phone No.")
            { }
            column(CompanyInformationG_Email; CompanyInformationG."E-Mail")
            { }
            column(Employee_No_; "No.")
            { }
            column(Employee_FullName; Employee.FullName())
            { }
            column(Job_Title; Employee."Job Title")
            { }
            column(Employment_Date; format("Employment Date"))
            { }
            column(Labor_ID; "MOL ID")
            { }
            column(AnnualLeaveCountG; AnnualLeaveCountG)
            { }
            column(LeaveBalance; LeaveBalanceG."Leave Balance")
            { }
            dataitem(SalaryClassFilter; "Salary Class")
            {
                DataItemLinkReference = Employee;
                DataItemTableView = sorting("Salary Class Code");
                dataitem(SalaryComputationLineEarnings; Integer)
                {
                    DataItemLinkReference = SalaryClassFilter;
                    DataItemTableView = sorting(number);
                    column(Computation_No_; ComputationNoG)
                    { }
                    column(SalaryComputationLineEarnings_Amount; AmountG)
                    { }
                    column(SalaryComputationLineEarnings_Description; DescriptionG)
                    { }
                    column(SalaryComputationLineEarnings_No__of_Paid_Leave_Days; NoofPaidLeaveDaysG)
                    { }
                    column(SalaryComputationLineEarnings_No__of_UnPaid_Leave_Days; NoofUnPaidLeaveDaysG)
                    { }
                    column(SalaryComputationLineEarnings_No__of_Working_Days; NoofWorkingDaysG)
                    { }
                    column(SalaryComputationLineEarnings_PaySlipMonthG; PaySlipMonthG)
                    { }
                    column(SalaryComputationLineEarnings_Pay_Period; PayPeriodDataItemG)
                    { }
                    column(SalaryComputationLineEarnings_Salary_Class; SalaryClassDataItemG)
                    { }
                    column(SalaryComputationLineEarnings_EmployeeNo; EmployeeNoDataItemG)
                    { }
                    column(SalaryComputationLineEarnings_LineType; LineTypeG)
                    { }
                    column(SalaryComputationLineDeduction_Amount; DeductionAmountG)
                    { }
                    column(SalaryComputationLineDeduction_Description; DeductionDescriptionG)
                    { }
                    column(SalaryComputationLineLeaveDays_AmtinWords; AmountinWordsG[1])
                    { }
                    column(SalaryComputationLineLeaveDays_TotalLeavetaken; TotalLeavetakenG)
                    { }
                    trigger OnPreDataItem()
                    begin
                        SalaryComputationLineDeductionG.SetCurrentKey("Employee No.", "Salary Class", "Pay Period", "Show in Payslip");
                        //SalaryComputationLineDeductionG.SetAutoCalcFields("Salary Class", "Pay Period");// Avi :Blocked coz made these fields as Normal Fields
                        SalaryComputationLineDeductionG.SetRange("Employee No.", Employee."No.");
                        SalaryComputationLineDeductionG.SetFilter("Salary Class", SalaryClassFilter."Salary Class Code");
                        SalaryComputationLineDeductionG.SetFilter("Pay Period", PayPeriodG);
                        SalaryComputationLineDeductionG.SetRange("Show in Payslip", true);
                        SalaryComputationLineDeductionG.SetFilter(Amount, '<%1', 0);
                        DeductionCountG := SalaryComputationLineDeductionG.Count();

                        SalaryComputationLineEarningsG.SetCurrentKey("Employee No.", "Salary Class", "Pay Period", "Show in Payslip");
                        //SalaryComputationLineEarningsG.SetAutoCalcFields("Salary Class", "Pay Period");// Avi :Blocked coz made these fields as Normal Fields
                        SalaryComputationLineEarningsG.SetRange("Employee No.", Employee."No.");
                        SalaryComputationLineEarningsG.SetFilter("Salary Class", SalaryClassFilter."Salary Class Code");
                        SalaryComputationLineEarningsG.SetFilter("Pay Period", PayPeriodG);
                        SalaryComputationLineEarningsG.SetRange("Show in Payslip", true);
                        SalaryComputationLineEarningsG.SetFilter(Amount, '>%1', 0);
                        EarningCountG := SalaryComputationLineEarningsG.Count();

                        SalaryComputationLineLeaveDaysG.Copy(SalaryComputationLineDeductionG);
                        SalaryComputationLineLeaveDaysG.SetRange(Amount);
                        SalaryComputationLineLeaveDaysG.SetRange("Show in Payslip");
                        SalaryComputationLineLeaveDaysG.SetRange("Line Type", SalaryComputationLineLeaveDaysG."Line Type"::Absence);
                        if SalaryComputationLineLeaveDaysG.FindFirst() then;

                        FinalCountG := EarningCountG;
                        if EarningCountG < DeductionCountG then
                            FinalCountG := DeductionCountG;

                        SalaryComputationLineEarnings.SETRANGE(Number, 1, FinalCountG);
                        IsDeductionNextEmptyG := false;
                        IsEarningNextEmptyG := false;
                        FinalCount2G := FinalCountG;

                    end;

                    trigger OnAfterGetRecord()
                    begin
                        if SalaryComputationLineEarnings.Number = 1 then begin
                            if SalaryComputationLineDeductionG.FindFirst() then;
                            if SalaryComputationLineEarningsG.FindFirst() then;
                        end else begin
                            if not IsDeductionNextEmptyG then
                                if SalaryComputationLineDeductionG.Next() = 0 then begin
                                    SalaryComputationLineDeductionG.Init();
                                    IsDeductionNextEmptyG := true;
                                end;

                            if not IsEarningNextEmptyG then
                                if SalaryComputationLineEarningsG.Next() = 0 then begin
                                    SalaryComputationLineEarningsG.Init();
                                    IsEarningNextEmptyG := true;
                                end;
                        end;

                        if EarningCountG > DeductionCountG then
                            AssignDefaultValue(SalaryComputationLineEarningsG)
                        else
                            AssignDefaultValue(SalaryComputationLineDeductionG);

                        AmountG := SalaryComputationLineEarningsG.Amount;
                        DescriptionG := SalaryComputationLineEarningsG.Description;
                        TotalEarningAmtG += AmountG;

                        DeductionAmountG := Abs(SalaryComputationLineDeductionG.Amount);
                        DeductionDescriptionG := SalaryComputationLineDeductionG.Description;
                        TotalDeductionAmtG += DeductionAmountG;

                        PaySlipMonthG := StrSubstNo(PaySlipMonthTxt, PayPeriodDataItemG);

                        FinalCount2G -= 1;
                        if FinalCount2G = 0 then begin
                            CheckG.InitTextVariable();
                            CheckG.FormatNoText(AmountinWordsG, TotalEarningAmtG - TotalDeductionAmtG, 'AED');
                            NoofPaidLeaveDaysG := SalaryComputationLineLeaveDaysG."No. of Paid Leave Days";
                            NoofUnPaidLeaveDaysG := SalaryComputationLineLeaveDaysG."No. of UnPaid Leave Days";
                            NoofWorkingDaysG := SalaryComputationLineLeaveDaysG."No. of Working Days";

                            SalaryComputationLineLeaveDaysG.SetRange("Salary Class");
                            SalaryComputationLineLeaveDaysG.SetRange("Pay Period");
                            SalaryComputationLineLeaveDaysG.CalcSums("No. of Paid Leave Days", "No. of UnPaid Leave Days");
                            TotalLeavetakenG := SalaryComputationLineLeaveDaysG."No. of Paid Leave Days" + SalaryComputationLineLeaveDaysG."No. of UnPaid Leave Days";
                        end
                    end;

                    trigger OnPostDataItem()
                    begin
                    end;
                }
                trigger OnPreDataItem()
                begin
                    if ChangeCompanyG then
                        SalaryClassFilter.ChangeCompany(EmployeeReplicaG."Company ATG");
                    SalaryClassFilter.SetFilter("Salary Class Code", SalaryClassG);
                end;

                trigger OnAfterGetRecord()
                begin
                end;

                trigger OnPostDataItem()
                begin
                end;
            }


            trigger OnPreDataItem()
            begin
                /* EmployeeReplicaG.Get(EmployeeNoG);
                ChangeCompanyG := EmployeeReplicaG."Company ATG" <> CurrentCompany();
                if ChangeCompanyG then begin
                    CompanyInformationG.ChangeCompany(EmployeeReplicaG."Company ATG");
                    Employee.ChangeCompany(EmployeeReplicaG."Company ATG");
                    PayCycleLineG.ChangeCompany(EmployeeReplicaG."Company ATG");
                    SalaryComputationLineDeductionG.ChangeCompany(EmployeeReplicaG."Company ATG");
                    SalaryComputationLineEarningsG.ChangeCompany(EmployeeReplicaG."Company ATG");
                    SalaryComputationLineLeaveDaysG.ChangeCompany(EmployeeReplicaG."Company ATG");
                end; */
                CompanyInformationG.get();
                CompanyInformationG.CalcFields(Picture);
                if EmployeeNoG <> '' then
                    Employee.SetFilter("No.", EmployeeNoG);
            end;

            trigger OnAfterGetRecord()
            var
                SalaryComputationLineL: Record "Salary Computation Line";
                EmployeeLevelAbsenceL: Record "Employee Level Absence";
                EmployeeTimingL: Record "Employee Timing";
            begin
                TotalEarningAmtG := 0;
                TotalDeductionAmtG := 0;
                /*  if ChangeCompanyG then
                     SalaryComputationLineL.ChangeCompany(EmployeeReplicaG."Company ATG"); */
                SalaryComputationLineL.SetCurrentKey("Employee No.", "Salary Class", "Pay Period");
                SalaryComputationLineL.SetRange("Employee No.", Employee."No.");
                SalaryComputationLineL.SetFilter("Salary Class", '%1', SalaryClassG);
                SalaryComputationLineL.SetFilter("Pay Period", PayPeriodG);
                if SalaryComputationLineL.IsEmpty() then
                    CurrReport.Skip();

                // Annual Leaves count for the month
                EmployeeLevelAbsenceL.SetRange("Employee No.", Employee."No.");
                EmployeeLevelAbsenceL.SetRange(Accrual, true);
                if EmployeeLevelAbsenceL.FindLast() then
                    LeaveBalanceG.Get(Employee."No.", EmployeeLevelAbsenceL."Absence Code");
                EmployeeTimingL.SetRange("Employee No.", Employee."No.");
                EmployeeTimingL.SetRange("From Date", PayCycleLineG."Period Start Date", PayCycleLineG."Period End Date");
                EmployeeTimingL.SetRange("First Half Status", EmployeeLevelAbsenceL."Absence Code");
                AnnualLeaveCountG := EmployeeTimingL.Count();
                EmployeeTimingL.SetRange("First Half Status");
                EmployeeTimingL.SetRange("Second Half Status", EmployeeLevelAbsenceL."Absence Code");
                AnnualLeaveCountG += EmployeeTimingL.Count();
                AnnualLeaveCountG := AnnualLeaveCountG / 2;

            end;

            trigger OnPostDataItem()
            begin

            end;
        }

    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group("Salary Slip")
                {
                    field("Salary Class"; SalaryClassG)
                    {
                        ApplicationArea = All;
                        //Editable = IsEditableG;
                        TableRelation = "Salary Class";
                        ToolTip = 'Specifies the value of the SalaryClassG';
                        trigger OnValidate()
                        begin

                        end;
                    }
                    field("Employee No."; EmployeeNoG)
                    {
                        ApplicationArea = All;
                        //Editable = IsEditableG;
                        TableRelation = Employee;
                        ToolTip = 'Specifies the value of the EmployeeNoG';
                        trigger OnLookup(var Text: Text): Boolean
                        var
                            EmployeeL: Record Employee;
                            FilterSelectionL: Codeunit SelectionFilterManagement;
                            EmployeeListL: Page "Employee List";
                            RecRefL: RecordRef;
                            SalaryClassErr: Label 'Salary class must have value';
                        begin
                            if SalaryClassG = '' then
                                Error(SalaryClassErr);

                            EmployeeL.SetRange("Salary Class", SalaryClassG);
                            EmployeeListL.LookupMode := true;
                            EmployeeListL.SetTableView(EmployeeL);
                            if EmployeeListL.RunModal() = Action::LookupOK then begin
                                EmployeeListL.SetSelectionFilter(EmployeeL);
                                RecRefL.GetTable(EmployeeL);
                                Evaluate(EmployeeNoG, FilterSelectionL.GetSelectionFilter(RecRefL, EmployeeL.FieldNo("No.")));
                            end;
                        end;
                    }
                    field("Pay Period"; PayPeriodG)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the PayPeriodG';
                        trigger OnLookup(var Text: Text): Boolean
                        var
                            SubGradeL: Record "Sub Grade";

                        begin
                            SubGradeL.SetRange("Salary Class", SalaryClassG);
                            SubGradeL.FindFirst();
                            SubGradeL.TestField("Pay Cycle");
                            PayCycleG := SubGradeL."Pay Cycle";
                            PayCycleLineG.SetCurrentKey("Period Start Date");
                            PayCycleLineG.SetRange("Pay Cycle", SubGradeL."Pay Cycle");
                            if Page.RunModal(0, PayCycleLineG) = Action::LookupOK then
                                PayPeriodG := PayCycleLineG."Pay Period";
                        end;
                    }
                }
            }
        }
    }
    labels
    {
        lbl_EmployeeName = 'Employee Name:';
        lbl_EmployeeID = 'Employee ID:';
        lbl_Designation = 'Designation:';
        lbl_EffectiveWorkDays = 'Effective Work Days:';
        lbl_JoiningDate = 'Joining Date:';
        lbl_ID = 'MOL ID:';
        lbl_LOPDays = 'LOP Days:';
        lbl_Earnings = 'Earnings';
        lbl_Amount = 'Amount';
        lbl_Deductions = 'Deductions';
        lbl_NetPay = 'Net Pay:';
        lbl_NetPayinWords = 'Net Pay in Words:';
        lbl_AnnualLeaveSummary = 'Annual Leave Summary';
        lbl_LeaveTaken = 'Leave Taken Till Date';
        lbl_BalanceAvailable = 'Balance Available';
        lbl_TotalEarnings = 'Total Earnings';
        lbl_TotalDeduction = 'Total Deduction';
    }
    var
        CompanyInformationG: Record "Company Information";
        PayCycleLineG: Record "Pay Period Line";
        SalaryComputationLineDeductionG: Record "Salary Computation Line";
        SalaryComputationLineEarningsG: Record "Salary Computation Line";
        SalaryComputationLineLeaveDaysG: Record "Salary Computation Line";
        EmployeeReplicaG: Record "Employee ATG";
        LeaveBalanceG: Record "Leave Balance Summary";

        CheckG: Report Check;
        PaySlipMonthTxt: Label 'Payslip for the month of %1';
        IsEarningNextEmptyG: Boolean;
        IsDeductionNextEmptyG: Boolean;
        SalaryClassG: Code[20];
        PayPeriodG: Code[30];
        PayCycleG: Code[20];
        EmployeeNoG: Code[20];
        ComputationNoG: Code[20];
        PayPeriodDataItemG: Code[30];
        SalaryClassDataItemG: Code[20];
        EmployeeNoDataItemG: Code[20];
        AmountG: Decimal;
        DeductionAmountG: Decimal;
        TotalEarningAmtG: Decimal;
        TotalDeductionAmtG: Decimal;
        NoofPaidLeaveDaysG: Decimal;
        NoofUnPaidLeaveDaysG: Decimal;
        NoofWorkingDaysG: Decimal;
        EarningCountG: Integer;
        DeductionCountG: Integer;
        FinalCountG: Integer;
        FinalCount2G: Integer;
        TotalLeavetakenG: Decimal;
        LineTypeG: Option;
        PaySlipMonthG: Text;
        DescriptionG: Text;
        DeductionDescriptionG: Text;
        AmountinWordsG: array[1] of Text;
        ChangeCompanyG: Boolean;
        AnnualLeaveCountG: Decimal;
        PasswordG: Text[20];
        GetEmpNoG: Codeunit "Single Instance";
        IsEditableG: Boolean;
        UserSetup: Record "User Setup";

    trigger OnInitReport()
    var
        EmployeeL: Record Employee;
    begin
        EmployeeNoG := GetEmpNoG.GetEmpNo();
        EmployeeL.Reset();
        EmployeeL.SetRange("No.", EmployeeNoG);
        if EmployeeL.FindFirst() then
            SalaryClassG := EmployeeL."Salary Class";
    end;

    trigger OnPreReport()

    begin
        /*Clear(IsEditableG);
        if (UserSetup.Get()) and (UserSetup."Is ESS User") then
            IsEditableG := false
        else
            IsEditableG := true;*/
    end;

    local procedure AssignDefaultValue(SalaryComputationLineP: Record "Salary Computation Line")
    begin
        ComputationNoG := SalaryComputationLineP."Computation No.";
        EmployeeNoDataItemG := SalaryComputationLineP."Employee No.";
        PayPeriodDataItemG := SalaryComputationLineP."Pay Period";
        SalaryClassG := SalaryComputationLineP."Salary Class";
        LineTypeG := SalaryComputationLineP."Line Type";
    end;

    procedure SetReportFilter(SalaryClassP: Code[20]; PayPeriodP: Code[30]; EmployeeNoP: Code[20])
    begin
        SalaryClassG := SalaryClassP;
        PayPeriodG := PayPeriodP;
        EmployeeNoG := EmployeeNoP;
    end;
}