page 60184 "Legacy Data"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Legacy Data";
    //Editable = false;

    layout
    {
        area(Content)
        {
            repeater("Legacy Data")
            {
                field(Date; rec.Date)
                {
                    ApplicationArea = all;
                }
                field("Employee Code"; rec."Employee Code")
                {
                    ApplicationArea = All;
                }
                field("Employee Name"; rec."Employee Name")
                {
                    ApplicationArea = All;
                }
                field("MOL Code"; rec."MOL Code")
                {
                    ApplicationArea = all;
                }
                field(Attendance; rec.Attendance)
                {
                    ApplicationArea = all;
                }
                field("Cost Center"; rec."Cost Center")
                {
                    ApplicationArea = all;
                }
                field(Basic; rec.Basic)
                {
                    ApplicationArea = all;
                }
                field(HRA; rec.HRA)
                {
                    ApplicationArea = all;
                }
                field("Additional Allownace"; rec."Additional Allownace")
                {
                    ApplicationArea = all;
                }
                field(Incentive; rec.Incentive)
                {
                    ApplicationArea = all;
                }
                field(Cell; rec.Cell)
                {
                    ApplicationArea = all;
                }
                field(Transport; rec.Transport)
                {
                    ApplicationArea = all;
                }
                field(Total; rec.Total)
                {
                    ApplicationArea = all;
                }
                field("Advance Deduction"; rec."Advance Deduction")
                {
                    ApplicationArea = all;
                }
                field("Loan Deduction"; rec."Loan Deduction")
                {
                    ApplicationArea = all;
                }
                field("Other Deduction"; rec."Other Deduction")
                {
                    ApplicationArea = all;
                }
                field("Other Addition"; rec."Other Addition")
                {
                    ApplicationArea = all;
                }
                field("Net Payable"; rec."Net Payable")
                {
                    ApplicationArea = all;
                }
                field("WPS Fixed"; rec."WPS Fixed")
                {
                    ApplicationArea = all;
                }
                field("WPS Variable"; rec."WPS Variable")
                {
                    ApplicationArea = all;
                }
                field("NET WPS"; rec."NET WPS")
                {
                    ApplicationArea = all;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Create Journal")
            {
                ApplicationArea = All;
                Image = Journal;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    recGenJnlLine: Record "Gen. Journal Line";
                    recGenJnlBatch: Record "Gen. Journal Batch";
                    recGeneralLdgSetup: Record "General Ledger Setup";
                    recEmployeeLegacy: Record "Legacy Data";
                    recEmployee: Record Employee;
                    recBankAcc: Record "Bank Account";
                    cduNoseries: Codeunit NoSeriesManagement;
                begin
                    if Confirm('Do you want to create Journal ?') then begin
                        recEmployeeLegacy.Reset();
                        if recEmployeeLegacy.FindSet() then
                            repeat
                                recGenJnlLine.Init();
                                recGenJnlLine."Journal Template Name" := 'GENERAL';
                                recGenJnlLine."Journal Batch Name" := 'DEFAULT';
                                recGenJnlLine."Line No." += 10000;
                                recGenJnlLine."Posting Date" := WorkDate();
                                recGenJnlLine.Validate("Posting Date");
                                recGenJnlLine."Document Type" := recGenJnlLine."Document Type"::Payment;
                                recGenJnlLine.Validate("Document Type");

                                recGenJnlBatch.Reset();
                                recGenJnlBatch.SetRange("Journal Template Name", 'GENERAL');
                                recGenJnlBatch.SetRange(Name, 'DEFAULT');
                                if recGenJnlBatch.FindFirst() then
                                    recGenJnlLine."Document No." := cduNoseries.GetNextNo(recGenJnlBatch."No. Series", Today, true);

                                recGenJnlLine."Account Type" := recGenJnlLine."Account Type"::"Bank Account";
                                if recEmployee.Get(recEmployeeLegacy."Employee Code") then begin
                                    recGenJnlLine."Account No." := recEmployee."Bank Name";
                                    recGenJnlLine.Validate("Account No.");
                                end;

                                if recBankAcc.Get(recEmployee."Bank Name") then begin
                                    recGenJnlLine."Currency Code" := recBankAcc."Currency Code";
                                    recGenJnlLine.Validate("Currency Code");
                                end;
                                recGenJnlLine."Bal. Account Type" := recGenJnlLine."Bal. Account Type"::Employee;
                                recGenJnlLine."Bal. Account No." := recEmployeeLegacy."Employee Code";
                                recGenJnlLine.Validate("Bal. Account No.");
                                recGenJnlLine.Amount := (-1) * recEmployeeLegacy."NET WPS";
                                recGenJnlLine.Validate(Amount);
                                recGenJnlLine."Shortcut Dimension 1 Code" := recEmployeeLegacy."Cost Center";
                                recGenJnlLine.Validate("Shortcut Dimension 1 Code");
                                recGenJnlLine.Insert();
                            until recEmployeeLegacy.Next() = 0;
                        Message('Journal lines are Inserted.');
                    end;
                end;
            }
        }


    }

    var
        myInt: Integer;
}