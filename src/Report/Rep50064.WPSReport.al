report 50064 "WPS Report"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    ProcessingOnly = true;

    dataset
    {
        dataitem(Employee; Employee)
        {
            trigger OnPreDataItem()
            begin
                LineNoG := 0;
                TotalNetPayG := 0;
                CSVBufferG.DeleteAll();
                GLSetupG.Get();
                HRSetupG.Get();
                HRSetupG.TestField("Bank Account");
                HRSetupG.TestField("Company ID");
                SetRange("Sponsor Type", SponsorTypeG);
                SetRange("Payment Type", PaymentTypeG);
            end;

            trigger OnAfterGetRecord()
            var
                SalaryComputationLineL: Record "Salary Computation Line";
            begin
                EmployeeBankAccountDetailG.SetRange("Employee No.", Employee."No.");
                EmployeeBankAccountDetailG.SetRange(Primary, true);
                if not EmployeeBankAccountDetailG.FindFirst() then
                    CurrReport.Skip();
                SalaryComputationLineL.SetRange("Employee No.", Employee."No.");
                SalaryComputationLineL.SetRange("Pay Period", PayPeriodLineG."Pay Period");
                SalaryComputationLineL.SetRange("Affects Salary", true);
                if not SalaryComputationLineL.FindFirst() then
                    CurrReport.Skip();
                SalaryComputationLineL.CalcSums(Amount);
                TotalNetPayG += SalaryComputationLineL.Amount;
                InsertIntoBuffer('EDM',
                    Employee."MOL ID",
                    BankAccountIdG,
                    EmployeeBankAccountDetailG."IBAN No.",
                    Format(PayPeriodLineG."Period Start Date", 0, '<Year4>-<Month,2>-<Day,2>'),
                    Format(PayPeriodLineG."Period End Date", 0, '<Year4>-<Month,2>-<Day,2>'),
                    format(PayPeriodLineG."Period End Date" - PayPeriodLineG."Period Start Date" + 1, 0, 1),
                    format(0),
                    format(SalaryComputationLineL.Amount, 0, 1),
                    format(0));
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group("WPS Filters")
                {
                    field("Sponsor Type"; SponsorTypeG)
                    {
                        ApplicationArea = All;
                        TableRelation = "Sponsor Type";
                        ToolTip = 'Specifies the value of the SponsorTypeG';
                    }
                    field("Payment Type"; PaymentTypeG)
                    {
                        ApplicationArea = all;
                        TableRelation = "Payment Type";
                        ToolTip = 'Specifies the value of the PaymentTypeG';
                    }
                    field("Bank Account ID"; BankAccountIdG)
                    {
                        ApplicationArea = all;
                        TableRelation = "Employee Bank Account Master";
                        ToolTip = 'Specifies the value of the BankAccountIdG';
                    }
                    field("Pay Cycle"; PayCycleG)
                    {
                        ApplicationArea = all;
                        TableRelation = "Pay Cycle";
                        ToolTip = 'Specifies the value of the PayCycleG';
                    }
                    field("Pay Period"; PayPeriodG)
                    {
                        ApplicationArea = all;
                        TableRelation = "Pay Period Line";
                        ToolTip = 'Specifies the value of the PayPeriodG';
                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            PayPeriodLineG.SetCurrentKey("Period Start Date");
                            PayPeriodLineG.SetRange("Pay Cycle", PayCycleG);
                            if page.RunModal(0, PayPeriodLineG) = Action::LookupOK then
                                PayPeriodG := PayPeriodLineG."Pay Period";
                        end;

                        trigger OnValidate()
                        begin
                            PayPeriodLineG.SetRange("Pay Cycle", PayCycleG);
                            PayPeriodLineG.SetRange("Pay Period", PayPeriodG);
                            PayPeriodLineG.FindFirst();
                        end;
                    }
                }
            }
        }
    }

    var
        PayPeriodLineG: Record "Pay Period Line";
        CSVBufferG: Record "CSV Buffer" temporary;
        EmployeeBankAccountDetailG: Record "Employee Bank Account Detail";
        GLSetupG: Record "General Ledger Setup";
        HRSetupG: Record "Human Resources Setup";
        TempBlobG: Codeunit "Temp Blob";
        FileManagementG: Codeunit "File Management";
        SponsorTypeG: Code[20];
        PaymentTypeG: Code[20];
        BankAccountIdG: Code[20];
        PayPeriodG: Code[20];
        PayCycleG: Code[20];
        LineNoG: Integer;
        TotalNetPayG: Decimal;

    trigger OnPostReport()
    begin
        HRSetupG.CalcFields("Bank Name");
        InsertIntoBuffer('SCR',
                    HRSetupG."Company ID",
                    HRSetupG."Bank Account",
                    Format(Today(), 0, '<Day,2>-<Month,2>-<Year4>'),
                    Format(Time(), 0, '<Hours24,2><Minutes,2>'),
                    format(PayPeriodLineG."Period End Date", 0, '<month,2><Year4>'),
                    Format(LineNoG / 10000, 0, 1),
                    Format(TotalNetPayG, 0, 1),
                    GLSetupG."LCY Code",
                    Format(0));

        CSVBufferG.SaveDataToBlob(TempBlobG, ',');
        FileManagementG.BLOBExport(TempBlobG, 'WPS-' + PayPeriodLineG."Pay Period" + '.csv', true);
    end;

    local procedure InsertIntoBuffer(TypeP: Text[250]; IdP: Text[250]; BankIdP: Text[250]; BankDescP: Text[250]; StartP: Text[250]; EndP: Text[250]; CountP: Text[250]; BasicP: Text[250]; NetPayP: Text[250]; LeaveDaysP: Text[250])
    var
        FiledNoL: Integer;
    begin
        LineNoG += 10000;
        FiledNoL := 0;
        repeat
            FiledNoL += 1;
            case FiledNoL of
                1:
                    CSVBufferG.InsertEntry(LineNoG, FiledNoL, TypeP);
                2:
                    CSVBufferG.InsertEntry(LineNoG, FiledNoL, IdP);
                3:
                    CSVBufferG.InsertEntry(LineNoG, FiledNoL, BankIdP);
                4:
                    CSVBufferG.InsertEntry(LineNoG, FiledNoL, BankDescP);
                5:
                    CSVBufferG.InsertEntry(LineNoG, FiledNoL, StartP);
                6:
                    CSVBufferG.InsertEntry(LineNoG, FiledNoL, EndP);
                7:
                    CSVBufferG.InsertEntry(LineNoG, FiledNoL, CountP);
                8:
                    CSVBufferG.InsertEntry(LineNoG, FiledNoL, BasicP);
                9:
                    CSVBufferG.InsertEntry(LineNoG, FiledNoL, NetPayP);
                10:
                    CSVBufferG.InsertEntry(LineNoG, FiledNoL, LeaveDaysP);
            end;
        until FiledNoL = 10;
    end;
}