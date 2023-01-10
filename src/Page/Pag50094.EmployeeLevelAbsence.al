page 50094 "Employee Level Absence"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Employee Level Absence";
    Caption = 'Employee Level Absence';

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Absence Code"; Rec."Absence Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Absence Code';

                }
                field("Absence Description"; Rec."Absence Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Absence Description';

                }
                field("From Date"; Rec."From Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the From Date';

                }
                field("Attachment Required"; Rec."Attachment Required")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Attachment Required';

                }
                field("Attachment Days"; Rec."Attachment days")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Attachment days';

                }
                field("Additional Days"; Rec."Additional Days")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Additional days';

                }
                field("Additional Days Action"; Rec."Additional Days Action")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Additional Days Action';

                }
                field("Allow in Probation"; Rec."Allow in Probation")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Allow in Probation';

                }
                field("Probation Action"; Rec."Probation Action")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Probation Action';

                }
                field("Allow in Notice Period"; Rec."Allow in Notice Period")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Allow in Notice Period';

                }
                field("Notice Period Action"; Rec."Notice Period Action")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Notice Period Action';

                }
                field("Maximum Days at Once"; Rec."Maximum Days at Once")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Maximum Days at Once';

                }
                field("Minimum Days at Once"; Rec."Minimum Days at Once")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Minimum Days at Once';

                }
                field("Minimum Days Before Request"; Rec."Minimum Days Before Request")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Minimum Days Before Request';

                }
                field("Minimum Days Between Request"; Rec."Minimum Days Between Request")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Minimum Days Between Request';

                }
                field("Maximum Days in a Year"; Rec."Maximum Days in a Year")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Maximum Days in a Year';

                }
                field("Maximum Times in a Year"; Rec."Maximum Times in a Year")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Maximum Times in a Year';

                }
                field("Minimum Tenure"; Rec."Minimum Tenure")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Minimum Tenure';

                }
                field("Maximum Times in Tenure"; Rec."Maximum Times in Tenure")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Maximum Times in Tenure';

                }
                field("Accrual"; Rec.Accrual)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Accrual';

                }
                field("Maximum Accrual Days"; Rec."Maximum Accrual Days")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Maximum Accrual Days';

                }
                field("Maximum Carry Forward Days"; Rec."Maximum Carry Forward Days")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Maximum Carry Forward Days';

                }
                field("Assigned Days"; Rec."Assigned Days")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Assigned Days';

                }
                field("Accrual Basis"; Rec."Accrual Basis")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Accrual Basis';

                }
                field("Apply More than Accrued"; Rec."Apply More Than Accrued")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Apply More Than Accrued';

                }

            }
        }
    }
}