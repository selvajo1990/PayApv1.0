page 60018 "Workflow Group Member ATG"
{
    PageType = ListPart;
    SourceTable = "Workflow Group Member ATG";
    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Employee No."; Rec."Employee No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Employee No.';
                }
                field("Sequence No."; Rec."Sequence No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Sequence No.';
                }
            }
        }
    }

}