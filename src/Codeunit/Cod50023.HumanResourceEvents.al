codeunit 50023 "Human Resource Events"
{
    EventSubscriberInstance = StaticAutomatic;
    trigger OnRun()
    begin
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::LogInManagement, 'OnAfterLogInStart', '', true, true)]
    local procedure OnAfterLogInStart()
    var
        UserSetup: Record "User Setup";
        EmpLogin: Page "Employee Login";
    begin
        UserSetup.Get(UserId);
        if not UserSetup."Is ESS User" then
            exit;

        EmpLogin.LookupMode(true);
        if not (EmpLogin.RunModal() = Action::LookupOK) then;
    end;

    [EventSubscriber(ObjectType::Table, 5200, 'OnAfterValidateEvent', 'Birth Date', true, true)]
    local procedure Employee_OnAfterValidateEvent_BirthDate(var Rec: Record Employee)
    var
        CurrentDateL: Integer;
        BirthDateL: Integer;
        DateFormatLbl: Label '<Year4><Month,2><Day,2>';
        DateInvalidErr: Label 'Invalid Date';
    begin
        if Rec."Birth Date" >= Today() then
            Error(DateInvalidErr);

        if Rec."Birth Date" > 0D then begin
            Evaluate(CurrentDateL, FORMAT(Today(), 10, DateFormatLbl));
            Evaluate(BirthDateL, FORMAT(Rec."Birth Date", 10, DateFormatLbl));
            Rec.Age := (CurrentDateL - BirthDateL) DIV 10000;
            Rec.Modify();
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Document Attachment", 'OnBeforeInsertEvent', '', true, true)]
    local procedure UpdateTableIDForLeaveRequest(VAR Rec: Record "Document Attachment"; RunTrigger: Boolean)
    begin
        if Rec."Table ID" = 0 then
            Rec."Table ID" := Database::"Leave Request";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::GlobalTriggerManagement, 'OnAfterOnDatabaseInsert', '', true, true)]
    local procedure CreateEmployeeReplica(RecRef: RecordRef)
    var
        EmployeeReplicaL: Record "Employee ATG";
        EmployeeL: Record Employee;
    begin
        case RecRef.Number() of
            Database::Employee:
                begin
                    RecRef.SetTable(EmployeeL);
                    EmployeeReplicaL.InsertUpdateRecord(EmployeeL."No.", EmployeeL.FullName(), CopyStr(EmployeeL.CurrentCompany(), 1, 100), EmployeeL."Company E-Mail", '', '', '', '');
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::GlobalTriggerManagement, 'OnAfterOnDatabaseModify', '', true, true)]
    local procedure UpdateEmployeeReplica(RecRef: RecordRef)
    var
        EmployeeReplicaL: Record "Employee ATG";
        EmployeeL: Record Employee;
        EmployeeLevelDesignationL: Record "Employee Level Designation";
        ReportingToDesignationL: Record "Employee Level Designation";
    begin
        case RecRef.Number() of
            Database::Employee:
                begin
                    RecRef.SetTable(EmployeeL);
                    EmployeeLevelDesignationL.SetRange("Employee No.", EmployeeL."No.");
                    EmployeeLevelDesignationL.SetRange("Primary Position", true);
                    if EmployeeLevelDesignationL.FindFirst() then begin
                        ReportingToDesignationL.SetRange("Designation Code", EmployeeLevelDesignationL."Reporting To");
                        if ReportingToDesignationL.FindFirst() then
                            ;
                    end;
                    EmployeeReplicaL.InsertUpdateRecord(EmployeeL."No.", EmployeeL.FullName(), CopyStr(EmployeeL.CurrentCompany(), 1, 100), EmployeeL."Company E-Mail", EmployeeLevelDesignationL."Designation Code", ReportingToDesignationL."Employee No.", ReportingToDesignationL."Designation Code", EmployeeLevelDesignationL.Description);
                end;
            Database::"Employee Level Designation":
                begin
                    RecRef.SetTable(EmployeeLevelDesignationL);
                    EmployeeL.Get(EmployeeLevelDesignationL."Employee No.");
                    if EmployeeLevelDesignationL."Primary Position" and (not EmployeeLevelDesignationL."Position Closed") then
                        EmployeeReplicaL.InsertUpdateRecord(EmployeeL."No.", EmployeeL.FullName(), CopyStr(EmployeeL.CurrentCompany(), 1, 100), EmployeeL."Company E-Mail", EmployeeLevelDesignationL."Designation Code", '', EmployeeLevelDesignationL."Reporting To", EmployeeLevelDesignationL.Description);
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Employee Level Designation", 'OnAfterModifyEvent', '', true, true)]
    local procedure UpdateEmployeeReplice(var Rec: Record "Employee Level Designation"; var xRec: Record "Employee Level Designation"; RunTrigger: Boolean)
    var
        ReportingToDesignationL: Record "Employee Level Designation";
        EmployeeReplicaL: Record "Employee ATG";
        EmployeeL: Record Employee;
        ApprovalUserSetupL: Record "Approval User Setup ATG";
        ApprovalSetupL: Record "Approval Setup ATG";

    begin
        if not RunTrigger then
            exit;
        if not Rec."Primary Position" then
            exit;
        if Rec."Position Closed" then
            exit;
        ReportingToDesignationL.SetRange("Designation Code", Rec."Reporting To");
        if ReportingToDesignationL.FindFirst() then
            ;
        EmployeeL.Get(Rec."Employee No.");
        EmployeeReplicaL.InsertUpdateRecord(EmployeeL."No.", '', '', EmployeeL."Company E-Mail", Rec."Designation Code", ReportingToDesignationL."Employee No.", ReportingToDesignationL."Designation Code", Rec.Description);
        ApprovalSetupL.SetRange("Approver Type", ApprovalSetupL."Approver Type"::Approver);
        ApprovalSetupL.SetRange("Approver Limit Type", ApprovalSetupL."Approver Limit Type"::"Direct Approver");
        if ApprovalSetupL.FindFirst() then
            ;
        ApprovalUserSetupL.CreateUpdateRecord(EmployeeL."No.", ApprovalUserSetupL."Approval For"::"Leave Request", ReportingToDesignationL."Employee No.", 0, true, ApprovalSetupL."Approval Code");
        ApprovalUserSetupL.UpdateApproverId(Rec."Designation Code", EmployeeL."No.");
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnAfterGLFinishPosting', '', true, true)]
    local procedure UpadteSalComputaionStatus(var GenJnlLine: record "Gen. Journal Line")
    var
        SalCompL: Record "Salary Computation Header";
        PayPeriodLineL: Record "Pay Period Line";
        SubLevL: Record "Sub Grade";
        EOSL: Record "End of Service";
        InstalmentLine: Record "Instalment Detail";
        SalaryComputationLine: Record "Salary Computation Line";
        LoanRequestG: Record "Loan Request"; //SKR 17-01-2023
        InstalmentLine1: Record "Instalment Detail";
    begin
        if SalCompL.get(GenJnlLine."External Document No.") then begin
            if GenJnlLine."Payroll Jnl. Type" = GenJnlLine."Payroll Jnl. Type"::Salary then begin
                SalCompL.Status := SalCompL.Status::Posted;
                SalCompL.Modify();
                SubLevL.Reset();
                SubLevL.SetRange("Salary Class", SalCompL."Salary Class");
                if SubLevL.FindLast() then
                    if PayPeriodLineL.get(SubLevL."Pay Cycle", SalCompL."Pay Period") then begin
                        PayPeriodLineL.Status := PayPeriodLineL.Status::Closed;
                        PayPeriodLineL.Modify();
                    end;
                SalaryComputationLine.SetRange("Computation No.", SalCompL."Computation No.");
                SalaryComputationLine.SetRange("Line Type", SalaryComputationLine."Line Type"::Loans);
                if SalaryComputationLine.FindSet() then
                    repeat
                        InstalmentLine.SetRange("Loan Request No.", SalaryComputationLine."Reference Document No.");
                        InstalmentLine.SetRange("Deduction Date", PayPeriodLineL."Period Start Date", PayPeriodLineL."Period End Date");
                        if InstalmentLine.FindFirst() then begin
                            InstalmentLine.Status := InstalmentLine.Status::Paid;
                            InstalmentLine.Modify();
                            LoanRequestG.Reset();
                            LoanRequestG.SetRange("Loan Request No.", InstalmentLine."Loan Request No.");
                            if LoanRequestG.FindFirst() then begin
                                InstalmentLine1.SetRange("Loan Request No.", LoanRequestG."Loan Request No.");
                                InstalmentLine.SetRange(Status, InstalmentLine1.Status::Unpaid);
                                if InstalmentLine1.FindSet() then
                                    repeat
                                        LoanRequestG."Outstanding Amount" += InstalmentLine1."EMI Amount";
                                        LoanRequestG.Modify();
                                    until InstalmentLine1.Next() = 0
                                else
                                    LoanRequestG."Outstanding Amount" := 0;
                                LoanRequestG.Modify();
                            end;
                        end;
                    until SalaryComputationLine.Next() = 0;
            end;
            if GenJnlLine."Payroll Jnl. Type" = GenJnlLine."Payroll Jnl. Type"::Accrual then begin
                SalCompL."Accrual Posting Status" := SalCompL."Accrual Posting Status"::Posted;
                SalCompL.Modify();
            end;
            if GenJnlLine."Payroll Jnl. Type" = GenJnlLine."Payroll Jnl. Type"::EOS then begin
                SalCompL."Accrual Posting Status" := SalCompL."Accrual Posting Status"::Posted;
                SalCompL.Status := SalCompL.Status::Posted;
                SalCompL.Modify();
                if EOSL.get(SalCompL."Computation No.") then begin
                    EOSL."Posting Status" := EOSL."Posting Status"::Posted;
                    EOSL.modify();
                end;
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, codeunit::"Gen. Jnl.-Post Line", 'OnAfterInitGLEntry', '', true, true)]
    local procedure UpdateGenJnlFields(var GLEntry: Record "G/L Entry"; GenJournalLine: Record "Gen. Journal Line")
    begin
        GLEntry."Pay Period" := GenJournalLine."Pay Period";
        GLEntry."Payroll Jnl. Type" := GenJournalLine."Payroll Jnl. Type";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::GenJnlManagement, 'OnTemplateSelectionSetFilter', '', true, true)]
    local procedure ExcludePayrollTemplate(var GenJnlTemplate: Record "Gen. Journal Template")
    begin
        GenJnlTemplate.SetRange("Payroll Template", false);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Document Attachment", 'OnBeforeSaveAttachment', '', true, true)]
    local procedure AssignTravelDocument(var DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef; FileName: Text)
    var
        ClaimLine: Record "Travel Req. & Exp. Claim Line";
    // Applicant: Record Applicant; // Start #15 - 12/05/2019 - 103
    begin
        case DocumentAttachment."Table ID" of
            Database::"Travel Req. & Exp. Claim Line":
                begin
                    if (DocumentAttachment."No." > '') and (DocumentAttachment."Line No." > 0) then begin
                        ClaimLine.SetRange("Document No.", DocumentAttachment."No.");
                        ClaimLine.SetRange("Line No.", DocumentAttachment."Line No.");
                        ClaimLine.FindFirst();
                        RecRef.GetTable(ClaimLine);
                        exit;
                    end;
                    RecRef.SetTable(ClaimLine);
                    DocumentAttachment."No." := ClaimLine."Document No.";
                    DocumentAttachment."Line No." := ClaimLine."Line No.";
                end;
        // Database::Applicant: // Start #15 - 12/05/2019 - 103
        //     begin
        //         if (DocumentAttachment."No." > '') and (DocumentAttachment."Line No." = 0) then begin
        //             Applicant.SetRange("Application ID", DocumentAttachment."No.");
        //             Applicant.FindFirst();
        //             RecRef.GetTable(Applicant);
        //             exit;
        //         end;
        //         RecRef.SetTable(Applicant);
        //         DocumentAttachment."No." := Applicant."Application ID";
        //     end; // Stop #15 - 12/05/2019 - 103
        end;
    end;

    [EventSubscriber(ObjectType::Page, page::"Document Attachment Factbox", 'OnBeforeDrillDown', '', true, true)]
    local procedure AssignTravelDocumentOnLookup(var RecRef: RecordRef; DocumentAttachment: Record "Document Attachment")
    var
        ClaimLine: Record "Travel Req. & Exp. Claim Line";
    begin
        if DocumentAttachment."Table ID" = Database::"Travel Req. & Exp. Claim Line" then begin
            ClaimLine.SetRange("Document No.", DocumentAttachment."No.");
            ClaimLine.SetRange("Line No.", DocumentAttachment."Line No.");
            ClaimLine.FindFirst();
            ClaimLine.TestField("Attachment Required", true);
            RecRef.GetTable(ClaimLine);
        end;
    end;

    [EventSubscriber(ObjectType::Page, Page::"Document Attachment Details", 'OnAfterOpenForRecRef', '', true, true)]
    local procedure CheckRecordForDocumentDetails(var DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef)
    var
        ClaimLine: Record "Travel Req. & Exp. Claim Line";
    //   Applicant: Record Applicant; // Start #15 - 12/05/2019 - 103
    begin
        case RecRef.Number() of
            Database::"Travel Req. & Exp. Claim Line":
                begin
                    RecRef.SetTable(ClaimLine);
                    DocumentAttachment.SetRange("No.", ClaimLine."Document No.");
                end;
        // Database::Applicant:// Start #15 - 12/05/2019 - 103
        //     begin
        //         RecRef.SetTable(Applicant);
        //         DocumentAttachment.SetRange("No.", Applicant."Application ID");
        //     end;// Stop #15 - 12/05/2019 - 103
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Travel Req. & Exp. Claim Line", 'OnAfterModifyEvent', '', true, true)]
    local procedure UpdateOutStandingAmount(var Rec: Record "Travel Req. & Exp. Claim Line")
    var
        ClaimHeader: Record "Travel Req & Expense Claim";
        Advance: Record "Travel & Expense Advance";
    begin
        ClaimHeader.Get(Rec."Document No.");
        if Advance.Get(ClaimHeader."Advance No.") then;
        ClaimHeader.CalcFields("Amount Payable (LCY)");
        ClaimHeader."Outstanding Amount" := ClaimHeader."Amount Payable (LCY)" - Advance."Amount (LCY)";
        ClaimHeader.Modify();
    end;

    [EventSubscriber(ObjectType::Table, Database::"Travel Req. & Exp. Claim Line", 'OnAfterDeleteEvent', '', true, true)]
    local procedure UpdateOutStandingAmountOnDelete(var Rec: Record "Travel Req. & Exp. Claim Line")
    begin
        UpdateOutStandingAmount(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Travel Req. & Exp. Claim Line", 'OnAfterInsertEvent', '', true, true)]
    local procedure UpdateOutStandingAmountOnInsert(var Rec: Record "Travel Req. & Exp. Claim Line")
    begin
        UpdateOutStandingAmount(Rec);
    end;
}