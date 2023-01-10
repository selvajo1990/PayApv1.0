page 60022 "Travel & Expense Configuration"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'Travel & Expense Configurations';
    SourceTable = "Travel & Expense Configuration";

    layout
    {
        area(Content)
        {
            repeater(Expense)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Code';
                }
                field("Travel & Expense Group"; Rec."Travel & Expense Group Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Travel & Expense Group Code';
                }
                field("Destination Code"; Rec."Destination Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Destination Code';
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
                field("Expense Code"; Rec."Expense Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Expense Code';
                }
                field("Expense Description"; Rec."Expense Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Expense Description';
                }
                field("Max Amount"; Rec."Max Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Value';
                }
                field(Currency; Rec.Currency)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Currency';
                }
            }
        }
    }
}