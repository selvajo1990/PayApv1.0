page 50036 "Issuing Agency"
{
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "Issuing Agency";
    Caption = 'Issuing Agency';
    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Issuing Agency Code"; Rec."Issuing Agency Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Issuing Agency Code';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description';
                }
                field(Notes; Rec.Notes)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Notes';
                }
                field("Contact No."; Rec."Contact No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Contact No.';
                }
                field("Contact Email"; Rec."Contact Email")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Contact Email';
                }
                field(Website; Rec.Website)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Website URL';
                }
            }
        }
        area(Factboxes)
        {

        }
    }
}