report 50069 "Employee Master"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = './res/EmployeeMaster.rdl';
    dataset
    {
        dataitem(Employee; Employee)
        {
            DataItemTableView = sorting("No.") where(Status = filter("Active"));
            RequestFilterFields = "No.";
            column(Comp_Name; CompInfoG.Name)
            { }
            column(Logo; CompInfoG.Picture)
            { }
            column(No_; "No.")
            { }
            column(FullName; FullName())
            { }
            column(Job_Title; "Job Title")
            { }
            column(DepartmentG; DepartmentG)
            { }
            column(PaymentModeG; PaymentModeG)
            { }
            column(Employment_Date; Format("Employment Date"))
            { }
            column(Labor_ID; "MOL ID")
            { }
            column(Probation_End_Date; Format("Probation End Date"))
            { }
            column(BankName; EmpBankAccDettailsG."Bank Name")
            { }
            column(AccNo; EmpBankAccDettailsG."Account No.")
            { }
            column(IBANNo; EmpBankAccDettailsG."IBAN No.")
            { }
            column(AdditionsG; AdditionsG)
            { }
            column(DeductionsG; DeductionsG)
            { }
            column(LeaveBalanceG; LeaveBalanceG)
            { }
            column(DurationfromJoiningtillDate; DurationfromJoiningtillDate)
            { }
            dataitem("Employee Level Identification"; "Employee Level Identification")
            {
                DataItemLink = "Employee No." = field("No.");
                DataItemTableView = sorting("Employee No.", Code, "Line No");
                column(Code; Code)
                { }
                column(Description; Description)
                { }
                column(Serial_No_; "Serial No.")
                { }
            }

            dataitem("Employee Level Earning"; "Employee Level Earning")
            {
                DataItemTableView = sorting("Employee No.", "Group Code", "From Date", "Earning Code");
                column(Earning_Code; "Earning Code")
                { }
                column(Pay_Amount; "Pay Amount")
                { }
                column(Earning_Description; "Earning Description")
                { }

                trigger OnPreDataItem()
                begin
                    SetRange("Employee No.", Employee."No.");
                    SetRange("From Date", EmpEarningHistoryG."From Date");
                    SetRange("Group Code", EmpEarningHistoryG."Group Code");
                end;

                trigger OnAfterGetRecord()
                begin
                    if EarningsG.Get("Earning Code") then
                        if not EarningsG."Affects Salary" then
                            CurrReport.Skip();
                end;

            }
            trigger OnPreDataItem()
            begin
                CompInfoG.Get();
                CompInfoG.CalcFields(Picture);
            end;

            trigger OnAfterGetRecord()
            var
                EmployeeDesigL: Record "Employee Level Designation";
                DepartmentL: Record Department;
                PaymentTypeL: Record "Payment Type";
            begin
                Clear(EmpBankAccDettailsG);
                EmpBankAccDettailsG.Reset();
                EmpBankAccDettailsG.SetRange("Employee No.", "No.");
                EmpBankAccDettailsG.SetRange(Primary, true);
                if EmpBankAccDettailsG.FindFirst() then;

                Clear(EmpEarningHistoryG);
                EmpEarningHistoryG.Reset();
                EmpEarningHistoryG.SetRange("Component Type", EmpEarningHistoryG."Component Type"::Earning);
                EmpEarningHistoryG.SetRange("Employee No.", "No.");
                EmpEarningHistoryG.SetFilter("From Date", '<=%1', Today());
                EmpEarningHistoryG.SetFilter("To Date", '>=%1', Today());
                if EmpEarningHistoryG.FindFirst() then;

                Clear(DepartmentG);
                EmployeeDesigL.Reset();
                EmployeeDesigL.SetRange("Employee No.", "No.");
                EmployeeDesigL.SetRange("Primary Position", true);
                if EmployeeDesigL.FindFirst() then
                    if DepartmentL.Get(EmployeeDesigL.Department) then
                        DepartmentG := DepartmentL.Description;

                Clear(PaymentModeG);
                IF PaymentTypeL.Get("Payment Type") then
                    PaymentModeG := PaymentTypeL.Description;

                TestField("Employment Date");
                DurationfromJoiningtillDate := Round((Today() - "Employment Date") / 30, 1);
            end;

        }
    }

    var
        CompInfoG: Record "Company Information";
        EmpBankAccDettailsG: Record "Employee Bank Account Detail";
        EarningsG: Record Earning;
        EmpEarningHistoryG: Record "Employee Earning History";
        DepartmentG: Text;
        PaymentModeG: Text;
        LeaveBalanceG: Decimal;
        AdditionsG: Decimal;
        DeductionsG: Decimal;
        DurationfromJoiningtillDate: Integer;
}