page 60152 "Flight Costs"
{

    PageType = List;
    SourceTable = "Flight Cost";
    Caption = 'Flight Costs';
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Flight Destination Code"; Rec."Flight Destination Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Flight Destination';
                }
                field("Flight Destination"; Rec."Flight Destination")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Flight Destination';
                }
                field("Class Type"; Rec."Class Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Class Type';
                }
                field(Category; Rec.Category)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Category';
                }
                field("Start Date"; Rec."Start Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Start Date';
                }
                field("End Date"; Rec."End Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the End Date';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Amount';
                }
            }
        }
    }

}
