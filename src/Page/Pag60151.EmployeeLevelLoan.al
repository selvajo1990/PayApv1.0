page 60151 "Employee Level Loan"
{

    PageType = List;
    SourceTable = "Employee Level Loan";
    Caption = 'Employee Level Loan';
    UsageCategory = None;

    layout
    {
        area(content)
        {
            repeater(General)
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
                field("Computation Basis"; Rec."Computation Basis")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Computation Basis';
                    trigger OnValidate()
                    begin
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
                field("Earning Code"; Rec."Earning Code")
                {
                    ApplicationArea = All;
                    Editable = Rec."Computation Basis" = Rec."Computation Basis"::Percentage;
                    ToolTip = 'Specifies the value of the Earning Code';
                }
                field(Percentage; Rec.Percentage)
                {
                    ApplicationArea = All;
                    Editable = Rec."Computation Basis" = Rec."Computation Basis"::Percentage;
                    ToolTip = 'Specifies the value of the Percentage';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    Editable = Rec."Computation Basis" = Rec."Computation Basis"::Amount;
                    ToolTip = 'Specifies the value of the Amount';
                }

                field("Minimum Tenure Formula"; Rec."Minimum Tenure Formula")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Minimum Tenure Formula';
                }
                field("No. of Instalment"; Rec."No. of Instalment")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. of Instalment';
                }
                field("Allow in Notice Period"; Rec."Allow in Notice Period")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Allow in Notice Period';
                }
                field("Allow Multiple Loan"; Rec."Allow Multiple Loan")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Allow Multiple Loan';
                }
                field("Allow Multiple Time"; Rec."Allow Multiple Time")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Allow Multiple Time';
                }
                field("End of Service"; Rec."End of Service")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the End of Service';
                }
                field("Include in Salary"; Rec."Include in Salary")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Include in Salary';
                }
                field("Minimum Days Between Request"; Rec."Minimum Days Between Request")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Minimum Days Between Request';
                }
            }
        }
    }

}
