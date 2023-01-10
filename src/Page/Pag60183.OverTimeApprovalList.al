page 60183 "Over Time Approval List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Over Time";
    SourceTableView = where(Status = const("Pending Approval"));
    Caption = 'Over Time Approval List';

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field("OT No."; Rec."OT No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Entry No.';
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Employee No.';
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Employee Name.';
                }
                field("Source Date"; Rec."Source Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Source Date.';
                }
                field("Over Tme Hours"; Rec."Over Tme Hours")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Over Time Hours.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = all;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Status.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Approve")
            {
                ApplicationArea = All;
                Caption = 'Approve';
                Promoted = true;
                PromotedCategory = Process;
                Image = Approve;

                trigger OnAction()
                begin
                    If Confirm('Do you Want to send Approve?') then begin
                        Rec.Status := Rec.Status::Approved;
                        Rec.Modify();
                    end else
                        exit;
                end;
            }
            action("Reject")
            {
                ApplicationArea = All;
                Caption = 'Reject';
                Promoted = True;
                PromotedCategory = Process;
                Image = Reject;
                trigger OnAction()
                begin
                    if Confirm('Do you want to Reject?') then begin
                        Rec.Status := Rec.Status::Rejected;
                        Rec.Modify();
                    end else
                        exit;
                end;
            }
        }
    }

}




