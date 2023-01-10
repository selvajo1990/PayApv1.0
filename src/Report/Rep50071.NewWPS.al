report 50071 "New WPS"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    RDLCLayout = './res/NewWPS.rdl';

    dataset
    {
        dataitem(Employee; Employee)
        {
            DataItemTableView = sorting("No.");

            column(Comp_Name; CompInfoG.Name)
            { }
            column(Comp_Add; CompInfoG.Address + ',' + CompInfoG."Address 2")
            { }
            column(CompInfoG; CompInfoG."Bank Name")
            { }
            column(PayStartDateG; FORMAT(PayStartDateG))
            { }
            column(PayEndDateG; FORMAT(PayEndDateG))
            { }
            column(CompanyID; HRSetupG."Company ID")
            { }
            column(NoOfDaysG; NoOfDaysG)
            { }
            column(PayPeriodG; PayPeriodG)
            { }
            column(SlNoG; SlNoG)
            { }
            column(No_; "No.")
            { }
            column(FullName; FullName())
            { }
            column(Labor_ID; "MOL ID")
            { }
            column(PersonalNoG; PersonalNoG)
            { }
            column(FixedPayG; FixedPayG)
            { }
            column(VarPayG; VarPayG)
            { }
            column(BankName; EmpBankAccDettailsG."Bank Name")
            { }
            column(EmpBankIBAN; EmpBankAccDettailsG."IBAN No.")
            { }

            trigger OnPreDataItem()
            var
                salaryCompHeaderL: Record "Salary Computation Header";
            begin
                CompInfoG.get();
                CompInfoG.CalcFields(Picture);
                HRSetupG.Get();
                salaryCompHeaderL.Reset();
                salaryCompHeaderL.SetFilter("Salary Class", SalaryClassG);
                salaryCompHeaderL.SetRange("Pay Period", PayPeriodG);
                if salaryCompHeaderL.FindLast() then begin
                    PayStartDateG := salaryCompHeaderL."From Date";
                    PayEndDateG := salaryCompHeaderL."To Date";
                    NoOfDaysG := PayEndDateG - PayStartDateG + 1;
                end;

            end;

            trigger OnAfterGetRecord()
            var
                EmpIdentificationL: Record "Employee Level Identification";
                SalaryCompLineL: Record "Salary Computation Line";
                EmpLevelErngsL: Record "Employee Level Earning";
            begin
                SlNoG += 1;
                Clear(PersonalNoG);
                EmpIdentificationL.Reset();
                EmpIdentificationL.SetRange("Employee No.", "No.");
                EmpIdentificationL.SetRange(Code, 'LC');
                if EmpIdentificationL.FindFirst() then
                    PersonalNoG := EmpIdentificationL."Serial No.";


                Clear(EmpBankAccDettailsG);
                EmpBankAccDettailsG.Reset();
                EmpBankAccDettailsG.SetRange("Employee No.", "No.");
                EmpBankAccDettailsG.SetRange(Primary, true);
                if EmpBankAccDettailsG.FindFirst() then;

                Clear(EmpEarningHistoryG);
                Clear(FixedPayG);
                EmpEarningHistoryG.Reset();
                EmpEarningHistoryG.SetRange("Component Type", EmpEarningHistoryG."Component Type"::Earning);
                EmpEarningHistoryG.SetRange("Employee No.", "No.");
                EmpEarningHistoryG.SetFilter("From Date", '<=%1', Today());
                EmpEarningHistoryG.SetFilter("To Date", '>=%1', Today());
                if EmpEarningHistoryG.FindFirst() then begin
                    EmpLevelErngsL.Reset();
                    EmpLevelErngsL.SetRange("Employee No.", Employee."No.");
                    EmpLevelErngsL.SetRange("From Date", EmpEarningHistoryG."From Date");
                    EmpLevelErngsL.SetRange("Group Code", EmpEarningHistoryG."Group Code");
                    EmpLevelErngsL.SetRange("Earning Code", 'GR');
                    if EmpLevelErngsL.FindFirst() then
                        FixedPayG := EmpLevelErngsL."Pay Amount";
                end;

                Clear(VarPayG);
                SalaryCompLineL.Reset();
                SalaryCompLineL.SetFilter("Salary Class", SalaryClassG);
                SalaryCompLineL.SetRange("Pay Period", PayPeriodG);
                SalaryCompLineL.SetRange(Type, SalaryCompLineL.Type::Adhoc);
                SalaryCompLineL.SetRange("Employee No.", "No.");
                if SalaryCompLineL.FindSet() then
                    repeat
                        VarPayG += SalaryCompLineL.Amount;
                    until SalaryCompLineL.Next() = 0;
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

    }

    var
        PayCycleLineG: Record "Pay Period Line";
        CompInfoG: Record "Company Information";
        EmpBankAccDettailsG: Record "Employee Bank Account Detail";
        EmpEarningHistoryG: Record "Employee Earning History";
        HRSetupG: Record "Human Resources Setup";
        SalaryClassG: Text;
        PayPeriodG: Text;
        PersonalNoG: Text;
        FixedPayG: Decimal;
        VarPayG: Decimal;
        PayStartDateG: Date;
        PayEndDateG: Date;
        NoOfDaysG: Integer;
        SlNoG: Integer;

}