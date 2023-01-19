page 60187 "Document Requests"
{
    Caption = 'Document Requests';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Document Request";
    CardPageId = "Docuument Request";
    Editable = false;
    //Created by SKR 16-01-2023

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Req ID"; "Req ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Request ID';
                }
                field("Employee No."; "Employee No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Employee No.';
                }
                field("Employee Name"; "Employee Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Employee Name';
                }
                field("Request Date"; "Request Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Request Date';
                }
                field("Requested Document"; "Requested Document")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Requested Document';
                }
                field(Status; Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Status of the Request';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {

        }
    }

    var

}