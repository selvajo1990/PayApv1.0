page 50116 "Payroll Posting Setup"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Payroll Posting Group";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                    Caption = 'Type';
                    ToolTip = 'Specifies the value of the Type';

                }
                field("Earning Code"; Rec."Earning Code")
                {
                    ApplicationArea = All;
                    Caption = 'Code';
                    ToolTip = 'Specifies the value of the Code';

                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Description';
                }
                field(Category; Rec.Category)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Category';
                }
                field("Debit Account"; Rec."Debit Account")
                {
                    ApplicationArea = All;
                    Caption = 'Account No.';
                    ToolTip = 'Specifies the value of the Account No.';

                }

                field("Credit Account"; Rec."Credit Account")
                {
                    ApplicationArea = All;
                    Caption = 'Bal. Account No.';
                    ToolTip = 'Specifies the value of the Bal. Account No.';

                }
            }
        }
    }
}