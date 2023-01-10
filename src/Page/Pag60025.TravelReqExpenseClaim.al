page 60025 "Travel Req. Expense Claim"
{
    PageType = Document;
    SourceTable = "Travel Req & Expense Claim";
    UsageCategory = None;
    Caption = 'Travel Requisition & Expense Claim';
    layout
    {
        area(FactBoxes)
        {
            part("Advance Claim"; "Advance Claim Factbox")
            {
                ApplicationArea = All;
                SubPageLink = "No." = field("No.");
                UpdatePropagation = Both;
                Caption = 'Advance Details';
            }
            part("Attachment"; "Document Attachment Factbox")
            {
                ApplicationArea = All;
                Provider = "Claim Line";
                SubPageLink = "No." = field("Document No."), "Line No." = field("Line No."), "Table ID" = filter('54169');
                UpdatePropagation = Both;
                Caption = 'Attachment';
            }
        }
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
                    ToolTip = 'Specifies the value of the Employee No.';
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Employee Name';
                }
                field("Advance No."; Rec."Advance No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Advance No.';
                }
                field("From Date"; Rec."From Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the From Date';
                }
                field("To Date"; Rec."To Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the To Date';
                }
                field("Claim Date"; Rec."Claim Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Claim Date';
                }
                field("Approved Date"; Rec."Approved Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Approved Date';
                }
                field("No. of Days"; Rec."No. of Days")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. of Days';
                }
                field("Pay with Salary"; Rec."Pay with Salary")
                {
                    Visible = false;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Pay with Salary';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Status';
                }
            }
            part("Claim Line"; "Travel Req. Exp. Claim Line")
            {
                ApplicationArea = All;
                SubPageLink = "Document No." = field("No."), "Travel & Expense Group Code" = field("Travel & Expense Group Code");
                UpdatePropagation = Both;
                Caption = 'Claim Lines';
            }
        }

    }
}