// web service page - don't change the property for general use.
page 60186 "Attendance Entries"
{
    Caption = 'Attendance Entries';
    PageType = List;
    SourceTable = "Attendance Entry";
    UsageCategory = None;
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Employee ID"; Rec."Employee ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Employee ID';
                }
                field("Entry Date"; Rec."Entry Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Entry Date';
                }
                field("Start Time"; Rec."Start Time")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Start Time';
                }
                field("End Time"; Rec."End Time")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the End Time';
                }
                field(Location; Rec.Location)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Location';
                }
                field("Location Name"; Rec."Location Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Location Name field.';
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SystemCreatedAt';
                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SystemModifiedAt';
                }
            }
        }
    }
}
