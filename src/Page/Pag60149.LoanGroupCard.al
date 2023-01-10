page 60149 "Loan Group Card"
{
    PageType = Card;
    SourceTable = "Loan Group";
    Caption = 'Loan Group Card';
    UsageCategory = None;
    layout
    {
        area(content)
        {
            group(General)
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
            part("Group Lines"; "Loan Group Subpage")
            {
                ApplicationArea = All;
                Caption = 'Group Lines';
                SubPageLink = "Loan Group Code" = field(Code);
            }
        }
    }

}
