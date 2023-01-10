page 50026 "Designation"
{
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "Designation";
    Caption = 'Designations';
    Editable = false;
    CardPageId = "Designation Card";

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
                    ToolTip = 'Specifies the value of the Description';
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Employee No.';
                }
                field("Start Date"; Rec."Start Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Start Date';
                }
                field("End Date"; Rec."End Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the End Date';
                }
                field(Department; Rec.Department)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Department';
                }
                field("Reporting To"; Rec."Reporting To")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Reporting To';
                }
                field("Position Assigned"; Rec."Position Assigned")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Position Assigned';
                    Visible = false;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Designation Histroy")
            {
                ApplicationArea = All;
                Caption = 'Designation Histroy';
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                Image = ListPage;
                RunObject = page "Designation Change List";
                RunPageLink = "Designation Code" = field("Designation Code");
                ToolTip = 'Executes the Designation Histroy action.';
            }
            action("Reporting To1")
            {
                ApplicationArea = All;
                Caption = 'Reporting To History';
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                Image = ListPage;
                ToolTip = 'Executes the Reporting To History action.';
                trigger OnAction()
                var
                    HrmsLogL: Record "HRMS Log";
                begin
                    HrmsLogL.SetRange("Record ID", Rec.RecordId());
                    Page.RunModal(54165, HrmsLogL);
                end;
            }
        }
    }
}