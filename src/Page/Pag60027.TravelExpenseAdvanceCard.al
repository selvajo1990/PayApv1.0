page 60027 "Travel & Expense Advance Card"
{
    PageType = Card;
    SourceTable = "Travel & Expense Advance";
    Caption = 'Travel & Expense Advance Card';
    UsageCategory = None;
    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    AssistEdit = true;
                    ToolTip = 'Specifies the value of the No.';
                    trigger OnAssistEdit()
                    begin
                        Rec.AssisEdit();
                    end;
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Employee No.';
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Employee Name';
                }
                field(Date; Rec."Document Date")
                {
                    ApplicationArea = All;
                    Caption = 'Document Date';
                    ToolTip = 'Specifies the value of the Document Date';
                }
                field("Approved Date"; Rec."Approved Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Approved Date';
                }
                field("Pay With Salary"; Rec."Pay With Salary")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Pay With Salary';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Status';
                }
            }
            group(Calculation)
            {
                field("Destination Code"; Rec."Destination Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Destination Code';
                }
                field(Destination; Rec.Destination)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Destination';
                }
                field("Purpose of Visit"; Rec."Purpose of Visit")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Purpose of Visit';
                }
                field("Purpose of Visit Description"; Rec."Purpose of Visit Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Purpose of Visit Description';
                }
                field("Expense Category Code"; Rec."Expense Category Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Expense Category Code';
                }
                field("Expense Category Description"; Rec."Expense Category Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Expense Category Description';
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Currency Code';
                }
                field("Amount (FCY)"; Rec."Amount (FCY)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Amount (FCY)';
                }
                field("Amount (LCY)"; Rec."Amount (LCY)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Amount (LCY)';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Create Travel Journals")
            {
                ApplicationArea = All;
                Caption = 'Create Travel Journals';
                Image = CreateDocuments;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the Create Travel Journals action.';
                trigger OnAction()
                begin
                    MakeJournal(Rec.RecordId());
                end;
            }
        }
    }

    procedure MakeJournal(RecID: RecordId)
    var
        TravelSetup: Record "Travel & Expense Setup";
        JnlBatch: Record "Gen. Journal Batch";
        TravelAdvance: Record "Travel & Expense Advance";
        ClaimHdr: Record "Travel Req & Expense Claim";
        ClaimLine: Record "Travel Req. & Exp. Claim Line";
        GeneralJournal: Record "Gen. Journal Line";
        GeneralJournal2: Record "Gen. Journal Line";
        NoSeries: Codeunit NoSeriesManagement;
        DocNo: Code[20];
        LineNo: Integer;
        LineExistErr: Label '%1: %2 already created in journal';
        CreatedMsg: Label 'Journal is created successfully';
    begin
        TravelSetup.Get();
        TravelSetup.TestField("Travel & Expense Jnl. Template");
        TravelSetup.TestField("Travel & Expense Jnl. Batch");
        JnlBatch.Get(TravelSetup."Travel & Expense Jnl. Template", TravelSetup."Travel & Expense Jnl. Batch");
        DocNo := NoSeries.GetNextNo(JnlBatch."No. Series", WorkDate(), true);

        LineNo := 10000;
        GeneralJournal2.SetRange("Journal Template Name", TravelSetup."Travel & Expense Jnl. Template");
        GeneralJournal2.SetRange("Journal Batch Name", TravelSetup."Travel & Expense Jnl. Batch");
        if GeneralJournal2.FindLast() then
            LineNo := GeneralJournal2."Line No." + 10000;
        case RecID.TableNo() of
            Database::"Travel & Expense Advance":
                begin
                    TravelAdvance.Get(RecID);
                    //TravelAdvance.TestField("Journal Created", false);
                    //TravelAdvance."Journal Created" := true;
                    TravelAdvance.Modify();

                    GeneralJournal.SetRange("Journal Template Name", TravelSetup."Travel & Expense Jnl. Template");
                    GeneralJournal.SetRange("Journal Batch Name", TravelSetup."Travel & Expense Jnl. Batch");
                    GeneralJournal.SetRange("External Document No.", TravelAdvance."No.");
                    if not GeneralJournal.IsEmpty() then
                        Error(StrSubstNo(LineExistErr, TravelAdvance.FieldCaption("No."), TravelAdvance."No."));
                    CreateJournalLines(TravelSetup."Travel & Expense Jnl. Template", TravelSetup."Travel & Expense Jnl. Batch",
                                    LineNo, DocNo, TravelAdvance."Document Date", TravelAdvance."Approved Date", TravelAdvance."Expense Category Description",
                                    TravelAdvance."Expense Category Code", TravelAdvance."No.", TravelAdvance."Amount (LCY)")

                end;
            Database::"Travel Req & Expense Claim":
                begin
                    ClaimHdr.Get(RecID);
                    //ClaimHdr.TestField("Journal Created", false);

                    GeneralJournal.SetRange("Journal Template Name", TravelSetup."Travel & Expense Jnl. Template");
                    GeneralJournal.SetRange("Journal Batch Name", TravelSetup."Travel & Expense Jnl. Batch");
                    GeneralJournal.SetRange("External Document No.", ClaimHdr."No.");
                    if not GeneralJournal.IsEmpty() then
                        Error(StrSubstNo(LineExistErr, ClaimHdr.FieldCaption("No."), ClaimHdr."No."));

                    ClaimLine.SetRange("Document No.", ClaimHdr."No.");
                    if ClaimLine.FindSet() then begin
                        // ClaimHdr."Journal Created" := true;
                        ClaimHdr.Modify();
                        repeat
                            CreateJournalLines(TravelSetup."Travel & Expense Jnl. Template", TravelSetup."Travel & Expense Jnl. Batch",
                                            LineNo, DocNo, ClaimHdr."Claim Date", ClaimHdr."Approved Date", ClaimLine."Expense Description",
                                            ClaimLine."Expense Code", ClaimLine."Document No.", ClaimLine."Payable Amount (LCY)");
                            LineNo += 10000;
                        until ClaimLine.Next() = 0;
                        Message(CreatedMsg);
                    end;
                end;
        end;
    end;

    local procedure CreateJournalLines(TemplateName: Code[10]; BatchName: Code[20]; LineNo: Integer; DocNo: Code[20]; DocDate: Date; PostingDate: Date; PostingDesc: Text[100]; ExpenseCode: Code[20]; ExternalDocNo: Code[20]; Amount: Decimal)
    var
        GeneralJournal: Record "Gen. Journal Line";
        ExpenseCategory: Record "Expense Category";
    begin
        ExpenseCategory.Get(ExpenseCode);
        ExpenseCategory.TestField("Main Account");
        ExpenseCategory.TestField("Sub Account");
        GeneralJournal.Init();
        GeneralJournal."Journal Template Name" := TemplateName;
        GeneralJournal.Validate("Journal Batch Name", BatchName);
        GeneralJournal."Line No." := LineNo;
        GeneralJournal.Validate("Posting Date", PostingDate);
        GeneralJournal.Validate("Document Date", DocDate);
        GeneralJournal.Validate("Document No.", DocNo);
        GeneralJournal.Validate("Document Type", GeneralJournal."Document Type"::Payment);
        GeneralJournal.Validate("Account Type", GeneralJournal."Account Type"::"G/L Account");
        GeneralJournal.Validate("Account No.", ExpenseCategory."Main Account");
        GeneralJournal.Validate(Description, PostingDesc);
        GeneralJournal.Validate("Bal. Account Type", GeneralJournal."Bal. Account Type"::"G/L Account");
        GeneralJournal.Validate("Bal. Account No.", ExpenseCategory."Sub Account");
        GeneralJournal.Validate(Amount, Amount);
        GeneralJournal."External Document No." := ExternalDocNo;
        GeneralJournal.Insert(true);
    end;
}
