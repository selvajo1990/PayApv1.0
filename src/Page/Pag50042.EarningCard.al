page 50042 "Earning Card"
{
    PageType = Card;
    SourceTable = "Earning";
    Caption = 'Earning Card';
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Earning Code';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description';
                }
                field(Category; Rec.Category)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Category';
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Type';
                }
                field(Hourly; Rec.Hourly)
                {
                    ApplicationArea = all;
                    Editable = (Rec.Type = Rec.Type::Constant) or (Rec.Type = Rec.Type::Adhoc);
                    ToolTip = 'Specifies the value of the Hourly';
                }
                group("Over Time")
                {
                    Visible = Rec.Hourly and (Rec.Type = Rec.Type::Constant);
                    field("Day Type"; Rec."Day Type")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Day Type';
                    }
                    field("Minimum Number of Days"; Rec."Minimum Number of Days")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Minimum Number of Days';
                    }
                    field("Minimum Duration"; Rec."Minimum Duration")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Minimum Duration';
                    }
                }
                field(Accrual; Rec.Accrual)
                {
                    ApplicationArea = All;
                    Editable = not (Rec.Hourly and (Rec.Type = Rec.Type::Constant));
                    ToolTip = 'Specifies the value of the Accrual';

                    trigger OnValidate()
                    var
                        ComputationDetailsL: Record "Computation Line Detail";
                    begin
                        if Rec.Accrual then begin
                            Rec."Pay Amount" := 0;
                            Rec."Pay Percentage" := 0;
                            Rec."Base Code" := '';
                        end else begin
                            Rec."Computation Code" := '';
                            Clear(Rec."Accrual Type");
                            ComputationDetailsL.SetRange("Earning Code", Rec.Code);
                            ComputationDetailsL.DeleteAll();
                        end;
                    end;
                }
                group(AT)
                {
                    Visible = Rec.Accrual;
                    Caption = '';
                    field("Accrual Type"; Rec."Accrual Type")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Accrual Type';
                    }
                    group("Air Ticket")
                    {
                        Visible = Rec."Accrual Type" = Rec."Accrual Type"::"Air Ticket";
                        Caption = '';
                        field("Pay on Anniversary"; Rec."Pay on Anniversary")
                        {
                            ApplicationArea = all;
                            ToolTip = 'Specifies the value of the Pay on Aniversary';
                        }
                    }
                }

                field("Show in payslip"; Rec."Show in payslip")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Show in payslip';
                }
                field("Affects Salary"; Rec."Affects Salary")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Affects Salary';
                }
                field("Pay With Salary"; Rec."Pay With Salary")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Pay With Salary';
                }
                field("Applicable for OT"; "Applicable for OT")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Applicable for OT';
                }
                field("OT% for Normal Days"; "OT% for Normal Days")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the OT% for Normal Days';
                }
                field("OT% for Holidays"; "OT% for Holidays")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the OT% for Holidays';
                }
            }
            group(Computation)
            {
                group("Prorata")
                {
                    Caption = '';
                    Visible = Rec.Type <> Rec.Type::Adhoc;
                    field("First Month Computation"; Rec."First Month Computation")
                    {
                        ApplicationArea = all;
                        ToolTip = 'Specifies the value of the First Month Computation';
                    }
                    field(Confirmed; Rec.Confirmed)
                    {
                        ApplicationArea = all;
                        ToolTip = 'Specifies the value of the Confirmed';
                    }
                    field("Last Month Computation"; Rec."Last Month Computation")
                    {
                        ApplicationArea = all;
                        ToolTip = 'Specifies the value of the Last Month Computation';
                    }
                }
                field("Payment Type"; Rec."Payment Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Payment Type';

                    trigger OnValidate()
                    begin
                        ResetFieldValue();
                    end;
                }
                group("Amount")
                {
                    Caption = '';
                    Visible = Rec."Payment Type" = Rec."Payment Type"::Amount;
                    field("Pay Amount"; Rec."Pay Amount")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Pay Amount';
                    }
                }
                group("Percentage")
                {
                    Caption = '';
                    Visible = Rec."Payment Type" = Rec."Payment Type"::Percentage;
                    field("Base Code"; Rec."Base Code")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Base Code';
                    }
                    field("Pay Percentage"; Rec."Pay Percentage")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Pay Percentage';
                    }
                }
                group(CC)
                {
                    Caption = '';
                    Visible = (Rec."Payment Type" = Rec."Payment Type"::Computation);
                    field("Computation Code"; Rec."Computation Code")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Computation Code';
                    }
                }
            }
            part("Accrual Setup Line"; "Accrual Setup Line")
            {
                ApplicationArea = all;
                Visible = (Rec."Accrual Type" = Rec."Accrual Type"::"Gratuity Accrual");
                Caption = 'Gratuity Accrual Setup';
                SubPageLink = "Earning Code" = field(Code);
            }

            part("Payment Setup Lines"; "Payment Setup Lines")
            {
                ApplicationArea = all;
                Visible = (Rec."Accrual Type" = Rec."Accrual Type"::"Gratuity Accrual");
                Caption = 'Gratuity Payment Setup';
                SubPageLink = "Earning Code" = field(Code);
            }
        }
    }

    local procedure ResetFieldValue()
    begin
        case true of
            Rec."Payment Type" = Rec."Payment Type"::" ":
                begin
                    Rec."Base Code" := '';
                    Rec."Pay Percentage" := 0;
                    Rec."Pay Amount" := 0;
                    Rec."Computation Code" := '';
                end;
            Rec."Payment Type" = Rec."Payment Type"::Amount:
                begin
                    Rec."Pay Percentage" := 0;
                    Rec."Base Code" := '';
                    Rec."Computation Code" := '';
                end;
            Rec."Payment Type" = Rec."Payment Type"::Percentage:
                begin
                    Rec."Pay Amount" := 0;
                    Rec."Computation Code" := '';
                end;
            Rec."Payment Type" = Rec."Payment Type"::Computation:
                begin
                    Rec."Pay Amount" := 0;
                    Rec."Pay Percentage" := 0;
                    Rec."Base Code" := '';
                end

        end;
    end;

    trigger OnOpenPage()
    begin
    end;

    trigger OnAfterGetRecord()
    begin
    end;
}
