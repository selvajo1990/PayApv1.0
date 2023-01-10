page 60154 "Air Ticket Groups"
{

    PageType = List;
    SourceTable = "Air Ticket Group";
    Caption = 'Air Ticket Groups';
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Air Ticket Group Code"; Rec."Air Ticket Group Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Air Ticket Group Code';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description';
                }
                field("Dependent Allowed"; Rec."Dependent Allowed")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Dependents Allowed';
                }
                field("Class Type"; Rec."Class Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Class Type';
                }
                field(Accrual; Rec.Accrual)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Accrual';
                }
                field("Accruing Type"; Rec."Accruing Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Accruing Type';
                }
                field(Provision; Rec.Provision)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Provision';
                }
                field("Minimum Tenure (In days)"; Rec."Minimum Tenure (In days)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Minimum Tenure (In days)';
                }
                field("Days Between"; Rec."Days Between")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Days Between';
                }
                field("Accrual Expiry Days"; Rec."Accrual Expiry Days")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Accrual Expiry Days';
                }
            }
        }
    }

}
