page 50087 "Designation Card"
{
    PageType = Card;
    SourceTable = Designation;
    Caption = 'Designation Card';
    UsageCategory = None;
    layout
    {
        area(Content)
        {
            group(General)
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
                }
            }
            part("Designation Assignment"; "Designation Assignment Subpage")
            {
                ApplicationArea = All;
                Caption = 'Designation Assignment';
                SubPageLink = "Position Closed" = filter(false), "Designation Code" = field("Designation Code");
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
                PromotedOnly = true;
                Image = ListPage;
                PromotedCategory = Process;
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
                PromotedOnly = true;
                Image = ListPage;
                PromotedCategory = Process;
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
    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Position Assigned" := false;
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if Rec."Designation Code" > '' then
            Rec.TestField("Start Date");
    end;
}