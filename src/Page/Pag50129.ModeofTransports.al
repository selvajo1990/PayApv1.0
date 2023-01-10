page 50129 "Mode of Transports"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Mode of Transport";
    Caption = 'Mode of Transports';

    layout
    {
        area(Content)
        {
            repeater(Mode)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Code';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description';
                }
            }
        }
    }

}