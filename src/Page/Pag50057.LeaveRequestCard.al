page 50057 "Leave Request Card"
{
    PageType = Card;
    SourceTable = "Leave Request";
    Caption = 'Leave Request';
    UsageCategory = None;
    layout
    {
        area(Content)
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
                    ShowMandatory = true;
                    //Editable = IsEditableG;
                    ToolTip = 'Specifies the value of the Employee No.';
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Employee Name';
                }
                field("Absence Code"; Rec."Absence Code")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                    NotBlank = true;
                    ToolTip = 'Specifies the value of the Absence Code';
                }
                field("Start Date"; Rec."Start Date")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                    ToolTip = 'Specifies the value of the Start Date';
                }
                field("From Period"; Rec."From Period")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the From Period';
                }
                field("End Date"; Rec."End Date")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                    ToolTip = 'Specifies the value of the End Date';
                }
                field("To Period"; Rec."To Period")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the To Period';
                }
                field(Hoildays; Rec.Hoildays)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Holidays';
                }
                field(Weekends; Rec.Weekends)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Weekends';
                }
                field("Leave Days"; Rec."Leave Days")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Leave Days';
                }
                field(Location; Rec.Location)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Location';
                }
                field("Contact No."; Rec."Contact No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Contact No.';
                }
                field("Current Balance"; Rec."Current Balance")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Current Balance';
                }
                field("Balance As On Start Date"; Rec."Balance As On Start Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Balance As On Start Date';
                }
                field("Closing Balance"; Rec."Closing Balance")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Closing Balance';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    //Editable = IsEditableG; 04-01-2022
                    Editable = true;
                    ToolTip = 'Specifies the value of the Status';
                }
            }
            part("Leave Salary"; "Leave Salary Subpage")
            {
                SubPageLink = "Computation No." = field("No."), Accrual = filter(false), Code = filter(<> ''), "Show in Payslip" = filter(true);
                Caption = 'Leave Salary';
                ApplicationArea = All;
            }
            part("Leave Resumption"; "Leave Resumption")
            {
                SubPageLink = "Leave Request No." = field("No.");
                Caption = 'Leave Resumption';
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(Processing)
        {
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
            action("Attachment")
            {
                ApplicationArea = All;
                Image = Attachments;
                ToolTip = 'Executes the Attachment action.';
                trigger OnAction()
                var
                    DocumentAttachmentL: Record "Document Attachment";
                    DocumentAttachmentDetailsL: Page "Document Attachment Details";
                    RecRefL: RecordRef;
                begin
                    RecRefL.GETTABLE(Rec);
                    DocumentAttachmentL.SetRange("Table ID", RecRefL.Number());
                    DocumentAttachmentL.SetRange("No.", Rec."No.");
                    DocumentAttachmentDetailsL.SetTableView(DocumentAttachmentL);
                    DocumentAttachmentDetailsL.RUNMODAL();
                end;
            }
        }
    }

    var
        UserSetup: Record "User Setup";
        SingleInstance: Codeunit "Single Instance";
        IsEditableG: Boolean;

    trigger OnOpenPage()
    begin
        if UserSetup.Get(UserId) and (UserSetup."Is ESS User") then
            if Rec."Employee No." <> SingleInstance.GetEmpNo() then
                IsEditableG := false
            else
                IsEditableG := true;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        if UserSetup.Get(UserId) and (UserSetup."Is ESS User") then
            Rec."Employee No." := SingleInstance.GetEmpNo();
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        LeaveRequestL: Record "Leave Request";
    begin
        if LeaveRequestL.Get(Rec."No.") then begin
            LeaveRequestL.TestField("Employee No.");
            LeaveRequestL.TestField("Absence Code");
            LeaveRequestL.TestField("Start Date");
            LeaveRequestL.TestField("End Date");
        end;
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