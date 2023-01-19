page 60157 "Salary Increment"
{

    PageType = Document;
    SourceTable = "Salary Increment Header";
    Caption = 'Salary Increment';
    UsageCategory = None;

    layout
    {
        area(content)
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
                        Rec.AssistEdit();
                        rec."Document Date" := Today;
                    end;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Document Date';
                }
                field("Effective Date"; Rec."Effective Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Effective Date';
                }
                field("Employee No."; rec."Employee No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Employee No.';

                }
                field("Employee Name"; rec."Employee Name")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of Employee Name';
                    Editable = false;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Status';
                }
                field("Approver Name"; rec."Approver Name")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Approved Name';
                }
                field("Approved Date"; Rec."Approved Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Approved Date';
                }
            }
            part("Increment Lines"; "Salary Increment Subpage")
            {
                Caption = 'Increment Lines';
                ApplicationArea = All;
                SubPageLink = "Document No." = field("No.");
            }
        }
    }

}
