report 50066 "Payroll Jnl. Calculate"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    ProcessingOnly = true;
    dataset
    {
        dataitem(SalCompHead; "Salary Computation Header")
        {
            DataItemTableView = sorting("Computation No.");
            dataitem(SalCompLine; "Salary Computation Line")
            {
                DataItemLinkReference = SalCompHead;
                DataItemLink = "Computation No." = field("Computation No.");
                DataItemTableView = sorting("Computation No.", "Line No.") where(category = filter(<> " "));

                trigger OnPreDataItem()
                begin
                    clear(dimarr);
                    if jnlTypeG = 1 then begin
                        SetRange(SalCompLine."Affects Salary", true);
                        SetRange(SalCompLine.Accrual, false);
                        Setfilter(type, '<>%1', SalCompLine.Type::"Employer Contribution");
                    end;
                    //(Type = filter ("Employer Contribution" | " "), Category = filter (Deduction | Absence | Earning));
                    if jnlTypeG = 2 then begin
                        Setfilter(type, '%1|%2', SalCompLine.Type::"Employer Contribution", SalCompLine.Type::" ");
                        Setfilter(Category, '<>%1', Category::" ");
                    end;

                end;

                trigger OnAfterGetRecord()
                var
                    IsinsertDim: Boolean;
                begin
                    PayPeriodG := "Pay Period";
                    DefDimG.Reset();
                    DefDimG.SetRange("Table ID", Database::Employee);
                    DefDimG.SetRange("No.", SalCompLine."Employee No.");
                    clear(dimValarr);
                    i := 0;
                    IsinsertDim := true;
                    if DefDimG.findset() then
                        repeat
                            if not HRSetupG."Employee Level Posting" then
                                if DefDimG."Dimension Code" = HRSetupG."Employee Dimension Code" then
                                    IsinsertDim := false;
                            if IsinsertDim then begin
                                currarr := isfoundDimArr(dimarr, DefDimG."Dimension Code");
                                if currarr = 0 then begin
                                    dimarr[i + 1] := DefDimG."Dimension Code";
                                    dimValarr[i + 1] := DefDimG."Dimension Value Code";
                                    i += 1;
                                end else
                                    dimValarr[currarr] := DefDimG."Dimension Value Code";
                            end;
                        until DefDimG.Next() = 0;

                    if TempTableG.get(SalCompLine."Line Type", SalCompLine.code, SalCompLine."Posting Category", dimValarr[1], dimvalarr[2], dimValarr[3], dimValarr[4],
                        dimValarr[5], dimValarr[6], dimValarr[7], dimValarr[8],
                        DMY2date(SalCompLine.Category, SalCompLine.Category)) then begin
                        TempTableG.Amount += SalCompLine."Amount";
                        TempTableG.Modify();
                    end else begin
                        TempTableG.init();
                        TempTableG."Line Type" := SalCompLine."Line Type";
                        TempTableG.Code := SalCompLine.Code;
                        TempTableG.Description := SalCompLine.Description;
                        TempTableG.Category := SalCompLine."Posting Category";
                        TempTableg."Dimension Value Code 1" := dimValarr[1];
                        TempTableg."Dimension Value Code 2" := dimValarr[2];
                        TempTableg."Dimension Value Code 3" := dimValarr[3];
                        TempTableg."Dimension Value Code 4" := dimValarr[4];
                        TempTableg."Dimension Value Code 5" := dimValarr[5];
                        TempTableg."Dimension Value Code 6" := dimValarr[6];
                        TempTableg."Dimension Value Code 7" := dimValarr[7];
                        TempTableg."Dimension Value Code 8" := dimValarr[8];
                        TempTableG.Date := DMY2date(SalCompLine.Category, SalCompLine.Category); //Date field used to store category
                        TempTableG.Amount := SalCompLine.Amount;
                        TempTableG."Line Type" := SalCompLine."Line Type";
                        TempTableG.Insert();
                    end;

                end;
            }
            trigger OnPreDataItem()
            begin
                if pstngDate = 0D then
                    pstngdate := workdate();

                HRSetupG.get();
                if jnlTypeG = 1 then begin
                    HRSetupG.TestField("Salary Comp. Jnl. Template");
                    JnlTempCode := HRSetupG."Salary Comp. Jnl. Template";
                end;
                if jnlTypeG = 2 then begin
                    HRSetupG.TestField("Accurals Jnl. Template");
                    JnlTempCode := HRSetupG."Accurals Jnl. Template";
                end;

                GenJnlBatchG.reset();
                GenJnlBatchG.SetRange("Journal Template Name", JnlTempCode);
                GenJnlBatchG.FindFirst();
                GenJnlBatchG.TestField("No. Series");
                CurrBatchNameG := GenJnlBatchG.Name;

                GLLineG.Reset();
                GLLineG.SetRange("Journal Template Name", JnlTempCode);
                GLLineG.SetRange("Journal Batch Name", CurrBatchNameG);
                if GLLineG.FindSet() then
                    error('Unposted Payroll Journal line exists in %1 Template, Post/Delete the entries to proceed.', JnlTempCode);
                TempTableG.reset();
                TempTableG.DeleteAll();

                Commit();
                GLLineG.LockTable();
                if not FindSet() then
                    error('Nothing to process.');
            end;

            trigger OnAfterGetRecord()
            begin

                CalcFields("Total Net Pay");
                if "Total Net Pay" = 0 then
                    error('Nothing to process.');
                SalCompNo := SalCompHead."Computation No.";
            end;

        }
        dataitem(TempTableInt; integer)
        {
            trigger OnPreDataItem()
            begin
                if temptableg.count() > 0 then
                    setrange(number, 1, temptableg.count())
                else
                    currreport.break();
                TempTableg.findset();

                clear(nosermgtG);
                docno := nosermgtG.GetNextNo(GenJnlBatchG."No. Series", WorkDate(), true);
                LineNoG := 10000;
            end;


            trigger OnAfterGetRecord()
            var
                TravelExpense: Record "Expense Category";
            begin
                if Number > 1 then
                    TempTableg.Next();

                if TempTableG.Category <> TempTableG.Category::"Travel & Expense" then begin
                    PayPstngSetupG.Get(TempTableG."Line Type", TempTableG.Code, TempTableG.Category);
                    PayPstngSetupG.TestField("Credit Account");
                    PayPstngSetupG.TestField("Debit Account");
                end else begin
                    TravelExpense.Get(TempTableG.Code);
                    TravelExpense.TestField("Main Account");
                    TravelExpense.TestField("Sub Account");
                    PayPstngSetupG."Credit Account" := TravelExpense."Main Account";
                    PayPstngSetupG."Debit Account" := TravelExpense."Sub Account";
                end;

                if TempTableG.Amount <> 0 then begin
                    clear(dimValarr);

                    dimValarr[1] := TempTableG."Dimension Value Code 1";
                    dimValarr[2] := TempTableG."Dimension Value Code 2";
                    dimValarr[3] := TempTableG."Dimension Value Code 3";
                    dimValarr[4] := TempTableG."Dimension Value Code 4";
                    dimValarr[5] := TempTableG."Dimension Value Code 5";
                    dimValarr[6] := TempTableG."Dimension Value Code 6";
                    dimValarr[7] := TempTableG."Dimension Value Code 7";
                    dimValarr[8] := TempTableG."Dimension Value Code 8";

                    GLLineG.init();
                    GLLineG."Journal Template Name" := JnlTempCode;
                    GLLineG."Journal Batch Name" := CurrBatchNameG;
                    GLLineG."Line No." := LineNoG;
                    GLLineG.validate("Posting Date", pstngDate);
                    GLLineG."Document No." := docno;
                    GLLineG."Document Type" := GLLineG."Document Type"::Payment;
                    gLLineG."Account Type" := GLLineG."Account Type"::"G/L Account";
                    GLLineG.validate("Account No.", PayPstngSetupG."Debit Account");
                    //GLLineG.Description := TempTableG."G/L Account No.";
                    GLLineG.Description := TempTableG.Code + '-' + TempTableG.Description;
                    GLLineG."Bal. Account Type" := GLLineG."Bal. Account Type"::"G/L Account";
                    GLLineG.validate("Bal. Account No.", PayPstngSetupG."Credit Account");
                    GLLineG.validate(Amount, TempTableg.Amount);
                    GLLineG."External Document No." := SalCompNo;
                    GLLineG."Pay Period" := PayPeriodG;
                    GLLineG."Payroll Jnl. Type" := jnlTypeG;
                    UpdateDimension(GLLineG, dimarr, dimValarr);
                    GLLineG.Insert();
                    LineNoG += 10000;
                end;
            end;
        }

    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                field("pstng Date"; pstngDate)
                {
                    ApplicationArea = all;
                    Caption = 'Posting Date';
                    ToolTip = 'Specifies the value of the Posting Date';

                }

            }
        }
        trigger Onopenpage()
        begin
            pstngDate := WorkDate();
        end;
    }
    var
        GLLineG: Record "Gen. Journal Line";
        HRSetupG: Record "Human Resources Setup";
        PayPstngSetupG: Record "Payroll Posting Group";
        TempTableG: Record "Budget Buffer ATG" temporary;
        DefDimG: Record "Default Dimension";
        GenJnlBatchG: Record "Gen. Journal Batch";
        nosermgtG: Codeunit NoSeriesManagement;
        i: Integer;
        currarr: Integer;
        LineNoG: Integer;
        PayPeriodG: Code[20];
        docno: code[20];
        CurrBatchNameG: Code[10];
        SalCompNo: code[20];
        dimarr: array[8] of code[20];
        dimValarr: array[8] of code[20];
        pstngDate: Date;
        jnlTypeG: Integer;
        JnlTempCode: code[10];

    trigger onpostreport()
    var
        SalCompHeadL: Record "Salary Computation Header";
    begin
        if SalCompHeadl.get(SalCompNo) then begin
            if jnlTypeG = 1 then
                SalCompHeadL.Status := SalCompHeadL.Status::"Journal Created";
            if jnlTypeG = 2 then
                SalCompHeadL."Accrual Posting Status" := SalCompHeadL."Accrual Posting Status"::"Journal Created";
            SalCompHeadL.modify();
        end;
        Message('Journal Lines has been created.');
    end;

    procedure SetParameters(JnlType: Integer)
    begin
        //JnlType 1 - Salary, 2-Accrual
        jnlTypeG := JnlType;
    end;

    local procedure isfoundDimArr(pArr: array[8] of code[20]; pval: code[20]): Integer
    var
        j: Integer;
    begin
        for j := 1 to 8 do
            if pArr[j] = pval then
                exit(j);
        exit(0);
    end;

    local procedure UpdateDimension(var GenJnlLine: Record "Gen. Journal Line"; pDimarr: array[8] of code[20]; pDimvalarr: array[8] of code[20])
    var
        TempDimSetEntry: Record "Dimension Set Entry" temporary;
        DimVal: Record "Dimension Value";
        DimMgt: Codeunit DimensionManagement;
        NewDimensionID: Integer;
        k: Integer;
        DimSetIDArr: array[10] of integer;
    begin
        NewDimensionID := GenJnlLine."Dimension Set ID";
        for k := 1 to 8 do
            if pDimvalarr[k] <> '' then begin
                DimVal.GET(pdimarr[k], pDimvalarr[k]);
                TempDimSetEntry."Dimension Code" := pdimarr[k];
                TempDimSetEntry."Dimension Value ID" := DimVal."Dimension Value ID";
                TempDimSetEntry."Dimension Value Code" := pDimvalarr[k];
                TempDimSetEntry.INSERT();
            end;

        NewDimensionID := DimMgt.GetDimensionSetID(TempDimSetEntry);
        GenJnlLine."Dimension Set ID" := NewDimensionID;

        GenJnlLine.CreateDim(
          DimMgt.TypeToTableID1(GenJnlLine."Account Type"), GenJnlLine."Account No.",
          DimMgt.TypeToTableID1(GenJnlLine."Bal. Account Type"), GenJnlLine."Bal. Account No.",
          DATABASE::Job, GenJnlLine."Job No.",
          DATABASE::"Salesperson/Purchaser", GenJnlLine."Salespers./Purch. Code",
          DATABASE::Campaign, GenJnlLine."Campaign No.");
        IF NewDimensionID <> GenJnlLine."Dimension Set ID" THEN BEGIN
            DimSetIDArr[2] := NewDimensionID;
            DimSetIDArr[1] := GenJnlLine."Dimension Set ID";
            GenJnlLine."Dimension Set ID" :=
              DimMgt.GetCombinedDimensionSetID(DimSetIDArr, GenJnlLine."Shortcut Dimension 1 Code", GenJnlLine."Shortcut Dimension 2 Code");
        END;
    end;
}