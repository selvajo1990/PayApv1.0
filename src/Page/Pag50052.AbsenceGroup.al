page 50052 "Absence Group"
{
    PageType = Document;
    SourceTable = "Absence Group";
    Caption = 'Absence Group';
    UsageCategory = None;


    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Absence Group Code"; Rec."Absence Group Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Absence Group Code';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description';
                }
            }
            part("Absence Group Subpage"; "Absence Group Subpage")
            {
                SubPageLink = "Absence Group Code" = field("Absence Group Code");
                Caption = 'Lines';
                ApplicationArea = all;
            }
        }
    }
}