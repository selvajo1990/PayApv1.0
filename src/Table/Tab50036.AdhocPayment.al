table 50036 "Adhoc Payment"
{
    DataClassification = CustomerContent;
    Caption = 'Adhoc Payment';
    LookupPageId = "Adhoc Payment";

    fields
    {
        field(1; "Adhoc No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Adhoc No.';
        }
        field(2; "Employee No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Employee No.';
            TableRelation = Employee;
        }
        field(3; "Employee Name"; Text[50])
        {
            Caption = 'Employee Name';
            FieldClass = FlowField;
            CalcFormula = lookup(Employee."First Name" where("No." = field("Employee No.")));
            Editable = false;
        }
        field(4; "Earning Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Earning Code';
            TableRelation = Earning.Code where(Type = filter(Adhoc));
            trigger OnValidate()
            var
                EarningL: Record Earning;
            begin
                if EarningL.Get("Earning Code") then;
                "Pay With Salary" := EarningL."Pay With Salary";
                Category := EarningL.Category;
                Type := EarningL.Type;
                "Earning Description" := EarningL.Description;
                "Affects Salary" := EarningL."Affects Salary";
                "Show in Payslip" := EarningL."Show in payslip";
            end;
        }
        field(5; "Adhoc Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Adhoc Date';
            trigger OnValidate()
            VAR
                PayPeriodLineL: record "Pay Period Line";
                PayPeriodDateErr: Label 'Pay Period has been closed, So you cannot pass any Adhoc payment in the month of %1';
            BEGIN
                PayPeriodLineL.Reset();
                PayPeriodLineL.Setfilter("Period Start Date", '<=%1', "Adhoc Date");
                PayPeriodLineL.SetFilter("Period End Date", '>=%1', "Adhoc Date");
                PayPeriodLineL.SetRange(Status, PayPeriodLineL.Status::Closed);
                if PayPeriodLineL.FindFirst() then
                    Error(PayPeriodDateErr, PayPeriodLineL."Pay Period");
            END;
        }
        field(6; "Adhoc Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Adhoc Amount';
            MinValue = 0;
        }
        field(7; Hours; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Hours';
            MinValue = 0;
            trigger OnValidate()
            var
                EarningL: record Earning;
                EmployeeEarningHistoryG: record "Employee Earning History";
                EmployeeLevelEarningG: record "Employee Level Earning";
                ComputationL: record Computation;
                Emp: Record Employee;
                PayCycleLineG: record "Pay Period Line";
                ComputationLineL: record "Computation Line Detail";
                EmployeeComputationValue: Decimal;
                PaymentTypeErr: Label 'Please select the payment type in Earning';
                NoofDaysinpaymonth: Integer;
            begin

                Emp.Get("Employee No.");
                PayCycleLineG.Reset();
                PayCycleLineG.SetRange("Pay Cycle", Emp."Pay Cycle");
                PayCycleLineG.SetFilter("Period Start Date", '<=%1', "Adhoc Date");
                PayCycleLineG.SetFilter("Period End Date", '>=%1', "Adhoc Date");
                if PayCycleLineG.FindFirst() then
                    NoofDaysinpaymonth := PayCycleLineG."Period End Date" - PayCycleLineG."Period Start Date" + 1;
                EmployeeComputationValue := 0;
                EarningL.Get("Earning Code");
                if EarningL.Type = EarningL.Type::Adhoc then
                    if EarningL.Hourly then
                        case EarningL."Payment Type" of

                            EarningL."Payment Type"::Percentage:
                                begin
                                    EmployeeEarningHistoryG.reset();
                                    EmployeeEarningHistoryG.SetRange("Employee No.", "Employee No.");
                                    EmployeeEarningHistoryG.setrange("Component Type", EmployeeEarningHistoryG."Component Type"::Earning);
                                    if EmployeeEarningHistoryG.FindLast() then begin
                                        EmployeeLevelEarningG.Reset();
                                        EmployeeLevelEarningG.setrange("Employee No.", "Employee No.");
                                        EmployeeLevelEarningG.SetRange("Group Code", EmployeeEarningHistoryG."Group Code");
                                        EmployeeLevelEarningG.setrange("to Date", EmployeeEarningHistoryG."To Date");
                                        EmployeeLevelEarningG.SetRange("Earning Code", EarningL."Base Code");
                                        if EmployeeLevelEarningG.FindFirst() then
                                            EmployeeComputationValue := (EmployeeLevelEarningG."Pay Amount" * EarningL."Pay Percentage") / 100;
                                    end;
                                end;
                            EarningL."Payment Type"::Computation:
                                begin
                                    EmployeeEarningHistoryG.reset();
                                    EmployeeEarningHistoryG.SetRange("Employee No.", "Employee No.");
                                    EmployeeEarningHistoryG.setrange("Component Type", EmployeeEarningHistoryG."Component Type"::Earning);
                                    if EmployeeEarningHistoryG.FindLast() then begin
                                        EmployeeLevelEarningG.Reset();
                                        EmployeeLevelEarningG.setrange("Employee No.", "Employee No.");
                                        EmployeeLevelEarningG.SetRange("Group Code", EmployeeEarningHistoryG."Group Code");
                                        EmployeeLevelEarningG.setrange("to Date", EmployeeEarningHistoryG."To Date");
                                        if EmployeeLevelEarningG.FindSet() then
                                            repeat
                                                //Employee Computation calculation
                                                ComputationL.get(EarningL."Computation Code");
                                                ComputationLineL.Reset();
                                                ComputationLineL.SetRange("Computation Code", ComputationL."Computation Code");
                                                ComputationLineL.SetRange("Earning Code", EmployeeLevelEarningG."Earning Code");
                                                if ComputationLineL.FindFirst() then
                                                    EmployeeComputationValue += (EmployeeLevelEarningG."Pay Amount" * ComputationLineL.Percentage) / 100;
                                            until EmployeeLevelEarningG.Next() = 0;
                                    end;
                                end;
                            EarningL."Payment Type"::Amount:
                                EmployeeComputationValue := EarningL."Pay Amount";
                            else
                                Error(PaymentTypeErr);
                        end;
                HrSetupG.Get();
                HrSetupG.TestField("Working Hours");
                "Adhoc Amount" := (EmployeeComputationValue / NoofDaysinpaymonth) / (HrSetupG."Working Hours" / 3600000) * Hours;
            end;
        }
        field(8; Amount; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Amount';
            MinValue = 0;
        }
        field(9; "Pay With Salary"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Pay With Salary';
        }
        field(10; Category; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = " ","Earning","Deduction";
            OptionCaption = ' ,Earning,Deduction';
            Caption = 'Category';
        }
        field(11; Type; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = " ","Constant","Adhoc","Employer Contribution";
            OptionCaption = ' ,Constant,Adhoc,Employer Contribution';
            Caption = 'Type';
        }
        field(12; "Earning Description"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Earning Description';
        }
        field(13; "Affects Salary"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Affects Salary';
        }
        field(14; "Show in Payslip"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Show in Payslip';
        }
    }

    keys
    {
        key(PK; "Adhoc No.")
        {
            Clustered = true;
        }
    }

    var
        HrSetupG: Record "Human Resources Setup";
        NoSeriesMgtG: Codeunit NoSeriesManagement;
        NoSeriesG: Code[20];

    trigger OnInsert()
    begin
        IF "Adhoc No." = '' THEN BEGIN
            HrSetupG.Get();
            HrSetupG.TESTFIELD("Adhoc Payment Nos.");
            NoSeriesMgtG.InitSeries(HrSetupG."Adhoc Payment Nos.", '', 0D, "Adhoc No.", NoSeriesG);
        END;
    end;

    trigger OnModify()
    begin

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
        HrSetupG.TESTFIELD("Adhoc Payment Nos.");
        IF NoSeriesMgtG.SelectSeries(HrSetupG."Adhoc Payment Nos.", '', NoSeriesG) THEN BEGIN
            NoSeriesMgtG.SetSeries("Adhoc No.");
            EXIT(TRUE);
        END;
    end;

}