page 50055 "Computation"
{
    PageType = Document;
    SourceTable = Computation;
    Caption = 'Computations';
    UsageCategory = None;
    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Computation Code"; Rec."Computation Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Computation Code';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description';
                }
            }
            part("Computation Subpage"; "Computation Subpage")
            {
                SubPageLink = "Computation Code" = field("Computation Code");
                Caption = 'Lines';
                ApplicationArea = all;
            }
        }
    }
}