report 50067 "Payroll Jnl. EOS Calculate"
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
                //salary
                DataItemLinkReference = SalCompHead;
                DataItemLink = "Computation No." = field("Computation No.");
                DataItemTableView = sorting("Computation No.", "Line No.") where(category = filter(<> " "), "Show in Payslip" = filter(true), Type = filter(<> Adhoc), "Pay with salary" = const(true));

                trigger OnAfterGetRecord()
                begin
                    InsertTemptable(SalCompLine."Line Type", SalCompLine.Code, SalCompLine."Posting Category", SalCompLine.Category, dimValarr, SalCompLine."Amount");
                end;
            }
            dataitem(SalCompLineAcc; "Salary Computation Line")
            {
                //Accruals
                DataItemLinkReference = SalCompHead;
                DataItemLink = "Computation No." = field("Computation No.");
                DataItemTableView = sorting("Computation No.", "Line No.") where(category = filter(<> " "), Type = filter("Employer Contribution" | " "), "Pay with salary" = const(true));

                trigger OnAfterGetRecord()
                begin
                    InsertTemptable(SalCompLineAcc."Line Type", SalCompLineAcc.code, SalCompLineAcc."Posting Category", SalCompLineAcc.Category, dimValarr, SalCompLineAcc."Amount");
                end;
            }
            dataitem(SalCompLineAdhoc; "Salary Computation Line")
            {
                //Adhoc
                DataItemLinkReference = SalCompHead;
                DataItemLink = "Computation No." = field("Computation No.");
                DataItemTableView = sorting("Computation No.", "Line No.") where(category = filter(<> " "), Type = filter(Adhoc), "Pay with salary" = const(true));

                trigger OnAfterGetRecord()
                begin
                    InsertTemptable(SalCompLineAdhoc."Line Type", SalCompLineAdhoc.code, SalCompLineAdhoc."Posting Category", SalCompLineAdhoc.Category, dimValarr, SalCompLineAdhoc."Amount");
                end;
            }

            trigger OnPreDataItem()
            begin
                if pstngDate = 0D then
                    pstngdate := workdate();

                HRSetupG.get();
                HRSetupG.TestField("EOS Jnl. Template");

                GenJnlBatchG.reset();
                GenJnlBatchG.SetRange("Journal Template Name", HRSetupG."EOS Jnl. Template");
                GenJnlBatchG.FindFirst();
                GenJnlBatchG.TestField("No. Series");
                CurrBatchNameG := GenJnlBatchG.Name;

                GLLineG.Reset();
                GLLineG.SetRange("Journal Template Name", HRSetupG."EOS Jnl. Template");
                GLLineG.SetRange("Journal Batch Name", CurrBatchNameG);
                if GLLineG.FindSet() then
                    error('Unposted Payroll Journal entries exists in %1 Journal Template, Post/Delete the entries to proceed.', HRSetupG."EOS Jnl. Template");

                TempTableG.reset();
                TempTableG.DeleteAll();

                Commit();
                GLLineG.LockTable();
                if not FindSet() then
                    error('Nothing to process.');
            end;

            trigger OnAfterGetRecord()
            var
                IsinsertDim: Boolean;
            begin

                CalcFields("Total Net Pay");
                SalCompNo := SalCompHead."Computation No.";

                DefDimG.Reset();
                DefDimG.SetRange("Table ID", 5200);
                DefDimG.SetRange("No.", SalCompHead."Employee No.");
                clear(dimValarr);
                clear(dimarr);
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
            end;

        }
        dataitem(TempTable; integer)
        {
            trigger OnPreDataItem()
            begin
                if temptableg.count() > 0 then
                    setrange(number, 1, temptableg.count())
                else
                    error('Nothing to process.');
                TempTableg.findset();

                clear(nosermgtG);
                docno := nosermgtG.GetNextNo(GenJnlBatchG."No. Series", WorkDate(), true);
                LineNoG := 10000;
            end;


            trigger OnAfterGetRecord()
            begin
                if Number > 1 then
                    TempTableg.Next();

                /* if date2dmy(TempTableG.date, 1) < 3 then
                    PayPstngSetupG.get(PayPstngSetupG.Type::Earning, TempTableG."G/L Account No.")
                else
                    PayPstngSetupG.get(PayPstngSetupG.Type::Absence, TempTableG."G/L Account No."); */
                PayPstngSetupG.Get(TempTableG."Line Type", TempTableG.Code, TempTableG.Category);
                PayPstngSetupG.TestField("Credit Account");
                PayPstngSetupG.TestField("Debit Account");

                if TempTableG.Amount <> 0 then begin
                    GLLineG.init();
                    GLLineG."Journal Template Name" := HRSetupG."EOS Jnl. Template";
                    GLLineG."Journal Batch Name" := CurrBatchNameG;
                    GLLineG."Line No." := LineNoG;
                    GLLineG.validate("Posting Date", pstngDate);
                    GLLineG."Document No." := docno;
                    GLLineG."Document Type" := GLLineG."Document Type"::Payment;
                    gLLineG."Account Type" := GLLineG."Account Type"::"G/L Account";
                    GLLineG.validate("Account No.", PayPstngSetupG."Debit Account");
                    GLLineG.Description := TempTableG.Code;
                    GLLineG."Bal. Account Type" := GLLineG."Bal. Account Type"::"G/L Account";
                    GLLineG.validate("Bal. Account No.", PayPstngSetupG."Credit Account");
                    GLLineG.validate(Amount, TempTableg.Amount);
                    GLLineG."External Document No." := SalCompNo;
                    GLLineG."Pay Period" := PayPeriodG;
                    GLLineG."Payroll Jnl. Type" := GLLineG."Payroll Jnl. Type"::EOS;
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


    trigger onpostreport()
    var
        SalCompHeadL: Record "Salary Computation Header";
        EosL: Record "End of Service";
    begin
        if SalCompHeadl.get(SalCompNo) then begin
            SalCompHeadL.Status := SalCompHeadL.Status::"Journal Created";
            SalCompHeadL."Accrual Posting Status" := SalCompHeadL."Accrual Posting Status"::"Journal Created";
            SalCompHeadL.modify();
        end;
        if EosL.get(SalCompNo) then begin
            EosL."Posting Status" := EosL."Posting Status"::"Journal Created";
            EosL.modify();
        end;
        Message('Journal Lines has been created.');
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

    local procedure InsertTemptable(LineTypeP: Option; pEarCode: code[20]; PostingCatP: Option; pCategory: integer; pDimValarr: array[8] of code[20]; pAmt: Decimal)
    begin
        if TempTableG.get(LineTypeP, pEarCode, PostingCatP, pdimValarr[1], pdimvalarr[2], pdimValarr[3], pdimValarr[4],
            pdimValarr[5], pdimValarr[6], pdimValarr[7], pdimValarr[8],
            DMY2date(pCategory, pCategory)) then begin
            TempTableG.Amount += pAmt;
            TempTableG.Modify();
        end else begin
            TempTableG.init();
            TempTableG."Line Type" := LineTypeP;
            TempTableG.Code := pEarCode;
            TempTableG.Category := PostingCatP;
            TempTableg."Dimension Value Code 1" := pdimValarr[1];
            TempTableg."Dimension Value Code 2" := pdimValarr[2];
            TempTableg."Dimension Value Code 3" := pdimValarr[3];
            TempTableg."Dimension Value Code 4" := pdimValarr[4];
            TempTableg."Dimension Value Code 5" := pdimValarr[5];
            TempTableg."Dimension Value Code 6" := pdimValarr[6];
            TempTableg."Dimension Value Code 7" := pdimValarr[7];
            TempTableg."Dimension Value Code 8" := pdimValarr[8];
            TempTableG.Date := DMY2date(pCategory, pCategory); //Date field used to store category option
            TempTableG.Amount := pAmt;
            TempTableG.Insert();
        end;

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