page 60171 "Disciplinary Action Card"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Disciplinary Action";
    Caption = 'Disciplinary Action';

    layout
    {
        area(Content)
        {
            group(General)
            {

                field("Disciplinary Code"; Rec."Disciplinary Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Disciplinary Code';
                }
                field("Reason Code"; Rec."Reason Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Reason Code';
                    //Editable = false;
                }
                field("Reason Description"; Rec."Reason Description")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Reason Description';
                }
                field("No. of Days"; Rec."No. of Days")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. of Days';

                }
                field(Notes; Rec.Notes)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Notes';
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Date';
                }

            }
            part(Lines; "Disciplinary Action Subform")
            {
                Caption = 'Occurances Lines';
                ApplicationArea = All;
                SubPageLink = "Reason Code" = field("Reason Code"), "Disciplinary Code" = field("Disciplinary Code");

            }
        }
    }

}