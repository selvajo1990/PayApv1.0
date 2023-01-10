page 60181 "OT List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Over Time";
    Caption = 'Over Time List';

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field("OT No."; Rec."OT No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Entry No.';
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Employee No.';
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Employee Name.';
                }
                field("Source Date"; Rec."Source Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Source Date.';
                }
                field("Over Tme Hours"; Rec."Over Tme Hours")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Over Time Hours.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = all;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Status.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
        }
    }

}




