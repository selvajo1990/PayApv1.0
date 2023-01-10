page 54318 "Approved Requests"
{
    PageType = List;
    ApplicationArea = All;
    Caption = 'Approved Requests';
    UsageCategory = Lists;
    SourceTable = "Approval Entry ATG";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(Approved; Rec.RecordCaption())
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the RecordCaption()';
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Document Type';
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Document No.';
                }
                field("Sender ID"; Rec."Sender ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the values of the Sender ID';
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
        }
    }

    var
        UserSetup: Record "User Setup";
        GetEmpNo: Codeunit "Single Instance";

    trigger OnOpenPage()
    begin
        if (UserSetup.Get(UserId)) and (UserSetup."Is ESS User") then begin
            Rec.FilterGroup(1);
            Rec.SetRange("Approver ID", GetEmpNo.GetEmpNo());
            Rec.FilterGroup(0);
        end
    end;
}