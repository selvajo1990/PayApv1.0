page 50045 "Earning Group Subpage"
{
    PageType = ListPart;
    SourceTable = "Earning Group Line";
    Caption = 'Earning Group Lines';
    AutoSplitKey = true;
    DelayedInsert = true;
    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Earning Code"; Rec."Earning Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Earning Code';
                }
                field("Earning Description"; Rec."Earning Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Earning Description';
                }
                field("Payment Type"; Rec."Payment Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Payment Type';
                }
                field("Base Code"; Rec."Base Code")
                {
                    ApplicationArea = All;
                    Editable = Rec."Payment Type" = Rec."Payment Type"::Percentage;
                    ToolTip = 'Specifies the value of the Base Code';
                }
                field("Computation Code"; Rec."Computation Code")
                {
                    ApplicationArea = All;
                    Editable = Rec."Payment Type" = Rec."Payment Type"::Computation;
                    ToolTip = 'Specifies the value of the Computation Code';
                }
                field("Pay Percentage"; Rec."Pay Percentage")
                {
                    ApplicationArea = All;
                    Editable = Rec."Payment Type" = Rec."Payment Type"::Percentage;
                    ToolTip = 'Specifies the value of the Pay Percentage';
                }
                field("Pay Amount"; Rec."Pay Amount")
                {
                    ApplicationArea = All;
                    Editable = Rec."Payment Type" = Rec."Payment Type"::Amount;
                    ToolTip = 'Specifies the value of the Pay Amount';
                }
                field("Affects Salary"; Rec."Affects Salary")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Affects Salary';
                }
                field("Show in payslip"; Rec."Show in payslip")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Show in Payslip';
                }
                field("Day Type"; Rec."Day Type")
                {
                    ApplicationArea = All;
                    Editable = Rec.Hourly and (Rec.Type = Rec.Type::Constant);
                    ToolTip = 'Specifies the value of the Day Type';
                }
                field("Minimum Number of Days"; Rec."Minimum Number of Days")
                {
                    ApplicationArea = All;
                    Editable = Rec.Hourly and (Rec.Type = Rec.Type::Constant);
                    ToolTip = 'Specifies the value of the Minimum Number of Days';
                }
                field("Minimum Duration"; Rec."Minimum Duration")
                {
                    ApplicationArea = All;
                    Editable = Rec.Hourly and (Rec.Type = Rec.Type::Constant);
                    ToolTip = 'Specifies the value of the Minimum Duration';
                }
            }
        }

    }
}
