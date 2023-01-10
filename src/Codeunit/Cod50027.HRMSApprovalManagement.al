codeunit 50027 "HRMS Approval Management"
{
    trigger OnRun()
    begin
    end;

    var
        WorkflowManagementG: Codeunit "Workflow Management";
        NoWorkflowEnabledErr: Label 'No approval workflow for this record type is enabled.';

    // Set document status to Pending Approval.
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnSetStatusToPendingApproval', '', true, true)]
    local procedure SetStatusToPendingApproval(RecRef: RecordRef; var Variant: Variant; var IsHandled: Boolean)
    var
        LeaveRequestL: Record "Leave Request";
        LeaveResumptionL: Record "Leave Resumption";
    begin
        case RecRef.Number() of
            DATABASE::"Leave Request":
                begin
                    RecRef.SetTable(LeaveRequestL);
                    LeaveRequestL.Status := LeaveRequestL.Status::"Pending Approval";
                    LeaveRequestL.Modify(true);
                    Variant := LeaveRequestL;
                    IsHandled := true;
                end;
            Database::"Leave Resumption":
                begin
                    RecRef.SetTable(LeaveResumptionL);
                    LeaveResumptionL.Status := LeaveResumptionL.Status::"Pending Approval";
                    LeaveResumptionL.Modify(true);
                    Variant := LeaveResumptionL;
                    IsHandled := true;
                end;
        end;
    end;

    // Reopen the document.
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnOpenDocument', '', true, true)]
    local procedure ReOpenDocument(RecRef: RecordRef; var Handled: Boolean)
    var
        LeaveRequestL: Record "Leave Request";
        LeaveResumptionL: Record "Leave Resumption";
    begin
        case RecRef.Number() of
            DATABASE::"Leave Request":
                begin
                    RecRef.SetTable(LeaveRequestL);
                    if LeaveRequestL.Status = LeaveRequestL.Status::Open then
                        exit;
                    LeaveRequestL.Status := LeaveRequestL.Status::Open;
                    LeaveRequestL.Modify(true);
                    Handled := true;
                end;
            Database::"Leave Resumption":
                begin
                    RecRef.SetTable(LeaveResumptionL);
                    if LeaveResumptionL.Status = LeaveResumptionL.Status::Open then
                        exit;
                    LeaveResumptionL.Status := LeaveResumptionL.Status::Open;
                    LeaveResumptionL.Modify(true);
                    Handled := true
                end;
        end;
    end;

    // Release the document.
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnReleaseDocument', '', true, true)]
    local procedure ApproveDocument(RecRef: RecordRef; var Handled: Boolean)
    var
        LeaveRequestL: Record "Leave Request";
        LeaveResumptionL: Record "Leave Resumption";
    begin
        case RecRef.Number() of
            DATABASE::"Leave Request":
                begin
                    RecRef.SetTable(LeaveRequestL);
                    LeaveRequestL.Status := LeaveRequestL.Status::Approved;
                    LeaveRequestL.Modify(true);
                    Handled := true;
                end;
            Database::"Leave Resumption":
                begin
                    RecRef.SetTable(LeaveResumptionL);
                    LeaveResumptionL.Status := LeaveResumptionL.Status::Approved;
                    LeaveResumptionL.Modify(true);
                    Handled := true
                end;
        end;
    end;

    procedure RunWorkflowOnSendLeaveRequestforApprovalCode(): Code[128]
    begin
        exit(CopyStr(UpperCase('RunWorkflowOnSendLeaveRequestforApproval'), 1, 128));
    end;

    [IntegrationEvent(true, false)]
    procedure OnSendLeaveRequestforApproval(var LeaveRequestP: Record "Leave Request")
    begin
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"HRMS Approval Management", 'OnSendLeaveRequestforApproval', '', true, true)]
    procedure RunWorkflowOnSendLeaveRequestforApproval(var LeaveRequestP: Record "Leave Request")
    begin
        WorkflowManagementG.HandleEvent(RunWorkflowOnSendLeaveRequestforApprovalCode(), LeaveRequestP);
    end;

    procedure RunWorkflowOnCancelLeaveRequestforApprovalCode(): Code[128]
    begin
        exit(CopyStr(UpperCase('RunWorkflowOnCancelLeaveRequestforApproval'), 1, 128));
    end;

    [IntegrationEvent(true, false)]
    procedure OnCancelLeaveRequestforApproval(var LeaveRequestP: Record "Leave Request")
    begin
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"HRMS Approval Management", 'OnCancelLeaveRequestforApproval', '', true, true)]
    procedure RunWorkflowOnCancelLeaveRequestforApproval(var LeaveRequestP: Record "Leave Request")
    begin
        WorkflowManagementG.HandleEvent(RunWorkflowOnCancelLeaveRequestforApprovalCode(), LeaveRequestP);
    end;

    procedure RunWorkflowOnApproveApprovalRequestforLeaveRequestCode(): Code[128]
    begin
        exit(CopyStr(UpperCase('RunWorkflowOnApproveApprovalRequestforLeaveRequest'), 1, 128));
    end;

    procedure RunWorkflowOnRejectApprovalRequestforLeaveRequestCode(): Code[128]
    begin
        exit(CopyStr(UpperCase('RunWorkflowOnRejectApprovalRequestforLeaveRequest'), 1, 128));
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnRejectApprovalRequest', '', true, true)]
    procedure RunWorkflowOnRejectApprovalRequestforLeaveRequest(var ApprovalEntry: Record "Approval Entry")
    var
        LeaveRequestL: Record "Leave Request";
    begin
        WorkflowManagementG.HandleEventOnKnownWorkflowInstance(RunWorkflowOnRejectApprovalRequestforLeaveRequestCode(),
        ApprovalEntry, ApprovalEntry."Workflow Step Instance ID");
        if LeaveRequestL.Get(ApprovalEntry."Document No.") then begin
            LeaveRequestL.Status := LeaveRequestL.Status::Rejected;
            LeaveRequestL.Modify(true);
        end;
    end;

    procedure RunWorkflowOnDelegateApprovalRequestforLeaveRequestCode(): Code[128]
    begin
        exit(CopyStr(UpperCase('RunWorkflowOnDelegateApprovalRequestforLeaveRequest'), 1, 128));
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnDelegateApprovalRequest', '', true, true)]
    procedure RunWorkflowOnDelegateApprovalRequestforLeaveRequest(var ApprovalEntry: Record "Approval Entry")
    var
        LeaveRequestL: Record "Leave Request";
    begin
        WorkflowManagementG.HandleEventOnKnownWorkflowInstance(RunWorkflowOnDelegateApprovalRequestforLeaveRequestCode(),
        ApprovalEntry, ApprovalEntry."Workflow Step Instance ID");
        if LeaveRequestL.Get(ApprovalEntry."Document No.") then begin
            LeaveRequestL.Status := LeaveRequestL.Status::Delegated;
            LeaveRequestL.Modify(true);
        end;
    end;

    // To set the additional field values for approval entry
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnPopulateApprovalEntryArgument', '', true, true)]
    local procedure ApprovalCall(var ApprovalEntryArgument: Record "Approval Entry"; var RecRef: RecordRef)
    var
        LeaveRequestL: Record "Leave Request";
        LeaveResumptionL: Record "Leave Resumption";
    begin
        case RecRef.Number() of
            Database::"Leave Request":
                begin
                    RecRef.SetTable(LeaveRequestL);
                    ApprovalEntryArgument."Document No." := LeaveRequestL."No.";
                end;
            Database::"Leave Resumption":
                begin
                    RecRef.SetTable(LeaveResumptionL);
                    ApprovalEntryArgument."Document No." := LeaveResumptionL."Leave Request No.";
                end;
        end;
    end;

    // checks the workflow activation
    procedure CheckLeaveRequestApprovalWorkflowEnabled(var LeaveRequestP: Record "Leave Request"): Boolean
    begin
        if not IsLeaveRequestApprovalWorkflowEnabled(LeaveRequestP) then
            Error(NoWorkflowEnabledErr);
        exit(true);
    end;

    procedure IsLeaveRequestApprovalWorkflowEnabled(LeaveRequestP: Record "Leave Request"): Boolean
    begin
        exit(WorkflowManagementG.CanExecuteWorkflow(LeaveRequestP, RunWorkflowOnSendLeaveRequestforApprovalCode()));
    end;

    // Events for Leave Request

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventsToLibrary', '', true, true)]
    local procedure AddWorkflowEventsToLibrary()
    var
        WorkflowEventHandlingL: Codeunit "Workflow Event Handling";
    begin
        WorkflowEventHandlingL.AddEventToLibrary(RunWorkflowOnSendLeaveRequestforApprovalCode(), Database::"Leave Request",
                'Approval of a Leave is requested.', 0, false);
        WorkflowEventHandlingL.AddEventToLibrary(RunWorkflowOnCancelLeaveRequestforApprovalCode(), Database::"Leave Request",
                'An approval request for a Leave is canceled.', 0, false);
        WorkflowEventHandlingL.AddEventToLibrary(RunWorkflowOnApproveApprovalRequestforLeaveRequestCode(), Database::"Approval Entry",
                'An approval request for a Leave is approved.', 0, false);
        WorkflowEventHandlingL.AddEventToLibrary(RunWorkflowOnRejectApprovalRequestforLeaveRequestCode(), Database::"Approval Entry",
                'An approval request for a Leave is rejected.', 0, false);
        WorkflowEventHandlingL.AddEventToLibrary(RunWorkflowOnDelegateApprovalRequestforLeaveRequestCode(), Database::"Approval Entry",
                'An approval request for a Leave is delegated.', 0, false);
        // Leave Resumption
        WorkflowEventHandlingL.AddEventToLibrary(RunWorkflowOnSendLeaveResumptionforApprovalCode(), Database::"Leave Resumption",
                'Approval of Leave Resumption is requested', 0, false);
        WorkflowEventHandlingL.AddEventToLibrary(RunWorkflowOnCancelLeaveResumptionforApprovalCode(), Database::"Leave Resumption",
                'An approval request for a Leave Resumption is canceled.', 0, false);
        WorkflowEventHandlingL.AddEventToLibrary(RunWorkflowOnApproveApprovalRequestforLeaveResumptionCode(), Database::"Approval Entry",
                'An approval request for a Leave Resumption is approved.', 0, false);
        WorkflowEventHandlingL.AddEventToLibrary(RunWorkflowOnRejectApprovalRequestforLeaveResumptionCode(), Database::"Approval Entry",
                'An approval request for a Leave Resumption is rejected.', 0, false);
        WorkflowEventHandlingL.AddEventToLibrary(RunWorkflowOnDelegateApprovalRequestforLeaveResumptionCode(), Database::"Approval Entry",
                'An approval request for a Leave Resumption is delegated.', 0, false);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowTableRelationsToLibrary', '', true, true)]
    local procedure AddWorkflowTableRelationToLibrary()
    var
        WorkflowSetupL: Codeunit "Workflow Setup";
    begin
        WorkflowSetupL.InsertTableRelation(Database::"Leave Request", 0, Database::"Approval Entry", 22);
        WorkflowSetupL.InsertTableRelation(Database::"Leave Resumption", 0, Database::"Approval Entry", 22);
    end;
    // Leave Resumption
    procedure RunWorkflowOnSendLeaveResumptionforApprovalCode(): Code[128]
    begin
        exit(CopyStr(UpperCase('RunWorkflowOnSendLeaveResumptionforApproval'), 1, 128));
    end;

    procedure RunWorkflowOnCancelLeaveResumptionforApprovalCode(): Code[128]
    begin
        exit(CopyStr(UpperCase('RunWorkflowOnCancelLeaveResumptionforApproval'), 1, 128));
    end;

    procedure RunWorkflowOnApproveApprovalRequestforLeaveResumptionCode(): Code[128]
    begin
        exit(CopyStr(UpperCase('RunWorkflowOnApprovalRequestforLeaveResumption'), 1, 128));
    end;

    procedure RunWorkflowOnRejectApprovalRequestforLeaveResumptionCode(): Code[128]
    begin
        exit(CopyStr(UpperCase('RunWorkflowOnRejectApprovalRequestforLeaveResumption'), 1, 128));
    end;

    procedure RunWorkflowOnDelegateApprovalRequestforLeaveResumptionCode(): Code[128]
    begin
        exit(CopyStr(UpperCase('RunWorkflowOnDelegateApprovalRequestforLeaveResumption'), 1, 128));
    end;

    procedure CheckLeaveResumptionApprovalWorkflowEnabled(var LeaveResumptionP: Record "Leave Resumption"): Boolean
    begin
        if not IsLeaveResumptionApprovalWorkflowEnabled(LeaveResumptionP) then
            Error(NoWorkflowEnabledErr);
        exit(true);
    end;

    procedure IsLeaveResumptionApprovalWorkflowEnabled(LeaveResumptionP: Record "Leave Resumption"): Boolean
    begin
        exit(WorkflowManagementG.CanExecuteWorkflow(LeaveResumptionP, RunWorkflowOnSendLeaveResumptionforApprovalCode()));
    end;

    [IntegrationEvent(true, false)]
    procedure OnSendLeaveResumptionForApproval(var LeaveResumptionP: Record "Leave Resumption")
    begin
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"HRMS Approval Management", 'OnSendLeaveResumptionForApproval', '', true, true)]
    procedure RunWorkflowOnSendLeaveResumptionforApproval(var LeaveResumptionP: Record "Leave Resumption")
    begin
        WorkflowManagementG.HandleEvent(RunWorkflowOnSendLeaveResumptionforApprovalCode(), LeaveResumptionP);
    end;

    [IntegrationEvent(true, false)]
    procedure OnCancelLeaveResumptionforApproval(var LeaveResumptionP: Record "Leave Resumption")
    begin
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"HRMS Approval Management", 'OnCancelLeaveResumptionforApproval', '', true, true)]
    procedure RunWorkflowOnCancelLeaveResumptionforApproval(var LeaveResumptionP: Record "Leave Resumption")
    begin
        WorkflowManagementG.HandleEvent(RunWorkflowOnCancelLeaveResumptionforApprovalCode(), LeaveResumptionP);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnRejectApprovalRequest', '', true, true)]
    procedure RunWorkflowOnRejectApprovalRequestforLeaveResumption(var ApprovalEntry: Record "Approval Entry")
    var
        LeaveResumptionL: Record "Leave Resumption";
    begin
        WorkflowManagementG.HandleEventOnKnownWorkflowInstance(RunWorkflowOnRejectApprovalRequestforLeaveResumptionCode(),
        ApprovalEntry, ApprovalEntry."Workflow Step Instance ID");
        if LeaveResumptionL.Get(ApprovalEntry."Document No.") then begin
            LeaveResumptionL.Status := LeaveResumptionL.Status::Rejected;
            LeaveResumptionL.Modify(true);
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnDelegateApprovalRequest', '', true, true)]
    procedure RunWorkflowOnDelegateApprovalRequestforLeaveResumption(var ApprovalEntry: Record "Approval Entry")
    var
        LeaveResumptionL: Record "Leave Resumption";
    begin
        WorkflowManagementG.HandleEventOnKnownWorkflowInstance(RunWorkflowOnDelegateApprovalRequestforLeaveResumptionCode(),
        ApprovalEntry, ApprovalEntry."Workflow Step Instance ID");
        if LeaveResumptionL.Get(ApprovalEntry."Document No.") then begin
            LeaveResumptionL.Status := LeaveResumptionL.Status::Delegated;
            LeaveResumptionL.Modify(true);
        end;
    end;

}