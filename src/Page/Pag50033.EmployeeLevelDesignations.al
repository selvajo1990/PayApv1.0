page 50033 "Employee Level Designations"
{
    PageType = List;
    SourceTable = "Employee Level Designation";
    Caption = 'Employee Level Designations';
    AutoSplitKey = true;
    DelayedInsert = true;
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Designation Code"; Rec."Designation Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Designation Code';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Description';
                }
                field(Department; Rec.Department)
                {
                    ApplicationArea = All;
                    Editable = not Rec."Position Closed";
                    ToolTip = 'Specifies the value of the Department';
                }
                field("Reporting To"; Rec."Reporting To")
                {
                    ApplicationArea = All;
                    Editable = not Rec."Position Closed";
                    ToolTip = 'Specifies the value of the Reporting To';
                }
                field("Work Assignment Start Date"; Rec."Work Assignment Start Date")
                {
                    ApplicationArea = All;
                    Editable = not Rec."Position Closed";
                    ToolTip = 'Specifies the value of the Work Assignment Start Date';
                }
                field("Work Assignment End Date"; Rec."Work Assignment End Date")
                {
                    ApplicationArea = All;
                    Editable = not Rec."Position Closed";
                    ToolTip = 'Specifies the value of the Work Assignment End Date';
                }
                field("Primary Position"; Rec."Primary Position")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Primary Position';
                }
            }
        }
    }
    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Evaluate(Rec."Employee No.", Rec.GetFilter("Employee No."));
    end;
}