page 50032 "Employee Assets"
{
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "Employee Asset";
    Caption = 'Employee Assets';

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
                field("Asset Type"; Rec."Asset Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Loan Type';
                }
                field("Asset Item"; Rec."Asset Item")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Loaned Item';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description';
                }
                field("Asset Price"; "Asset Price")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Asset Price';
                }
                field("Issued Date"; Rec."Issued Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Issued Date';
                }
                field("Serial No."; Rec."Serial No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Serial No.';
                }
                field("Returneded Date"; Rec."Returned Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Collected/Transferred Date';
                }
                /*field("Actual Return Date"; Rec."Actual Return Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Actual Return Date';
                }*/
                field(Status; Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Status';
                }
                field(Notes; Notes)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Notes';
                }
            }
        }
        area(Factboxes)
        {
        }
    }
}
