page 50060 "Loan Card"
{
    PageType = Card;
    SourceTable = Loan;
    Caption = 'Loan & Advance Card';
    UsageCategory = None;
    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Loan Code"; Rec."Loan Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Loan Code';
                }
                field("Loan Description"; Rec."Loan Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Loan Description';
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Date';
                }
            }
            group("Calculation")
            {
                field("Computation Basis"; Rec."Computation Basis")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Computation Basis';
                    trigger OnValidate()
                    begin
                        MakeEditable();
                        if Rec."Computation Basis" = Rec."Computation Basis"::Amount then
                            Rec.Amount := 0;
                        case true of
                            Rec."Computation Basis" = Rec."Computation Basis"::" ":
                                begin
                                    Rec.Amount := 0;
                                    Rec."Earning Code" := '';
                                    Rec.Percentage := 0;
                                end;
                            Rec."Computation Basis" = Rec."Computation Basis"::Amount:
                                begin
                                    Rec."Earning Code" := '';
                                    Rec.Percentage := 0;
                                end;
                            Rec."Computation Basis" = Rec."Computation Basis"::Percentage:
                                Rec.Amount := 0;
                        end;
                    end;
                }
                group("Per")
                {
                    Caption = '';
                    Visible = HidePercentageG;
                    field("Earning Code"; Rec."Earning Code")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Earning Code';
                    }
                    field(Percentage; Rec.Percentage)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Percentage';
                    }
                }
                group(Amo)
                {
                    Caption = '';
                    Visible = HideAmountG;
                    field(Amount; Rec.Amount)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Amount';
                        Visible = false;
                    }
                }
                field("Minimum Tenure Formula"; Rec."Minimum Tenure Formula")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Minimum Tenure';
                }
                field("No. of Instalments"; Rec."No. of Instalment")
                {
                    ApplicationArea = All;
                    Editable = Rec."End of Service" = false;
                    ToolTip = 'Specifies the value of the No. of Instalment';
                    Visible = false;
                }
                field("Allow in Notice Period"; Rec."Allow in Notice Period")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Allow in Notice Period';
                }
                field("Allow Multiple Loans"; Rec."Allow Multiple Loan")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Allow Multiple Loan';
                }
                field("Allow Multiple Times"; Rec."Allow Multiple Time")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Allow Multiple Time';
                }
                field("Minimum Days Between Request"; Rec."Minimum Days Between Request")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Minimum Days Between Request';
                }
                field("End of Service"; Rec."End of Service")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the End of Service';
                }
            }
        }
    }
    var
        HidePercentageG: Boolean;
        HideAmountG: Boolean;

    local procedure MakeEditable()
    begin
        Clear(HidePercentageG);
        Clear(HideAmountG);
        HidePercentageG := Rec."Computation Basis" = Rec."Computation Basis"::Percentage;
        HideAmountG := Rec."Computation Basis" = Rec."Computation Basis"::Amount;
    end;

    trigger OnOpenPage()
    begin
        MakeEditable();
    end;

    trigger OnAfterGetRecord()
    begin
        MakeEditable();
    end;
}