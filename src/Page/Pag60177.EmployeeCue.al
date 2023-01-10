page 60177 "ESS Cue"
{
    PageType = CardPart;
    UsageCategory = Administration;
    RefreshOnActivate = true;
    SourceTable = "ESS Cue";
    Caption = 'ESS Cue';

    layout
    {
        area(Content)
        {
            Cuegroup(Employee)
            {
                Caption = '';
                field("Requests to Approve"; Rec."Requests to Approve")
                {
                    ApplicationArea = All;
                    Caption = 'Requests to Approve';
                    ToolTip = 'Specifies the value of the Requests to Approve field.';
                    DrillDownPageId = "Request to Approve ATG";
                }
                field("My Leave Request"; Rec."Leave Request")
                {
                    ApplicationArea = All;
                    Caption = 'My Leave Request';
                    ToolTip = 'Specifies the value of the Leave Request field.';
                    DrillDownPageId = "Leave Request List";
                }
                //<< skr
                field("Approved Requests"; Rec."Approved Requests")
                {
                    ApplicationArea = All;
                    Caption = 'Approved Requests';
                    ToolTip = 'Specifies the value of the Approved Requests field.';
                    DrillDownPageId = "Approved Requests";
                }
                //>> skr
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;

        Rec.FilterGroup(1);
        Rec.SetRange("Employee No. Filter", SingleInstance.GetEmpNo());
        Rec.FilterGroup(0);
    end;

    var
        SingleInstance: Codeunit "Single Instance";
}