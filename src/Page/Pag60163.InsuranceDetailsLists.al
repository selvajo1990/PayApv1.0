page 60163 "Insurance Details Lists"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Insurance Information";
    CardPageId = "Insurance Cards";
    Caption = 'Insurance Details';

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {

                field("Type of Insurance"; Rec."Type of Insurance Description")
                {
                    ApplicationArea = All;
                    Caption = 'Insurance Types';
                    ToolTip = 'Specifies the value of the Insurance Types';

                }
                field("Level in Insurance"; Rec."Level in Insurance Description")
                {
                    ApplicationArea = All;
                    Caption = 'Insurance Levels';
                    ToolTip = 'Specifies the value of the Insurance Levels';

                }
                field("From Date"; Rec."From Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the From Date';

                }
                field("To Date"; Rec."To Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the To Date';
                }
                field("Insurance Amount"; Rec."Insurance Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Insurance Amount';
                }


            }
        }

    }


}