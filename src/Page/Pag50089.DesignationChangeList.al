page 50089 "Designation Change List"
{
    PageType = List;
    SourceTable = "Employee Level Designation";
    Caption = 'Designation Change List';
    Editable = false;
    UsageCategory = None;
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
                field("Employee Name"; Rec."Employee Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Employee Name';
                }
                field("Designation Code"; Rec."Designation Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Designation Code';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Editable = Rec."Position Closed";
                    ToolTip = 'Specifies the value of the Description';
                }
                field(Department; Rec.Department)
                {
                    ApplicationArea = All;
                    Editable = Rec."Position Closed";
                    ToolTip = 'Specifies the value of the Department';
                }
                field("Reporting To"; Rec."Reporting To")
                {
                    ApplicationArea = All;
                    Editable = Rec."Position Closed";
                    ToolTip = 'Specifies the value of the Reporting To';
                }
                field("Work Assignment Start Date"; Rec."Work Assignment Start Date")
                {
                    ApplicationArea = All;
                    Editable = Rec."Position Closed";
                    ToolTip = 'Specifies the value of the Work Assignment Start Date';
                }
                field("Work Assignment End Date"; Rec."Work Assignment End Date")
                {
                    ApplicationArea = All;
                    Editable = Rec."Position Closed";
                    ToolTip = 'Specifies the value of the Work Assignment End Date';
                }

            }
        }
    }
}