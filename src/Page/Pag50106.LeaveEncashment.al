page 50106 "Leave Encashment"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Leave Encashment";
    Caption = 'Leave Encashment';

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Leave Compensation ID"; Rec."Leave Compensation ID")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Leave Compensation ID';
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
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Employee Name';
                }

                field("Leave Type"; Rec."Leave Type")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Leave Type';
                }
                field("Compensation Date"; Rec."Compensation Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Compensation Date';
                }
                field("Encashment Days"; Rec."Encashment Days")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Encashment Days';
                }
                field("Encashment Amount"; Rec."Encashment Amount")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Encashment Amount';
                }
                field("Pay with Salary"; Rec."Pay with Salary")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Pay with Salary';
                }
            }
        }
    }

}