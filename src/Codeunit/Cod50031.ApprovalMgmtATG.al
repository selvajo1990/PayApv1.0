codeunit 50031 "Approval Mgmt ATG"
{
    trigger OnRun()
    begin
    end;

    procedure CheckApprovalEnabled(EmployeeId: Code[20]; ApprovalFor: Option "Leave Request"): Code[20]
    var
        ApprovalUserSetup: Record "Approval User Setup ATG";
        EmployeeReplicaL: Record "Employee ATG";
    begin
        EmployeeReplicaL.Get(EmployeeId);
        ApprovalUserSetup.ChangeCompany(EmployeeReplicaL."Company ATG");
        if not ApprovalUserSetup.Get(EmployeeId, ApprovalFor) then
            Error(ApprovalCheckErr, EmployeeId, Format(ApprovalFor));
        ApprovalUserSetup.TestField("Template Code");
        exit(ApprovalUserSetup."Template Code");
    end;

    procedure CreateApprovalRequests(RecRef: RecordRef; ApprovalCode: Code[20])
    var
        ApprovalSetup: Record "Approval Setup ATG";
        ApprovalEntryArgument: Record "Approval Entry ATG";
        LeaveRequestL: Record "Leave Request";
        EmployeeReplicaL: Record "Employee ATG";
        Variant: Variant;
    begin
        case RecRef.Number() of
            Database::"Leave Request":
                begin
                    RecRef.SetTable(LeaveRequestL);
                    EmployeeReplicaL.Get(LeaveRequestL."Employee No.");
                    ApprovalSetup.ChangeCompany(EmployeeReplicaL."Company ATG");
                    CompanyNameG := EmployeeReplicaL."Company ATG";
                end;
        end;
        ApprovalSetup.Get(ApprovalCode);
        ApprovalSetup.TestField("Approver Type");
        //ApprovalSetup.TestField("Approver Limit Type");
        PopulateApprovalEntryArgument(RecRef, ApprovalSetup, ApprovalEntryArgument);
        case ApprovalSetup."Approver Type" of
            ApprovalSetup."Approver Type"::Approver:
                CreateApprReqForApprTypeApprover(ApprovalSetup, ApprovalEntryArgument);
            ApprovalSetup."Approver Type"::"Workflow User Group":
                CreateApprReqForApprTypeWorkflowUserGroup(ApprovalSetup, ApprovalEntryArgument);
        end;

        Variant := RecRef;
        SendApprovalRequestForApproval(Variant, ApprovalEntryArgument);
    end;

    procedure CreateApprReqForApprTypeWorkflowUserGroup(var ApprovalSetup: Record "Approval Setup ATG"; var ApprovalEntryArgument: Record "Approval Entry ATG")
    var
        Employee: Record "Employee ATG";
        WorkflowGroupMember: Record "Workflow Group Member ATG";
        SequenceNo: Integer;
        ApproverId: Code[20];
    begin
        ApprovalSetup.TestField("Approver Type", ApprovalSetup."Approver Type"::"Workflow User Group");
        ApprovalSetup.TestField("Workflow User Group Code");
        if not Employee.Get(GlobalSenderID) then
            Error(UserIdNotInSetupErr, GlobalSenderID);
        SequenceNo := GetLastSequenceNo(ApprovalEntryArgument);
        WorkflowGroupMember.ChangeCompany(ApprovalSetup.CurrentCompany());
        WorkflowGroupMember.SetCurrentKey("Workflow Group Code", "Sequence No.");
        WorkflowGroupMember.SetRange("Workflow Group Code", ApprovalSetup."Workflow User Group Code");

        if not WorkflowGroupMember.FindSet() then
            Error(NoWFUserGroupMembersErr);
        repeat
            ApproverId := WorkflowGroupMember."Employee No.";
            if not Employee.Get(ApproverId) then
                Error(WFUserGroupNotInSetupErr, ApproverId);
            MakeApprovalEntry(ApprovalEntryArgument, SequenceNo + WorkflowGroupMember."Sequence No.", ApproverId, ApprovalSetup);
        until WorkflowGroupMember.Next() = 0;

    end;

    procedure CreateApprReqForApprTypeApprover(var ApprovalSetup: Record "Approval Setup ATG"; var ApprovalEntryArgument: Record "Approval Entry ATG")
    begin
        case ApprovalSetup."Approver Limit Type" of
            ApprovalSetup."Approver Limit Type"::"Approver Chain":
                begin
                    CreateApprovalRequestForUser(ApprovalSetup, ApprovalEntryArgument);
                    CreateApprovalRequestForChainOfApprovers(ApprovalSetup, ApprovalEntryArgument);
                end;
            ApprovalSetup."Approver Limit Type"::"First Qualified Approver":
                begin
                    CreateApprovalRequestForUser(ApprovalSetup, ApprovalEntryArgument);
                    CreateApprovalRequestForApproverWithSufficientLimit(ApprovalSetup, ApprovalEntryArgument);
                end;
            ApprovalSetup."Approver Limit Type"::"Direct Approver":
                begin
                    CreateApprovalRequestForUser(ApprovalSetup, ApprovalEntryArgument);
                    CreateApprovalRequestForDirectApprover(ApprovalSetup, ApprovalEntryArgument);
                end;
        end;
    end;

    procedure CreateApprovalRequestForApproverWithSufficientLimit(ApprovalSetup: Record "Approval Setup ATG"; ApprovalEntryArgument: Record "Approval Entry ATG")
    begin
        CreateApprovalRequestForApproverChain(ApprovalSetup, ApprovalEntryArgument, true);
    end;

    procedure CreateApprovalRequestForUser(ApprovalSetup: Record "Approval Setup ATG"; ApprovalEntryArgument: Record "Approval Entry ATG")
    var
        SequenceNo: Integer;
    begin
        SequenceNo := GetLastSequenceNo(ApprovalEntryArgument);
        SequenceNo += 1;
        MakeApprovalEntry(ApprovalEntryArgument, SequenceNo, GlobalSenderID, ApprovalSetup);
    end;

    procedure CreateApprovalRequestForChainOfApprovers(ApprovalSetup: Record "Approval Setup ATG"; ApprovalEntryArgument: Record "Approval Entry ATG")
    begin
        CreateApprovalRequestForApproverChain(ApprovalSetup, ApprovalEntryArgument, false);
    end;

    procedure CreateApprovalRequestForApproverChain(ApprovalSetup: Record "Approval Setup ATG"; ApprovalEntryArgument: Record "Approval Entry ATG"; SufficientApproverOnly: Boolean)
    var
        ApprovalEntry: Record "Approval Entry ATG";
        Employee: Record "Employee ATG";
        ApprovalUserSetup: Record "Approval User Setup ATG";
        SequenceNo: Integer;
        ApproverId: Code[20];
    begin
        ApproverId := GlobalSenderID;
        if not Employee.Get(ApproverId) then
            Error(ApproverUserIdNotInSetupErr, ApprovalEntry."Sender ID");
        ApprovalEntry.ChangeCompany(Employee."Company ATG");
        ApprovalUserSetup.ChangeCompany(Employee."Company ATG");
        ApprovalEntry.SetCurrentKey("Record ID to Approve", "Sequence No.");
        ApprovalEntry.SetRange("Table ID", ApprovalEntryArgument."Table ID");
        ApprovalEntry.SetRange("Record ID to Approve", ApprovalEntryArgument."Record ID to Approve");
        ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Created);
        if ApprovalEntry.FindLast() then
            ApproverId := ApprovalEntry."Approver ID";
        //not required - just keeping eye on it
        // else 
        //     IF (ApprovalSetup."Approver Limit Type" = ApprovalSetup."Approver Limit Type"::"First Qualified Approver") then begin
        //         ApproverId := Employee."No.";
        //         Error('wrong code');
        //     end;


        case ApprovalEntryArgument."Table ID" of
            Database::"Leave Request":
                ApprovalUserSetup.Get(GlobalSenderID, ApprovalUserSetup."Approval For"::"Leave Request");
        end;

        if not IsSufficientApprover(Employee, ApprovalEntryArgument, ApprovalUserSetup) then
            repeat
                ApproverId := ApprovalUserSetup."Approver ID";
                case ApprovalEntryArgument."Table ID" of
                    Database::"Leave Request":
                        ApprovalUserSetup.Get(ApproverId, ApprovalUserSetup."Approval For"::"Leave Request");
                end;
                if ApproverId = '' then
                    Error(NoSuitableApproverFoundErr);

                if not Employee.Get(ApproverId) then
                    ERROR(ApproverUserIdNotInSetupErr, Employee."No. ATG");

                if IsSufficientApprover(Employee, ApprovalEntryArgument, ApprovalUserSetup) OR (not SufficientApproverOnly) then begin
                    SequenceNo := GetLastSequenceNo(ApprovalEntryArgument) + 1;
                    MakeApprovalEntry(ApprovalEntryArgument, SequenceNo, ApproverId, ApprovalSetup);
                end;
            until IsSufficientApprover(Employee, ApprovalEntryArgument, ApprovalUserSetup);
    end;

    procedure IsSufficientApprover(Employee: Record "Employee ATG"; ApprovalEntryArgument: Record "Approval Entry ATG"; ApprovalUserSetup: Record "Approval User Setup ATG"): Boolean
    begin
        case ApprovalEntryArgument."Table ID" of
            Database::"Leave Request":
                exit(IsSufficientLeaveApprover(Employee, ApprovalEntryArgument."Approval Value", ApprovalUserSetup));
        end;
    end;

    procedure IsSufficientLeaveApprover(Employee: Record "Employee ATG"; ApprovalValue: Decimal; ApprovalUserSetup: Record "Approval User Setup ATG"): Boolean
    begin
        if ApprovalUserSetup."Employee No." = ApprovalUserSetup."Approver ID" then
            exit(true);
        if (ApprovalUserSetup."Unlimited Leave Request") or
           ((ApprovalValue <= ApprovalUserSetup."Leave Request Limit") AND (ApprovalUserSetup."Leave Request Limit" <> 0))
        then
            exit(true);
        exit(false);
    end;

    procedure PopulateApprovalEntryArgument(RecRef: RecordRef; var ApprovalSetup: Record "Approval Setup ATG"; var ApprovalEntryArgument: Record "Approval Entry ATG")
    var
        LeaveRequest: Record "Leave Request";
        OT: Record "Over Time";
    begin
        ApprovalEntryArgument.ChangeCompany(ApprovalSetup.CurrentCompany());
        ApprovalEntryArgument.Init();
        ApprovalEntryArgument."Table ID" := RecRef.Number();
        ApprovalEntryArgument."Record ID to Approve" := RecRef.RecordId();
        ApprovalEntryArgument."Approval Code" := ApprovalSetup."Approval Code";
        case RecRef.Number() of
            Database::"Leave Request":
                begin
                    RecRef.SetTable(LeaveRequest);
                    ApprovalEntryArgument."Document Type" := CopyStr(LeaveRequest.TableCaption(), 1, 50);
                    ApprovalEntryArgument."Document No." := LeaveRequest."No.";
                    ApprovalEntryArgument."Approval Value" := LeaveRequest."Leave Days";
                    GlobalSenderID := LeaveRequest."Employee No.";
                end;
        end;
    end;

    procedure GetLastSequenceNo(var ApprovalEntryArgument: Record "Approval Entry ATG"): Integer
    var
        ApprovalEntry: Record "Approval Entry ATG";
    begin
        if CompanyNameG > '' then
            ApprovalEntry.ChangeCompany(CompanyNameG);
        ApprovalEntry.SetCurrentKey("Record ID to Approve", "Approval Code", "Sequence No.");
        ApprovalEntry.SetRange("Table ID", ApprovalEntryArgument."Table ID");
        ApprovalEntry.SetRange("Record ID to Approve", ApprovalEntryArgument."Record ID to Approve");
        ApprovalEntry.SetRange("Approval Code", ApprovalEntryArgument."Approval Code");
        if ApprovalEntry.FindLast() then
            exit(ApprovalEntry."Sequence No.");
        exit(0);
    end;

    procedure MakeApprovalEntry(ApprovalEntryArgument: Record "Approval Entry ATG"; SequenceNo: Integer; ApproverId: Code[20]; ApprovalSetup: Record "Approval Setup ATG")
    var
        ApprovalEntry: Record "Approval Entry ATG";
    begin
        if CompanyNameG > '' then
            ApprovalEntry.ChangeCompany(CompanyNameG);
        ApprovalEntry."Table ID" := ApprovalEntryArgument."Table ID";
        ApprovalEntry."Document Type" := ApprovalEntryArgument."Document Type";
        ApprovalEntry."Document No." := ApprovalEntryArgument."Document No.";
        ApprovalEntry."Sequence No." := SequenceNo;
        ApprovalEntry."Sender ID" := GlobalSenderID;
        ApprovalEntry."Approval Value" := ApprovalEntryArgument."Approval Value";
        ApprovalEntry."Approver ID" := ApproverId;
        ApprovalEntry."Approval Code" := ApprovalEntryArgument."Approval Code";
        IF ApproverId = GlobalSenderID then
            ApprovalEntry.Status := ApprovalEntry.Status::Approved
        else
            ApprovalEntry.Status := ApprovalEntry.Status::Created;
        ApprovalEntry."Date-Time Sent for Approval" := CreateDateTime(Today(), Time());
        ApprovalEntry."Last Date-Time Modified" := CreateDateTime(Today(), Time());
        ApprovalEntry."Last Modified By User ID" := CopyStr(UserId(), 1, 50);
        SetApproverType(ApprovalEntry, ApprovalSetup);
        SetLimitType(ApprovalEntry, ApprovalSetup);
        ApprovalEntry."Record ID to Approve" := ApprovalEntryArgument."Record ID to Approve";
        ApprovalEntry."Approval Code" := ApprovalEntryArgument."Approval Code";
        ApprovalEntry.Insert(true);
    end;

    procedure SetLimitType(var ApprovalEntry: Record "Approval Entry ATG"; ApprovalSetup: Record "Approval Setup ATG")
    begin
        case ApprovalSetup."Approver Limit Type" of
            ApprovalSetup."Approver Limit Type"::"Approver Chain",
            ApprovalSetup."Approver Limit Type"::"First Qualified Approver":
                ApprovalEntry."Limit Type" := ApprovalEntry."Limit Type"::"Approval Limits";
            ApprovalSetup."Approver Limit Type"::"Direct Approver":
                ApprovalEntry."Limit Type" := ApprovalEntry."Limit Type"::"No Limits";
            ApprovalSetup."Approver Limit Type"::"Specific Approver":
                ApprovalEntry."Limit Type" := ApprovalEntry."Limit Type"::"No Limits";
        end;

        if ApprovalEntry."Approval Type" = ApprovalEntry."Approval Type"::"Workflow User Group" then
            ApprovalEntry."Limit Type" := ApprovalEntry."Limit Type"::"No Limits";
    end;

    procedure SetApproverType(var ApprovalEntry: Record "Approval Entry ATG"; ApprovalSetup: Record "Approval Setup ATG")
    begin
        case ApprovalSetup."Approver Type" of
            ApprovalSetup."Approver Type"::Approver:
                ApprovalEntry."Approval Type" := ApprovalEntry."Approval Type"::Approver;
            ApprovalSetup."Approver Type"::"Workflow User Group":
                ApprovalEntry."Approval Type" := ApprovalEntry."Approval Type"::"Workflow User Group";
        end;
    end;

    procedure SendApprovalRequestForApproval(Variant: Variant; ApprovalEntry: Record "Approval Entry ATG")
    var
        RecRef: RecordRef;
    begin
        RecRef.GetTable(Variant);
        case RecRef.Number() of
            Database::"Approval Entry":
                SendApprovalRequestFromApprovalEntry(Variant);
            else
                SendApprovalRequestFromRecord(RecRef, ApprovalEntry);
        end;
    end;

    procedure SendApprovalRequestFromApprovalEntry(Variant: Variant)
    var
        ApprovalEntry: Record "Approval Entry ATG";
        ApprovalEntry2: Record "Approval Entry ATG";
        ApprovalEntry3: Record "Approval Entry ATG";
    begin
        IF ApprovalEntry.Status = ApprovalEntry.Status::Open THEN BEGIN
            NotificationEntry.CreateNew(ApprovalEntry."Approver ID", ApprovalEntry, 0);
            EXIT;
        END;

        // IF FindOpenApprovalEntriesForPayroll(ApprovalEntry) THEN
        //    EXIT;
        ApprovalEntry2.ChangeCompany(ApprovalEntry.CurrentCompany());
        ApprovalEntry3.ChangeCompany(ApprovalEntry.CurrentCompany());
        ApprovalEntry2.SetCurrentKey("Table ID", "Document Type", "Document No.", "Sequence No.");
        ApprovalEntry2.SetRange("Record ID to Approve", ApprovalEntry."Record ID to Approve");
        ApprovalEntry2.SetRange(Status, ApprovalEntry2.Status::Created);

        IF ApprovalEntry2.FindFirst() then begin
            ApprovalEntry3.CopyFilters(ApprovalEntry2);
            ApprovalEntry3.SetRange("Sequence No.", ApprovalEntry2."Sequence No.");
            if ApprovalEntry3.FindSet() then
                repeat
                    ApprovalEntry3.VALIDATE(Status, ApprovalEntry3.Status::Open);
                    ApprovalEntry3.Modify(true);
                    NotificationEntry.CreateNew(ApprovalEntry3."Approver ID", ApprovalEntry3, 0);
                until ApprovalEntry3.Next() = 0;
        end;
    end;

    procedure FindOpenApprovalEntriesForPayroll(ApprovalEntry: Record "Approval Entry ATG"): Boolean
    var
        ApprovalEntry2: Record "Approval Entry ATG";
    begin
        if CompanyNameG > '' then
            ApprovalEntry2.ChangeCompany(CompanyNameG);

        ApprovalEntry2.SetRange("Record ID to Approve", ApprovalEntry."Record ID to Approve");
        ApprovalEntry2.SetRange(Status, ApprovalEntry2.Status::Open);
        ApprovalEntry2.SetRange("Sequence No.", ApprovalEntry."Sequence No.");
        exit(not ApprovalEntry2.IsEmpty());
    end;

    procedure SendApprovalRequestFromRecord(RecRef: RecordRef; ApprovalEntryP: Record "Approval Entry ATG")
    var
        ApprovalEntry: Record "Approval Entry ATG";
        ApprovalEntry2: Record "Approval Entry ATG";
        LeaveRequest: Record "Leave Request";
        OverTime: Record "Over Time";
    begin

        if FindOpenApprovalEntriesForPayroll(ApprovalEntryP) then
            exit;
        if CompanyNameG > '' then begin
            ApprovalEntry.ChangeCompany(CompanyNameG);
            ApprovalEntry2.ChangeCompany(CompanyNameG);
            LeaveRequest.ChangeCompany(CompanyNameG);
            NotificationEntry.ChangeCompany(CompanyNameG);
        end;
        ApprovalEntry.SetCurrentKey("Table ID", "Record ID to Approve", Status, "Sequence No.");
        ApprovalEntry.SetRange("Table ID", RecRef.Number());
        ApprovalEntry.SetRange("Record ID to Approve", RecRef.RecordId());
        ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Created);
        if ApprovalEntry.FindFirst() then begin
            ApprovalEntry2.CopyFilters(ApprovalEntry);
            ApprovalEntry2.SetRange("Sequence No.", ApprovalEntry."Sequence No.");
            if ApprovalEntry2.FindSet(true) then
                repeat
                    ApprovalEntry2.Validate(Status, ApprovalEntry2.Status::Open);
                    ApprovalEntry2.Modify(true);
                    NotificationEntry.CreateNew(ApprovalEntry2."Approver ID", ApprovalEntry2, 0);
                until ApprovalEntry2.Next() = 0;
            //IF FindApprovedApprovalEntryForWorkflowUserGroup(ApprovalEntry, WorkflowStepInstance) THEN
            //    OnApproveApprovalRequest(ApprovalEntry);

            ApprovalEntry2.CalcFields("Pending Approvals");
            case RecRef.Number() of
                Database::"Leave Request":
                    if ApprovalEntry2."Pending Approvals" <> 0 then begin
                        LeaveRequest.Get(ApprovalEntry2."Record ID to Approve");
                        LeaveRequest.Status := LeaveRequest.Status::"Pending Approval";
                        LeaveRequest.Modify(true);
                    end;
            end;
            exit;
        end;
        // ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Approved);
        // if ApprovalEntry.FindLast() then
        //     OnApproveApprovalRequest(ApprovalEntry)
        // else
        //     Error(NoApprovalRequestsFoundErr);

    end;

    procedure ApproveApprovalRequests(var ApprovalEntry: Record "Approval Entry ATG")
    var
        RecRef: RecordRef;
        Variant: Variant;
    begin
        if ApprovalEntry.FindSet(true) then
            repeat
                GlobalAproverID := ApprovalEntry."Approver ID";
                ApproveSelectedApprovalRequest(ApprovalEntry);
            until ApprovalEntry.Next() = 0;
        RecRef.Open(Database::"Leave Request");
        RecRef.ChangeCompany(ApprovalEntry.CurrentCompany());
        RecRef.Get(ApprovalEntry."Record ID to Approve");

        Variant := RecRef;
        SendApprovalRequestForApproval(Variant, ApprovalEntry);
    end;

    procedure ApproveSelectedApprovalRequest(var ApprovalEntry: Record "Approval Entry ATG")
    var
        LeaveRequest: Record "Leave Request";
        OverTime: Record "Over Time";
        RecRef: RecordRef;
    begin
        IF ApprovalEntry.Status <> ApprovalEntry.Status::Open THEN
            Error(ApproveOnlyOpenRequestsErr);

        IF ApprovalEntry."Approver ID" <> GlobalAproverID THEN
            CheckUserAsApprovalAdministrator(ApprovalEntry);

        ApprovalEntry.Validate(Status, ApprovalEntry.Status::Approved);
        ApprovalEntry.Modify(true);

        ApprovalEntry.CalcFields("Pending Approvals");
        if not RecRef.Get(ApprovalEntry."Record ID to Approve") then begin
            RecRef.Open(Database::"Leave Request");
            RecRef.ChangeCompany(ApprovalEntry.CurrentCompany());
            RecRef.Get(ApprovalEntry."Record ID to Approve");
            LeaveRequest.ChangeCompany(ApprovalEntry.CurrentCompany());
            CompanyNameG := ApprovalEntry.CurrentCompany();
        end;
        case RecRef.Number() of
            Database::"Leave Request":
                begin
                    RecRef.SetTable(LeaveRequest);
                    if ApprovalEntry."Pending Approvals" = 0 then begin
                        LeaveRequest.Status := LeaveRequest.Status::Approved;
                        LeaveRequest.Modify(true);
                    end;
                end;
        end;
    end;

    procedure CheckUserAsApprovalAdministrator(ApprovalEntry: Record "Approval Entry ATG")
    var
        ApprovalUserSetup: Record "Approval User Setup ATG";
    begin
        ApprovalUserSetup.Get(GlobalAproverID, ApprovalUserSetup."Approval For"::"Leave Request");
        ApprovalUserSetup.TestField("Approval Administrator");
    end;

    procedure RejectApprovalRequests(var ApprovalEntry: Record "Approval Entry ATG")
    var
        LeaveRequest: Record "Leave Request";
        OverTime: Record "Over Time";
        RecRef: RecordRef;
        Variant: Variant;
    begin
        if ApprovalEntry.FindSet(true) then begin
            if not RecRef.Get(ApprovalEntry."Record ID to Approve") then begin
                RecRef.Open(Database::"Leave Request");
                RecRef.ChangeCompany(ApprovalEntry.CurrentCompany());
                RecRef.Get(ApprovalEntry."Record ID to Approve");
                LeaveRequest.ChangeCompany(ApprovalEntry.CurrentCompany());
                CompanyNameG := ApprovalEntry.CurrentCompany();
            end;
            case RecRef.Number() of
                Database::"Leave Request":
                    begin
                        LeaveRequest.Get(ApprovalEntry."Record ID to Approve");
                        Variant := LeaveRequest;
                        RejectAllApprovalRequests(Variant);
                        LeaveRequest.Status := LeaveRequest.Status::Rejected;
                        LeaveRequest.Modify(true);
                    end;
            end;
        end;
    end;

    procedure RejectSelectedApprovalRequest(var ApprovalEntry: Record "Approval Entry ATG")
    begin
        if ApprovalEntry.Status <> ApprovalEntry.Status::Open then
            Error(RejectOnlyOpenRequestsErr);

        if ApprovalEntry."Approver ID" <> GlobalAproverID then
            CheckUserAsApprovalAdministrator(ApprovalEntry);

        ApprovalEntry.Get(ApprovalEntry."Entry No.");
        ApprovalEntry.Validate(Status, ApprovalEntry.Status::Rejected);
        ApprovalEntry.Modify(true);
    end;

    procedure RejectAllApprovalRequests(Variant: Variant)
    var
        ApprovalEntry: Record "Approval Entry ATG";
        RecRef: RecordRef;
    begin
        RecRef.GetTable(Variant);
        case RecRef.Number() of
            Database::"Approval Entry":
                begin
                    ApprovalEntry := Variant;
                    RecRef.Get(ApprovalEntry."Record ID to Approve");
                    RejectAllApprovalRequests(RecRef);
                end;
            else
                RejectApprovalRequestsForRecord(RecRef);
        end;
    end;

    procedure RejectApprovalRequestsForRecord(RecRef: RecordRef)
    var
        ApprovalEntry: Record "Approval Entry ATG";
        OldStatus: Option;
    begin
        if CompanyNameG > '' then
            ApprovalEntry.ChangeCompany(CompanyNameG);
        ApprovalEntry.SetCurrentKey("Table ID", "Document Type", "Document No.", "Sequence No.");
        ApprovalEntry.SetRange("Table ID", RecRef.Number());
        ApprovalEntry.SetRange("Record ID to Approve", RecRef.RecordId());
        ApprovalEntry.SetFilter(Status, '<>%1&<>%2', ApprovalEntry.Status::Rejected, ApprovalEntry.Status::Canceled);
        if ApprovalEntry.FindSet(true) then
            repeat
                OldStatus := ApprovalEntry.Status;
                ApprovalEntry.Validate(Status, ApprovalEntry.Status::Rejected);
                ApprovalEntry.Modify(true);
                if (OldStatus in [ApprovalEntry.Status::Open, ApprovalEntry.Status::Approved]) and
                   (ApprovalEntry."Approver ID" <> GlobalSenderID)
                then
                    NotificationEntry.CreateNew(ApprovalEntry."Approver ID", ApprovalEntry, 0);
            until ApprovalEntry.Next() = 0;
        // IF ApprovalEntry."Approver ID" <> ApprovalEntry."Sender ID" THEN
        //     ApprovalEntry."Approver ID" := ApprovalEntry."Sender ID";
        // NotificationEntry.CreateNew(ApprovalEntry."Approver ID", ApprovalEntry, 0);
    end;

    local procedure CreateApprovalRequestForDirectApprover(ApprovalSetup: Record "Approval Setup ATG"; ApprovalEntryArgument: Record "Approval Entry ATG")
    var
        ApprovalEntry: Record "Approval Entry ATG";
        Employee: Record "Employee ATG";
        ApprovalUserSetup: Record "Approval User Setup ATG";
        SequenceNo: Integer;
        ApproverId: Code[20];
    begin
        ApproverId := GlobalSenderID;

        if not Employee.Get(ApproverId) then
            Error(ApproverUserIdNotInSetupErr, ApprovalEntry."Sender ID");
        ApprovalEntry.ChangeCompany(Employee."Company ATG");
        ApprovalUserSetup.ChangeCompany(Employee."Company ATG");
        ApprovalEntry.SetCurrentKey("Record ID to Approve", "Sequence No.");
        ApprovalEntry.SetRange("Table ID", ApprovalEntryArgument."Table ID");
        ApprovalEntry.SetRange("Record ID to Approve", ApprovalEntryArgument."Record ID to Approve");
        ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Created);
        if ApprovalEntry.FindLast() then
            ApproverId := ApprovalEntry."Approver ID";


        case ApprovalEntryArgument."Table ID" of
            Database::"Leave Request":
                ApprovalUserSetup.Get(GlobalSenderID, ApprovalUserSetup."Approval For"::"Leave Request");
        end;

        ApproverId := ApprovalUserSetup."Approver ID";
        case ApprovalEntryArgument."Table ID" of
            Database::"Leave Request":
                ApprovalUserSetup.Get(ApproverId, ApprovalUserSetup."Approval For"::"Leave Request");
        end;
        if ApproverId = '' then
            Error(NoSuitableApproverFoundErr);

        if not Employee.Get(ApproverId) then
            ERROR(ApproverUserIdNotInSetupErr, Employee."No. ATG");

        SequenceNo := GetLastSequenceNo(ApprovalEntryArgument) + 1;
        MakeApprovalEntry(ApprovalEntryArgument, SequenceNo, ApproverId, ApprovalSetup);
    end;

    var
        NotificationEntry: Record "Notification Entry ATG";
        ApprovalCheckErr: Label 'Approval is not enabled for Employee No.: %1 & Approval For: %2';
        ApproverUserIdNotInSetupErr: Label 'You must set up an approver for Employee No. %1 in the Approval User Setup ATG window.';
        NoSuitableApproverFoundErr: Label 'No qualified approver was found.';
        ApproveOnlyOpenRequestsErr: Label 'You can only approve open approval requests.';
        RejectOnlyOpenRequestsErr: Label 'You can only reject open approval entries.';
        UserIdNotInSetupErr: Label 'Employee No. %1 does not exist in the Approval User Setup window.';
        NoWFUserGroupMembersErr: Label 'A workflow group with at least one member must be set up.';
        WFUserGroupNotInSetupErr: Label 'The workflow group member with Employee No. %1 does not exist in the Approval User Setup window.';
        GlobalSenderID: Code[20];
        GlobalAproverID: Code[20];
        CompanyNameG: Text;

}