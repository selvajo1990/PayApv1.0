page 54215 "Travel & Expense Setup"
{

    PageType = Card;
    SourceTable = "Travel & Expense Setup";
    Caption = 'Travel & Expense Setup';
    ApplicationArea = All;
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Travel & Expense Jnl. Template"; Rec."Travel & Expense Jnl. Template")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Travel & Expense Jnl. Template';
                }
                field("Travel & Expense Jnl. Batch"; Rec."Travel & Expense Jnl. Batch")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Travel & Expense Jnl. Batch';
                }
            }
            group("Numbering")
            {
                field("Travel & Expense Advance Nos."; Rec."Travel & Expense Advance Nos.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Travel & Expense Advance Nos.';
                }
                field("Travel Req. & Exp. Claim Nos."; Rec."Travel Req. & Exp. Claim Nos.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Travel Requisition & Expense Claim';
                }
            }
        }
    }
    trigger OnOpenPage()
    begin
        Rec.Reset();
        IF NOT Rec.Get() THEN BEGIN
            Rec.Init();
            Rec.Insert();
        END;
    end;
}
