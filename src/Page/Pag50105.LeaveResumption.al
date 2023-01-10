page 50105 "Leave Resumption"
{
    PageType = ListPart;
    UsageCategory = None;
    SourceTable = "Leave Resumption";
    Caption = 'Leave Resumption';
    DelayedInsert = true;
    AutoSplitKey = true;
    InsertAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Start Date"; Rec."Start Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Start Date';

                }
                field("End Date"; Rec."End Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the End Date';

                }
                field("Resumption Date"; Rec."Resumption Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Resumption Date';

                }
                field("Resumption Days"; Rec."Resumption Days")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Resumption Days';

                }
                field("Resumption Type"; Rec."Resumption Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Resumption Type';

                }
                field("Resumption Action"; Rec."Resumption Action")
                {
                    ApplicationArea = All;
                    Editable = Rec."Resumption Type" = Rec."Resumption Type"::"Late Return";
                    ToolTip = 'Specifies the value of the Resumption Action';

                }
                field(Status; Rec.Status) // added temporarily for testing
                {
                    ApplicationArea = all;
                    Editable = true;
                    ToolTip = 'Specifies the value of the Status';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Leave Resumption")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                Image = CreateSerialNo;
                PromotedCategory = Process;
                ToolTip = 'Executes the Leave Resumption action.';
                trigger OnAction()
                var
                    LeaveResumptionReportL: Report "Leave Resumption";
                begin
                    LeaveResumptionReportL.SetParams(Rec."Leave Request No.");
                    LeaveResumptionReportL.RunModal();
                end;
            }
            action("Send Approval Request")
            {
                Caption = 'Send Approval Request';
                Image = SendApprovalRequest;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                ApplicationArea = all;
                Enabled = Rec.Status = Rec.Status::open;
                ToolTip = 'Executes the Send Approval Request action.';
                trigger OnAction()
                begin
                    if HrmsApprovalManagementG.CheckLeaveResumptionApprovalWorkflowEnabled(Rec) then
                        HrmsApprovalManagementG.OnSendLeaveResumptionforApproval(Rec);
                end;
            }
            action("Cancel Approval Request")
            {
                Caption = 'Cancel Request Approval';
                ApplicationArea = All;
                Image = CancelApprovalRequest;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Enabled = Rec.Status = Rec.Status::"Pending Approval";
                ToolTip = 'Executes the Cancel Request Approval action.';
                trigger OnAction()
                begin
                    HrmsApprovalManagementG.OnCancelLeaveResumptionforApproval(Rec);
                end;
            }
        }

    }
    var
        HrmsApprovalManagementG: Codeunit "HRMS Approval Management";
}