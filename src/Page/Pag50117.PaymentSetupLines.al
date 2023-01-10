page 50117 "Payment Setup Lines"
{
    PageType = ListPart;
    SourceTable = "Payment Setup Line";
    Caption = 'Gratuity Payment Setup';
    DelayedInsert = true;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Reason Code"; Rec."Reason Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Reason Code';

                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description';

                }
                field("From Days"; Rec."From Days")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the From Days';

                }
                field("To Days"; Rec."To Days")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the To Days';

                }
                field("No. of Years"; Rec."No. of Years")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the No. of Years';

                }
                field(Days; Rec.Days)
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the value of the No. of Days';

                }
                field("Cancel Previous"; Rec."Cancel Previous")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Cancel Previous';

                }
                field("Add Days"; Rec."Add Days")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Define No. of Days';
                    trigger OnDrillDown()
                    var
                        GratuityFormulaL: Record "Gratuity Formula";
                    begin
                        GratuityFormulaL.SetRange("Earning Code", Rec."Earning Code");
                        GratuityFormulaL.SetRange("Reason Code", Rec."Reason Code");
                        GratuityFormulaL.SetRange("To Days", Rec."To Days");
                        Page.Run(0, GratuityFormulaL);
                    end;
                }
            }
        }
    }
    var
        AddDaysTxt: Label 'Add No. of Days';

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Add Days" := CopyStr(AddDaysTxt, 1, MaxStrLen(Rec."Add Days"));
    end;
}