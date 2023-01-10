page 50059 "Loans"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = Loan;
    Caption = 'Loans & Advances';
    CardPageId = "Loan Card";
    Editable = false;
    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Loan Code"; Rec."Loan Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Loan Code';
                }
                field("Loan Description"; Rec."Loan Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Loan Description';
                }
            }
        }
        area(Factboxes)
        {

        }

    }
}