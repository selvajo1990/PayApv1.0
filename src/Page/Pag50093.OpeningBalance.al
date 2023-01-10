page 50093 "Opening Balance"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Opening Balance";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
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
                field("Type"; Rec."Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Type';

                }
                field("Code"; Rec."Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Code';

                }
                field("Pay Period"; Rec."Pay Period")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Pay Period';
                }
                field("Value"; Rec."Value")
                {
                    ApplicationArea = All;
                    Editable = (Rec.Type = Rec.Type::Absence);
                    ToolTip = 'Specifies the value of the Value';

                }
                field("Amount"; Rec.Amount)
                {
                    ApplicationArea = All;
                    Editable = (Rec.Type = Rec.Type::Earning);
                    ToolTip = 'Specifies the value of the Amount';

                }
                field("Comment"; Rec.Comment)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Comment';

                }
            }
        }
    }

}