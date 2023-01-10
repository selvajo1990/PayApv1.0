page 50134 "Expense Category"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Expense Category";
    Caption = 'Expense Category';

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
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description';
                }
                field("Travel Payment Type"; Rec."Travel Payment Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Travel Payment Type';
                }
                field("Travel Type"; Rec."Travel Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Expense Type';
                    trigger OnValidate()
                    begin
                        Rec."Main Account" := '';
                        Rec."Sub Account" := '';
                    end;
                }
                field("Main Account"; Rec."Main Account")
                {
                    ApplicationArea = All;
                    Editable = Rec."Travel Type" = Rec."Travel Type"::Advance;
                    ToolTip = 'Specifies the value of the Main Account';
                }
                field("Sub Account"; Rec."Sub Account")
                {
                    ApplicationArea = All;
                    Editable = Rec."Travel Type" = Rec."Travel Type"::Advance;
                    ToolTip = 'Specifies the value of the Sub Account';
                }
                field("Attachment Required"; Rec."Attachment Required")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Attachment Required';
                }
            }
        }
    }
}