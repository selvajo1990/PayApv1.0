report 50065 "Salary Computation"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    Caption = 'Salary Computation';
    ProcessingOnly = true;

    dataset
    {
        dataitem(Employee; Employee)
        {
            DataItemTableView = SORTING("No.");

            trigger OnPreDataItem()
            var
                EmployeeL: Record Employee;
            begin
                SalaryCountG := 0;
                Employee.SetFilter("No.", EmployeeNoG);
                Employee.SetFilter("Salary Class", SalaryClassG);
                EmployeeCountG := Employee.Count();
                Employee.FindFirst();
                // Inserting Salary Computation Header
                SalaryComputationHeaderG.Init();
                if ComputationNoG > '' then
                    SalaryComputationHeaderG."Computation No." := ComputationNoG;
                SalaryComputationHeaderG.Validate("Computation No.");
                if EmployeeCountG = 1 then
                    SalaryComputationHeaderG."Employee No." := Employee."No.";
                SalaryComputationHeaderG."Salary Class" := SalaryClassG;
                SalaryComputationHeaderG."No. of Employee" := EmployeeCountG;
                SalaryComputationHeaderG."Pay Period" := PayCycleLineG."Pay Period";
                SalaryComputationHeaderG."From Date" := PayCycleLineG."Period Start Date";
                SalaryComputationHeaderG."To Date" := PayCycleLineG."Period End Date";
                SalaryComputationHeaderG.Status := SalaryComputationHeaderG.Status::Open;
                SalaryComputationHeaderG."Created DateTime" := CurrentDateTime();
                if EmployeeL.Get(Employee."No.") then begin
                    EmployeeL."Last Salary Paid Pate" := Today;
                    EmployeeL.Modify();
                end;
                SalaryComputationHeaderG.TestField("Pay Period");
                SalaryComputationHeaderG.TestField("From Date");
                SalaryComputationHeaderG.TestField("To Date");
                SalaryComputationHeaderG.SetRecFilter();
                if (SalaryComputationHeaderG.IsEmpty()) and (ComputationNoG = '') then       //Suraj #14
                    SalaryComputationHeaderG.Insert();

                if HrSetupG."Enable Salary Cut-off" then
                    GetCutOffDates();
            end;

            trigger OnAfterGetRecord()
            var
                EmployeeLevelEarningL: Record "Employee Level Earning";
                AdhocPaymentL: Record "Adhoc Payment";
                TravelExpense: Record "Travel & Expense Advance";
                AmountL: Decimal;
                TotalAmountL: Decimal;
                MonthlyOpeningBalanceL: Decimal;
                StartDateL: Date;
                EndDateL: Date;
                CounterL: Integer;
                NoOfWorkingDaysL: Decimal;
                NoOfUnPaidLeaveL: Decimal;
                NoOfPaidLeaveL: Decimal;
                NoOfPayPeriodDaysL: Decimal;
                NoOfWithHoldDaysL: Decimal;
                LeaveDetailsLbl: Label 'Leave Information';
                IsAccrualL: Boolean;
                EarningcodeL: Code[20];

            begin
                RemoveDuplicateComputation();
                IsAccrualL := false;
                CounterL := 0;
                NoOfWorkingDaysL := CalculateWorkingDays(Employee."No.");
                IsSingleComponentG := IsSingleComponent(Employee."No.", FilterG);
                if FilterG = '' then
                    CurrReport.Skip();
                if (Employee."Termination Date" > CalculationStartDateG) and (Employee."Termination Date" < CalculationEndDateG) and (not EOSCalculationG) then
                    CurrReport.Skip();
                NoOfPayPeriodDaysL := CalculatePayPeriodDays();
                if IsSingleComponentG then begin
                    if HrSetupG."Enable Salary Cut-off" then begin
                        NoOfUnPaidLeaveL := CalculateUnPaidLeave(Employee."No.", CutoffStartDateG, CutoffEndDateG);
                        NoOfPaidLeaveL := CalculatePaidLeave(Employee."No.", CutoffStartDateG, CutoffEndDateG);
                    end else begin
                        NoOfUnPaidLeaveL := CalculateUnPaidLeave(Employee."No.", CalculationStartDateG, CalculationEndDateG);
                        NoOfPaidLeaveL := CalculatePaidLeave(Employee."No.", CalculationStartDateG, CalculationEndDateG);
                    end;
                    NoOfWithHoldDaysL := CalculateWithHoldDays(Employee."No.", CalculationStartDateG, CalculationEndDateG);
                end;
                // Inserting Basic Components & Employer Deduction
                SalaryCountG += 1;
                if NoOfWorkingDaysL > 0 then begin
                    if LeaveSalaryG and (ComputationCodeG > '') then
                        CalculateLeaveSalary(NoOfWorkingDaysL, NoOfPayPeriodDaysL)
                    else begin
                        EmployeeLevelEarningL.SetCurrentKey("Employee No.", "Earning Code", "From Date", "Pay With Salary", Accural);
                        EmployeeLevelEarningL.SetAutoCalcFields("To Date");
                        EmployeeLevelEarningL.SetRange("Employee No.", Employee."No.");
                        EmployeeLevelEarningL.SetFilter("From Date", FilterG);
                        EmployeeLevelEarningL.SetRange("Day Type", EmployeeLevelEarningL."Day Type"::" ");     // OT
                        // EmployeeLevelEarningL.SetRange("Pay With Salary", true); // Blocked coz Employer Deduction is not working
                        // EmployeeLevelEarningL.SetRange("Affects Salary", true);
                        EmployeeLevelEarningL.SetRange(Accural, false);
                        if EmployeeLevelEarningL.FindSet() then
                            repeat
                                EmployeeLevelEarningL.TestField("Earning Code");
                                GetComputationMode(EmployeeLevelEarningL);
                                if IsSingleComponentG then begin
                                    if ComputationModeG = ComputationModeG::Prorata then begin
                                        AmountL := CalculateAmount(NoOfPayPeriodDaysL, NoOfWorkingDaysL - NoOfWithHoldDaysL, 0, EmployeeLevelEarningL."Pay Amount");
                                        AmountL -= CheckForLeaveSetup(EmployeeLevelEarningL."Pay Amount", CalculationStartDateG, CalculationEndDateG);
                                        AmountL -= CalculateUnpaidLeaveSalary(EmployeeLevelEarningL, NoOfUnPaidLeaveL, NoOfPayPeriodDaysL, NoOfWorkingDaysL - NoOfWithHoldDaysL);
                                    end else
                                        AmountL := CalculateAmount(NoOfPayPeriodDaysL, NoOfPayPeriodDaysL, 0, EmployeeLevelEarningL."Pay Amount");
                                    if EmployeeLevelEarningL.Category = EmployeeLevelEarningL.Category::Deduction then
                                        AmountL := -AmountL;
                                    LineNoG += 10000;
                                    InsertSalaryComputationLine(SalaryComputationHeaderG."Computation No.", LineNoG, Employee."No.", EmployeeLevelEarningL."Earning Code", AmountL, EmployeeLevelEarningL."Earning Description", NoOfWorkingDaysL, 0, 0, SalaryComputationLineG."Line Type"::Earning, EmployeeLevelEarningL."Pay With Salary", EmployeeLevelEarningL."Affects Salary", EmployeeLevelEarningL."Show in payslip", EmployeeLevelEarningL.Category, EmployeeLevelEarningL.Type, 0, IsAccrualL, EmployeeLevelEarningL."Accrual Type"::" ", 0, 0, SalaryComputationLineG."Posting Category"::Salary, '', '');
                                end else begin
                                    CounterL += 1;
                                    EndDateL := GetEndDate(EmployeeLevelEarningL);
                                    StartDateL := GetStartDate(EmployeeLevelEarningL."From Date");
                                    if not HrSetupG."Enable Salary Cut-off" then
                                        NoOfUnPaidLeaveL := CalculateUnPaidLeave(Employee."No.", StartDateL, EndDateL)
                                    else
                                        NoOfUnPaidLeaveL := CalculateUnPaidLeave(Employee."No.", GetCutoffStartDate(EmployeeLevelEarningL), GetCutoffEndDate(EmployeeLevelEarningL));
                                    NoOfPaidLeaveL := CalculatePaidLeave(Employee."No.", StartDateL, EndDateL);
                                    NoOfWorkingDaysL := EndDateL - StartDateL + 1;
                                    NoOfWithHoldDaysL := CalculateWithHoldDays(Employee."No.", StartDateL, EndDateL);

                                    if ComputationModeG = ComputationModeG::Prorata then begin
                                        AmountL += CalculateAmount(NoOfPayPeriodDaysL, NoOfWorkingDaysL - NoOfWithHoldDaysL, NoOfUnPaidLeaveL, EmployeeLevelEarningL."Pay Amount");
                                        AmountL -= CheckForLeaveSetup(EmployeeLevelEarningL."Pay Amount", StartDateL, EndDateL);
                                    end else
                                        AmountL += CalculateAmount(NoOfPayPeriodDaysL, NoOfWorkingDaysL, 0, EmployeeLevelEarningL."Pay Amount");

                                    if (EmployeeLevelEarningL."Earning Code" <> EarningcodeL) then
                                        CounterG := GetLineCount(EmployeeLevelEarningL);
                                    EarningcodeL := EmployeeLevelEarningL."Earning Code";
                                    if CounterG = CounterL then begin
                                        CounterL := 0;
                                        LineNoG += 10000;
                                        if EmployeeLevelEarningL.Category = EmployeeLevelEarningL.Category::Deduction then
                                            AmountL := -AmountL;
                                        InsertSalaryComputationLine(SalaryComputationHeaderG."Computation No.", LineNoG, Employee."No.", EmployeeLevelEarningL."Earning Code", AmountL, EmployeeLevelEarningL."Earning Description", NoOfWorkingDaysL, 0, 0, SalaryComputationLineG."Line Type"::Earning, EmployeeLevelEarningL."Pay With Salary", EmployeeLevelEarningL."Affects Salary", EmployeeLevelEarningL."Show in payslip", EmployeeLevelEarningL.Category, EmployeeLevelEarningL.Type, 0, IsAccrualL, EmployeeLevelEarningL."Accrual Type"::" ", 0, 0, SalaryComputationLineG."Posting Category"::Salary, '', '');
                                        AmountL := 0;
                                    end;
                                end;
                            until EmployeeLevelEarningL.Next() = 0;

                        // Inserting Accrual Components
                        // EmployeeLevelEarningL.SetRange("Affects Salary");
                        // EmployeeLevelEarningL.SetRange("Pay With Salary");
                        EmployeeLevelEarningL.SetRange(Accural, true);
                        if EmployeeLevelEarningL.FindSet() then
                            repeat
                                LineNoG += 10000;
                                case EmployeeLevelEarningL."Accrual Type" of
                                    EmployeeLevelEarningL."Accrual Type"::"Gratuity Accrual":
                                        begin
                                            AmountL := CalculateGratuity(EmployeeLevelEarningL, TotalAmountL, MonthlyOpeningBalanceL);
                                            if AmountL <> 0 then
                                                InsertSalaryComputationLine(SalaryComputationHeaderG."Computation No.", LineNoG, Employee."No.", EmployeeLevelEarningL."Earning Code", AmountL, EmployeeLevelEarningL."Earning Description", 0, 0, 0, SalaryComputationLineG."Line Type"::Earning, EmployeeLevelEarningL."Pay With Salary", EmployeeLevelEarningL."Affects Salary", EmployeeLevelEarningL."Show in payslip", EmployeeLevelEarningL.Category, EmployeeLevelEarningL.Type, 0, IsAccrualL, EmployeeLevelEarningL."Accrual Type", TotalAmountL, MonthlyOpeningBalanceL, SalaryComputationLineG."Posting Category"::Salary, '', '');
                                            TotalAmountL := 0;
                                        end;
                                    EmployeeLevelEarningL."Accrual Type"::"Air Ticket":
                                        begin
                                            CalculateAirTicket(EmployeeLevelEarningL, TotalAmountL, AmountL, IsAccrualL);
                                            if AmountL <> 0 then
                                                if IsAccrualL then begin
                                                    InsertSalaryComputationLine(SalaryComputationHeaderG."Computation No.", LineNoG, Employee."No.", EmployeeLevelEarningL."Earning Code", EmployeeLevelEarningL."Pay Amount", EmployeeLevelEarningL."Earning Description", 0, 0, 0, SalaryComputationLineG."Line Type"::Earning, true, true, true, EmployeeLevelEarningL.Category, EmployeeLevelEarningL.Type, 0, false, EmployeeLevelEarningL."Accrual Type", 0, 0, SalaryComputationLineG."Posting Category"::Salary, '', '');
                                                    LineNoG += 10000;
                                                    InsertSalaryComputationLine(SalaryComputationHeaderG."Computation No.", LineNoG, Employee."No.", EmployeeLevelEarningL."Earning Code", AmountL, EmployeeLevelEarningL."Earning Description", 0, 0, 0, SalaryComputationLineG."Line Type"::Earning, EmployeeLevelEarningL."Pay With Salary", false, EmployeeLevelEarningL."Show in payslip", EmployeeLevelEarningL.Category, EmployeeLevelEarningL.Type::"Employer Contribution", 0, EmployeeLevelEarningL.Accural, EmployeeLevelEarningL."Accrual Type", TotalAmountL - EmployeeLevelEarningL."Pay Amount", MonthlyOpeningBalanceL, SalaryComputationLineG."Posting Category"::Salary, '', '');
                                                end else
                                                    InsertSalaryComputationLine(SalaryComputationHeaderG."Computation No.", LineNoG, Employee."No.", EmployeeLevelEarningL."Earning Code", AmountL, EmployeeLevelEarningL."Earning Description", 0, 0, 0, SalaryComputationLineG."Line Type"::Earning, false, false, false, EmployeeLevelEarningL.Category, EmployeeLevelEarningL.Type::"Employer Contribution", 0, EmployeeLevelEarningL.Accural, EmployeeLevelEarningL."Accrual Type", TotalAmountL, MonthlyOpeningBalanceL, SalaryComputationLineG."Posting Category"::Salary, '', '');
                                            TotalAmountL := 0;
                                        end;
                                end;
                            until EmployeeLevelEarningL.Next() = 0;
                    end;
                    //For OT Calculation
                    EmployeeOTCalculation(EmployeeLevelEarningL);
                    //For  DE Calculation
                    EmployeeDeductionCalculation(EmployeeLevelEarningL);
                    // Inserting Adhoc Payment
                    AdhocPaymentL.SetRange("Employee No.", Employee."No.");
                    AdhocPaymentL.SetRange("Pay With Salary", true);
                    AdhocPaymentL.SetRange("Adhoc Date", CalculationStartDateG, CalculationEndDateG);
                    if HrSetupG."Enable Salary Cut-off" then
                        AdhocPaymentL.SetRange("Adhoc Date", CutoffStartDateG, CutoffEndDateG);
                    if AdhocPaymentL.FindSet() then
                        repeat
                            AdhocPaymentL.TestField("Earning Code");
                            if AdhocPaymentL."Pay With Salary" then begin
                                LineNoG += 10000;
                                AmountL := Round(AdhocPaymentL."Adhoc Amount", HrSetupG."HR Rounding Precision", HrSetupG.RoundingDirection());
                                if AdhocPaymentL.Category = AdhocPaymentL.Category::Deduction then
                                    AmountL := -AmountL;
                                InsertSalaryComputationLine(SalaryComputationHeaderG."Computation No.", LineNoG, Employee."No.", AdhocPaymentL."Earning Code", AmountL, AdhocPaymentL."Earning Description", 0, 0, 0, SalaryComputationLineG."Line Type"::Earning, AdhocPaymentL."Pay With Salary", AdhocPaymentL."Affects Salary", AdhocPaymentL."Show in Payslip", AdhocPaymentL.Category, AdhocPaymentL.Type, 0, false, EmployeeLevelEarningL."Accrual Type"::" ", 0, 0, SalaryComputationLineG."Posting Category"::Salary, '', '');
                            end;
                        until AdhocPaymentL.Next() = 0;

                    // Inserting Leave Details
                    LineNoG += 10000;

                    // only for multiple component
                    if not IsSingleComponentG then begin
                        NoOfWorkingDaysL := CalculateWorkingDays(Employee."No.");
                        FindLeaveForMultiComponent(NoOfUnPaidLeaveL, NoOfPaidLeaveL, NoOfWithHoldDaysL)
                    end;
                end else
                    LineNoG += 10000;
                CheckForLeaveEncashment(); // Leave Encashment Calculation
                InsertSalaryComputationLine(SalaryComputationHeaderG."Computation No.", LineNoG, Employee."No.", '', 0, LeaveDetailsLbl, NoOfWorkingDaysL, NoOfUnPaidLeaveL, NoOfPaidLeaveL, SalaryComputationLineG."Line Type"::Absence, false, false, false, 0, 0, NoOfWithHoldDaysL, false, EmployeeLevelEarningL."Accrual Type"::" ", 0, 0, SalaryComputationLineG."Posting Category"::Salary, '', '');
                // Inserting Leave Accrual and Deduction
                if ((CalculationEndDateG = PayCycleLineG."Period End Date") and (Employee."Leave Accrual Start Date" > 0D)) or
                    EOSCalculationG
                then
                    CreateUpdateAccrualDeduction();
                // Update the Leave Balance - Reset if it is Year End.
                UpdateLeaveBalance();

                //Insert Loan Entries
                LoanRequestCalculation(NoOfWorkingDaysL);

                //Insert Instalment Loan Entries
                InstallmentCalculation(NoOfWorkingDaysL);

                // Inserting Advance
                LineNoG += 10000;
                TravelExpense.SetRange("Employee No.", Employee."No.");
                TravelExpense.SetRange("Approved Date", CalculationStartDateG, CalculationEndDateG);
                if HrSetupG."Enable Salary Cut-off" then
                    TravelExpense.SetRange("Approved Date", CutoffStartDateG, CutoffEndDateG);
                if TravelExpense.FindFirst() and TravelExpense."Pay with Salary" then
                    InsertSalaryComputationLine(SalaryComputationHeaderG."Computation No.", LineNoG, Employee."No.", TravelExpense."Expense Category Code", TravelExpense."Amount (LCY)", TravelExpense."Expense Category Description", 0, 0, 0, SalaryComputationLineG."Line Type"::" ", true, true, true, SalaryComputationLineG.Category::Earning, SalaryComputationLineG.Type::" ", 0, false, SalaryComputationLineG."Accrual Type"::" ", 0, 0, SalaryComputationLineG."Posting Category"::"Travel & Expense", '', '');

                // Pesion Pasi Gosi Calculation 
                //PasiGosiCalculation();

                //Breach Of Conduct
                BreachOfConductCalculation();

                // Air Ticket Accrual
                CalculateAirTicketAccrual();
            end;
        }
    }
    requestpage
    {
        layout
        {
            area("Content")
            {

                group("Salary Computation Filter")
                {
                    field("Salary Class"; SalaryClassG)
                    {
                        ApplicationArea = All;
                        TableRelation = "Salary Class";
                        ToolTip = 'Specifies the value of the SalaryClassG';

                        trigger OnValidate()
                        var
                            SalaryClassL: Record "Salary Class";
                            SubGradeL: Record "Sub Grade";
                            InvaildFilterErr: Label 'Invalid Filter';
                        begin
                            if not SalaryClassL.Get(SalaryClassG) then
                                Error(InvaildFilterErr);
                            SubGradeL.SetRange("Salary Class", SalaryClassG);
                            SubGradeL.FindFirst();
                            SubGradeL.TestField("Pay Cycle");
                            PayCycleG := SubGradeL."Pay Cycle";
                        end;
                    }
                    field("Employee No."; EmployeeNoG)
                    {
                        ApplicationArea = All;
                        TableRelation = Employee;
                        ToolTip = 'Specifies the value of the EmployeeNoG';

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            EmployeeL: Record Employee;
                            EmployeeList: Page "Employee List";
                            SalaryClassErr: Label 'Salary class must have value';
                        begin
                            if SalaryClassG = '' then
                                Error(SalaryClassErr);
                            EmployeeL.SetRange("Salary Class", SalaryClassG);
                            EmployeeList.SetTableView(EmployeeL);
                            EmployeeList.LookupMode(true);
                            if EmployeeList.RunModal() = Action::LookupOK then
                                EmployeeNoG := CopyStr(EmployeeList.GetSelectionFilter(), 1, 20);
                        end;
                    }
                    field("Pay Period"; PayPeriodG)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the PayPeriodG';

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            PayCycleLineG.SetCurrentKey("Period Start Date");
                            PayCycleLineG.SetRange("Pay Cycle", PayCycleG);
                            //PayCycleLineG.SetRange(Status, PayCycleLineG.Status::Open);
                            if Page.RunModal(0, PayCycleLineG) = Action::LookupOK then
                                PayPeriodG := PayCycleLineG."Pay Period";
                        end;

                        trigger OnValidate()
                        var
                            PayCycleLineL: Record "Pay Period Line";
                            InvaildFilterErr: Label 'Invalid Filter';
                        begin
                            PayCycleLineL.SetCurrentKey("Pay Cycle", "Pay Period");
                            PayCycleLineL.SetRange("Pay Cycle", PayCycleG);
                            PayCycleLineL.SetRange("Pay Period", PayPeriodG);
                            if PayCycleLineL.IsEmpty() then
                                Error(InvaildFilterErr);
                        end;
                    }
                    field("Display Salary"; DisplaySalaryG)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the DisplaySalaryG';
                    }
                }
            }
        }
    }
    trigger OnPreReport()
    var
        FilterMissingErr: Label 'Both Employee No. & Salary Class cannot be empty';
        PayPeriodErr: Label 'Pay Period Should have value';
    begin
        if (EmployeeNoG = '') and (SalaryClassG = '') then
            Error(FilterMissingErr);
        if PayPeriodG = '' then
            Error(PayPeriodErr);
        HrSetupG.Get();
        HrSetupG.TestField("Salary Computation Nos.");
        HrSetupG.TestField("HR Rounding Precision");
    end;

    trigger OnPostReport()
    var
        SalaryCalculatedLbl: Label 'Salary calculated for %1 Employee';
    begin
        if (not LeaveSalaryG) then
            Message(SalaryCalculatedLbl, SalaryCountG);
        SalaryComputationHeaderG."No. of Employee" := SalaryCountG;
        if ComputationNoG = '' then     //Suraj #14
            SalaryComputationHeaderG.Modify();
        if DisplaySalaryG then begin
            Commit();
            Page.Run(Page::"Salary Computation Dispaly", SalaryComputationHeaderG);
        end;
    end;

    var
        HrSetupG: Record "Human Resources Setup";
        SalaryComputationHeaderG: Record "Salary Computation Header";
        SalaryComputationLineG: Record "Salary Computation Line";
        PayCycleLineG: Record "Pay Period Line";
        //PasiGosiG: record "Pension/PASI/GOSI";
        EmployeeEarningHistoryG: record "Employee Earning History";
        EmployeeLevelEarningG: record "Employee Level Earning";
        EmployeeDisciplinaryActionG: record "Employee Disciplinary Action";
        DisciplinaryActionLineG: record "Disciplinary Action Line";
        EmployeeTimingG: record "Employee Timing";
        DisplaySalaryG: Boolean;
        IsSingleComponentG: Boolean;

        EmployeeNoG: Code[20];
        SalaryClassG: Code[20];

        PayPeriodG: Code[30];
        PayCycleG: Code[20];
        CalculationStartDateG: Date;
        CalculationEndDateG: Date;
        EmployeeCountG: Integer;
        LineNoG: Integer;
        CounterG: Integer;
        SalaryCountG: Integer;
        FilterG: Text;
        CutoffStartDateG: Date;
        CutoffEndDateG: Date;
        ComputationNoG: Code[20];
        LeaveSalaryG: Boolean;
        EOSCalculationG: Boolean;
        LeaveSalaryExistFortheMonthG: Boolean;
        ComputationCodeG: code[20];
        ReasonCodeG: Code[20];
        ComputationTypeG: Integer;
        ComputationModeG: Option "Prorata","Full Amount";
        ModeOfMonthG: Option "First Month","Confirmed","Last Month";
        JournalsCreatedErr: Label 'Payroll Journals has been Created for the Month %1 in Salary Computation %2. Please delete the entries and try again';

    local procedure CalculateAirTicketAccrual()
    var
        EmployeeAirTicket: Record "Employee Level Air Ticket";
        FlightCost: Record "Flight Cost";
        Relative: Record "Employee Relative";
        TicketRequest: Record "Air Ticket Request";
        AgeGroup: Record "Age Group";
        SalaryComputationLine: Record "Salary Computation Line";
        SalaryComputationLine2: Record "Salary Computation Line";
        EmployeeEarningHistroy: Record "Employee Earning History";
        RelativeAmount: Decimal;
        PerdayAmount: Decimal;
        DeductionAmount: Decimal;
        AmountL: Decimal;
        TotalAmountL: Decimal;
        FirstTimeRelativeAmount: Decimal;
        MonthlyAccrualAmount: Decimal;
        FirstAccrualDay: Date;
        DefaultAccrualStartDate: Date;
        RelativeAccrualStartDate: Date;
        ExpiryDate: Date;
        AccrualCurrentYear: Integer;
        FreeText2: Text[250];
        AirTicketAmtTxt: Label 'Air Ticket Amount';
        AirTicketTxt: Label 'Air Ticket';
    begin
        TicketRequest.Reset();
        TicketRequest.SetRange("Employee No.", Employee."No.");
        TicketRequest.SetRange(Status, TicketRequest.Status::Approved);
        TicketRequest.SetRange("Approved Date", PayCycleLineG."Period Start Date", PayCycleLineG."Period End Date");
        TicketRequest.SetRange("Air Ticket Type", TicketRequest."Air Ticket Type"::Amount);
        TicketRequest.CalcSums(Amount);
        if TicketRequest.Amount > 0 then
            DeductionAmount := TicketRequest.Amount;
        TicketRequest.SetRange("Pay with Salary", true);
        if not TicketRequest.IsEmpty() then begin
            TicketRequest.CalcSums(Amount);
            if TicketRequest.Amount > 0 then begin
                DeductionAmount := TicketRequest.Amount;
                LineNoG += 10000;
                InsertSalaryComputationLine(SalaryComputationHeaderG."Computation No.", LineNoG, Employee."No.", CopyStr(EmployeeAirTicket.TableCaption(), 1, 20), DeductionAmount, AirTicketAmtTxt, 0, 0, 0, SalaryComputationLineG."Line Type"::Earning, true, true, true, SalaryComputationLineG.Category::Earning, SalaryComputationLineG.Type::Constant, 0, true, SalaryComputationLine."Accrual Type"::"Air Ticket", DeductionAmount, 0, SalaryComputationLineG."Posting Category"::Accruals, '', Format(FirstAccrualDay));
            end;
        end else begin
            TicketRequest.SetRange("Air Ticket Type", TicketRequest."Air Ticket Type"::Ticket);
            TicketRequest.CalcSums("No. of Ticket");
            if TicketRequest."No. of Ticket" > 0 then begin
                LineNoG += 10000;
                DeductionAmount := TicketRequest."No. of Ticket";
                // if it air ticket how to show in payslip
                InsertSalaryComputationLine(SalaryComputationHeaderG."Computation No.", LineNoG, Employee."No.", CopyStr(EmployeeAirTicket.TableCaption(), 1, 20), 0, AirTicketTxt, 0, 0, 0, SalaryComputationLineG."Line Type"::Earning, false, false, false, SalaryComputationLineG.Category::Earning, SalaryComputationLineG.Type::Constant, 0, true, SalaryComputationLine."Accrual Type"::"Air Ticket", 0, 0, SalaryComputationLineG."Posting Category"::Accruals, '', Format(FirstAccrualDay));
                SalaryComputationLineG.Get(SalaryComputationHeaderG."Computation No.", LineNoG);
                SalaryComputationLineG."Accrual Value" := DeductionAmount;
                SalaryComputationLineG.Modify();
            end;
        end;

        if (Employee."Air Ticket Accrual Start Date" > 0D) and (PayCycleLineG."Period End Date" >= Employee."Air Ticket Accrual Start Date") then begin
            AccrualCurrentYear := (PayCycleLineG."Period End Date" - Employee."Air Ticket Accrual Start Date" + 1) DIV 365;
            if AccrualCurrentYear = 0 then
                RelativeAccrualStartDate := Employee."Air Ticket Accrual Start Date"
            else
                RelativeAccrualStartDate := CalcDate(StrSubstNo('<%1Y>', AccrualCurrentYear), Employee."Air Ticket Accrual Start Date");
            FirstAccrualDay := 0D;
            RelativeAmount := 0;
            DefaultAccrualStartDate := CalcDate('<-CM>', Employee."Air Ticket Accrual Start Date");
            Employee.TestField("Birth Date");
            Employee.TestField("Flight Destination Code");
            Employee.TestField("Air Ticket Group");

            EmployeeEarningHistroy.SetRange("Employee No.", Employee."No.");
            EmployeeEarningHistroy.SetRange("Group Code", Employee."Air Ticket Group");
            EmployeeEarningHistroy.SetRange("Component Type", EmployeeEarningHistroy."Component Type"::"Air Ticket");
            EmployeeEarningHistroy.SetFilter("From Date", '<=%1', PayCycleLineG."Period End Date");
            EmployeeEarningHistroy.SetFilter("To Date", '>=%1', PayCycleLineG."Period End Date");
            EmployeeEarningHistroy.FindFirst();

            EmployeeAirTicket.SetRange("Employee No.", Employee."No.");
            EmployeeAirTicket.SetRange("Air Ticket Group Code", EmployeeEarningHistroy."Group Code");
            EmployeeAirTicket.SetRange("From Date", EmployeeEarningHistroy."From Date");
            if not EmployeeAirTicket.FindFirst() then
                exit;
            EmployeeAirTicket.TestField(Provision);
            EmployeeAirTicket.TestField("Accrual Expiry Days");

            GetPreviousMonthRecord(SalaryComputationLine, CopyStr(EmployeeAirTicket.TableCaption(), 1, 20));

            Relative.SetRange("Employee No.", Employee."No.");
            Relative.SetRange("Air Ticket", true);
            if Relative.FindSet() then
                repeat
                    FreeText2 += Relative."Relative Code" + '|';
                    if EmployeeAirTicket."Accruing Type" = EmployeeAirTicket."Accruing Type"::Amount then begin
                        FlightCost.SetRange("Flight Destination Code", Employee."Flight Destination Code");
                        FlightCost.SetRange("Class Type", EmployeeAirTicket."Class Type");
                        FlightCost.SetRange(Category, Relative."Age Group");
                        FlightCost.SetFilter("Start Date", '<=%1', PayCycleLineG."Period End Date");
                        FlightCost.SetFilter("End Date", '>=%1', PayCycleLineG."Period End Date");
                        FlightCost.FindFirst();
                        if SalaryComputationLine."Free Text 2".Contains(Relative."Relative Code") and (SalaryComputationLine."Free Text 2" > '') then
                            RelativeAmount += FlightCost.Amount
                        else
                            FirstTimeRelativeAmount += ((PayCycleLineG."Period End Date" - CalcDate('<-CM>', RelativeAccrualStartDate) + 1) * FlightCost.Amount) / EmployeeAirTicket.Provision;
                    end else
                        if SalaryComputationLine."Free Text 2".Contains(Relative."Relative Code") and (SalaryComputationLine."Free Text 2" > '') then
                            RelativeAmount += 1
                        else
                            FirstTimeRelativeAmount += (PayCycleLineG."Period End Date" - CalcDate('<-CM>', RelativeAccrualStartDate) + 1) / EmployeeAirTicket.Provision;
                until Relative.Next() = 0;

            // for employee - no change needed
            if (EmployeeAirTicket."Accruing Type" = EmployeeAirTicket."Accruing Type"::Amount) then begin
                AgeGroup.Setfilter("From Age", '<=%1', Today() - Employee."Birth Date" + 1);
                AgeGroup.Setfilter("To Age", '>=%1', Today() - Employee."Birth Date" + 1);
                AgeGroup.FindFirst();
                FlightCost.SetRange("Flight Destination Code", Employee."Flight Destination Code");
                FlightCost.SetRange("Class Type", EmployeeAirTicket."Class Type");
                FlightCost.SetRange(Category, AgeGroup."Age Group Code");
                FlightCost.SetFilter("Start Date", '<=%1', PayCycleLineG."Period End Date");
                FlightCost.SetFilter("End Date", '>=%1', PayCycleLineG."Period End Date");
                FlightCost.FindFirst();
                RelativeAmount += FlightCost.Amount
            end else
                RelativeAmount += 1;

            if SalaryComputationLine."Free Text 1" = '' then
                ExpiryDate := CalcDate(StrSubstNo('<%1D>', EmployeeAirTicket."Accrual Expiry Days"), Employee."Air Ticket Accrual Start Date")
            else begin
                Evaluate(FirstAccrualDay, SalaryComputationLine."Free Text 1");
                ExpiryDate := CalcDate(StrSubstNo('<%1D>', EmployeeAirTicket."Accrual Expiry Days"), FirstAccrualDay);
            end;

            if (ExpiryDate >= PayCycleLineG."Period Start Date") and (ExpiryDate <= PayCycleLineG."Period End Date") then begin
                FirstAccrualDay := RelativeAccrualStartDate;
                SalaryComputationLine2.Reset();
                SalaryComputationLine2.SetRange("Employee No.", Employee."No.");
                SalaryComputationLine2.SetRange("Pay Period", GetPayPeriod(RelativeAccrualStartDate - 1, Employee."No."));
                SalaryComputationLine2.SetRange(Code, CopyStr(EmployeeAirTicket.TableCaption(), 1, 20));
                SalaryComputationLine2.FindLast();

                TicketRequest.Reset();
                TicketRequest.SetRange("Employee No.", Employee."No.");
                TicketRequest.SetRange(Status, TicketRequest.Status::Approved);
                TicketRequest.SetRange("Approved Date", CalcDate(StrSubstNo('<%1D>', EmployeeAirTicket.Provision), FirstAccrualDay), PayCycleLineG."Period End Date");
                TicketRequest.CalcSums(Amount, "No. of Ticket");

                case true of
                    (EmployeeAirTicket."Accruing Type" = EmployeeAirTicket."Accruing Type"::Amount) and (SalaryComputationLine2."Total Amount" > TicketRequest.Amount):
                        DeductionAmount := SalaryComputationLine2."Total Amount" - TicketRequest.Amount;
                    (EmployeeAirTicket."Accruing Type" = EmployeeAirTicket."Accruing Type"::Ticket) and (SalaryComputationLine2."Total Accrual Value" > TicketRequest."No. of Ticket"):
                        DeductionAmount := SalaryComputationLine2."Total Accrual Value" - TicketRequest."No. of Ticket";
                end;
            end;
            PerdayAmount := RelativeAmount / EmployeeAirTicket.Provision;
            MonthlyAccrualAmount := CalculatePayPeriodDays() * PerdayAmount;
            AmountL := MonthlyAccrualAmount + FirstTimeRelativeAmount;

            LineNoG += 10000;
            if EmployeeAirTicket."Accruing Type" = EmployeeAirTicket."Accruing Type"::Amount then begin
                TotalAmountL := Round(AmountL + SalaryComputationLine."Total Amount" - DeductionAmount, HrSetupG."HR Rounding Precision", HrSetupG.RoundingDirection());
                AmountL := Round(AmountL, HrSetupG."HR Rounding Precision", HrSetupG.RoundingDirection());
                InsertSalaryComputationLine(SalaryComputationHeaderG."Computation No.", LineNoG, Employee."No.", CopyStr(EmployeeAirTicket.TableCaption(), 1, 20), AmountL, EmployeeAirTicket.Description, 0, 0, 0, SalaryComputationLineG."Line Type"::Earning, false, false, false, SalaryComputationLineG.Category::Earning, SalaryComputationLineG.Type::"Employer Contribution", 0, true, SalaryComputationLine."Accrual Type"::"Air Ticket", TotalAmountL, 0, SalaryComputationLineG."Posting Category"::Accruals, '', Format(FirstAccrualDay));
                SalaryComputationLineG.Get(SalaryComputationHeaderG."Computation No.", LineNoG);
                SalaryComputationLineG."Free Text 2" := FreeText2;
                SalaryComputationLineG.Modify();
            end else begin
                TotalAmountL := AmountL + SalaryComputationLine."Total Accrual Value" - DeductionAmount;
                InsertSalaryComputationLine(SalaryComputationHeaderG."Computation No.", LineNoG, Employee."No.", CopyStr(EmployeeAirTicket.TableCaption(), 1, 20), 0, EmployeeAirTicket.Description, 0, 0, 0, SalaryComputationLineG."Line Type"::Earning, false, false, false, SalaryComputationLineG.Category::Earning, SalaryComputationLineG.Type::"Employer Contribution", 0, true, SalaryComputationLine."Accrual Type"::"Air Ticket", 0, 0, SalaryComputationLineG."Posting Category"::Accruals, '', Format(FirstAccrualDay));
                SalaryComputationLineG.Get(SalaryComputationHeaderG."Computation No.", LineNoG);
                SalaryComputationLineG."Accrual Value" := Round(AmountL, HrSetupG."HR Rounding Precision", HrSetupG.RoundingDirection());
                SalaryComputationLineG."Total Accrual Value" := Round(TotalAmountL, HrSetupG."HR Rounding Precision", HrSetupG.RoundingDirection());
                SalaryComputationLineG."Free Text 2" := FreeText2;
                SalaryComputationLineG.Modify();
            end;
        end;
    end;

    local procedure CalculatePaidLeave(EmployeeP: Code[20];
        StartDateP: Date;
        EndDateP: Date) NoOfPaidDaysR: Decimal
    var
        AbsenceL: Record Absence;
        EmployeeTimingsL: Record "Employee Timing";
    begin
        NoOfPaidDaysR := 0;
        if (StartDateP = 0D) or (EndDateP = 0D) then
            exit(0);
        EmployeeTimingsL.SetRange("Employee No.", EmployeeP);
        EmployeeTimingsL.SetRange("From Date", StartDateP, EndDateP);
        AbsenceL.SetRange(Type, AbsenceL.Type::Paid);
        if AbsenceL.FindSet() then
            repeat
                EmployeeTimingsL.SetRange("First Half Status", AbsenceL."Absence Code");
                NoOfPaidDaysR += EmployeeTimingsL.Count();
                EmployeeTimingsL.SetRange("First Half Status");
                EmployeeTimingsL.SetRange("Second Half Status", AbsenceL."Absence Code");
                NoOfPaidDaysR += EmployeeTimingsL.Count();
            until AbsenceL.Next() = 0;
        exit(NoOfPaidDaysR / 2);
    end;

    local procedure CalculateUnPaidLeave(EmployeeP: Code[20]; StartDateP: Date; EndDateP: Date) NoOfUnpaidDaysR: Decimal
    var
        AbsenceL: Record Absence;
        EmployeeTimingsL: Record "Employee Timing";
    begin
        if (StartDateP = 0D) or (EndDateP = 0D) then
            exit(0);
        EmployeeTimingsL.SetRange("Employee No.", EmployeeP);
        EmployeeTimingsL.SetRange("From Date", StartDateP, EndDateP);
        AbsenceL.SetRange(Type, AbsenceL.Type::Unpaid);
        if AbsenceL.FindSet() then
            repeat
                EmployeeTimingsL.SetRange("First Half Status", AbsenceL."Absence Code");
                NoOfUnpaidDaysR += EmployeeTimingsL.Count();
                EmployeeTimingsL.SetRange("First Half Status");
                EmployeeTimingsL.SetRange("Second Half Status", AbsenceL."Absence Code");
                NoOfUnpaidDaysR += EmployeeTimingsL.Count();
            until AbsenceL.Next() = 0;
        exit(NoOfUnpaidDaysR / 2);
    end;

    local procedure CalculateWorkingDays(EmployeeP: Code[20]): Integer
    var
        EmployeeL: Record Employee;
        SalaryComputationLineL: Record "Salary Computation Line";
        LeaveRequestL: Record "Leave Request";
    begin
        if LeaveSalaryG then
            exit(CalculationEndDateG - CalculationStartDateG + 1); // If leave Salary setting the values in SetDefaultVluesforleavesalary function.
        EmployeeL.Get(EmployeeP);
        EmployeeL.TestField("Employment Date");
        SalaryComputationLineL.SetRange("Employee No.", EmployeeL."No.");
        SalaryComputationLineL.SetRange("Salary Class", EmployeeL."Salary Class");
        SalaryComputationLineL.SetRange("Pay Period", PayCycleLineG."Pay Period");
        SalaryComputationLineL.SetRange("Computation Type", SalaryComputationLineL."Computation Type"::"Leave Days");
        if SalaryComputationLineL.FindLast() then begin // Finding any leave salary happened for that pay period.
            LeaveSalaryExistFortheMonthG := true;
            LeaveRequestL.Get(SalaryComputationLineL."Computation No.");
            CalculationStartDateG := LeaveRequestL."End Date" + 1;
            CalculationEndDateG := PayCycleLineG."Period End Date";
            if CalculationStartDateG > PayCycleLineG."Period End Date" then begin
                CalculationStartDateG := PayCycleLineG."Period Start Date";
                exit(0);
            end;
            exit(CalculationEndDateG - CalculationStartDateG + 1);
        end;
        CalculationStartDateG := PayCycleLineG."Period Start Date";
        CalculationEndDateG := PayCycleLineG."Period End Date";
        ModeOfMonthG := ModeOfMonthG::Confirmed;
        if (EmployeeL."Employment Date" >= PayCycleLineG."Period Start Date") and (EmployeeL."Employment Date" <= PayCycleLineG."Period End Date") then begin
            CalculationStartDateG := EmployeeL."Employment Date";
            ModeOfMonthG := ModeOfMonthG::"First Month";
            exit((PayCycleLineG."Period End Date" - EmployeeL."Employment Date") + 1);
        end;
        if (EmployeeL."Termination Date" > 0D) and (ComputationNoG > '') then begin
            CalculationEndDateG := EmployeeL."Termination Date";
            ModeOfMonthG := ModeOfMonthG::"Last Month";
        end;
        exit(CalculationEndDateG - CalculationStartDateG + 1)
    end;

    local procedure CalculatePayPeriodDays(): Integer
    begin
        exit(PayCycleLineG."Period End Date" - PayCycleLineG."Period Start Date" + 1);
    end;

    local procedure CalculateWithHoldDays(EmployeeNoP: Code[20]; StartDateP: Date; EndDateP: Date) NoOfWithHoldDaysR: Integer
    var
        WithHoldL: Record "Withhold Salary";
        DateL: Record Date;
        TempDate2L: Record Date temporary;
    begin
        WithHoldL.SetRange("Employee No.", EmployeeNoP);
        if WithHoldL.FindSet() then
            repeat
                WithHoldL.TestField("From Date");
                WithHoldL.TestField("To Date");
                TempDate2L.Reset();
                TempDate2L.DeleteAll();
                DateL.SetRange("Period Type", DateL."Period Type"::Date);
                DateL.SetRange("Period Start", WithHoldL."From Date", WithHoldL."To Date");
                DateL.FindSet();
                repeat
                    TempDate2L.Init();
                    TempDate2L := DateL;
                    TempDate2L.Insert();
                until DateL.Next() = 0;
                TempDate2L.SetRange("Period Start", StartDateP, EndDateP);
                NoOfWithHoldDaysR += TempDate2L.Count();
            until WithHoldL.Next() = 0;
        exit(NoOfWithHoldDaysR);
    end;

    local procedure CalculateAmount(NoOfPayPeriodDaysP: Decimal; NoOfWorkingDaysP: Decimal; NoOfUnPaidLeaveP: Decimal; AmountP: Decimal) AmountR: Decimal
    begin
        AmountR := Round(((AmountP / NoOfPayPeriodDaysP) * NoOfWorkingDaysP) - ((AmountP / NoOfPayPeriodDaysP) * NoOfUnPaidLeaveP), HrSetupG."HR Rounding Precision", HrSetupG.RoundingDirection());
        exit(AmountR);
    end;

    local procedure CalculateGratuity(EmployeeLevelEarningP: Record "Employee Level Earning"; var TotalAmountP: Decimal; var MonthlyOpeningBalanceP: Decimal): Decimal
    var
        AccrualSetupLineL: Record "Accrual Setup Line";
        OpeningBalanceL: Record "Opening Balance";
        SalaryComputationLineL: Record "Salary Computation Line";
        PaymentSetupLineL: Record "Payment Setup Line";
        GratuityFormulaL: Record "Gratuity Formula";
        ReasonCodeL: Record "Reason Code";
        NoOfDaysMonthL: Decimal;
        ServiceDaysL: Decimal;
        ServiceDayProrataL: Decimal;
        MonthlyAmountL: Decimal;
        PerDayGratuitySalaryL: Decimal;
        CumulativeOpeningBalanceL: Decimal;
        DaysCalculatedL: Integer;
    begin
        MonthlyAmountL := 0;

        if (Employee."Gratuity Accrual Start Date" = 0D) or (Employee."Gratuity Accrual Start Date" > PayCycleLineG."Period End Date") then
            exit(0);
        // Avi : Gratuity for EOS
        if not ((Employee."Termination Date" = CalculationEndDateG) or (CalculationEndDateG = PayCycleLineG."Period End Date")) then
            exit(0);

        HrSetupG.TestField("Gratuity Accrual Days");
        ServiceDaysL := CalculationEndDateG - Employee."Gratuity Accrual Start Date" + 1;
        if Employee."Termination Date" = CalculationEndDateG then begin
            AccrualSetupLineL.SetCurrentKey("From Days");
            AccrualSetupLineL.SetRange("Earning Code", EmployeeLevelEarningP."Earning Code");
            AccrualSetupLineL.FindFirst();
            if ServiceDaysL < AccrualSetupLineL."To Days" then
                exit(0);
        end;
        OpeningBalanceL.SetRange("Employee No.", Employee."No.");
        OpeningBalanceL.SetRange(Code, EmployeeLevelEarningP."Earning Code");
        OpeningBalanceL.CalcSums(Amount);
        CumulativeOpeningBalanceL := OpeningBalanceL.Amount;
        OpeningBalanceL.SetRange("Pay Period", PayCycleLineG."Pay Period");
        OpeningBalanceL.CalcSums(Amount);
        MonthlyOpeningBalanceP := OpeningBalanceL.Amount;

        NoOfDaysMonthL := PayCycleLineG."Period End Date" - Employee."Gratuity Accrual Start Date" + 1;
        if EOSCalculationG and (ReasonCodeG > '') then begin
            ReasonCodeL.Get(ReasonCodeG);
            PaymentSetupLineL.SetCurrentKey("Earning Code", "Reason Code", "From Days");
            PaymentSetupLineL.SetRange("Earning Code", EmployeeLevelEarningP."Earning Code");
            PaymentSetupLineL.SetRange("Reason Code", ReasonCodeG);
            PaymentSetupLineL.SetFilter("From Days", '<=%1', ServiceDaysL);
            PaymentSetupLineL.SetFilter("To Days", '>=%1', ServiceDaysL);
            if PaymentSetupLineL.Findfirst() then begin
                GratuityFormulaL.SetCurrentKey("Earning Code", "Reason Code", "Days Upto");
                GratuityFormulaL.SetRange("Reason Code", ReasonCodeG);
                GratuityFormulaL.SetRange("Earning Code", EmployeeLevelEarningP."Earning Code");
                GratuityFormulaL.SetRange("To Days", PaymentSetupLineL."To Days");
                if not GratuityFormulaL.FindSet() then
                    exit(0);
                repeat
                    if ServiceDaysL <= GratuityFormulaL."Days Upto" then
                        ServiceDayProrataL += ((ServiceDaysL - DaysCalculatedL) / HrSetupG."Gratuity Accrual Days") * GratuityFormulaL."No. of Days"
                    else
                        ServiceDayProrataL += ((GratuityFormulaL."Days Upto" - DaysCalculatedL) / HrSetupG."Gratuity Accrual Days") * GratuityFormulaL."No. of Days";
                    DaysCalculatedL := GratuityFormulaL."Days Upto";
                until GratuityFormulaL.Next() = 0;
                PerDayGratuitySalaryL := Round(EmployeeLevelEarningP."Pay Amount" * 12 / HrSetupG."Gratuity Accrual Days", HrSetupG."HR Rounding Precision", HrSetupG.RoundingDirection());
                TotalAmountP := Round(PerDayGratuitySalaryL * ServiceDayProrataL, HrSetupG."HR Rounding Precision", HrSetupG.RoundingDirection());
                if ReasonCodeL.Percentage > 0 then
                    TotalAmountP := TotalAmountP * ReasonCodeL.Percentage / 100;
            end;
            MonthlyAmountL := TotalAmountP;
            exit(MonthlyAmountL);
        end;

        AccrualSetupLineL.SetRange("Earning Code", EmployeeLevelEarningP."Earning Code");
        AccrualSetupLineL.SetFilter("From Days", '<=%1', NoOfDaysMonthL);
        AccrualSetupLineL.SetFilter("To Days", '>=%1', NoOfDaysMonthL);
        AccrualSetupLineL.FindLast();

        ServiceDayProrataL := ServiceDaysL / HrSetupG."Gratuity Accrual Days";

        PerDayGratuitySalaryL := Round(EmployeeLevelEarningP."Pay Amount" * 12 / HrSetupG."Gratuity Accrual Days", HrSetupG."HR Rounding Precision", HrSetupG.RoundingDirection());
        TotalAmountP := Round(PerDayGratuitySalaryL * ServiceDayProrataL * AccrualSetupLineL."No. Of Days", HrSetupG."HR Rounding Precision", HrSetupG.RoundingDirection());

        GetPreviousMonthRecord(SalaryComputationLineL, EmployeeLevelEarningP."Earning Code");

        TotalAmountP := TotalAmountP + CumulativeOpeningBalanceL;
        MonthlyAmountL := TotalAmountP - SalaryComputationLineL."Total Amount" - MonthlyOpeningBalanceP;
        // if EOSCalculationG then
        //     MonthlyAmountL := TotalAmountP;
        exit(MonthlyAmountL);
    end;

    local procedure IsSingleComponent(EmployeeNoP: Code[20]; var FilterP: Text): Boolean
    var
        EmployeeLevelEarningL: Record "Employee Level Earning";
        DateL: Date;
        CounterL: Integer;
    begin
        CounterL := 0;
        DateL := 0D;
        FilterP := '';
        EmployeeLevelEarningL.SetAutoCalcFields("To Date");
        EmployeeLevelEarningL.SETCURRENTKEY("Employee No.", "From Date");
        EmployeeLevelEarningL.SetRange("Employee No.", EmployeeNoP);
        EmployeeLevelEarningL.FindSet();
        REPEAT
            IF DateL <> EmployeeLevelEarningL."From Date" THEN
                if ((CalculationStartDateG >= EmployeeLevelEarningL."From Date") and (CalculationStartDateG <= EmployeeLevelEarningL."To Date")) or
                     ((CalculationEndDateG >= EmployeeLevelEarningL."From Date") and (CalculationEndDateG <= EmployeeLevelEarningL."To Date")) or
                     ((CalculationStartDateG <= EmployeeLevelEarningL."From Date") and (CalculationEndDateG >= EmployeeLevelEarningL."To Date"))
                THEN begin
                    FilterP += format(EmployeeLevelEarningL."From Date") + '|';
                    CounterL += 1;
                end;

            DateL := EmployeeLevelEarningL."From Date";
        UNTIL EmployeeLevelEarningL.Next() = 0;
        // if FilterP = '' then
        //     Error(EarningComponentValidateErr, EmployeeNoP, CalculationStartDateG, CalculationEndDateG);
        if FilterP > '' then
            FilterP := CopyStr(FilterP, 1, STRLEN(FilterP) - 1);
        exit(CounterL = 1);
    end;

    local procedure GetEndDate(EmployeeLevelEarningP: Record "Employee Level Earning"): Date
    begin
        if (EmployeeLevelEarningP."To Date" >= CalculationStartDateG) and (EmployeeLevelEarningP."To Date" <= CalculationEndDateG) then
            exit(EmployeeLevelEarningP."To Date");
        exit(CalculationEndDateG);
    end;

    local procedure GetStartDate(FromDateP: Date): Date
    begin
        if (FromDateP >= CalculationStartDateG) and (FromDateP <= CalculationEndDateG) then
            exit(FromDateP);
        exit(CalculationStartDateG);
    end;

    local procedure GetCutoffStartDate(var EmployeeLevelEarningP: Record "Employee Level Earning"): Date
    begin
        if not ((EmployeeLevelEarningP."From Date" >= CutoffStartDateG) and (EmployeeLevelEarningP."From Date" <= CutoffEndDateG)) and
           not ((EmployeeLevelEarningP."To Date" >= CutoffStartDateG) and (EmployeeLevelEarningP."To Date" <= CutoffEndDateG)) then
            exit(0D);
        if ((EmployeeLevelEarningP."From Date" >= CutoffStartDateG) and (EmployeeLevelEarningP."From Date" <= CutoffEndDateG)) then
            exit(EmployeeLevelEarningP."From Date");
        exit(CutoffStartDateG);
    end;

    local procedure GetCutoffEndDate(EmployeeLevelEarningP: Record "Employee Level Earning"): Date
    begin
        if (EmployeeLevelEarningP."To Date" >= CutoffStartDateG) and (EmployeeLevelEarningP."To Date" <= CutoffEndDateG) then
            exit(EmployeeLevelEarningP."To Date");
        exit(CutoffEndDateG);
    end;

    local procedure FindLeaveForMultiComponent(var NoOfUnpaidLeaveP: Decimal; var NoOfPaidLeaveP: Decimal; var NoOfWithHoldDaysP: Decimal);
    var
        EmployeeLevelEarningL: Record "Employee Level Earning";
        StartDateL: Date;
        EndDateL: Date;
    begin
        NoOfUnpaidLeaveP := 0;
        NoOfPaidLeaveP := 0;
        NoOfWithHoldDaysP := 0;
        EmployeeLevelEarningL.SetAutoCalcFields("To Date");
        EmployeeLevelEarningL.SetCurrentKey("From Date");
        EmployeeLevelEarningL.SetRange("Employee No.", Employee."No.");
        EmployeeLevelEarningL.SetFilter("From Date", FilterG);
        if EmployeeLevelEarningL.FindSet() then
            repeat
                if StartDateL <> EmployeeLevelEarningL."From Date" then begin
                    EndDateL := GetEndDate(EmployeeLevelEarningL);
                    if not HrSetupG."Enable Salary Cut-off" then
                        NoOfUnpaidLeaveP += CalculateUnPaidLeave(Employee."No.", EmployeeLevelEarningL."From Date", EndDateL)
                    else
                        NoOfUnpaidLeaveP += CalculateUnPaidLeave(Employee."No.", GetCutoffStartDate(EmployeeLevelEarningL), GetCutoffEndDate(EmployeeLevelEarningL));
                    NoOfPaidLeaveP += CalculatePaidLeave(EmployeeLevelEarningL."Employee No.", GetStartDate(EmployeeLevelEarningL."From Date"), EndDateL);
                    NoOfWithHoldDaysP += CalculateWithHoldDays(Employee."No.", GetStartDate(EmployeeLevelEarningL."From Date"), EndDateL);
                end;
                StartDateL := EmployeeLevelEarningL."From Date";
            until EmployeeLevelEarningL.Next() = 0;
    end;

    local procedure GetLineCount(var EmployeeLevelEarningP: Record "Employee Level Earning"): Decimal
    var
        EmployeeLevelEarningL: Record "Employee Level Earning";
    begin
        EmployeeLevelEarningL.CopyFilters(EmployeeLevelEarningP);
        EmployeeLevelEarningL.SetRange("Earning Code", EmployeeLevelEarningP."Earning Code");
        exit(EmployeeLevelEarningL.Count());
    end;

    local procedure GetCutOffDates()
    var
        MonthL: Integer;
        YearL: Integer;
    begin
        HrSetupG.TestField("Salary Cut-off Start Date");
        HrSetupG.TestField("Salary Cut-off End Date");

        if Date2DMY(PayCycleLineG."Period Start Date", 2) = Date2DMY(PayCycleLineG."Period End Date", 2) then begin
            MonthL := Date2DMY(PayCycleLineG."Period Start Date", 2) - 1;
            YearL := Date2DMY(PayCycleLineG."Period Start Date", 3);
            if MonthL <= 0 then begin
                MonthL := 12;
                YearL := YearL - 1;
            end;
            CutoffStartDateG := DMY2Date(HrSetupG."Salary Cut-off Start Date", MonthL, YearL)
        end else
            CutoffStartDateG := DMY2Date(HrSetupG."Salary Cut-off Start Date", Date2DMY(PayCycleLineG."Period Start Date", 2), Date2DMY(PayCycleLineG."Period Start Date", 3));

        CutoffEndDateG := CalcDate('<1M>', CutoffStartDateG) - 1;
    end;

    local procedure InsertSalaryComputationLine(ComputationNoP: Code[20];
    LineNoP: Integer;
    EmployeeNoP: Code[20];
    EarningCodeP: Code[20];
    AmountP: Decimal;
    DescriptionP: Text[50];
    NoOfWorkingDayP: Decimal;
    NoOfUnPaidLeaveP: Decimal;
    NoOfPaidLeaveP: Decimal;
    LineTypeP: Option;
    PaywithSalaryP: Boolean;
    AffectSalaryP: Boolean;
    ShowinPaySlipP: Boolean;
    CategoryP: Option;
    TypeP: Option;
    WithHoldDaysP: Decimal;
    AccrualP: Boolean;
    AccrualTypeP: Option;
    TotalAmtP: Decimal;
    OpeningBalanceP: Decimal;
    PostingCategoryP: Option;
    ReferenceDocumentNoP: Code[20];
    FreeText1P: Text[50])
    var
        SalaryComputationLineL: Record "Salary Computation Line";
    begin
        SalaryComputationLineL.Init();
        SalaryComputationLineL."Computation No." := ComputationNoP;
        SalaryComputationLineL.Description := DescriptionP;
        SalaryComputationLineL."Line No." := LineNoP;
        SalaryComputationLineL."Employee No." := EmployeeNoP;
        SalaryComputationLineL."Code" := EarningCodeP;
        SalaryComputationLineL.Amount := AmountP;
        SalaryComputationLineL."No. of UnPaid Leave Days" := NoOfUnPaidLeaveP;
        SalaryComputationLineL."No. of Paid Leave Days" := NoOfPaidLeaveP;
        SalaryComputationLineL."No. of Working Days" := NoOfWorkingDayP;
        SalaryComputationLineL."Line Type" := LineTypeP;
        SalaryComputationLineL."Pay With Salary" := PaywithSalaryP;
        SalaryComputationLineL."Show in Payslip" := ShowinPaySlipP;
        SalaryComputationLineL."Affects Salary" := AffectSalaryP;
        SalaryComputationLineL.Category := CategoryP;
        SalaryComputationLineL.Type := TypeP;
        SalaryComputationLineL."No. Of WithHold Days" := WithHoldDaysP;
        SalaryComputationLineL.Accrual := AccrualP;
        SalaryComputationLineL."Accrual Type" := AccrualTypeP;
        SalaryComputationLineL."Total Amount" := TotalAmtP;
        SalaryComputationLineL."Opening Balance" := OpeningBalanceP;
        SalaryComputationLineL."Computation Type" := ComputationTypeG; // Avi : For Leave salary calculation, value is set in Function SetParametersForLeaveSalary. else Value = " " for Salary Computation and Gratuty.
        SalaryComputationLineL."Salary Class" := SalaryClassG; // Avi 
        SalaryComputationLineL."Pay Period" := PayCycleLineG."Pay Period";
        SalaryComputationLineL."Posting Category" := PostingCategoryP;
        if SalaryComputationLineL."Posting Category" <> SalaryComputationLineL."Posting Category"::"Travel & Expense" then begin
            if (SalaryComputationLineL.Type IN [SalaryComputationLineL.Type::" ", SalaryComputationLineL.Type::"Employer Contribution"]) AND NOT (SalaryComputationLineL."Line Type" = SalaryComputationLineL."Line Type"::Loans) then
                SalaryComputationLineL."Posting Category" := SalaryComputationLineL."Posting Category"::Accruals
            else
                SalaryComputationLineL."Posting Category" := PostingCategoryP;
            if EOSCalculationG then
                SalaryComputationLineL."Posting Category" := SalaryComputationLineL."Posting Category"::"End of Service";
        end;
        SalaryComputationLineL."Reference Document No." := ReferenceDocumentNoP;
        SalaryComputationLineL."Free Text 1" := FreeText1P;
        SalaryComputationLineL.Insert();
    end;

    local procedure RemoveDuplicateComputation()
    var
        SalaryComputationHeaderL: Record "Salary Computation Header";
        SalaryComputationLineL: Record "Salary Computation Line";
    begin
        SalaryComputationLineL.SetCurrentKey("Computation No.", "Employee No.", "Pay Period");
        SalaryComputationLineL.SetFilter("Computation No.", '<>%1', SalaryComputationHeaderG."Computation No.");
        SalaryComputationLineL.SetRange("Employee No.", Employee."No.");
        SalaryComputationLineL.SetRange("Pay Period", PayCycleLineG."Pay Period");
        SalaryComputationLineL.SetRange("Computation Type", SalaryComputationLineL."Computation Type"::" ");// Avi : added this coz it should not delete Leave Salary lines
        SalaryComputationLineL.DeleteAll();

        SalaryComputationHeaderL.SetCurrentKey("Employee No.", "Pay Period", "Computation No.");
        SalaryComputationHeaderL.SetRange("Pay Period", PayCycleLineG."Pay Period");
        SalaryComputationHeaderL.SetFilter("Computation No.", '<>%1', SalaryComputationHeaderG."Computation No.");
        if SalaryComputationHeaderL.FindLast() and
            (SalaryComputationHeaderL.Status = SalaryComputationHeaderL.Status::"Journal Created")
        then
            Error(JournalsCreatedErr, PayCycleLineG."Pay Period", SalaryComputationHeaderL."Computation No.");
        SalaryComputationHeaderL.SetRange("Employee No.", Employee."No.");
        if SalaryComputationHeaderL.FindLast() then begin
            SalaryComputationHeaderL.Init();
            SalaryComputationHeaderL.Modify();
        end;
    end;

    local procedure CreateUpdateAccrualDeduction()
    var
        EmployeeGroupHistoryL: Record "Employee Earning History";
        EmployeeLevelAbsenceL: Record "Employee Level Absence";
        SalaryComputationLineL: Record "Salary Computation Line";
        LeaveBalanceL: Record "Leave Balance Summary";
        AbsenceL: Record Absence;
        HRMSManagementL: Codeunit "HRMS Management";
        NoOfDaysL: Decimal;
        PreviousTotalAccrualL: Decimal;
        StartDateL: Date;
        EndDateL: date;
        DeductionDateL: Date;
    begin
        if Employee."Leave Accrual Start Date" > CalculationEndDateG then
            exit;
        if LeaveSalaryExistFortheMonthG then begin
            DeductionDateL := CalculationStartDateG;
            CalculationStartDateG := PayCycleLineG."Period Start Date";
        end;
        EmployeeGroupHistoryL.SetRange("Employee No.", Employee."No.");
        EmployeeGroupHistoryL.SetFilter("From Date", FilterG);
        EmployeeGroupHistoryL.FindFirst();
        EmployeeLevelAbsenceL.SetRange("Employee No.", EmployeeGroupHistoryL."Employee No.");
        EmployeeLevelAbsenceL.SetRange("From Date", EmployeeGroupHistoryL."From Date");
        EmployeeLevelAbsenceL.SetRange(Accrual, true);
        if EmployeeLevelAbsenceL.FindSet() then
            repeat
                if GetPreviousMonthRecord(SalaryComputationLineL, EmployeeLevelAbsenceL."Absence Code") then
                    PreviousTotalAccrualL := SalaryComputationLineL."Total Accrual Value";
                if CheckIfItIsStartofYear(EmployeeLevelAbsenceL) then
                    PreviousTotalAccrualL := EmployeeLevelAbsenceL."Maximum Carry Forward Days";
                SalaryComputationLineL.Reset();
                LineNoG += 10000;
                InsertSalaryComputationLine(SalaryComputationHeaderG."Computation No.", LineNoG, Employee."No.", EmployeeLevelAbsenceL."Absence Code", 0, EmployeeLevelAbsenceL."Absence Description", 0, 0, 0, SalaryComputationLineG."Line Type"::Absence, false, false, false, SalaryComputationLineL.Category::Absence, SalaryComputationLineL.Type::" ", 0, true, 0, 0, 0, SalaryComputationLineG."Posting Category"::Salary, '', '');
                SalaryComputationLineL.Get(SalaryComputationHeaderG."Computation No.", LineNoG);
                LeaveBalanceL.get(Employee."No.", EmployeeLevelAbsenceL."Absence Code");
                if CheckIfItIsStartofYear(EmployeeLevelAbsenceL) and (EmployeeLevelAbsenceL."Accrual Basis" = EmployeeLevelAbsenceL."Accrual Basis"::Anniversary) then begin
                    AbsenceL.GetStartDateAndEndDate(Employee."Employment Date", CalculationEndDateG, EmployeeLevelAbsenceL."Accrual Basis", StartDateL, EndDateL);
                    NoOfDaysL := (CalculationEndDateG - StartDateL) + 1;
                end else
                    NoOfDaysL := (CalculationEndDateG - CalculationStartDateG) + 1;
                if EmployeeLevelAbsenceL."Accrual Basis" = EmployeeLevelAbsenceL."Accrual Basis"::Biennial then
                    SalaryComputationLineL."Accrual Value" := ((EmployeeLevelAbsenceL."Assigned Days" / 730) * NoOfDaysL) - GetNoOfLeaveTakenForTheMonth(EmployeeLevelAbsenceL."Absence Code")
                else
                    SalaryComputationLineL."Accrual Value" := ((EmployeeLevelAbsenceL."Assigned Days" / 365) * NoOfDaysL) - GetNoOfLeaveTakenForTheMonth(EmployeeLevelAbsenceL."Absence Code");
                SalaryComputationLineL."Total Accrual Value" := SalaryComputationLineL."Accrual Value" + PreviousTotalAccrualL;
                CheckForOpeningBalance(SalaryComputationLineL);
                PreviousTotalAccrualL := HRMSManagementL.CheckForLeaveEncashment(Employee."No.", EmployeeLevelAbsenceL."Absence Code", CalculationStartDateG, CalculationEndDateG);
                SalaryComputationLineL."Accrual Value" += PreviousTotalAccrualL;
                SalaryComputationLineL."Total Accrual Value" += PreviousTotalAccrualL;
                if SalaryComputationLineL."Total Accrual Value" > EmployeeLevelAbsenceL."Maximum Accrual Days" then
                    SalaryComputationLineL."Total Accrual Value" := EmployeeLevelAbsenceL."Maximum Accrual Days";
                CalculateLeaveAccrualAmount(SalaryComputationLineL);
                SalaryComputationLineL.Modify();
            until EmployeeLevelAbsenceL.Next() = 0;
        if LeaveSalaryExistFortheMonthG then
            CalculationStartDateG := DeductionDateL;
    end;

    local procedure GetPreviousMonthRecord(var SalaryComputationLineP: Record "Salary Computation Line"; CodeP: code[20]): Boolean
    begin
        SalaryComputationLineP.Reset();
        SalaryComputationLineP.SetCurrentKey("Employee No.", "Pay Period");
        SalaryComputationLineP.SetRange("Employee No.", Employee."No.");
        SalaryComputationLineP.SetFilter("Pay Period", '%1', UPPERCASE(FORMAT(PayCycleLineG."Period Start Date" - 1, 0, '<Month Text>') + '-' + format(Date2DMY(PayCycleLineG."Period Start Date" - 1, 3))));
        SalaryComputationLineP.SetRange("Code", "CodeP");
        Exit(SalaryComputationLineP.FindLast());
    end;


    local procedure CalculateLeaveSalary(NoOfWorkingDaysP: Decimal; NoOfPayPeriodDaysP: Decimal)
    var
        EmployeeLevelEarningL: Record "Employee Level Earning";
        ComputationLineDetailL: Record "Computation Line Detail";
        AmountL: Decimal;
        NoOfUnpaidLeaveL: Decimal;
    begin
        ComputationLineDetailL.SetRange("Computation Code", ComputationCodeG);
        if ComputationLineDetailL.FindSet() then
            repeat
                ComputationLineDetailL.TestField(Percentage);
                EmployeeLevelEarningL.SetCurrentKey("Employee No.", "Earning Code", "From Date", "Pay With Salary", Accural);
                EmployeeLevelEarningL.SetAutoCalcFields("To Date");
                EmployeeLevelEarningL.SetRange("Employee No.", Employee."No.");
                EmployeeLevelEarningL.SetFilter("From Date", FilterG);
                EmployeeLevelEarningL.SetRange("Earning Code", ComputationLineDetailL."Earning Code");
                if EmployeeLevelEarningL.FindFirst() then begin
                    LineNoG += 10000;
                    NoOfUnpaidLeaveL := CalculateUnPaidLeave(Employee."No.", CalculationStartDateG, CalculationEndDateG);
                    AmountL := CalculateAmount(NoOfPayPeriodDaysP, NoOfWorkingDaysP, NoOfUnpaidLeaveL, EmployeeLevelEarningL."Pay Amount" * ComputationLineDetailL.Percentage / 100);
                    if EmployeeLevelEarningL.Category = EmployeeLevelEarningL.Category::Deduction then
                        AmountL := -AmountL;
                    // IsAccrualL --> Need to check
                    //AmountL := Round(((((EmployeeLevelEarningL."Pay Amount" * 12) / 365) * ComputationLineDetailL.Percentage / 100) * NoOfWorkingDaysP), HrSetupG."HR Rounding Precision", HrSetupG.RoundingDirection());
                    InsertSalaryComputationLine(SalaryComputationHeaderG."Computation No.", LineNoG, Employee."No.", EmployeeLevelEarningL."Earning Code", AmountL, EmployeeLevelEarningL."Earning Description", CalculateWorkingDays(Employee."No."), 0, 0, SalaryComputationLineG."Line Type"::Earning, EmployeeLevelEarningL."Pay With Salary", EmployeeLevelEarningL."Affects Salary", EmployeeLevelEarningL."Show in payslip", EmployeeLevelEarningL.Category, EmployeeLevelEarningL.Type, 0, false, EmployeeLevelEarningL."Accrual Type"::" ", 0, 0, SalaryComputationLineG."Posting Category"::Salary, '', '');
                end;
            until ComputationLineDetailL.Next() = 0;
    end;

    local procedure CalculateLeaveAccrualAmount(var SalaryComputationLineP: Record "Salary Computation Line")
    var
        AbsenceL: Record Absence;
        ComputationLineDetailL: Record "Computation Line Detail";
        EmployeeLevelEarningL: Record "Employee Level Earning";
    begin
        AbsenceL.Get(SalaryComputationLineP.Code);
        if EOSCalculationG then begin
            AbsenceL.TestField("Encashment computation");
            ComputationLineDetailL.SetRange("Computation Code", AbsenceL."Encashment computation");
        end else begin
            AbsenceL.TestField("Accruals computation");
            ComputationLineDetailL.SetRange("Computation Code", AbsenceL."Accruals computation");
        end;
        if ComputationLineDetailL.FindSet() then
            repeat
                EmployeeLevelEarningL.SetRange("Employee No.", SalaryComputationLineP."Employee No.");
                EmployeeLevelEarningL.SetFilter("From Date", FilterG);
                EmployeeLevelEarningL.SetRange("Earning Code", ComputationLineDetailL."Earning Code");
                if EmployeeLevelEarningL.FindFirst() then begin
                    SalaryComputationLineP.Amount += SalaryComputationLineP."Accrual Value" * ((EmployeeLevelEarningL."Pay Amount" * 12 / 365) * ComputationLineDetailL.Percentage / 100);
                    SalaryComputationLineP."Total Amount" += SalaryComputationLineP."Total Accrual Value" * ((EmployeeLevelEarningL."Pay Amount" * 12 / 365) * ComputationLineDetailL.Percentage / 100);
                end;
            until ComputationLineDetailL.Next() = 0;
        if EOSCalculationG then
            SalaryComputationLineP.Amount := SalaryComputationLineP."Total Amount";
    end;

    local procedure GetComputationMode(EmployeeLevelEarningP: Record "Employee Level Earning")
    var
        EarningL: Record Earning;
    begin
        if LeaveSalaryG Or LeaveSalaryExistFortheMonthG then begin
            ComputationModeG := ComputationModeG::Prorata;
            exit;
        end;
        if EarningL.Get(EmployeeLevelEarningP."Earning Code") then
            case ModeOfMonthG of
                ModeOfMonthG::Confirmed:
                    ComputationModeG := EarningL.Confirmed;
                ModeOfMonthG::"First Month":
                    ComputationModeG := EarningL."First Month Computation";
                ModeOfMonthG::"Last Month":
                    ComputationModeG := EarningL."Last Month Computation";
            end;
    end;

    local procedure CheckForOpeningBalance(var SalaryComputationLineP: Record "Salary Computation Line")
    var
        OpeningBalanceL: Record "Opening Balance";
    begin
        OpeningBalanceL.SetRange("Employee No.", SalaryComputationLineP."Employee No.");
        OpeningBalanceL.SetRange("Pay Period", SalaryComputationLineP."Pay Period");
        OpeningBalanceL.SetRange(Type, OpeningBalanceL.Type::Absence);
        OpeningBalanceL.CalcSums(Value);
        SalaryComputationLineP."Accrual Value" += OpeningBalanceL.Value;
        SalaryComputationLineP."Total Accrual Value" += OpeningBalanceL.Value;
    end;

    local procedure UpdateLeaveBalance()
    var
        LeaveBalanceL: Record "Leave Balance Summary";
        AbsenceL: Record Absence;
        EmployeeGroupHistoryL: Record "Employee Earning History";
        EmployeeLevelAbsenceL: Record "Employee Level Absence";
        StartDateL: Date;
        EndDateL: Date;
    begin
        EmployeeGroupHistoryL.SetRange("Employee No.", Employee."No.");
        EmployeeGroupHistoryL.SetFilter("From Date", FilterG);
        EmployeeGroupHistoryL.FindFirst();
        EmployeeLevelAbsenceL.SetRange("Employee No.", EmployeeGroupHistoryL."Employee No.");
        EmployeeLevelAbsenceL.SetRange("From Date", EmployeeGroupHistoryL."From Date");
        if EmployeeLevelAbsenceL.FindSet() then
            repeat
                if EmployeeLevelAbsenceL.Accrual and (Employee."Leave Accrual Start Date" > 0D) then
                    AbsenceL.GetStartDateAndEndDate(Employee."Leave Accrual Start Date", CalculationEndDateG, EmployeeLevelAbsenceL."Accrual Basis", StartDateL, EndDateL)
                else
                    AbsenceL.GetStartDateAndEndDate(Employee."Employment Date", CalculationEndDateG, EmployeeLevelAbsenceL."Accrual Basis", StartDateL, EndDateL);
                if EmployeeLevelAbsenceL."Accrual Basis" = EmployeeLevelAbsenceL."Accrual Basis"::Anniversary then begin
                    if (StartDateL >= CalculationStartDateG) and ((StartDateL <> Employee."Employment Date") and (StartDateL <> Employee."Leave Accrual Start Date")) then
                        LeaveBalanceL.ClearLeaveBalance(Employee."No.", EmployeeLevelAbsenceL."Absence Code", EmployeeLevelAbsenceL."Assigned Days", EmployeeLevelAbsenceL."Maximum Carry Forward Days", PayCycleLineG)
                end else
                    if (EndDateL <= CalculationEndDateG) and (EndDateL > 0D) then
                        LeaveBalanceL.ClearLeaveBalance(Employee."No.", EmployeeLevelAbsenceL."Absence Code", EmployeeLevelAbsenceL."Assigned Days", EmployeeLevelAbsenceL."Maximum Carry Forward Days", PayCycleLineG);
            until EmployeeLevelAbsenceL.Next() = 0;
    end;

    local procedure CheckIfItIsStartofYear(EmployeeLevelAbsenceP: Record "Employee Level Absence"): Boolean
    var
        AbsenceL: Record Absence;
        StartDateL: Date;
        EndDateL: Date;
    begin
        if EmployeeLevelAbsenceP.Accrual and (Employee."Leave Accrual Start Date" > 0D) then
            AbsenceL.GetStartDateAndEndDate(Employee."Leave Accrual Start Date", CalculationEndDateG, EmployeeLevelAbsenceP."Accrual Basis", StartDateL, EndDateL)
        else
            AbsenceL.GetStartDateAndEndDate(Employee."Employment Date", CalculationEndDateG, EmployeeLevelAbsenceP."Accrual Basis", StartDateL, EndDateL);
        if (Employee."Leave Accrual Start Date" = StartDateL) or (Employee."Employment Date" = StartDateL) then
            exit(false);
        if EmployeeLevelAbsenceP."Accrual Basis" = EmployeeLevelAbsenceP."Accrual Basis"::Anniversary then begin
            if (StartDateL > 0D) and (StartDateL >= CalculationStartDateG) and (StartDateL <= CalculationEndDateG) then
                exit(true);
        end else
            if (StartDateL = CalculationStartDateG) and (StartDateL > 0D) then
                exit(true);
    end;

    local procedure GetNoOfLeaveTakenForTheMonth(AbsenceCodeP: Code[20]) NoOfLeaveTakenR: Decimal
    var
        EmployeeTimingL: Record "Employee Timing";
    begin
        EmployeeTimingL.SetRange("Employee No.", Employee."No.");
        EmployeeTimingL.SetRange("From Date", CalculationStartDateG, CalculationEndDateG);
        EmployeeTimingL.SetRange("First Half Status", AbsenceCodeP);
        NoOfLeaveTakenR := EmployeeTimingL.Count();
        EmployeeTimingL.SetRange("Second Half Status", AbsenceCodeP);
        NoOfLeaveTakenR += EmployeeTimingL.Count();
        exit(NoOfLeaveTakenR / 2);

    end;

    local procedure CheckForLeaveEncashment()
    var
        LeaveEncashmentL: Record "Leave Encashment";
        AbsenceL: Record Absence;
        EmployeeLevelEarningL: Record "Employee Level Earning";
        EncashmentDescLbl: Label ' Encashment';
    begin
        LeaveEncashmentL.SetRange("Employee No.", Employee."No.");
        LeaveEncashmentL.SetRange("Compensation Date", CalculationStartDateG, CalculationEndDateG);
        LeaveEncashmentL.SetRange("Pay with Salary", true);
        if LeaveEncashmentL.FindSet() then begin
            LineNoG += 10000;
            repeat
                AbsenceL.Get(LeaveEncashmentL."Leave Type");
                InsertSalaryComputationLine(SalaryComputationHeaderG."Computation No.", LineNoG, Employee."No.", LeaveEncashmentL."Leave Type", LeaveEncashmentL."Encashment Amount", AbsenceL.Description + EncashmentDescLbl, 0, 0, 0, SalaryComputationLineG."Line Type"::Absence, LeaveEncashmentL."Pay With Salary", true, true, EmployeeLevelEarningL.Category::Earning, EmployeeLevelEarningL.Type::Constant, 0, false, EmployeeLevelEarningL."Accrual Type"::" ", 0, 0, SalaryComputationLineG."Posting Category"::Encashment, '', '');
                LineNoG += 10000;
            until LeaveEncashmentL.Next() = 0;
        end;
    end;

    local procedure CheckForLeaveSetup(AmountP: Decimal; StartDateP: Date; EndDateP: Date) DeductionAmountR: Decimal
    var
        SickLeaveSetupL: Record "Sick Leave Setup";
        SickLeaveSetup2L: Record "Sick Leave Setup";
        EmployeeTimingL: Record "Employee Timing";
        AbsenceL: Record Absence;
        TotalNoOfLeaveL: Decimal;
        NoOfLeaveInPayPeriodL: Decimal;
        NoofPaidLeaveL: Decimal;
        StartDateL: Date;
        EndDateL: Date;
    begin
        SickLeaveSetupL.SetCurrentKey("Absence Code", "Line No.");
        If not SickLeaveSetupL.FindFirst() then
            exit;
        repeat
            if SickLeaveSetupL."Absence Code" <> AbsenceL."Absence Code" then begin
                AbsenceL.Get(SickLeaveSetupL."Absence Code");
                if AbsenceL.Accrual then
                    AbsenceL.GetStartDateAndEndDate(Employee."Leave Accrual Start Date", EndDateP, AbsenceL."Accrual Basis", StartDateL, EndDateL)
                else
                    AbsenceL.GetStartDateAndEndDate(Employee."Employment Date", EndDateP, AbsenceL."Accrual Basis", StartDateL, EndDateL);
                EmployeeTimingL.SetRange("Employee No.", Employee."No.");
                EmployeeTimingL.SetRange("From Date", StartDateL, PayCycleLineG."Period End Date");
                EmployeeTimingL.SetRange("First Half Status", SickLeaveSetupL."Absence Code");
                TotalNoOfLeaveL := EmployeeTimingL.Count();
                EmployeeTimingL.SetRange("Second Half Status", SickLeaveSetupL."Absence Code");
                TotalNoOfLeaveL += EmployeeTimingL.Count();
                EmployeeTimingL.SetRange("From Date", StartDateP, EndDateP);
                NoOfLeaveInPayPeriodL := EmployeeTimingL.Count();
                EmployeeTimingL.SetRange("First Half Status", SickLeaveSetupL."Absence Code");
                NoOfLeaveInPayPeriodL += EmployeeTimingL.Count();
                TotalNoOfLeaveL := TotalNoOfLeaveL / 2; // Gives total no of holidays in that year.
                NoOfLeaveInPayPeriodL := NoOfLeaveInPayPeriodL / 2; // Gives total no of holidays in that Pay Period.
                NoofPaidLeaveL := TotalNoOfLeaveL - NoOfLeaveInPayPeriodL;
                AmountP := AmountP / (PayCycleLineG."Period End Date" - PayCycleLineG."Period Start Date" + 1); // One day calculation
                SickLeaveSetup2L.SetCurrentKey("From Days");
                SickLeaveSetup2L.SetRange("Absence Code", SickLeaveSetupL."Absence Code");
                SickLeaveSetup2L.SetFilter("To Days", '>=%1', NoofPaidLeaveL + 1);
                SickLeaveSetup2L.SetFilter("From Days", '<=%1', TotalNoOfLeaveL);
                if SickLeaveSetup2L.findset() then
                    if SickLeaveSetup2L.Count() = 1 then
                        DeductionAmountR += (AmountP * SickLeaveSetup2L.Percentage / 100) * NoOfLeaveInPayPeriodL
                    else
                        repeat
                            if (TotalNoOfLeaveL > (NoofPaidLeaveL + (SickLeaveSetup2L."To Days" - NoofPaidLeaveL))) then begin
                                DeductionAmountR += (AmountP * SickLeaveSetup2L.Percentage / 100) * (SickLeaveSetup2L."To Days" - NoofPaidLeaveL);
                                NoofPaidLeaveL := NoofPaidLeaveL + (SickLeaveSetup2L."To Days" - NoofPaidLeaveL);
                            end else begin
                                DeductionAmountR := DeductionAmountR + ((AmountP * SickLeaveSetup2L.Percentage / 100) * (TotalNoOfLeaveL - NoofPaidLeaveL));
                                NoofPaidLeaveL := NoofPaidLeaveL + (TotalNoOfLeaveL - NoofPaidLeaveL);
                            end;
                        until SickLeaveSetup2L.Next() = 0;
            end;
        until SickLeaveSetupL.Next() = 0;
    end;

    local procedure CalculateUnpaidLeaveSalary(EmployeeLevelEarningP: Record "Employee Level Earning"; NoofUnpaidLeaveP: Decimal; NoOfPayPeriodDaysP: Decimal; NoOfWorkingDaysP: Decimal) UnapidLeaveSalaryR: Decimal
    var
        SalaryComputationLineL: Record "Salary Computation Line";
        PayPeriodLineL: Record "Pay Period Line";
    begin
        if NoofUnpaidLeaveP = 0 then
            exit(0);
        //Round(((AmountP / NoOfPayPeriodDaysP) * NoOfWorkingDaysP) - ((AmountP / NoOfPayPeriodDaysP) * NoOfUnPaidLeaveP)
        if not HrSetupG."Enable Salary Cut-off" then
            UnapidLeaveSalaryR := Round((EmployeeLevelEarningP."Pay Amount" / NoOfPayPeriodDaysP * NoofUnpaidLeaveP), HrSetupG."HR Rounding Precision", HrSetupG.RoundingDirection())
        else begin
            if GetPreviousMonthRecord(SalaryComputationLineL, EmployeeLevelEarningP."Earning Code") then begin
                PayPeriodLineL.SetRange("Pay Cycle", Employee."Pay Cycle");
                PayPeriodLineL.SetRange("Pay Period", SalaryComputationLineL."Pay Period");
                PayPeriodLineL.FindFirst();
                UnapidLeaveSalaryR := Round((EmployeeLevelEarningP."Pay Amount" / (PayPeriodLineL."Period End Date" - PayPeriodLineL."Period Start Date" + 1) * CalculateUnPaidLeave(Employee."No.", CutoffStartDateG, PayPeriodLineL."Period End Date")), HrSetupG."HR Rounding Precision", HrSetupG.RoundingDirection());
            end;
            UnapidLeaveSalaryR += Round(((EmployeeLevelEarningP."Pay Amount" / NoOfPayPeriodDaysP) * CalculateUnPaidLeave(Employee."No.", PayCycleLineG."Period Start Date", CutoffEndDateG)), HrSetupG."HR Rounding Precision", HrSetupG.RoundingDirection())
        end;
        exit(UnapidLeaveSalaryR);
    end;

    local procedure CalculateAirTicket(EmployeeLevelEarningP: Record "Employee Level Earning"; var TotalAmountP: Decimal; var MonthlyAmountP: Decimal; var IsAnniversaryMonthP: Boolean)
    var
        OpeningBalanceL: Record "Opening Balance";
        SalaryComputationLineL: Record "Salary Computation Line";
        AbsenceL: Record Absence;
        EarningL: Record Earning;
        StartDateL: Date;
        EndDateL: Date;
    begin
        OpeningBalanceL.SetRange("Pay Period", PayCycleLineG."Pay Period");
        OpeningBalanceL.SetRange("Employee No.", EmployeeLevelEarningP."Employee No.");
        OpeningBalanceL.SetRange(Type, OpeningBalanceL.Type::Earning);
        OpeningBalanceL.SetRange(Code, EmployeeLevelEarningP."Earning Code");
        OpeningBalanceL.CalcSums(Amount);
        MonthlyAmountP := OpeningBalanceL.Amount;
        GetPreviousMonthRecord(SalaryComputationLineL, EmployeeLevelEarningP."Earning Code");
        AbsenceL.GetStartDateAndEndDate(Employee."Employment Date", CalculationEndDateG, AbsenceL."Accrual Basis"::Anniversary, StartDateL, EndDateL);
        MonthlyAmountP := MonthlyAmountP + (EmployeeLevelEarningP."Pay Amount" * (CalculationEndDateG - CalculationStartDateG + 1) / (EndDateL - StartDateL + 1));
        TotalAmountP := SalaryComputationLineL."Total Amount" + MonthlyAmountP;
        AbsenceL.GetStartDateAndEndDate(Employee."Employment Date", CalculationStartDateG, AbsenceL."Accrual Basis"::Anniversary, StartDateL, EndDateL);
        if (EndDateL <= CalculationEndDateG) and
            (Employee."Employment Date" <> CalculationStartDateG) and
            (EarningL.Get(EmployeeLevelEarningP."Earning Code"))
        then
            IsAnniversaryMonthP := EarningL."Pay on Anniversary";
    end;

    procedure GetPayPeriod(DateP: Date; EmployeeNoP: code[20]): Code[30]
    var
        Employee: Record Employee;
        PayCycleLine: Record "Pay Period Line";
    begin
        Employee.Get(EmployeeNoP);
        Employee.TestField("Pay Cycle");
        // check payperiod exist or not
        PayCycleLine.SetRange("Pay Cycle", Employee."Pay Cycle");
        PayCycleLine.SetFilter("Period Start Date", '<=%1', DateP);
        PayCycleLine.SetFilter("Period End Date", '>=%1', DateP);
        if PayCycleLine.FindFirst() then
            exit(PayCycleLine."Pay Period");
    end;

    procedure GetPayPeriodLine(DateP: Date; EmployeeNoP: code[20]; var PayCycleLine: Record "Pay Period Line")
    var
        Employee: Record Employee;
    begin
        Employee.Get(EmployeeNoP);
        Employee.TestField("Pay Cycle");
        // check payperiod exist or not
        PayCycleLine.SetRange("Pay Cycle", Employee."Pay Cycle");
        PayCycleLine.SetFilter("Period Start Date", '<=%1', DateP);
        PayCycleLine.SetFilter("Period End Date", '>=%1', DateP);
        PayCycleLine.FindFirst();
    end;

    /*local procedure PasiGosiCalculation()
    var
        ComputationL: Record Computation;
        ComputationLineL: Record "Computation Line Detail";
        //AdvancePasiL: record "Advance Pasi/Gosi";
        //AdvancePasiLineL: record "Advance Pasi/Gosi Line";
        //AdvancePasiLineL1: record "Advance Pasi/Gosi Line";
        SalaryComputationLineL: record "Salary Computation Line";
        FinalEmployeeComputation: Decimal;
        FinalEmployerComputation: Decimal;
        EmployeeComputationValue: Decimal;
        EmployerComputationValue: Decimal;
        FinalEmployeeDifference: Decimal;
        FinalEmployerDifference: decimal;
        noofdaysL: Decimal;
        NoofworkingDaysF: Decimal;
        NoofworkingDaysL: Decimal;
    begin
        EmployeeComputationValue := 0;
        EmployerComputationValue := 0;
        FinalEmployerComputation := 0;
        FinalEmployeeComputation := 0;
        FinalEmployeeDifference := 0;
        FinalEmployerDifference := 0;
        NoofworkingDaysF := 0;
        NoofworkingDaysL := 0;
        noofdaysL := PayCycleLineG."Period End Date" - PayCycleLineG."Period Start Date" + 1;
        if (Employee."Employment Date" >= PayCycleLineG."Period Start Date") and (Employee."Employment Date" <= PayCycleLineG."Period End Date") then
            NoofworkingDaysF := PayCycleLineG."Period End Date" - Employee."Employment Date" + 1
        else
            if (Employee."Termination Date" >= PayCycleLineG."Period Start Date") and (Employee."Termination Date" <= PayCycleLineG."Period End Date") then
                NoofworkingDaysL := Employee."Termination Date" - PayCycleLineG."Period Start Date" + 1;

        PasiGosiG.Reset();
        PasiGosiG.SetRange("Employee Country", Employee."Employee Nationality");
        PasiGosiG.setrange("Employer Country", Employee."Employer Nationality");
        PasiGosiG.SetRange("Effective Till", 20541231D);
        if PasiGosiG.FindFirst() then begin

            //Age validation if given then
            if (PasiGosiG."Min Age" <> 0) or (PasiGosiG."Max Age" <> 0) then begin
                PasiGosiG.TestField("Min Age");
                PasiGosiG.TestField("Max Age");
                if (Employee.Age < PasiGosiG."Min Age") or (Employee.Age > PasiGosiG."Max Age") then
                    exit;
            end;


            EmployeeEarningHistoryG.reset();
            EmployeeEarningHistoryG.SetRange("Employee No.", Employee."No.");
            EmployeeEarningHistoryG.setrange("Component Type", EmployeeEarningHistoryG."Component Type"::Earning);
            if EmployeeEarningHistoryG.FindLast() then begin
                EmployeeLevelEarningG.Reset();
                EmployeeLevelEarningG.setrange("Employee No.", Employee."No.");
                EmployeeLevelEarningG.SetRange("Group Code", EmployeeEarningHistoryG."Group Code");
                EmployeeLevelEarningG.setrange("to Date", EmployeeEarningHistoryG."To Date");
                if EmployeeLevelEarningG.FindSet() then
                    repeat
                        //Employee Computation calculation
                        ComputationL.get(PasiGosiG."Employee Computation");
                        ComputationLineL.Reset();
                        ComputationLineL.SetRange("Computation Code", ComputationL."Computation Code");
                        ComputationLineL.SetRange("Earning Code", EmployeeLevelEarningG."Earning Code");
                        if ComputationLineL.FindFirst() then
                            EmployeeComputationValue += (EmployeeLevelEarningG."Pay Amount" * ComputationLineL.Percentage) / 100;
                        //Employer Computation calculation
                        ComputationL.get(PasiGosiG."Employer Computation");
                        ComputationLineL.Reset();
                        ComputationLineL.SetRange("Computation Code", ComputationL."Computation Code");
                        ComputationLineL.SetRange("Earning Code", EmployeeLevelEarningG."Earning Code");
                        if ComputationLineL.FindFirst() then
                            EmployerComputationValue += (EmployeeLevelEarningG."Pay Amount" * ComputationLineL.Percentage) / 100;
                    until EmployeeLevelEarningG.Next() = 0;

                //Amount validation if in pasi setup Available
                if (PasiGosiG."Mini Salary" <> 0) or (PasiGosiG."Max Salary" <> 0) then begin
                    PasiGosiG.TestField("Mini Salary");
                    PasiGosiG.TestField("Max Salary");
                    if (EmployeeComputationValue > PasiGosiG."Mini Salary") or (EmployeeComputationValue > PasiGosiG."Max Salary") then
                        exit;
                end;

                //For first month of Employement
                if (PasiGosiG."Employee First Computation" = PasiGosiG."Employee First Computation"::Prorata) and (NoofworkingDaysF <> 0) then begin
                    FinalEmployeeComputation := (EmployeeComputationValue * PasiGosiG."Employee Deduction") / 100;
                    FinalEmployeeComputation := FinalEmployeeComputation / noofdaysL * NoofworkingDaysF;
                end else
                    FinalEmployeeComputation := (EmployeeComputationValue * PasiGosiG."Employee Deduction") / 100;     //374

                if (PasiGosiG."Employer First Computation" = PasiGosiG."Employer First Computation"::Prorata) and (NoofworkingDaysF <> 0) then begin
                    FinalEmployerComputation := (EmployerComputationValue * PasiGosiG."Employer Deduction") / 100;
                    FinalEmployerComputation := FinalEmployerComputation / noofdaysL * NoofworkingDaysF;
                end else
                    FinalEmployerComputation := (EmployeeComputationValue * PasiGosiG."Employer Deduction") / 100;

                //For EOS Of the Employment
                if (PasiGosiG."Employee Last Computation" = PasiGosiG."Employee Last Computation"::Prorata) and (NoofworkingDaysL <> 0) then begin
                    FinalEmployeeComputation := (EmployeeComputationValue * PasiGosiG."Employee Deduction") / 100;
                    FinalEmployeeComputation := FinalEmployeeComputation / noofdaysL * NoofworkingDaysL;
                end else
                    FinalEmployeeComputation := (EmployeeComputationValue * PasiGosiG."Employee Deduction") / 100;     //374

                if (PasiGosiG."Employer Last Computation" = PasiGosiG."Employer Last Computation"::Prorata) and (NoofworkingDaysL <> 0) then begin
                    FinalEmployerComputation := (EmployerComputationValue * PasiGosiG."Employer Deduction") / 100;
                    FinalEmployerComputation := FinalEmployerComputation / noofdaysL * NoofworkingDaysL;
                end else
                    FinalEmployerComputation := (EmployeeComputationValue * PasiGosiG."Employer Deduction") / 100;
            end;
            //Advance PASI/ GOSI Calculation 
            AdvancePasiL.Reset();
            AdvancePasiL.SetRange("Employee No.", Employee."No.");
            AdvancePasiL.SetFilter(Date, '<%1', PayCycleLineG."Period End Date");
            if AdvancePasiL.FindFirst() then
                repeat
                    AdvancePasiLineL1.Reset();
                    AdvancePasiLineL1.SetRange("Document No.", AdvancePasiL."No.");
                    AdvancePasiLineL1.SetFilter("Pay Period Month", '%1', PayPeriodG);
                    if AdvancePasiLineL1.FindFirst() then
                        AdvancePasiLineL1.Delete();
                    AdvancePasiLineL.Reset();
                    AdvancePasiLineL.SetRange("Document No.", AdvancePasiL."No.");
                    if AdvancePasiLineL.FindLast() then begin
                        AdvancePasiLineL1.Init();
                        AdvancePasiLineL1."Document No." := AdvancePasiL."No.";
                        AdvancePasiLineL1."Line No." := AdvancePasiLineL."Line No." + 10000;
                        AdvancePasiLineL1."Pay Period Month" := format(PayPeriodG);
                        if AdvancePasiLineL.Balance >= FinalEmployeeComputation then begin
                            AdvancePasiLineL1.validate("Contribution Amount", FinalEmployeeComputation);
                            FinalEmployeeComputation := 0;
                        end else begin
                            AdvancePasiLineL1.validate("Contribution Amount", AdvancePasiLineL.Balance);
                            FinalEmployeeComputation := FinalEmployeeComputation - AdvancePasiLineL.Balance;
                            AdvancePasiLineL1.Balance := 0;
                        end;

                        if (AdvancePasiLineL1."Contribution Amount" <> 0) then begin
                            AdvancePasiLineL1.Insert();
                            SalaryComputationLineL.Reset();
                            SalaryComputationLineL.SetRange("Computation No.", SalaryComputationHeaderG."Computation No.");
                            SalaryComputationLineL.SetRange("Employee No.", Employee."No.");
                            SalaryComputationLineL.SetRange(Code, PasiGosiG."Emp. Deduction Code");
                            if SalaryComputationLineL.FindFirst() then begin
                                SalaryComputationLineL.Amount -= AdvancePasiLineL1."Contribution Amount";
                                SalaryComputationLineL.Modify();
                            end else begin
                                LineNoG += 10000;
                                InsertSalaryComputationLine(SalaryComputationHeaderG."Computation No.", LineNoG, Employee."No.", PasiGosiG."Emp. Deduction Code", -AdvancePasiLineL1."Contribution Amount", 'Advance PASI For Employee', 0, 0, 0, SalaryComputationLineG."Line Type"::"PASI/GOSI", true, true, true, SalaryComputationLineG.Category::Deduction, SalaryComputationLineG.Type::Constant, 0, false, EmployeeLevelEarningG."Accrual Type"::" ", 0, 0, SalaryComputationLineG."Posting Category"::Salary, '', '');
                            end;
                        end;
                    end else begin
                        AdvancePasiLineL1.Init();
                        AdvancePasiLineL1."Document No." := AdvancePasiL."No.";
                        AdvancePasiLineL1."Line No." := 10000;
                        AdvancePasiLineL1."Pay Period Month" := format(PayPeriodG);
                        if AdvancePasiL.Amount >= FinalEmployeeComputation then begin
                            AdvancePasiLineL1.validate("Contribution Amount", FinalEmployeeComputation);
                            FinalEmployeeComputation := 0;
                        end else begin
                            AdvancePasiLineL1.validate("Contribution Amount", AdvancePasiL.Amount);
                            FinalEmployeeComputation := FinalEmployeeComputation - AdvancePasiL.Amount;
                        end;
                        if AdvancePasiLineL1."Contribution Amount" <> 0 then begin
                            AdvancePasiLineL1.Insert();
                            SalaryComputationLineL.Reset();
                            SalaryComputationLineL.SetRange("Computation No.", SalaryComputationHeaderG."Computation No.");
                            SalaryComputationLineL.SetRange("Employee No.", Employee."No.");
                            SalaryComputationLineL.SetRange(Code, PasiGosiG."Emp. Deduction Code");
                            if SalaryComputationLineL.FindFirst() then begin
                                SalaryComputationLineL.Amount -= AdvancePasiLineL1."Contribution Amount";
                                SalaryComputationLineL.Modify();
                            end else begin
                                LineNoG += 10000;
                                InsertSalaryComputationLine(SalaryComputationHeaderG."Computation No.", LineNoG, Employee."No.", PasiGosiG."Emp. Deduction Code", -AdvancePasiLineL1."Contribution Amount", 'Advance PASI For Employee', 0, 0, 0, SalaryComputationLineG."Line Type"::"PASI/GOSI", true, true, true, SalaryComputationLineG.Category::Deduction, SalaryComputationLineG.Type::Constant, 0, false, EmployeeLevelEarningG."Accrual Type"::" ", 0, 0, SalaryComputationLineG."Posting Category"::Salary, '', '');
                            end;
                        end;
                    end;
                until (AdvancePasiL.next() = 0) or (FinalEmployeeComputation = 0);
        end;

        //Insetion in Salary Line
        if FinalEmployeeComputation <> 0 then begin
            LineNoG += 10000;
            InsertSalaryComputationLine(SalaryComputationHeaderG."Computation No.", LineNoG, Employee."No.", PasiGosiG."Emp. Deduction Code", -FinalEmployeeComputation, PasiGosiG."Emp. Deduction Description", 0, 0, 0, SalaryComputationLineG."Line Type"::"PASI/GOSI", true, true, true, SalaryComputationLineG.Category::Deduction, SalaryComputationLineG.Type::Constant, 0, false, EmployeeLevelEarningG."Accrual Type"::" ", 0, 0, SalaryComputationLineG."Posting Category"::Salary, '', '');
        end;
        if FinalEmployerComputation <> 0 then begin
            LineNoG += 10000;
            InsertSalaryComputationLine(SalaryComputationHeaderG."Computation No.", LineNoG, Employee."No.", PasiGosiG."Empl. Deduction Code", FinalEmployerComputation, PasiGosiG."Empl. Deduction Description", 0, 0, 0, SalaryComputationLineG."Line Type"::"PASI/GOSI", true, false, false, SalaryComputationLineG.Category::Deduction, SalaryComputationLineG.Type::"Employer Contribution", 0, false, EmployeeLevelEarningG."Accrual Type"::" ", 0, 0, SalaryComputationLineG."Posting Category"::Accruals, '', '');
        end;
        if PasiGosiG."Employee Difference" <> 0 then begin
            if (PasiGosiG."Employee Last Computation" = PasiGosiG."Employee Last Computation"::Prorata) and (NoofworkingDaysL <> 0) then begin
                FinalEmployeeDifference := (EmployeeComputationValue * PasiGosiG."Employee Difference") / 100;
                FinalEmployeeDifference := FinalEmployeeDifference / noofdaysL * NoofworkingDaysL;
            end else
                FinalEmployeeDifference := (EmployeeComputationValue * PasiGosiG."Employee Difference") / 100;

            LineNoG += 10000;
            InsertSalaryComputationLine(SalaryComputationHeaderG."Computation No.", LineNoG, Employee."No.", PasiGosiG."Emp. Difference Code", -FinalEmployeeDifference, PasiGosiG."Emp. Difference Description", 0, 0, 0, SalaryComputationLineG."Line Type"::"PASI/GOSI", true, true, true, SalaryComputationLineG.Category::Deduction, SalaryComputationLineG.Type::Constant, 0, false, EmployeeLevelEarningG."Accrual Type"::" ", 0, 0, SalaryComputationLineG."Posting Category"::Salary, '', '');
        end;

        if PasiGosiG."Employer Difference" <> 0 then begin
            if (PasiGosiG."Employer Last Computation" = PasiGosiG."Employer Last Computation"::Prorata) and (NoofworkingDaysL <> 0) then begin
                FinalEmployerDifference := (EmployeeComputationValue * PasiGosiG."Employer Difference") / 100;
                FinalEmployerDifference := FinalEmployerDifference / noofdaysL * NoofworkingDaysL;
            end else
                FinalEmployerDifference := (EmployeeComputationValue * PasiGosiG."Employer Difference") / 100;

            LineNoG += 10000;
            InsertSalaryComputationLine(SalaryComputationHeaderG."Computation No.", LineNoG, Employee."No.", PasiGosiG."Empl. Difference Code", -FinalEmployerDifference, PasiGosiG."Empl. Difference Description", 0, 0, 0, SalaryComputationLineG."Line Type"::"PASI/GOSI", true, true, true, SalaryComputationLineG.Category::Deduction, SalaryComputationLineG.Type::Constant, 0, false, EmployeeLevelEarningG."Accrual Type"::" ", 0, 0, SalaryComputationLineG."Posting Category"::Salary, '', '');
        end;
    end;*/




    local procedure BreachOfConductCalculation()
    var
        ComputationLineL: Record "Computation Line Detail";
        BreachAmount: decimal;
        FinalBreachAmount: Decimal;
        NoofDaysinpaymonth: integer;

    begin

        NoofDaysinpaymonth := PayCycleLineG."Period End Date" - PayCycleLineG."Period Start Date" + 1;
        FinalBreachAmount := 0;
        EmployeeDisciplinaryActionG.Reset();
        EmployeeDisciplinaryActionG.SetRange(Date, PayCycleLineG."Period Start Date", PayCycleLineG."Period End Date");
        if HrSetupG."Enable Salary Cut-off" then
            EmployeeDisciplinaryActionG.SetRange(Date, CutoffStartDateG, CutoffEndDateG);
        EmployeeDisciplinaryActionG.SetRange("Employee No.", Employee."No.");
        if EmployeeDisciplinaryActionG.FindSet() then begin
            repeat
                DisciplinaryActionLineG.Reset();
                DisciplinaryActionLineG.setrange("Disciplinary Code", EmployeeDisciplinaryActionG."Disciplinary Code");
                DisciplinaryActionLineG.SetRange("Reason Code", EmployeeDisciplinaryActionG."Reason Code");
                DisciplinaryActionLineG.SetRange("Occurance No.", EmployeeDisciplinaryActionG."Occurance No.");
                if DisciplinaryActionLineG.FindFirst() then begin
                    EmployeeEarningHistoryG.reset();
                    EmployeeEarningHistoryG.SetRange("Employee No.", Employee."No.");
                    EmployeeEarningHistoryG.setrange("Component Type", EmployeeEarningHistoryG."Component Type"::Earning);
                    if EmployeeEarningHistoryG.FindLast() then;

                    BreachAmount := 0;
                    EmployeeLevelEarningG.Reset();
                    EmployeeLevelEarningG.setrange("Employee No.", Employee."No.");
                    EmployeeLevelEarningG.SetRange("Group Code", EmployeeEarningHistoryG."Group Code");
                    EmployeeLevelEarningG.setrange("to Date", EmployeeEarningHistoryG."To Date");
                    if EmployeeLevelEarningG.FindSet() then
                        repeat
                            ComputationLineL.Reset();
                            ComputationLineL.SetRange("Computation Code", DisciplinaryActionLineG."Computation Code");
                            ComputationLineL.SetRange("Earning Code", EmployeeLevelEarningG."Earning Code");
                            if ComputationLineL.FindFirst() then
                                BreachAmount += (EmployeeLevelEarningG."Pay Amount" * ComputationLineL.Percentage) / 100;
                        until EmployeeLevelEarningG.next() = 0;

                    if (DisciplinaryActionLineG.Days <> 0) then
                        FinalBreachAmount += (BreachAmount / NoofDaysinpaymonth) * DisciplinaryActionLineG.Days;

                    if DisciplinaryActionLineG.Percentage <> 0 then
                        FinalBreachAmount += ((BreachAmount / NoofDaysinpaymonth) * DisciplinaryActionLineG.Percentage) / 100
                end else
                    exit;
            until EmployeeDisciplinaryActionG.next() = 0;
            LineNoG += 10000;
            InsertSalaryComputationLine(SalaryComputationHeaderG."Computation No.", LineNoG, Employee."No.", DisciplinaryActionLineG."Reason Code", FinalBreachAmount, DisciplinaryActionLineG."Reason Description", 0, 0, 0, SalaryComputationLineG."Line Type"::Earning, true, true, true, SalaryComputationLineG.Category::Deduction, SalaryComputationLineG.Type::Constant, 0, false, EmployeeLevelEarningG."Accrual Type"::" ", 0, 0, SalaryComputationLineG."Posting Category"::Salary, '', '');
        end;
    end;

    Local procedure LoanRequestCalculation(NoOfWorkingDaysP: Decimal)
    var
        LoanRequestL: Record "Loan Request";
        AmountL: Decimal;
    begin
        LoanRequestL.Reset();
        LoanRequestL.SetRange("Employee No.", Employee."No.");
        LoanRequestL.SetRange("Requested date", PayCycleLineG."Period Start Date", PayCycleLineG."Period End Date");
        if HrSetupG."Enable Salary Cut-off" then
            LoanRequestL.SetRange("Requested date", CutoffStartDateG, CutoffEndDateG);
        LoanRequestL.SetFilter(Amount, '>%1', 0);
        LoanRequestL.SetRange("Include in Salary", true);
        if LoanRequestL.FindSet() then
            repeat
                LineNoG += 10000;
                AmountL := LoanRequestL.Amount;
                InsertSalaryComputationLine(SalaryComputationHeaderG."Computation No.", LineNoG, Employee."No.", LoanRequestL."Loan Type", AmountL, LoanRequestL."Loan Description", NoOfWorkingDaysP, 0, 0, SalaryComputationLineG."Line Type"::Loans, true, true, true, SalaryComputationLineG.Category::Earning, SalaryComputationLineG.Type::Constant, 0, false, SalaryComputationLineG."Accrual Type"::" ", AmountL, 0, SalaryComputationLineG."Posting Category"::Salary, LoanRequestL."Loan Request No.", '');
            until LoanRequestL.Next() = 0;

        // Insert EOS Deduction
        if EOSCalculationG then begin
            LoanRequestL.SetRange("Requested date");
            LoanRequestL.SetRange("Include in Salary");
            LoanRequestL.SetRange("End of Service", true);
            if LoanRequestL.FindSet() then
                repeat
                    LineNoG += 10000;
                    AmountL := -LoanRequestL.Amount;
                    InsertSalaryComputationLine(SalaryComputationHeaderG."Computation No.", LineNoG, Employee."No.", LoanRequestL."Loan Type", AmountL, LoanRequestL."Loan Description", NoOfWorkingDaysP, 0, 0, SalaryComputationLineG."Line Type"::Loans, true, true, true, SalaryComputationLineG.Category::Deduction, SalaryComputationLineG.Type::Constant, 0, false, SalaryComputationLineG."Accrual Type"::" ", AmountL, 0, SalaryComputationLineG."Posting Category"::"End of Service", LoanRequestL."Loan Request No.", '');
                until LoanRequestL.Next() = 0;
        end;

    end;

    Local procedure InstallmentCalculation(NoOfWorkingDaysP: Decimal)
    var
        LoanRequestL: Record "Loan Request";
        LoanInstallmentLineL: Record "Instalment Detail";
        AmountL: Decimal;

    begin
        if not EOSCalculationG then begin
            LoanInstallmentLineL.Reset();
            LoanInstallmentLineL.SetRange(Status, LoanInstallmentLineL.Status::Unpaid);
            LoanInstallmentLineL.SetRange("Deduction Date", PayCycleLineG."Period Start Date", PayCycleLineG."Period End Date");
            if HrSetupG."Enable Salary Cut-off" then
                LoanInstallmentLineL.SetRange("Deduction Date", CutoffStartDateG, CutoffEndDateG);
            If LoanInstallmentLineL.FindSet() then
                repeat
                    LoanRequestL.Get(LoanInstallmentLineL."Loan Request No.");
                    if LoanRequestL."Employee No." = Employee."No." then begin
                        LineNoG += 10000;
                        AmountL := -LoanInstallmentLineL."Deduction Amount";
                        InsertSalaryComputationLine(SalaryComputationHeaderG."Computation No.", LineNoG, Employee."No.", LoanRequestL."Loan Type", AmountL, LoanRequestL."Loan Description" + ' Instalment', NoOfWorkingDaysP, 0, 0, SalaryComputationLineG."Line Type"::Loans, true, true, true, SalaryComputationLineG.Category::Deduction, SalaryComputationLineG.Type::Constant, 0, false, SalaryComputationLineG."Accrual Type"::" ", AmountL, 0, SalaryComputationLineG."Posting Category"::Instalment, LoanInstallmentLineL."Loan Request No.", '');
                    end;
                until LoanInstallmentLineL.Next() = 0;
            //For End of Services 
        end else begin
            LoanRequestL.Reset();
            LoanRequestL.SetRange("Employee No.", Employee."No.");
            LoanRequestL.SetFilter(Amount, '>%1', 0);
            if LoanRequestL.FindSet() then
                repeat
                    LoanInstallmentLineL.SetRange("Loan Request No.", LoanRequestL."Loan Request No.");
                    LoanInstallmentLineL.SetRange(Status, LoanInstallmentLineL.Status::Unpaid);
                    LoanInstallmentLineL.CalcSums("Deduction Amount");
                    AmountL := -LoanInstallmentLineL."Deduction Amount";
                    if AmountL <> 0 then begin
                        LineNoG += 10000;
                        InsertSalaryComputationLine(SalaryComputationHeaderG."Computation No.", LineNoG, Employee."No.", LoanRequestL."Loan Type", AmountL, LoanRequestL."Loan Description" + ' Instalment', NoOfWorkingDaysP, 0, 0, SalaryComputationLineG."Line Type"::Loans, true, true, true, SalaryComputationLineG.Category::Deduction, SalaryComputationLineG.Type::Constant, 0, false, SalaryComputationLineG."Accrual Type"::" ", AmountL, 0, SalaryComputationLineG."Posting Category"::Instalment, LoanInstallmentLineL."Loan Request No.", '');
                    end;
                until LoanRequestL.Next() = 0;
        end;
    end;

    local procedure EmployeeOTCalculation(EmployeeLevelEarningP: Record "Employee Level Earning")
    var

        OtHours: Decimal;
        OTPayL: Decimal;
        ModiDate: Date;
        MinDay: Integer;
        PayAmountL: decimal;
        TotalNoOfHoursL: Decimal;
        NoofDaysL: Decimal;
    begin
        NoofDaysL := PayCycleLineG."Period End Date" - PayCycleLineG."Period Start Date" + 1;
        EmployeeLevelEarningP.SetRange("Employee No.", Employee."No.");
        EmployeeLevelEarningP.SetRange(Category, EmployeeLevelEarningP.Category::Earning);
        EmployeeLevelEarningP.SetRange(Accural, false);
        EmployeeLevelEarningP.SetFilter("Day Type", '<>%1', EmployeeLevelEarningP."Day Type"::" ");
        if EmployeeLevelEarningP.FindSet() then begin
            OtHours := 0;
            EmployeeTimingG.Reset();
            EmployeeTimingG.SetRange("Employee No.", Employee."No.");
            EmployeeTimingG.SetRange("From Date", PayCycleLineG."Period Start Date", PayCycleLineG."Period End Date");
            EmployeeTimingG.SetRange("First Half Status", Format(EmployeeLevelEarningP."Day Type"::"Working Day"));
            if EmployeeTimingG.FindFirst() then
                TotalNoOfHoursL := (EmployeeTimingG."Total Hours") / 3600000
            else
                exit;
            repeat
                EmployeeTimingG.SetRange("First Half Status");
                EmployeeTimingG.SetFilter("OT Hours", '>=%1', EmployeeLevelEarningP."Minimum Duration");

                case EmployeeLevelEarningP."Day Type" of
                    EmployeeLevelEarningP."Day Type"::"Any Day":
                        begin
                            EmployeeTimingG.CalcSums("OT Hours");
                            OtHours := EmployeeTimingG."OT Hours" / 3600000;
                        end;
                    EmployeeLevelEarningP."Day Type"::"Public Holiday":
                        begin
                            EmployeeTimingG.SetRange("First Half Status", Format(EmployeeLevelEarningP."Day Type"::"Public Holiday"));
                            EmployeeTimingG.CalcSums("OT Hours");
                            OtHours := EmployeeTimingG."OT Hours" / 3600000;
                        end;
                    EmployeeLevelEarningP."Day Type"::"Week Off":
                        begin
                            EmployeeTimingG.SetRange("First Half Status", Format(EmployeeLevelEarningP."Day Type"::"Week Off"));
                            EmployeeTimingG.CalcSums("OT Hours");
                            OtHours := EmployeeTimingG."OT Hours" / 3600000;
                        end;
                    EmployeeLevelEarningP."Day Type"::"Working Day":
                        begin
                            EmployeeTimingG.SetRange("First Half Status", Format(EmployeeLevelEarningP."Day Type"::"Working Day"));
                            EmployeeTimingG.CalcSums("OT Hours");
                            OtHours := EmployeeTimingG."OT Hours" / 3600000;
                        end;
                end;
                if EmployeeLevelEarningP."Payment Type" = EmployeeLevelEarningP."Payment Type"::Amount then
                    OTPayL := EmployeeLevelEarningP."Pay Amount" * TotalNoOfHoursL * NoofDaysL
                else
                    OTPayL := PayAmountCalculation(EmployeeLevelEarningP);

                ModiDate := CalcDate(EmployeeLevelEarningP."Minimum Number of Days", Today());
                MinDay := ModiDate - Today();
                PayAmountL := OtHours * (OTPayL / TotalNoOfHoursL) / NoofDaysL;
                if (EmployeeTimingG.Count() >= MinDay) and (PayAmountL <> 0) then begin
                    LineNoG += 10000;
                    InsertSalaryComputationLine(SalaryComputationHeaderG."Computation No.", LineNoG, Employee."No.", EmployeeLevelEarningP."Earning Code", PayAmountL, EmployeeLevelEarningP."Earning Description", 0, 0, 0, SalaryComputationLineG."Line Type"::Earning, true, true, true, SalaryComputationLineG.Category::Earning, SalaryComputationLineG.Type::Constant, 0, false, EmployeeLevelEarningG."Accrual Type"::" ", 0, 0, SalaryComputationLineG."Posting Category"::Salary, '', '');
                end;
            until EmployeeLevelEarningP.Next() = 0;
        end;
    end;

    local procedure EmployeeDeductionCalculation(EmployeeLevelEarningP: Record "Employee Level Earning")
    var
        OtHours: Decimal;
        OTPayL: Decimal;
        ModiDate: Date;
        MinDay: Integer;
        PayAmountL: decimal;
        TotalNoOfHoursL: Decimal;
        NoofDaysL: Decimal;
    begin
        NoofDaysL := PayCycleLineG."Period End Date" - PayCycleLineG."Period Start Date" + 1;
        EmployeeLevelEarningP.SetRange("Employee No.", Employee."No.");
        EmployeeLevelEarningP.SetRange(Category, EmployeeLevelEarningP.Category::Deduction);
        EmployeeLevelEarningP.SetRange(Accural, false);
        EmployeeLevelEarningP.SetFilter("Day Type", '<>%1', EmployeeLevelEarningP."Day Type"::" ");
        if EmployeeLevelEarningP.FindSet() then begin
            OtHours := 0;
            EmployeeTimingG.Reset();
            EmployeeTimingG.SetRange("Employee No.", Employee."No.");
            EmployeeTimingG.SetRange("From Date", PayCycleLineG."Period Start Date", PayCycleLineG."Period End Date");
            EmployeeTimingG.SetRange("First Half Status", Format(EmployeeLevelEarningP."Day Type"::"Working Day"));
            if EmployeeTimingG.FindFirst() then
                TotalNoOfHoursL := (EmployeeTimingG."Total Hours") / 3600000
            else
                exit;

            repeat
                EmployeeTimingG.SetRange("First Half Status");
                EmployeeTimingG.SetFilter("OT Hours", '<=%1', EmployeeLevelEarningP."Minimum Duration");

                case EmployeeLevelEarningP."Day Type" of
                    EmployeeLevelEarningP."Day Type"::"Any Day":
                        begin
                            EmployeeTimingG.CalcSums("OT Hours");
                            OtHours := EmployeeTimingG."OT Hours" / 3600000;
                        end;
                    EmployeeLevelEarningP."Day Type"::"Public Holiday":
                        begin
                            EmployeeTimingG.SetRange("First Half Status", Format(EmployeeLevelEarningP."Day Type"::"Public Holiday"));
                            EmployeeTimingG.CalcSums("OT Hours");
                            OtHours := EmployeeTimingG."OT Hours" / 3600000;
                        end;
                    EmployeeLevelEarningP."Day Type"::"Week Off":
                        begin
                            EmployeeTimingG.SetRange("First Half Status", Format(EmployeeLevelEarningP."Day Type"::"Week Off"));
                            EmployeeTimingG.CalcSums("OT Hours");
                            OtHours := EmployeeTimingG."OT Hours" / 3600000;
                        end;
                    EmployeeLevelEarningP."Day Type"::"Working Day":
                        begin
                            EmployeeTimingG.SetRange("First Half Status", Format(EmployeeLevelEarningP."Day Type"::"Working Day"));
                            EmployeeTimingG.CalcSums("OT Hours");
                            OtHours := EmployeeTimingG."OT Hours" / 3600000;
                        end;

                end;
                //Monthly Amount Calculated
                if EmployeeLevelEarningP."Payment Type" = EmployeeLevelEarningP."Payment Type"::Amount then
                    OTPayL := EmployeeLevelEarningP."Pay Amount" * TotalNoOfHoursL * NoofDaysL
                else
                    OTPayL := PayAmountCalculation(EmployeeLevelEarningP);


                ModiDate := CalcDate(EmployeeLevelEarningP."Minimum Number of Days", Today());
                MinDay := ModiDate - Today();
                PayAmountL := OtHours * (OTPayL / TotalNoOfHoursL) / NoofDaysL;
                if (EmployeeTimingG.Count() >= MinDay) and (PayAmountL <> 0) then begin
                    LineNoG += 10000;
                    InsertSalaryComputationLine(SalaryComputationHeaderG."Computation No.", LineNoG, Employee."No.", EmployeeLevelEarningP."Earning Code", PayAmountL, EmployeeLevelEarningP."Earning Description", 0, 0, 0, SalaryComputationLineG."Line Type"::Earning, true, true, true, SalaryComputationLineG.Category::Deduction, SalaryComputationLineG.Type::Constant, 0, false, EmployeeLevelEarningG."Accrual Type"::" ", 0, 0, SalaryComputationLineG."Posting Category"::Salary, '', '');
                end;
            until EmployeeLevelEarningP.Next() = 0;
        end;
    end;

    local procedure PayAmountCalculation(EmployeeLevelEarningP: record "Employee Level Earning"): Decimal
    var
        ComputationL: record Computation;
        ComputationLineL: record "Computation Line Detail";
        OTPayL: Decimal;
    begin
        case EmployeeLevelEarningP."Payment Type" of
            EmployeeLevelEarningP."Payment Type"::Computation:
                begin
                    OTPayL := 0;
                    EmployeeEarningHistoryG.reset();
                    EmployeeEarningHistoryG.SetRange("Employee No.", Employee."No.");
                    EmployeeEarningHistoryG.SetRange("Component Type", EmployeeEarningHistoryG."Component Type"::Earning);
                    if EmployeeEarningHistoryG.FindSet() then begin
                        EmployeeLevelEarningG.Reset();
                        EmployeeLevelEarningG.SetRange("Employee No.", Employee."No.");
                        EmployeeLevelEarningG.SetRange("Group Code", EmployeeEarningHistoryG."Group Code");
                        EmployeeLevelEarningG.SetRange("To Date", EmployeeEarningHistoryG."To Date");
                        if EmployeeLevelEarningG.FindSet() then
                            repeat
                                ComputationL.Get(EmployeeLevelEarningP."Computation Code");
                                ComputationLineL.Reset();
                                ComputationLineL.setrange("Computation Code", ComputationL."Computation Code");
                                ComputationLineL.SetRange("Earning Code", EmployeeLevelEarningG."Earning Code");
                                if ComputationLineL.FindFirst() then
                                    OTPayL += (EmployeeLevelEarningG."Pay Amount" * ComputationLineL.Percentage) / 100;
                            until EmployeeLevelEarningG.Next() = 0;
                    end;
                end;
            EmployeeLevelEarningP."Payment Type"::Percentage:
                begin
                    EmployeeEarningHistoryG.reset();
                    EmployeeEarningHistoryG.SetRange("Employee No.", Employee."No.");
                    EmployeeEarningHistoryG.SetRange("Component Type", EmployeeEarningHistoryG."Component Type"::Earning);
                    if EmployeeEarningHistoryG.FindSet() then begin
                        EmployeeLevelEarningG.Reset();
                        EmployeeLevelEarningG.SetRange("Employee No.", Employee."No.");
                        EmployeeLevelEarningG.SetRange("Group Code", EmployeeEarningHistoryG."Group Code");
                        EmployeeLevelEarningG.SetRange("To Date", EmployeeEarningHistoryG."To Date");
                        EmployeeLevelEarningG.SetRange("Earning Code", EmployeeLevelEarningP."Base Code");
                        if EmployeeLevelEarningG.FindFirst() then
                            OTPayL := (EmployeeLevelEarningG."Pay Amount" * EmployeeLevelEarningP."Pay Percentage") / 100;
                    end;
                end;
        end;
        exit(OTPayL);
    end;

    procedure SetDefaultValueForEndofService(FromDateP: Date; ToDateP: Date; ComputationNoP: Code[20]; EmployeeNoP: Code[20]; ReasonCodeP: Code[20])
    var
        EmployeeL: Record Employee;
    begin
        PayCycleLineG."Period Start Date" := FromDateP;
        PayCycleLineG."Period End Date" := ToDateP;
        PayCycleLineG."Pay Period" := FORMAT(PayCycleLineG."Period End Date", 0, '<Month Text>') + '-' + format(Date2DMY(PayCycleLineG."Period End Date", 3));
        ComputationNoG := ComputationNoP;
        EmployeeL.Get(EmployeeNoP);
        EmployeeNoG := EmployeeL."No.";
        SalaryClassG := EmployeeL."Salary Class";
        PayPeriodG := PayCycleLineG."Pay Period";
        ReasonCodeG := ReasonCodeP;
        EOSCalculationG := true;
    end;

    procedure SetParametersForLeaveSalary(FromDateP: Date; ToDateP: Date; ComputationNoP: Code[20]; EmployeeNoP: Code[20]; CalculationStartDateP: Date; CalculationEndDateP: Date; ComputationCodeP: code[20]; ComputationTypeP: Integer)
    var
        EmployeeL: Record Employee;
        SalaryComputationLineL: Record "Salary Computation Line";
    begin
        // Created by Avinash : perticularly for the Leave Salary Calculation.
        CalculationStartDateG := CalculationStartDateP;
        CalculationEndDateG := CalculationEndDateP;
        PayCycleLineG."Period Start Date" := FromDateP;
        PayCycleLineG."Period End Date" := ToDateP;
        PayCycleLineG."Pay Period" := FORMAT(PayCycleLineG."Period End Date", 0, '<Month Text>') + '-' + format(Date2DMY(PayCycleLineG."Period End Date", 3));
        ComputationNoG := ComputationNoP;
        EmployeeL.Get(EmployeeNoP);
        EmployeeNoG := EmployeeL."No.";
        SalaryClassG := EmployeeL."Salary Class";
        PayPeriodG := PayCycleLineG."Pay Period";
        ComputationCodeG := ComputationCodeP;
        ComputationTypeG := ComputationTypeP;
        LeaveSalaryG := true;
        SalaryComputationLineL.SetRange("Computation No.", ComputationNoP);
        if SalaryComputationLineL.FindLast() then
            ;
        LineNoG += SalaryComputationLineL."Line No.";
    end;

}
