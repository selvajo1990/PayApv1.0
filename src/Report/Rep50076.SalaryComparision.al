report 50076 "Salary Comparision"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    RDLCLayout = './res/SalaryComparision.rdl';

    dataset
    {
        dataitem(Employee; Employee)
        {
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
            column(FilterReport; FilterReport)
            {

            }
            column(SI; SI)
            { }
            column(No; "No.")
            {

            }
            column(FullName; FullName())
            {

            }
            column(PayPeriod; PayPeriod)
            {

            }
            column(CurMonthNetSalary; CurMonthNetSalary)
            {

            }
            column(PrevMonthNetSalary; PrevMonthNetSalary)
            {

            }
            column(DifferenceAmt; DifferenceAmt)
            {

            }
            trigger OnPreDataItem()
            begin
                SetRange("Salary Class", SalaryClassG);

                PayCycleLine2.SetRange("Pay Cycle", PayCycleG);
                PayCycleLine2.SetRange("Period Start Date", CALCDATE('<-1M>', PayCycleLineG."Period Start Date"));
                PayCycleLine2.SetRange("Period End Date", CALCDATE('<-1D>', PayCycleLineG."Period Start Date"));
                PayCycleLine2.FindFirst();
                PrevPayPeriod := PayCycleLine2."Pay Period";
            end;

            trigger OnAfterGetRecord()
            var
                Counter: Integer;
            begin
                CurMonthNetSalary := 0;
                PayPeriod := '';
                DifferenceAmt := 0;
                PrevMonthNetSalary := 0;
                SI += 1;

                for Counter := 1 to 2 do begin
                    if Counter = 1 then // Current Month
                        SalaryComputationLineC.SetRange("Pay Period", PayPeriodG)
                    else
                        SalaryComputationLineC.SetRange("Pay Period", PrevPayPeriod);
                    SalaryComputationLineC.SetRange("Salary Class", SalaryClassG);
                    SalaryComputationLineC.SetRange("Employee No.", Employee."No.");
                    SalaryComputationLineC.SetRange("Show in Payslip", true);
                    SalaryComputationLineC.CalcSums(Amount);
                    if Counter = 1 then // Current Month
                        CurMonthNetSalary := SalaryComputationLineC.Amount
                    else
                        PrevMonthNetSalary := SalaryComputationLineC.Amount;
                end;

                DifferenceAmt := CurMonthNetSalary - PrevMonthNetSalary;
                FilterReport := ' Salary Comparision for ' + fORMAT(PayPeriodG) + ' and ' + fORMAT(PrevPayPeriod);
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group("Salary Comparision Filter")
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
                }
            }
        }
    }
    trigger OnPreReport()
    begin
        SI := 0;
        CompanyInformationG.get();
        CompanyInformationG.CalcFields(Picture);
        if PayPeriodG = '' then
            Error(PayFilterErr);
    end;

    var
        SalaryComputationLineC: record "Salary Computation Line";
        PayCycleLineG: Record "Pay Period Line";
        PayCycleLine2: Record "Pay Period Line";
        CompanyInformationG: Record "Company Information";
        PayFilterErr: Label 'Pay Period should not be blank';

        SalaryClassG: Code[20];
        PayPeriodG: Code[30];

        PrevPayPeriod: Code[30];

        PayCycleG: Code[20];
        PrevMonthNetSalary: Decimal;
        DifferenceAmt: Decimal;
        CurMonthNetSalary: Decimal;
        PayPeriod: Text;
        FilterReport: Text;
        SI: Integer;

}