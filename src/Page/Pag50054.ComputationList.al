page 50054 "Computation List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = Computation;
    Caption = 'Computations';
    CardPageId = Computation;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Computation Code"; Rec."Computation Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Computation Code';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description';
                }
            }
        }
        area(Factboxes)
        {

        }
    }

}