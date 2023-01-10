report 50070 "Accruals & Employee Deductions"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    RDLCLayout = './res/AccrualsAndEmployeeDeduc.rdl';
    dataset
    {
        dataitem(SalaryComputationLine; "Salary Computation Line")
        {
            DataItemTableView = sorting("Computation No.", "Line No.") where(Type = filter("Employer Contribution" | " "), Category = filter(Deduction | Absence | Earning));
            column(Company_Name; CompanyInfoG.Name)
            { }
            column(Logo; CompanyInfoG.Picture)
            { }
            column(Employee_No_; "Employee No.")
            { }
            column(Employee_Name; EmployeeRecG.FullName())
            { }
            column(Code; Code)
            { }
            column(Pay_Period; "Pay Period")
            { }
            column(Description; Description)
            { }
            column(Amount; Amount)
            { }
            column(Total_Amount; "Total Amount")
            { }
            column(Accrual_Value; "Accrual Value")
            { }
            column(Total_Accrual_Value; "Total Accrual Value")
            { }
            trigger OnPreDataItem()
            begin
                CompanyInfoG.Get();
                CompanyInfoG.CalcFields(Picture);
                SalaryComputationLine.SetFilter("Salary Class", SalaryClassG);
                SalaryComputationLine.SetRange("Pay Period", PayPeriodG);
                IF AccrualTypeG <> '' then
                    SalaryComputationLine.SetFilter(Code, AccrualTypeG);
                if EmployeeG <> '' then
                    SalaryComputationLine.SetFilter("Employee No.", EmployeeG);
            end;

            trigger OnAfterGetRecord()
            begin
                EmployeeRecG.Get("Employee No.");
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
                    /* field("Accrual Type"; AccrualTypeG)
                    {
                        ApplicationArea = All;
                        TableRelation = Earning where (Type = filter ("Employer Contribution" | " "));
                    }
                    field(Employee; EmployeeG)
                    {
                        ApplicationArea = All;
                        TableRelation = Employee;
                    } */
                }
            }
        }
    }

    var
        PayCycleLineG: Record "Pay Period Line";
        CompanyInfoG: Record "Company Information";
        EmployeeRecG: Record Employee;

        SalaryClassG: Text;
        PayPeriodG: Text;
        AccrualTypeG: text;
        EmployeeG: Text;
}