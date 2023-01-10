page 50039 "Age Group"
{
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "Age Group";
    Caption = 'Age Group';
    DelayedInsert = true;
    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Age Group Code"; Rec."Age Group Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Age Group Code';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description';
                }
                field("From Age"; Rec."From Age")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the From Days';
                }
                field("To Age"; Rec."To Age")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the To Days';
                }
                field(Age; Rec.Age)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Age';
                }
            }
        }
        area(Factboxes)
        {

        }
    }
}