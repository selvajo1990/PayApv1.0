page 50062 "Loan Request Card"
{
    PageType = Card;
    SourceTable = "Loan Request";
    Caption = 'Loan & Advance Request Card';
    UsageCategory = None;
    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Loan Request No."; Rec."Loan Request No.")
                {
                    ApplicationArea = All;
                    AssistEdit = true;
                    ToolTip = 'Specifies the value of the Loan Request No.';
                    trigger OnAssistEdit()
                    begin
                        Rec.AssisEdit();
                    end;
                }
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
                field("Include in Salary"; Rec."Include in Salary")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Include in Salary';
                }
                field("Requested date"; Rec."Requested date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Requested Date';
                }
                field("Deduction Start Date"; Rec."Deduction Start Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Deduction Start Date';
                }

                field("Loan Type"; Rec."Loan Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Loan Type';
                }
                field("Loan Description"; Rec."Loan Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Loan Description';
                }


            }
            group(Details)
            {
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Amount';
                }
                group(Instalment)
                {
                    Caption = '';
                    Editable = Rec."End of Service" = false;

                    field("No. of Instalment"; Rec."No. of Instalment")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the No. of Instalment';
                    }

                }
                field("Instalment Amount"; Rec."Instalment Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Instalment Amount';
                }
                field("Outstanding Amount"; "Outstanding Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Outstanding Amount';
                }
                field(Notes; Rec.Notes)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Notes';
                }
            }
            part("Instalment Detail"; "Instalment Detail")
            {
                SubPageLink = "Loan Request No." = field("Loan Request No.");
                Caption = 'Instalment Detail';
                ApplicationArea = All;
                //Visible = "End of Service" = false;
            }
        }
    }
    var
        UserSetup: Record "User Setup";

    trigger OnOpenPage()
    begin
        if UserSetup.Get(UserId) and UserSetup."Is ESS User" then begin
            CurrPage.Editable := false;
        end;
    end;
}