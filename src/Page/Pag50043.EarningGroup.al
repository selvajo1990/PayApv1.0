page 50043 "Earning Group"
{
    PageType = Document;
    SourceTable = "Earning Group";
    Caption = 'Earning Group';
    UsageCategory = None;
    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Earning Group Code"; Rec."Earning Group Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Earning Group Code';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description';
                }
            }
            part("Earning Group Subpage"; "Earning Group Subpage")
            {
                SubPageLink = "Group Code" = field("Earning Group Code");
                Caption = 'Lines';
                ApplicationArea = all;
            }
        }

    }
}