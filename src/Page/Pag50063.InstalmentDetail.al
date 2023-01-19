page 50063 "Instalment Detail"
{
    PageType = ListPart;
    SourceTable = "Instalment Detail";
    Caption = 'Instalment Detail';
    Editable = false;
    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Deduction Amount"; Rec."Deduction Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Deduction Amount';
                }
                field("Deduction Date"; Rec."Deduction Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Deduction Date';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    Editable = Rec.Status = Rec.Status::Unpaid;
                    ToolTip = 'Specifies the value of the Status';
                }

            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Shift Payment")
            {
                ApplicationArea = All;
                Caption = 'Shift Payment';
                Image = ChangeDates;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                ToolTip = 'Executes the Shift Payment action.';
                Visible = ESSUser;
                trigger OnAction()
                begin
                    Rec.ShiftPayment();
                end;
            }
            action("Change EMI Amount")
            {
                ApplicationArea = All;
                Caption = 'Change EMI Amount';
                Image = ChangeTo;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                ToolTip = 'Executes the Change EMI Amount action.';
                Visible = ESSUser;
                trigger OnAction()
                begin
                    Rec.ChangeEmiAmount();
                end;
            }
            action("Change No. of Instalments")
            {
                ApplicationArea = All;
                Caption = 'Change No. of Instalments';
                Image = ChangeToLines;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                ToolTip = 'Executes the Change No. of Instalments action.';
                Visible = ESSUser;
                trigger OnAction()
                begin
                    Rec.ChangeInstlaments();
                end;
            }
        }
    }
    var
        UserSetup: Record "User Setup";
        ESSUser: Boolean;

    trigger OnOpenPage()
    begin
        Clear(ESSUser);
        if UserSetup.Get(UserId) and UserSetup."Is ESS User" then
            ESSUser := false else
            ESSUser := true;
    end;
}