page 50037 "Identification"
{
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = Identification;
    Caption = 'Identifications';
    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Identification Code"; Rec."Identification Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Code';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description';
                }
                field("Issuing Agency"; Rec."Issuing Agency")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Issuing Agency';
                }
                field("Alert Formula"; Rec."Alert Formula")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Alert Formula';
                }
            }
        }
        area(Factboxes)
        {

        }
    }
}