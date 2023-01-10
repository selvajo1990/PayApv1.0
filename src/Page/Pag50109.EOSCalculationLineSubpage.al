page 50109 "EOS Calculation Line Subpage"
{
    PageType = ListPart;
    SourceTable = "Salary Computation Line";
    DeleteAllowed = false;
    InsertAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Line Type"; Rec."Line Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Line Type';
                }
                field("Earning Group"; Rec."Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Code';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Description';
                }
                field("Posting Category"; Rec."Posting Category")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Posting Category';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Amount';
                }
                field("Total Amount"; Rec."Total Amount")
                {
                    ApplicationArea = all;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Total Amount';
                }
                field("Pay With Salary"; Rec."Pay With Salary")
                {
                    ApplicationArea = all;
                    Caption = 'Pay';
                    ToolTip = 'Specifies the value of the Pay';
                }
                field(Comments; Rec.Comments)
                {
                    ApplicationArea = All;
                    Editable = true;
                    ToolTip = 'Specifies the value of the Comments';
                }

            }
        }
    }

}