page 50107 "End of Service List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "End of Service";
    Editable = false;
    Caption = 'End of Services';
    CardPageId = "End of Service";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("End of Service No."; Rec."End of Service No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the End of Service No.';

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
                field("Reason Code"; Rec."Reason Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Reason Code';
                }
                field("Last Working Day"; Rec."Last Working Day")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Last Working Day';
                }
            }
        }
    }

}