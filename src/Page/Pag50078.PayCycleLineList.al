page 50078 "Pay Cycle Line List"
{
    PageType = List;
    SourceTable = "Pay Period Line";
    Editable = false;
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Pay Period"; Rec."Pay Period")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Pay Period';
                }
                field("Period Start Date"; Rec."Period Start Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Period Start Date';
                }
                field("Period End Date"; Rec."Period End Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Period End Date';
                }
            }
        }
        area(Factboxes)
        {

        }
    }
    trigger OnAfterGetRecord()
    begin
        Rec.SetCurrentKey("Period Start Date");
    end;
}