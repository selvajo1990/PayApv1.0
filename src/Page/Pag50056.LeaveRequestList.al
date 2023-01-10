page 50056 "Leave Request List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Leave Request";
    Caption = 'Leave Request List';
    CardPageId = "Leave Request Card";
    Editable = false;
    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No.';
                }
                field("Absence Code"; Rec."Absence Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Absence Code';
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Employee No.';
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Employee Name';
                }
                field("Start Date"; Rec."Start Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Start Date';
                }
                field("End Date"; Rec."End Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the End Date';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Status of the Leave Request';
                }
                field("Closing Balance"; Rec."Closing Balance")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Closing Balance';
                }
            }
        }

    }

    actions
    {
        area(Processing)
        {
            group("Request Approval")
            {
                Caption = 'Request Approval';
                Image = SendTo;
                action("Send Approval Request")
                {
                    Caption = 'Send Approval Request';
                    Image = SendApprovalRequest;
                    ApplicationArea = all;
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;
                    Enabled = Rec.Status = Rec.Status::open;
                    ToolTip = 'Executes the Send Approval Request action.';
                    trigger OnAction()
                    var
                        ConfirmationLbl: Label 'Do you want to send for approval?';
                    begin
                        if not Confirm(ConfirmationLbl) then
                            exit;
                        SendToApproval();
                    end;
                }
                // action("Cancel Approval Request")
                // {
                //     Caption = 'Cancel Request Approval';
                //     ApplicationArea = All;
                //     Image = CancelApprovalRequest;
                //     Promoted = true;
                //     PromotedIsBig = true;
                //     PromotedCategory = Process;
                //     Enabled = Rec.Status = Rec.Status::"Pending Approval";
                //     ToolTip = 'Executes the Cancel Request Approval action.';
                //     trigger OnAction()
                //     begin
                //         //HrmsManagementG.OnCancelLeaveRequestforApproval(Rec);
                //     end;
                // }
            }
        }
    }
    var
        UserSetup: Record "User Setup";
        HrmsManagementG: Codeunit "HRMS Approval Management";
        GetEmpNo: Codeunit "Single Instance";

    trigger OnOpenPage()
    begin
        if (UserSetup.Get(UserId)) and (UserSetup."Is ESS User") then begin
            Rec.FilterGroup(1);
            Rec.SetRange("Employee No.", GetEmpNo.GetEmpNo());
            Rec.FilterGroup(0);
        end
    end;

    procedure SendToApproval()
    var
        ApprovalMgmt: Codeunit "Approval Mgmt ATG";
        RecfRef: RecordRef;
        ApprovalFor: Option "Leave Request";
        Variant: Variant;
    begin
        Variant := Rec;
        RecfRef.GetTable(Variant);
        ApprovalMgmt.CreateApprovalRequests(RecfRef, ApprovalMgmt.CheckApprovalEnabled(Rec."Employee No.", ApprovalFor::"Leave Request"));
    end;
}