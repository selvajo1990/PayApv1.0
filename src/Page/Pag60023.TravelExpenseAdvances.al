page 60023 "Travel & Expense Advances"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    Editable = false;
    CardPageId = 60027;
    SourceTable = "Travel & Expense Advance";
    Caption = 'Travel & Expense Advances';
    layout
    {
        area(Content)
        {
            repeater(Expense)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No.';
                }
                field(Date; Rec."Document Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Document Date';
                }
                field("Approved Date"; Rec."Approved Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Approved Date';
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Employee Name';
                }
                field(Destination; Rec.Destination)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Destination';
                }
                field("Purpose of Visit Description"; Rec."Purpose of Visit Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Purpose of Visit Description';
                }
                field("Expense Category Description"; Rec."Expense Category Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Expense Category Description';
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Currency Code';
                }
                field("Amount (FCY)"; Rec."Amount (FCY)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Amount (FCY)';
                }
                field(Amount; Rec."Amount (LCY)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Amount (LCY)';
                }
                field("Pay With Salary"; Rec."Pay With Salary")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Pay With Salary';
                }
            }
        }

    }
    actions
    {
        area(Processing)
        {
            action("Create Travel Journals")
            {
                ApplicationArea = All;
                Caption = 'Create Travel Journals';
                Image = CreateDocuments;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the Create Travel Journals action.';
                trigger OnAction()
                var
                    TravelExpenseAdvanceCard: Page "Travel & Expense Advance Card";
                begin
                    TravelExpenseAdvanceCard.MakeJournal(Rec.RecordId());
                end;
            }
        }
    }
}