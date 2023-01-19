page 60188 "Docuument Request"
{
    Caption = 'Document Request';
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Document Request";
    //Created by SKR 16-01-2023

    layout
    {
        area(Content)
        {
            group("Employee Document Request")
            {
                field("Req ID"; "Req ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Request ID';
                }
                field("Employee No."; "Employee No.")
                {
                    ApplicationArea = All;
                    Editable = IsEditable;
                    ShowMandatory = true;
                    ToolTip = 'Specifies the Employee No';
                }
                field("Employee Name"; "Employee Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Employee Name';
                }
                field("Request Date"; "Request Date")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                    ToolTip = 'Specifies the Request Date';
                }
                field("Requested Document"; "Requested Document")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                    ToolTip = 'Specifies the Requested Document';
                }
                field(Status; Status)
                {
                    ApplicationArea = All;
                    Editable = IsEditable;
                    ToolTip = 'Specifies the Status of the Request';
                }
                field("Issued Date"; "Issued Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Document Issued Date';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Request Document")
            {
                ApplicationArea = All;
                Caption = 'Request Document';
                Promoted = true;
                PromotedCategory = Process;
                Image = SendApprovalRequest;

                trigger OnAction()
                begin
                    if ("Requested Document" > 0) then
                        if Confirm('Do you want to request the Document?') then begin
                            Rec.Status := Status::"Pending Approval";
                            Message('Request Sent');
                        end else
                            exit else
                        Error('Please select a Document to request');
                end;
            }
        }
    }

    var
        GetEmpNo: Codeunit "Single Instance";
        UserSetupG: Record "User Setup";
        IsEditable: Boolean;

    trigger OnOpenPage()
    begin
        Clear(IsEditable);
        if UserSetupG.Get(UserId) and UserSetupG."Is ESS User" then
            IsEditable := false
        else
            IsEditable := true;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        if UserSetupG.Get(UserId) and UserSetupG."Is ESS User" then begin
            Rec."Employee No." := GetEmpNo.GetEmpNo();
        end;
    end;

}