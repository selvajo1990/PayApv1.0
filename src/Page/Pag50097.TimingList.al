page 50097 "Timing List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = Timing;
    Caption = 'Timings';
    Editable = false;
    CardPageId = Timing;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Calendar ID"; Rec."Calendar ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Calendar ID';
                }
                field("From Date"; Rec."From Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the From Date';
                }
                field("Week Day"; Rec."Week Day")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Week Day';
                }
                field("No. of Working Days"; Rec."No. of Working Days")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. of Working Days';
                }
                field("No. of Weekend Days"; Rec."No. of Weekend Days")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. of Weekend Days';
                }
                field("Starting No. of Working Day"; Rec."Starting No. of Working Day")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Starting No. of Working day';
                }
                field("Starting No. of Weekend Day"; Rec."Starting No. of Weekend Day")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Starting No. of Weekend Day';
                }
            }
        }
    }

}