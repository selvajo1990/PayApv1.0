report 50061 "Salary Register"
{
    UsageCategory = Lists;
    ApplicationArea = All;
    Caption = 'Salary Register';
    RDLCLayout = './res/SalaryRegister.rdl';
    dataset
    {
        dataitem(Heading; Integer)
        {
            DataItemTableView = sorting(Number) where(Number = filter(1));
            column(CompanyInfoG_Name; CompanyInfoG.Name)
            { }
            column(CompanyInfoG_Picture; CompanyInfoG.Picture)
            { }
            column(PayPeriodG; PayPeriodG)
            { }
            column(SalaryClassG; SalaryClassG)
            { }
            trigger OnPreDataItem()
            begin
                CompanyInfoG.get();
                CompanyInfoG.CalcFields(Picture);
            end;
        }
        dataitem(Employee; Employee)
        {
            PrintOnlyIfDetail = true;
            DataItemTableView = sorting("No.");
            column(Employee_No_; "No.")
            { }
            column(Employee_Name; "First Name" + ' ' + "Last Name")
            { }
            column(EmployeeG_JobTitle; "Job Title")
            { }
            column(EmpDepartmentG; EmpDepartmentG)
            { }
            column(PaymentTypeG; PaymentTypeG)
            { }
            column(AdhocEarningsG; AdhocEarningsG)
            { }
            column(AdhocDeductionG; AdhocDeductionG)
            { }
            dataitem("Employee Level Earning"; "Employee Level Earning")
            {
                DataItemTableView = sorting("Employee No.", "Group Code", "From Date", "Earning Code");
                column(Earning_Code; "Earning Code")
                { }
                column(Pay_Amount; "Pay Amount")
                { }
                column(EarningsL; EarningsL.Description)
                { }

                trigger OnPreDataItem()
                begin
                    if SkipLoopG then
                        CurrReport.Skip();
                    SetRange("Employee No.", Employee."No.");
                    SetRange("From Date", EmpEarningHistoryG."From Date");
                    SetRange("Group Code", EmpEarningHistoryG."Group Code");
                end;

                trigger OnAfterGetRecord()
                begin
                    if Category = Category::Deduction then
                        "Pay Amount" := -"Pay Amount";
                    if EarningsL.Get("Earning Code") then
                        if not EarningsL."Affects Salary" then
                            CurrReport.Skip();


                end;

            }
            dataitem(SalaryComputationLine; "Salary Computation Line")
            {
                DataItemTableView = sorting("Computation No.", "Line No.") where(Type = filter(<> "Employer Contribution"), "Affects Salary" = filter(true));

                column(Earning_Group; "Code")
                { }
                column(Description; Description)
                { }
                column(Amount; Amount)
                { }
                trigger OnPreDataItem()
                begin
                    if SkipLoopG then
                        CurrReport.Skip();
                    SalaryComputationLine.SetFilter("Salary Class", SalaryClassG);
                    SalaryComputationLine.SetRange("Pay Period", PayPeriodG);
                    SalaryComputationLine.SetRange("Employee No.", Employee."No.");
                end;

                trigger OnAfterGetRecord()
                var
                    EarningCodesL: Record Earning;
                begin
                    if EmployeeG.Get("Employee No.") then;
                    if EarningCodesL.Get(Code) then
                        if EarningCodesL.Type = EarningCodesL.Type::Adhoc then
                            CurrReport.Skip();

                end;
            }
            trigger OnAfterGetRecord()
            var
                SalaryCompHeaderL: Record "Salary Computation Header";
                SalaryCompLineL: Record "Salary Computation Line";
                EarningCodesL: Record Earning;
                EmployeeDesigL: Record "Employee Level Designation";
                DepartmentL: Record Department;
                PaymentTypeL: Record "Payment Type";
            begin
                Clear(AdhocEarningsG);
                Clear(AdhocDeductionG);
                Clear(SkipLoopG);
                SalaryCompLineL.SetFilter("Salary Class", SalaryClassG);
                SalaryCompLineL.SetRange("Pay Period", PayPeriodG);
                SalaryCompLineL.SetRange("Employee No.", "No.");
                SalaryCompLineL.SetFilter(Type, '<>%1', SalaryCompLineL.Type::"Employer Contribution");
                SalaryCompLineL.SetRange("Affects Salary", true);
                if NOT SalaryCompLineL.FindSet() then begin
                    CurrReport.Skip();
                    SkipLoopG := true;
                end else
                    repeat
                        if EarningCodesL.Get(SalaryCompLineL.Code) then
                            if EarningCodesL.Type = EarningCodesL.Type::Adhoc then begin
                                if EarningCodesL.Category = EarningCodesL.Category::Earning then
                                    AdhocEarningsG += SalaryCompLineL.Amount;
                                if EarningCodesL.Category = EarningCodesL.Category::Deduction then
                                    AdhocDeductionG += SalaryCompLineL.Amount;
                            end;
                    until SalaryCompLineL.Next() = 0;

                Clear(EmpEarningHistoryG);
                SalaryCompHeaderL.SetFilter("Salary Class", SalaryClassG);
                SalaryCompHeaderL.SetRange("Pay Period", PayPeriodG);
                if SalaryCompHeaderL.FindFirst() then begin
                    EmpEarningHistoryG.Reset();
                    EmpEarningHistoryG.SetRange("Component Type", EmpEarningHistoryG."Component Type"::Earning);
                    EmpEarningHistoryG.SetRange("Employee No.", "No.");
                    EmpEarningHistoryG.SetFilter("From Date", '<=%1', SalaryCompHeaderL."From Date");
                    EmpEarningHistoryG.SetFilter("To Date", '>=%1', SalaryCompHeaderL."To Date");
                    if EmpEarningHistoryG.FindFirst() then;
                end;
                Clear(EmpDepartmentG);
                EmployeeDesigL.Reset();
                EmployeeDesigL.SetRange("Employee No.", "No.");
                EmployeeDesigL.SetRange("Primary Position", true);
                if EmployeeDesigL.FindFirst() then
                    if DepartmentL.Get(EmployeeDesigL.Department) then
                        EmpDepartmentG := DepartmentL.Description;

                Clear(PaymentTypeG);
                IF PaymentTypeL.Get("Payment Type") then
                    PaymentTypeG := PaymentTypeL.Description;
            end;
        }


    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group("Salary Register Filter")
                {
                    field("Salary Class"; SalaryClassG)
                    {
                        ApplicationArea = All;
                        TableRelation = "Salary Class";
                        ToolTip = 'Specifies the value of the SalaryClassG';
                    }

                    field("Pay Period"; PayPeriodG)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the PayPeriodG';
                        trigger OnLookup(var Text: Text): Boolean
                        var
                            SubGradeL: Record "Sub Grade";
                            InvaildFilterLbl: Label 'Salary class must have value';
                        begin
                            if SalaryClassG = '' then
                                Error(InvaildFilterLbl);

                            SubGradeL.SetRange("Salary Class", SalaryClassG);
                            SubGradeL.FindFirst();
                            SubGradeL.TestField("Pay Cycle");
                            PayCycleLineG.SetRange("Pay Cycle", SubGradeL."Pay Cycle");
                            if Page.RunModal(0, PayCycleLineG) = Action::LookupOK then
                                PayPeriodG := PayCycleLineG."Pay Period";
                        end;
                    }
                }
            }
        }

        actions
        {

        }
    }
    labels
    {
        lbl_ReportTitle = 'Salary Register';
        lbl_EmployeeNo = 'Employee No.';
        lbl_EmployeeName = 'Employee Name';
        lbl_EarningCode = 'Earning Code';
        lbl_DeductionCode = 'Deduction Code';
        lbl_TotalEarnings = 'Total Earnings';
        lbl_TotalDeduction = 'Total Deduction';
        lbl_TotalNetPay = 'Total Net Pay';
        lbl_Amount = 'Amount';
    }
    var
        PayCycleLineG: Record "Pay Period Line";
        CompanyInfoG: Record "Company Information";
        EmployeeG: Record Employee;
        EarningsL: Record Earning;
        EmpEarningHistoryG: Record "Employee Earning History";
        SalaryClassG: Text;
        PayPeriodG: Text;
        AdhocEarningsG: Decimal;
        AdhocDeductionG: Decimal;
        EmpDepartmentG: Text;
        PaymentTypeG: Text;
        SkipLoopG: Boolean;

}
