page 50139 "Request to Approve ATG"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    Editable = false;
    SourceTable = "Approval Entry ATG";
    SourceTableView = order(descending) where(Status = filter(Open));
    Caption = 'Request to Approve ATG';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("To Approve"; Rec.RecordCaption())
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the RecordCaption()';
                }
                field(Comment; Rec.Comment)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Comment';
                }
                //<< Skr
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Document No.';
                }
                //>> Skr
                field("Sender ID"; Rec."Sender ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Sender ID';
                }
                field("Approver ID"; Rec."Approver ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Approver ID';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Status';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(Approve)
            {
                ApplicationArea = All;
                Caption = 'Approve';
                Image = Approve;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                ToolTip = 'Executes the Approve action.';
                trigger OnAction()
                begin
                    ApproveEntries();
                end;
            }
            action(Reject)
            {
                ApplicationArea = All;
                Caption = 'Reject';
                Image = Reject;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                ToolTip = 'Executes the Reject action.';
                trigger OnAction()
                begin
                    RejectEntries();
                end;
            }
            //<< skr
            action(ViewLeaveRequest)
            {
                ApplicationArea = All;
                Caption = 'View Leave Request';
                Image = ViewPage;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                ToolTip = 'Executes the ViewLeaveRequest action.';

                trigger OnAction()
                var
                    LeaveRequestL: Record "Leave Request";
                begin
                    LeaveRequestL.Reset();
                    LeaveRequestL.SetRange("No.", Rec."Document No.");
                    if LeaveRequestL.FindFirst() then
                        Page.RunModal(54132, LeaveRequestL)
                end;
            }
            //>> skr
        }
    }
    procedure ApproveEntries()
    var
        ApprovalEntry: Record "Approval Entry ATG";
        ApprovalMgmt: Codeunit "Approval Mgmt ATG";
    begin
        ApprovalEntry := Rec;
        ApprovalEntry.SetRecFilter();
        ApprovalMgmt.ApproveApprovalRequests(ApprovalEntry);
    end;

    procedure RejectEntries()
    var
        ApprovalEntry: Record "Approval Entry ATG";
        ApprovalMgmt: Codeunit "Approval Mgmt ATG";
    begin
        ApprovalEntry := Rec;
        ApprovalEntry.SetRecFilter();
        ApprovalMgmt.RejectApprovalRequests(ApprovalEntry);
    end;

}