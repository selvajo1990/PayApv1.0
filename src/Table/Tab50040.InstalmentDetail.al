table 50040 "Instalment Detail"
{
    DataClassification = CustomerContent;
    Caption = 'Instalment Detail';
    fields
    {
        field(1; "Loan Request No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Loan Request No.';
        }
        field(2; "Line No."; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Line No.';
        }
        field(21; "Deduction Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Deduction Amount';
            MinValue = 0;
            trigger OnValidate()
            begin
                UpdateDeductionAmount(xRec."Deduction Amount" - "Deduction Amount");
            end;
        }
        field(22; "Deduction Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Deduction Date';
            Editable = false;
        }
        field(23; Status; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = " ","Paid","Unpaid";
            OptionCaption = ' ,Paid,Unpaid';
            Caption = 'Status';
            Editable = false;
        }
        field(24; "From Deduction Date"; Date)
        {
            DataClassification = CustomerContent;
            Description = 'For Filter Page - For Developer use';
            Editable = false;
        }
        field(25; "No. of Month"; Decimal)
        {
            DataClassification = CustomerContent;
            Description = 'For Filter Page - For Developer use';
            Editable = false;
        }
        field(26; "EMI Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Description = 'For Filter Page - For Developer use';
            Editable = false;
        }
    }

    keys
    {
        key(PK; "Loan Request No.", "Line No.")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin

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

    var
        PendingLoanErr: Label 'There is no Unpaid loan lines in the given detection date';
        PaidLoanErr: Label 'There is no paid lines. You can recalulate the loan for any correction';
        MandatoryErr: Label '%1 must have value';

    local procedure UpdateDeductionAmount(DifferenceAmountP: Decimal)
    var
        HrSetupL: Record "Human Resources Setup";
        InstalmentDetailL: Record "Instalment Detail";
        LoanRequestL: Record "Loan Request";
        CalculatedAmountL: Decimal;
        PendingLineL: Integer;
        AmountDifferenceErr: Label '%1 cannot be greater than Total Amount';
    begin
        LoanRequestL.Get(Rec."Loan Request No.");
        if DifferenceAmountP > LoanRequestL.Amount then
            Error(AmountDifferenceErr, Rec.FieldCaption("Deduction Amount"));

        PendingLineL := FindPendingLoanLines();
        if PendingLineL = 0 then
            Error('You cannot modify last instalment'); // Check with func

        HrSetupL.Get();
        HrSetupL.TestField("HR Rounding Precision");
        CalculatedAmountL := Round(DifferenceAmountP / PendingLineL, HrSetupL."HR Rounding Precision", HrSetupL.RoundingDirection());
        InstalmentDetailL.SetCurrentKey("Loan Request No.", "Deduction Date");
        InstalmentDetailL.SetRange("Loan Request No.", Rec."Loan Request No.");
        InstalmentDetailL.SetFilter("Deduction Date", '>%1', Rec."Deduction Date");
        if InstalmentDetailL.FindSet() then
            repeat
                InstalmentDetailL."Deduction Amount" := InstalmentDetailL."Deduction Amount" + CalculatedAmountL;
                InstalmentDetailL.Modify(true);
            until InstalmentDetailL.Next() = 0;

    end;

    local procedure FindPendingLoanLines(): Integer
    var
        InstalmentDetailL: Record "Instalment Detail";
    begin
        InstalmentDetailL.SetCurrentKey("Loan Request No.", "Deduction Date");
        InstalmentDetailL.SetRange("Loan Request No.", Rec."Loan Request No.");
        InstalmentDetailL.SetFilter("Deduction Date", '>%1', Rec."Deduction Date");
        exit(InstalmentDetailL.Count());
    end;

    procedure ShiftPayment()
    var
        TempInstalmentDetailL: Record "Instalment Detail" temporary;
        InstalmentDetailL: Record "Instalment Detail";
        InstalmentDetailL2: Record "Instalment Detail";
        InstalmentDetailL3: Record "Instalment Detail";
        InstalmentDetailL4: Record "Instalment Detail";
        PageFilterL: FilterPageBuilder;
        Counter: Integer;
        LastLineNo: Integer;
        FutureDeductionDateL: Date;
        ShiftFilterTxt: Label 'Shift Payment';
    begin
        Rec.TestField(Status, Rec.Status::Unpaid);
        InstalmentDetailL4.Reset();
        InstalmentDetailL4.SetRange("Loan Request No.", Rec."Loan Request No.");
        InstalmentDetailL4.SetRange(Status, InstalmentDetailL4.Status::Paid);
        if InstalmentDetailL4.IsEmpty() then
            Error(PaidLoanErr);

        InstalmentDetailL.SetRange("From Deduction Date", Rec."Deduction Date");
        PageFilterL.AddRecord(ShiftFilterTxt, InstalmentDetailL);
        PageFilterL.AddField(ShiftFilterTxt, InstalmentDetailL."From Deduction Date");
        PageFilterL.AddField(ShiftFilterTxt, InstalmentDetailL."No. of Month");
        PageFilterL.SetView(ShiftFilterTxt, InstalmentDetailL.GetView());
        if PageFilterL.RunModal() then begin
            InstalmentDetailL.SetView(PageFilterL.GETVIEW(ShiftFilterTxt));
            case true of
                InstalmentDetailL.GetFilter("From Deduction Date") = '':
                    Error(StrSubstNo(MandatoryErr, InstalmentDetailL.FieldCaption("From Deduction Date")));
                InstalmentDetailL.GetFilter("No. of Month") = '':
                    Error(StrSubstNo(MandatoryErr, InstalmentDetailL.FieldCaption("No. of Month")));
            end;

            Evaluate(InstalmentDetailL."No. of Month", InstalmentDetailL.GetFilter("No. of Month"));
            Evaluate(InstalmentDetailL."Deduction Date", InstalmentDetailL.GetFilter("From Deduction Date"));

            InstalmentDetailL2.SetCurrentKey("Loan Request No.", Status, "Deduction Date");
            InstalmentDetailL2.SetRange("Loan Request No.", Rec."Loan Request No.");
            InstalmentDetailL2.SetRange(Status, InstalmentDetailL2.Status::Unpaid);
            InstalmentDetailL2.SetRange("Deduction Date", InstalmentDetailL.GetRangeMin("From Deduction Date"));
            if InstalmentDetailL2.IsEmpty() then
                Error(PendingLoanErr);

            TempInstalmentDetailL.DeleteAll();
            InstalmentDetailL2.SetFilter("Deduction Date", '>=%1', InstalmentDetailL.GetRangeMin("From Deduction Date"));

            if InstalmentDetailL2.FindSet() then
                repeat
                    TempInstalmentDetailL := InstalmentDetailL2;
                    TempInstalmentDetailL.Insert();
                    LastLineNo := InstalmentDetailL2."Line No.";
                until InstalmentDetailL2.Next() = 0;
            InstalmentDetailL2.DeleteAll();

            FutureDeductionDateL := InstalmentDetailL."Deduction Date";
            for Counter := 1 to abs(InstalmentDetailL."No. of Month") do begin // Inserting Empty shifting line
                LastLineNo += 10000;
                InstalmentDetailL3.Init();
                InstalmentDetailL3."Loan Request No." := Rec."Loan Request No.";
                InstalmentDetailL3."Line No." := LastLineNo;
                FutureDeductionDateL := CalcDate('<CM>', FutureDeductionDateL);
                InstalmentDetailL3."Deduction Date" := FutureDeductionDateL;
                InstalmentDetailL3.Status := InstalmentDetailL3.Status::" ";
                InstalmentDetailL3.Insert(true);
                FutureDeductionDateL := CalcDate('<1D>', FutureDeductionDateL);
            end;

            TempInstalmentDetailL.FindSet();
            repeat
                LastLineNo += 10000;
                InstalmentDetailL3.Init();
                InstalmentDetailL3."Loan Request No." := Rec."Loan Request No.";
                InstalmentDetailL3."Line No." := LastLineNo;
                InstalmentDetailL3."Deduction Amount" := TempInstalmentDetailL."Deduction Amount";
                FutureDeductionDateL := CalcDate('<CM>', FutureDeductionDateL);
                InstalmentDetailL3."Deduction Date" := FutureDeductionDateL;
                InstalmentDetailL3.Status := TempInstalmentDetailL.Status::Unpaid;
                InstalmentDetailL3.Insert(true);
                FutureDeductionDateL := CalcDate('<1D>', FutureDeductionDateL);
            until TempInstalmentDetailL.Next() = 0;
        end;
    end;

    procedure ChangeEmiAmount()
    var
        InstalmentDetailL: Record "Instalment Detail";
        InstalmentDetailL2: Record "Instalment Detail";
        InstalmentDetailL3: Record "Instalment Detail";
        LoanRequest: Record "Loan Request";
        PageFilterL: FilterPageBuilder;
        Counter: Integer;
        LastLineNo: Integer;
        LeftSide: Integer;
        FutureDeductionDateL: Date;
        PaidAmount: Decimal;
        UnPaidAmount: Decimal;
        NoOfInstalment: Decimal;
        RightSide: Decimal;

        EMIFilterTxt: Label 'Change EMI Amount';
        InvaildEmiAmountErr: Label 'EMI Amount can''t be greater than pending loan';
    begin
        Rec.TestField(Status, Rec.Status::Unpaid);
        InstalmentDetailL2.Reset();
        InstalmentDetailL2.SetRange("Loan Request No.", Rec."Loan Request No.");
        InstalmentDetailL2.SetRange(Status, InstalmentDetailL2.Status::Paid);
        if InstalmentDetailL2.IsEmpty() then
            Error(PaidLoanErr);

        InstalmentDetailL.SetRange("From Deduction Date", Rec."Deduction Date");
        PageFilterL.AddRecord(EMIFilterTxt, InstalmentDetailL);
        PageFilterL.AddField(EMIFilterTxt, InstalmentDetailL."From Deduction Date");
        PageFilterL.AddField(EMIFilterTxt, InstalmentDetailL."EMI Amount");
        PageFilterL.SetView(EMIFilterTxt, InstalmentDetailL.GetView());
        if PageFilterL.RunModal() then begin
            InstalmentDetailL.SetView(PageFilterL.GETVIEW(EMIFilterTxt));
            case true of
                InstalmentDetailL.GetFilter("From Deduction Date") = '':
                    Error(StrSubstNo(MandatoryErr, InstalmentDetailL.FieldCaption("From Deduction Date")));
                InstalmentDetailL.GetFilter("EMI Amount") = '':
                    Error(StrSubstNo(MandatoryErr, InstalmentDetailL.FieldCaption("EMI Amount")));
            end;

            Evaluate(InstalmentDetailL."EMI Amount", InstalmentDetailL.GetFilter("EMI Amount"));
            Evaluate(InstalmentDetailL."Deduction Date", InstalmentDetailL.GetFilter("From Deduction Date"));
            InstalmentDetailL."EMI Amount" := Abs(InstalmentDetailL."EMI Amount");

            InstalmentDetailL2.Reset();
            InstalmentDetailL2.SetRange("Loan Request No.", "Loan Request No.");
            if InstalmentDetailL2.FindLast() then
                LastLineNo := InstalmentDetailL2."Line No." + 10000;

            InstalmentDetailL2.Reset();
            InstalmentDetailL2.SetCurrentKey("Loan Request No.", Status, "Deduction Date");
            InstalmentDetailL2.SetRange("Loan Request No.", Rec."Loan Request No.");
            InstalmentDetailL2.SetRange(Status, InstalmentDetailL2.Status::Unpaid);
            InstalmentDetailL2.SetRange("Deduction Date", InstalmentDetailL.GetRangeMin("From Deduction Date"));
            if InstalmentDetailL2.IsEmpty() then
                Error(PendingLoanErr);

            InstalmentDetailL2.SetFilter("Deduction Date", '>=%1', InstalmentDetailL.GetRangeMin("From Deduction Date"));
            InstalmentDetailL2.DeleteAll();

            InstalmentDetailL2.SetRange("Deduction Date");
            InstalmentDetailL2.SetRange(Status, InstalmentDetailL2.Status::Paid);
            InstalmentDetailL2.CalcSums("Deduction Amount");

            PaidAmount := InstalmentDetailL2."Deduction Amount";

            InstalmentDetailL2.SetRange(Status, InstalmentDetailL2.Status::Unpaid);
            InstalmentDetailL2.SetFilter("Deduction Date", '<%1', InstalmentDetailL."Deduction Date");
            InstalmentDetailL2.CalcSums("Deduction Amount");

            UnPaidAmount := InstalmentDetailL2."Deduction Amount";

            LoanRequest.Get("Loan Request No.");
            LoanRequest.TestField(Amount);
            NoOfInstalment := (LoanRequest.Amount - (PaidAmount + UnPaidAmount)) / InstalmentDetailL."EMI Amount";
            if (InstalmentDetailL."EMI Amount") > (LoanRequest.Amount - (PaidAmount + UnPaidAmount)) then
                Error(InvaildEmiAmountErr);
            LeftSide := NoOfInstalment div 1;
            RightSide := NoOfInstalment mod 1;

            FutureDeductionDateL := InstalmentDetailL."Deduction Date";
            for Counter := 1 to LeftSide do begin // Inserting shifting line
                LastLineNo += 10000;
                InstalmentDetailL3.Init();
                InstalmentDetailL3."Loan Request No." := Rec."Loan Request No.";
                InstalmentDetailL3."Line No." := LastLineNo;
                FutureDeductionDateL := CalcDate('<CM>', FutureDeductionDateL);
                InstalmentDetailL3."Deduction Amount" := InstalmentDetailL."EMI Amount";
                InstalmentDetailL3."Deduction Date" := FutureDeductionDateL;
                InstalmentDetailL3.Status := InstalmentDetailL3.Status::Unpaid;
                InstalmentDetailL3.Insert(true);
                FutureDeductionDateL := CalcDate('<1D>', FutureDeductionDateL);
            end;
            if RightSide > 0 then begin
                LastLineNo += 10000;
                InstalmentDetailL3.Init();
                InstalmentDetailL3."Loan Request No." := Rec."Loan Request No.";
                InstalmentDetailL3."Line No." := LastLineNo;
                FutureDeductionDateL := CalcDate('<CM>', FutureDeductionDateL);
                InstalmentDetailL3."Deduction Date" := FutureDeductionDateL;
                InstalmentDetailL3."Deduction Amount" := RightSide * InstalmentDetailL."EMI Amount";
                InstalmentDetailL3.Status := InstalmentDetailL3.Status::Unpaid;
                InstalmentDetailL3.Insert(true);
                FutureDeductionDateL := CalcDate('<1D>', FutureDeductionDateL);
            end;
        end;
    end;

    procedure ChangeInstlaments()
    var
        InstalmentDetailL: Record "Instalment Detail";
        InstalmentDetailL2: Record "Instalment Detail";
        HrSetupL: Record "Human Resources Setup";
        PageFilterL: FilterPageBuilder;
        UnPaidAmount: Decimal;
        Counter: Integer;
        LastLineNo: Integer;
        FutureDeductionDateL: Date;
        InstlamentsFilterTxt: Label 'Change Instlament';
    begin
        Rec.TestField(Status, Rec.Status::Unpaid);
        InstalmentDetailL2.Reset();
        InstalmentDetailL2.SetRange("Loan Request No.", Rec."Loan Request No.");
        InstalmentDetailL2.SetRange(Status, InstalmentDetailL2.Status::Paid);
        if InstalmentDetailL2.IsEmpty() then
            Error(PaidLoanErr);

        InstalmentDetailL.SetRange("From Deduction Date", Rec."Deduction Date");
        PageFilterL.AddRecord(InstlamentsFilterTxt, InstalmentDetailL);
        PageFilterL.AddField(InstlamentsFilterTxt, InstalmentDetailL."From Deduction Date");
        PageFilterL.AddField(InstlamentsFilterTxt, InstalmentDetailL."No. of Month");
        PageFilterL.SetView(InstlamentsFilterTxt, InstalmentDetailL.GetView());
        if PageFilterL.RunModal() then begin
            InstalmentDetailL.SetView(PageFilterL.GETVIEW(InstlamentsFilterTxt));
            case true of
                InstalmentDetailL.GetFilter("From Deduction Date") = '':
                    Error(StrSubstNo(MandatoryErr, InstalmentDetailL.FieldCaption("From Deduction Date")));
                InstalmentDetailL.GetFilter("No. of Month") = '':
                    Error(StrSubstNo(MandatoryErr, InstalmentDetailL.FieldCaption("No. of Month")));
            end;

            Evaluate(InstalmentDetailL."No. of Month", InstalmentDetailL.GetFilter("No. of Month"));
            Evaluate(InstalmentDetailL."Deduction Date", InstalmentDetailL.GetFilter("From Deduction Date"));
            InstalmentDetailL."No. of Month" := Abs(InstalmentDetailL."No. of Month");

            InstalmentDetailL2.Reset();
            InstalmentDetailL2.SetRange("Loan Request No.", "Loan Request No.");
            if InstalmentDetailL2.FindLast() then
                LastLineNo := InstalmentDetailL2."Line No." + 10000;

            InstalmentDetailL2.Reset();
            InstalmentDetailL2.SetCurrentKey("Loan Request No.", Status, "Deduction Date");
            InstalmentDetailL2.SetRange("Loan Request No.", Rec."Loan Request No.");
            InstalmentDetailL2.SetRange(Status, InstalmentDetailL2.Status::Unpaid);
            InstalmentDetailL2.SetRange("Deduction Date", InstalmentDetailL.GetRangeMin("From Deduction Date"));
            if InstalmentDetailL2.IsEmpty() then
                Error(PendingLoanErr);

            InstalmentDetailL2.SetFilter("Deduction Date", '>=%1', InstalmentDetailL.GetRangeMin("From Deduction Date"));
            InstalmentDetailL2.CalcSums("Deduction Amount");
            UnPaidAmount := InstalmentDetailL2."Deduction Amount";
            InstalmentDetailL2.DeleteAll();

            HrSetupL.Get();
            HrSetupL.TestField("HR Rounding Precision");
            UnPaidAmount := Round(UnPaidAmount / InstalmentDetailL."No. of Month", HrSetupL."HR Rounding Precision", HrSetupL.RoundingDirection());
            FutureDeductionDateL := InstalmentDetailL."Deduction Date";
            for Counter := 1 to InstalmentDetailL."No. of Month" do begin
                LastLineNo += 10000;
                InstalmentDetailL.Reset();
                InstalmentDetailL."Loan Request No." := Rec."Loan Request No.";
                InstalmentDetailL."Line No." := LastLineNo;
                InstalmentDetailL."Deduction Amount" := UnPaidAmount;
                FutureDeductionDateL := CalcDate('<CM>', FutureDeductionDateL);
                InstalmentDetailL."Deduction Date" := FutureDeductionDateL;
                InstalmentDetailL.Status := InstalmentDetailL.Status::Unpaid;
                InstalmentDetailL.Insert(true);
                FutureDeductionDateL := CalcDate('<1D>', FutureDeductionDateL);
            end;
        end;

    end;
}