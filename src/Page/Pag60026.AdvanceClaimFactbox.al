page 60026 "Advance Claim Factbox"
{
    PageType = CardPart;
    SourceTable = "Travel Req & Expense Claim";

    layout
    {
        area(Content)
        {
            group("Advance Details")
            {
                Caption = '';
                field(Date; AdvanceLines."Document Date")
                {
                    ApplicationArea = All;
                    Caption = 'Date of Advance';
                    ToolTip = 'Specifies the value of the Date of Advance';
                }
                field(Amount; AdvanceLines."Amount (LCY)")
                {
                    ApplicationArea = All;
                    Caption = 'Advance Amount';
                    ToolTip = 'Specifies the value of the Advance Amount';
                }
                field(Destination; AdvanceLines.Destination)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Destination';
                }
                field("Purpose of Visit Description"; AdvanceLines."Purpose of Visit Description")
                {
                    ApplicationArea = All;
                    Caption = 'Purpose of Visit';
                    ToolTip = 'Specifies the value of the Purpose of Visit';
                }
                field("Amount Claimed"; Rec."Amount Claimed (LCY)")
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    ToolTip = 'Specifies the value of the Amount Claimed (LCY)';
                }
                field("Amount Payable"; Rec."Amount Payable (LCY)")
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    ToolTip = 'Specifies the value of the Amount Payable (LCY)';
                }
                field("Outstanding Amount (LCY)"; Rec."Outstanding Amount")
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    ToolTip = 'Specifies the value of the Outstanding Amount';
                }
            }
        }
    }
    var
        AdvanceLines: Record "Travel & Expense Advance";

    trigger OnFindRecord(Which: Text): Boolean
    begin
        exit(Rec.Find(Which));
    end;

    trigger OnAfterGetRecord()
    begin
        if Rec."Advance No." > '' then
            AdvanceLines.Get(Rec."Advance No.");
    end;

}