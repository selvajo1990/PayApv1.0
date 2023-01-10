table 50038 "Loan Request"
{
    DataClassification = CustomerContent;
    Caption = 'Loan Request';
    LookupPageId = "Loan Request List";

    fields
    {
        field(1; "Loan Request No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Loan Request No.';
            trigger OnValidate()
            begin
                ValidateHeaderInfo();
            end;
        }
        field(2; "Employee No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Employee No.';
            TableRelation = Employee;
            trigger OnValidate()
            var
                EmployeeL: Record Employee;
            begin
                ValidateHeaderInfo();
                if EmployeeL.Get("Employee No.") then
                    "Employee Name" := EmployeeL.FullName()
                else
                    "Employee Name" := '';
            end;
        }
        field(3; "Loan Type"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Loan Type';
            TableRelation = Loan;
            trigger OnValidate()
            var
                LoanL: Record Loan;
                EmplEarnHistoryL: Record "Employee Earning History";
                EmpLevelEarningsL: Record "Employee Level Earning";
                EmployeeL: Record Employee;
                LoanRequestL: Record "Loan Request";
                LoanL1: Record Loan;
                Installment: Record "Instalment Detail";
            begin
                Installment.SetRange("Loan Request No.", "Loan Request No.");
                Installment.DeleteAll();
                TestField("Requested date");
                TestField("Deduction Start Date");
                ValidateHeaderInfo();
                EmployeeL.Get("Employee No.");
                TestField("Requested date");
                Amount := 0;
                "No. of Instalment" := 0;
                "Instalment Amount" := 0;
                "Loan Description" := '';
                "End of Service" := false;
                "No. of Instalment" := 0;
                IsPayPeriodClosed("Requested date", "Employee No.", '');
                if LoanL.Get("Loan Type") then begin
                    "End of Service" := LoanL."End of Service";
                    "Loan Description" := LoanL."Loan Description";
                    if (CalcDate(LoanL."Minimum Tenure Formula", EmployeeL."Employment Date") - 1) >= "Requested date" then
                        Error('You can not apply %1 Loan before %2 of Joining.', LoanL."Loan Description", LoanL."Minimum Tenure Formula");
                    if not LoanL."Allow in Notice Period" then
                        if EmployeeL."Notice Period Start Date" <> 0D then
                            if EmployeeL."Notice Period Start Date" <= "Requested date" then
                                Error('You can not apply %1 Loan in Notice Period', LoanL."Loan Description");

                    LoanRequestL.Reset();
                    LoanRequestL.SetRange("Employee No.", "Employee No.");
                    if LoanRequestL.FindSet() then
                        repeat
                            if CheckPaidInstalmentLine(LoanRequestL."Loan Request No.") then begin
                                if LoanRequestL."Loan Type" = "Loan Type" then
                                    if Not LoanL."Allow Multiple Time" then
                                        Error('Same type of loan is already Exists')
                                    else
                                        if "Requested date" <= (CalcDate(LoanL."Minimum Days Between Request", LoanRequestL."Requested date") - 1) then
                                            Error('You can not apply same loan without completing %1 Days Between Request', DelChr(Format(LoanL."Minimum Days Between Request"), '=', 'D'));
                                if LoanL1.Get(LoanRequestL."Loan Type") then
                                    If not LoanL1."Allow Multiple Loan" then
                                        Error('You can not apply multiple Loans');
                            end;
                        until LoanRequestL.Next() = 0;

                    if LoanL."Computation Basis" = LoanL."Computation Basis"::Amount then begin
                        Amount := LoanL.Amount;
                        if LoanL."End of Service" then
                            exit;
                        Validate("No. of Instalment", LoanL."No. of Instalment");
                    end else begin
                        if LoanL."End of Service" then
                            exit;
                        if LoanL."Computation Basis" = LoanL."Computation Basis"::Percentage then begin
                            EmplEarnHistoryL.Reset();
                            EmplEarnHistoryL.SetRange("Component Type", EmplEarnHistoryL."Component Type"::Earning);
                            EmplEarnHistoryL.SetRange("Employee No.", "Employee No.");
                            EmplEarnHistoryL.SetFilter("From Date", '<=%1', "Requested date");
                            EmplEarnHistoryL.SetFilter("To Date", '>=%1', "Requested date");
                            if EmplEarnHistoryL.FindFirst() then begin
                                EmpLevelEarningsL.Reset();
                                EmpLevelEarningsL.SetRange("Employee No.", "Employee No.");
                                EmpLevelEarningsL.SetRange("Group Code", EmplEarnHistoryL."Group Code");
                                EmpLevelEarningsL.SetRange("From Date", EmplEarnHistoryL."From Date");
                                EmpLevelEarningsL.SetRange("Earning Code", LoanL."Earning Code");
                                if EmpLevelEarningsL.FindFirst() then begin
                                    Amount := ((EmpLevelEarningsL."Pay Amount") * LoanL.Percentage) / 100;
                                    Validate("No. of Instalment", LoanL."No. of Instalment");
                                end;
                            end;

                        end;
                    end;
                end;

            end;
        }

        field(4; "Requested date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Requested Date';
            trigger OnValidate()
            var
                EmployeeL: Record Employee;
            begin
                if ("Requested date" <> xRec."Requested date") and ("Requested date" > 0D) then
                    IsPayPeriodClosed("Requested date", "Employee No.", '');
                TestField("Employee No.");
                if EmployeeL.Get("Employee No.") then
                    If EmployeeL."Employment Date" > "Requested date" then
                        Error('Requested Date can not be earlier then the Employment Date');
                if "Deduction Start Date" <> 0D then
                    Validate("Deduction Start Date");
                if "Loan Type" <> '' then
                    Validate("Loan Type");
                ValidateHeaderInfo();
            end;
        }
        field(5; "Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Amount';
            trigger OnValidate()
            begin
                ValidateHeaderInfo();
                TestField("Requested date");
                IsPayPeriodClosed("Requested date", "Employee No.", '');
                if "No. of Instalment" > 0 then
                    Validate("No. of Instalment");
            end;
        }
        field(6; "No. of Instalment"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'No. of Instalment';
            MinValue = 0;
            trigger OnValidate()
            var
                HrSetupL: Record "Human Resources Setup";
                InstalmentDetailL: Record "Instalment Detail";
                InvalidAmountErr: Label '%1 should have value';
                LineExistQst: Label 'Exisitng instalment lines will recreated. Do you want to continue ?';
                DeleteLinesErr: Label 'Instalment lines & field values will be removed. Do you want to continue ?';
                CounterL: Integer;
                LineNoL: Decimal;
                FutureDeductionDateL: Date;
            begin
                if Amount <= 0 then
                    Error(InvalidAmountErr, Rec.FieldCaption(Amount));

                if "No. of Instalment" = 0 then
                    if Confirm(DeleteLinesErr, false) then begin
                        DeleteInstalment("Loan Request No.");
                        "Deduction Start Date" := 0D;
                        "Instalment Amount" := 0;
                        Amount := 0;
                        exit;
                    end else begin
                        "No. of Instalment" := xRec."No. of Instalment";
                        exit;
                    end;

                ValidateHeaderInfo();

                if not CheckInstalmentLine() then
                    if not Confirm(LineExistQst, false) then begin
                        "No. of Instalment" := xRec."No. of Instalment";
                        exit;
                    end;

                DeleteInstalment("Loan Request No.");

                rec.TestField("Deduction Start Date");
                HrSetupL.Get();
                HrSetupL.TestField("HR Rounding Precision");
                "Instalment Amount" := Round(Amount / "No. of Instalment", HrSetupL."HR Rounding Precision", HrSetupL.RoundingDirection());
                FutureDeductionDateL := "Deduction Start Date";
                for CounterL := 1 to "No. of Instalment" do begin
                    LineNoL += 10000;
                    InstalmentDetailL.Reset();
                    InstalmentDetailL."Loan Request No." := Rec."Loan Request No.";
                    InstalmentDetailL."Line No." := LineNoL;
                    InstalmentDetailL."Deduction Amount" := "Instalment Amount";
                    FutureDeductionDateL := CalcDate('<CM>', FutureDeductionDateL);
                    InstalmentDetailL."Deduction Date" := FutureDeductionDateL;
                    InstalmentDetailL.Status := InstalmentDetailL.Status::Unpaid;
                    InstalmentDetailL.Insert(true);
                    FutureDeductionDateL := CalcDate('<1D>', FutureDeductionDateL);
                end;
            end;
        }
        field(7; "Instalment Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Instalment Amount';
            MinValue = 0;
            Editable = false;
        }

        field(8; "Deduction Start Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Deduction Start Date';
            trigger OnValidate()
            begin
                TestField("Requested date");
                if "Requested date" > "Deduction Start Date" then
                    Error('Deduction Start Date should not be earlier than the Requested Date');
                if "Loan Type" <> '' then
                    Validate("Loan Type");
            end;
        }
        field(9; "Notes"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Notes';
        }
        field(14; "Include in Salary"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Include in Salary';
        }
        field(15; "Employee Name"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Employee Name';
        }
        field(16; "Loan Description"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Loan Description';
        }
        field(17; "End of Service"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'End of Service';
        }
    }

    keys
    {
        key(PK; "Loan Request No.")
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
        IF "Loan Request No." = '' THEN BEGIN
            HrSetupG.Get();
            HrSetupG.TESTFIELD("Loan Request Nos.");
            NoSeriesMgtG.InitSeries(HrSetupG."Loan Request Nos.", '', 0D, "Loan Request No.", NoSeriesG);
        END;
    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin
        if not CheckPaidInstalmentLine("Loan Request No.") then
            Error('You can not Delete with Paid Instalment Lines');
        DeleteInstalment("Loan Request No.");
    end;

    trigger OnRename()
    begin

    end;

    procedure CheckPaidInstalmentLine(LoanRequestNo: Code[20]): Boolean
    var
        InstalmentDetailL: Record "Instalment Detail";
    begin
        InstalmentDetailL.SetRange("Loan Request No.", LoanRequestNo);
        InstalmentDetailL.SetRange(Status, InstalmentDetailL.Status::Paid);
        exit(InstalmentDetailL.IsEmpty());
    end;

    local procedure CheckInstalmentLine(): Boolean
    var
        InstalmentDetailL: Record "Instalment Detail";
    begin
        InstalmentDetailL.SetRange("Loan Request No.", Rec."Loan Request No.");
        exit(InstalmentDetailL.IsEmpty());
    end;

    procedure ValidateHeaderInfo()
    var
        ModifyNotAllowedErr: Label 'You are not allowed to modify once the instalment is paid';
    begin
        if not CheckPaidInstalmentLine(Rec."Loan Request No.") then
            Error(ModifyNotAllowedErr);
    end;

    procedure AssisEdit(): Boolean
    begin
        HrSetupG.Get();
        HrSetupG.TESTFIELD("Loan Request Nos.");
        IF NoSeriesMgtG.SelectSeries(HrSetupG."Loan Request Nos.", '', NoSeriesG) THEN BEGIN
            NoSeriesMgtG.SetSeries("Loan Request No.");
            EXIT(TRUE);
        END;
    end;

    procedure DeleteInstalment(LoanRequestNoP: Code[20])
    var
        InstalmentDetailL: Record "Instalment Detail";
    begin
        InstalmentDetailL.SetRange("Loan Request No.", Rec."Loan Request No.");
        InstalmentDetailL.DeleteAll();
    end;

    procedure IsPayPeriodClosed(DateP: Date; EmployeeNoP: code[20]; PayPeriodP: Code[30])
    var
        Employee: Record Employee;
        PayCycleLine: Record "Pay Period Line";
        PeriodClosedErr: Label 'Pay Period is closed for the month %1';
        InvalidPayPeriodErr: Label 'Invalid Pay Period';
    begin
        Employee.Get(EmployeeNoP);
        if PayPeriodP = '' then
            Employee.TestField("Pay Cycle")    // for all it will work 
        else
            Employee."Pay Cycle" := PayPeriodP;      // Once it will run at the time or Employee Creation 

        // check payperiod exist or not

        PayCycleLine.SetRange("Pay Cycle", Employee."Pay Cycle");
        PayCycleLine.SetFilter("Period Start Date", '<=%1', DateP);
        PayCycleLine.SetFilter("Period End Date", '>=%1', DateP);
        if PayCycleLine.IsEmpty() then
            Error(InvalidPayPeriodErr);

        PayCycleLine.SetRange(Status, PayCycleLine.Status::Closed);
        if PayCycleLine.FindFirst() then
            Error(StrSubstNo(PeriodClosedErr, PayCycleLine."Pay Period"));
    end;
}