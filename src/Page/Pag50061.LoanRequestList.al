page 50061 "Loan Request List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Loan Request";
    Caption = 'Loan & Advance Requests';
    Editable = false;
    CardPageId = "Loan Request Card";
    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Loan Request No."; Rec."Loan Request No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Loan Request No.';
                }
                field("Loan Description"; Rec."Loan Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Loan Description';
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
                field("Loan Type"; Rec."Loan Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Loan Type';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Amount';
                }
            }
        }
        area(Factboxes)
        {

        }
    }
}