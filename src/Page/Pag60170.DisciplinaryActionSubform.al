page 60170 "Disciplinary Action Subform"
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Disciplinary Action Line";
    AutoSplitKey = true;
    DelayedInsert = true;

    layout
    {
        area(Content)
        {

            repeater(GroupName1)
            {
                field("Occurance No."; Rec."Occurance No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Occurance No.';

                }
                field(Days; Rec.Days)
                {

                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Days';

                }
                field(Percentage; Rec.Percentage)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Percentage';
                }
                Field("Warning Letter"; Rec."Warning Letter")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Warning Letter';
                }
                field("Reason Description"; Rec."Reason Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Reason Description';
                }
                field("Computation Code"; Rec."Computation Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Computation Code';
                }
            }
        }

    }
}