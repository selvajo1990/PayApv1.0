page 50058 "Adhoc Payment"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Adhoc Payment";
    Caption = 'Adhoc Payments';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Adhoc No."; Rec."Adhoc No.")
                {
                    ApplicationArea = All;
                    AssistEdit = true;
                    ToolTip = 'Specifies the value of the Adhoc No.';
                    trigger OnAssistEdit()
                    begin
                        Rec.AssisEdit();
                    end;
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Employee No.';
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Employee Name';
                }
                field("Earning Code"; Rec."Earning Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Earning Code';
                    trigger OnValidate()
                    var
                        EarningL: record Earning;
                    begin
                        EarningL.Get(Rec."Earning Code");
                        if EarningL.Hourly then
                            AmountEnable := false
                        else
                            AmountEnable := true;

                    end;

                }
                field("Earning Description"; Rec."Earning Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Earning Description';
                }
                field("Adhoc Date"; Rec."Adhoc Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Adhoc Date';
                }
                field(Hours; Rec.Hours)
                {
                    ApplicationArea = all;
                    Editable = not AmountEnable;
                    ToolTip = 'Specifies the value of the Hours';
                }
                field("Adhoc Amount"; Rec."Adhoc Amount")
                {
                    ApplicationArea = All;
                    Editable = AmountEnable;
                    ToolTip = 'Specifies the value of the Adhoc Amount';
                }
                field("Pay With Salary"; Rec."Pay With Salary")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Pay With Salary';
                }
                field("Affects Salary"; Rec."Affects Salary")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Affects Salary';
                }
                field("Show in Payslip"; Rec."Show in Payslip")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Show in Payslip';
                }

            }
        }
        area(Factboxes)
        {

        }
    }
    var
        AmountEnable: Boolean;

    trigger OnInit()
    begin
        AmountEnable := true;
    end;

}