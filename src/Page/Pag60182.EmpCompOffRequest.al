page 60182 "Employee Comp Off Requests"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Employee Compensatory Off";
    SourceTableView = where(Status = const("Pending Approval"));

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field("Entry No."; "Entry No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Entry No.';
                }
                field("Employee No."; "Employee No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifes the value of the Employee No.';
                }
                field("Employee Name"; "Employee Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Emplyee Name';
                }
                field("Source Date"; "Source Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Source Date';
                }
                field("No of Comp Days"; "No of Comp Days")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No of Comp of Days';
                }
                field(Status; Status)
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

    var
        myInt: Integer;
}