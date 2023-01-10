page 50086 "My Notes"
{
    PageType = ListPart;
    SourceTable = "Record Link";
    SourceTableView = where(Notify = filter(true));
    Caption = 'My Notification';
    Editable = false;
    ShowFilter = false;
    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = All;
                    Caption = 'From';
                    ToolTip = 'Specifies the value of the From';
                }
                field(Created; DateG)
                {
                    ApplicationArea = All;
                    Caption = 'Created Date';
                    ToolTip = 'Specifies the value of the Created Date';
                }
                field(Note; NoteG)
                {
                    Caption = 'Note';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the NoteG';

                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description';
                }
                field(URL1; Rec.URL1)
                {
                    Caption = 'HyperLink';
                    ApplicationArea = All;
                    AssistEdit = true;
                    ToolTip = 'Specifies the value of the HyperLink';
                    trigger OnAssistEdit()
                    begin
                        Hyperlink(Rec.URL1);
                    end;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Remove Notification")
            {
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;
                Image = RemoveLine;
                ApplicationArea = all;
                PromotedCategory = Process;
                ToolTip = 'Executes the Remove Notification action.';
                trigger OnAction()
                begin
                    Rec.Notify := false;
                    Rec.Modify();
                end;
            }
        }
    }
    var
        Base64: Codeunit "Base64 Convert";
        TypeHelper: Codeunit "Type Helper";
        InStreamG: InStream;
        DateG: Date;
        NoteG: Text;

    trigger OnOpenPage()
    begin
        Rec.SetRange("User ID", UserId());
    end;

    trigger OnAfterGetRecord()
    begin
        DateG := DT2Date(Rec.Created);
        NoteG := '';
        Rec.CalcFields(Note);

        Rec.Note.CreateInStream(InStreamG);

        Base64.ToBase64(InStreamG);
        NoteG := TypeHelper.ReadAsTextWithSeparator(InStreamG, TypeHelper.NewLine());
    end;
}