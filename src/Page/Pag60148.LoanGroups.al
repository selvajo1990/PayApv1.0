page 60148 "Loan Groups"
{
    PageType = List;
    SourceTable = "Loan Group";
    Caption = 'Loan Groups';
    ApplicationArea = All;
    UsageCategory = Lists;
    CardPageId = "Loan Group Card";
    Editable = false;
    layout
    {
        area(content)
        {
            repeater(General)
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
            }
        }
    }
}
