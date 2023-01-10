page 50130 "Travel Req & Expense Claim"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Travel Req & Expense Claim";
    Caption = 'Travel Requisition & Expense Claim List';
    Editable = false;
    CardPageId = 60025;

    layout
    {
        area(Content)
        {
            repeater("Expense Claim")
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No.';
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
            }
        }
    }
}