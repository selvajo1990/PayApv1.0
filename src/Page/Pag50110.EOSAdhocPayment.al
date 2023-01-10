page 50110 "EOS Adhoc Payment"
{
    PageType = ListPart;
    SourceTable = "Salary Computation Line";
    Editable = false;
    Caption = 'Adhoc Payment';
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Earning Code"; Rec."Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Code';
                }
                field("Earning Description"; Rec."Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description';
                }

                field("Adhoc Amount"; Rec."Amount")
                {
                    ApplicationArea = All;
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

            }
        }
    }
    // procedure ShowEosAdhocPayment(FromDateP: Date; ToDateP: Date)
    // begin
    //     Rec.SetRange("Adhoc Date", FromDateP, ToDateP);
    // end;

}