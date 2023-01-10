page 60180 "Employee Comp Off"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Employee Compensatory Off";

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
                    ToolTip = 'Specifies the value of the Employee No.';
                }
                field("Employee Name"; "Employee Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Employee Name';
                }
                field("Source Date"; "Source Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Source Date';
                }
                field("No of Comp Days"; "No of Comp Days")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No of Comp Days';
                }
                field(Status; Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Status';
                    Editable = false;
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
                Image = Approve;
                Visible = false;

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
                Image = Reject;
                Visible = false;
                trigger OnAction()
                begin
                    if Confirm('Do you want to Reject?') then begin
                        Rec.Status := Rec.Status::Rejected;
                        Rec.Modify();
                    end else
                        exit;
                end;
            }
            action("Reopen")
            {
                ApplicationArea = All;
                Caption = 'Reopen';
                Promoted = true;
                Image = ReOpen;
                Visible = false;
                trigger OnAction()
                begin
                    if Rec.Status = Rec.Status::Rejected then
                        if Confirm('Do you want to Reopen?') then begin
                            Rec.Status := Rec.Status::Open;
                            Rec.Modify();
                        end;
                end;
            }
        }
    }

    var
        myInt: Integer;
}