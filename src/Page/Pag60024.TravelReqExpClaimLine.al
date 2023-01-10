page 60024 "Travel Req. Exp. Claim Line"
{
    PageType = ListPart;
    Caption = 'Travel Requisition & Expense Claim Subpage';
    SourceTable = "Travel Req. & Exp. Claim Line";
    AutoSplitKey = true;
    DelayedInsert = true;
    layout
    {
        area(Content)
        {
            repeater("Expense Claim Line")
            {
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Document Date';
                }
                field("Travel & Expense Code"; Rec."Travel & Expense Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Travel & Expense Code';
                }
                field("Expense Description"; Rec."Expense Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Expense Description';
                }
                field(Destination; Rec.Destination)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Destination';
                }
                field("Destination Type Description"; Rec."Destination Type Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Destination Type Description';
                }
                field("Travel Payment Type"; Rec."Travel Payment Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Travel Payment Type';
                }
                field(Currency; Rec."Currency Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Currency Code';
                }
                field("Amount (FCY)"; Rec."Amount (FCY)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Value';
                }
                field("Amount (LCY)"; Rec."Amount (LCY)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Amount Claimed (LCY)';
                }
                field("Payable Amount"; Rec."Payable Amount (LCY)")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Payable Amount (LCY)';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(Attachment)
            {
                ApplicationArea = All;
                Image = Attachments;
                Promoted = true;
                PromotedIsBig = true;
                Caption = 'Attachment';
                ToolTip = 'Executes the Attachment action.';
                trigger OnAction()
                var
                    DocumentAttachment: Record "Document Attachment";
                    DocumentAttachmentDetails: Page "Document Attachment Details";
                    RecRef: RecordRef;
                begin
                    Rec.TestField("Attachment Required", true);
                    RecRef.GetTable(Rec);
                    DocumentAttachment.Reset();
                    DocumentAttachment.SetRange("Table ID", RecRef.Number());
                    DocumentAttachment.SetRange("Document Type", 0);
                    DocumentAttachment.SetRange("No.", Rec."Document No.");
                    DocumentAttachment.SetRange("Line No.", Rec."Line No.");
                    DocumentAttachmentDetails.SetTableView(DocumentAttachment);
                    DocumentAttachmentDetails.RunModal();
                end;
            }
        }
    }
}