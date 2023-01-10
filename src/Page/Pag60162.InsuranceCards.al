page 60162 "Insurance Cards"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Insurance Information";
    Caption = 'Insurance Details';

    layout
    {
        area(Content)
        {
            group(General)
            {

                field("Level in Insurance"; Rec."Level in Insurance Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Insurance Levels';
                }
                field("Level in Insurance Description"; Rec."Level in Insurance Description")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Level in Insurance Description';
                }
                field("Type of Insurance"; Rec."Type of Insurance Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Insurance Types';

                }
                field("Type of Insurance Description"; Rec."Type of Insurance Description")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Type of Insurance Description';
                }
                field("From Date"; Rec."From Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the From Date';
                }
                field("To Date"; Rec."To Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the To Date';
                }
                field("Insurance Amount"; Rec."Insurance Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Insurance Amount';
                }
            }
            group("Company Information")
            {
                field("Company Name"; Rec."Company Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Company Name';
                }
                field("Contact Person"; Rec."Contact Person")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Contact Person';
                }
                field("E-Mail ID"; Rec."E-Mail ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the E-Mail ID';
                }
                field(Address; Rec.Address)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Address';
                }

                field("Policy Number"; Rec."Policy Number")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Policy Number';
                }
                field("Contact Number"; Rec."Contact Number")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Contact Number';
                }



            }

            part(Lines; "Employee Detail")
            {
                Caption = 'Employee Details';
                ApplicationArea = All;
                SubPageLink = "Document No." = field("No.");

            }
        }
    }
    actions
    {
        area(Reporting)
        {
            action("Insurance Details")
            {
                ApplicationArea = All;
                Caption = 'Insurance Details';
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;
                Image = Report;
                PromotedCategory = Report;
                ToolTip = 'Executes the Insurance Details action.';
                trigger OnAction()
                var
                    InsuranceDetails: Record "Insurance Information";
                begin
                    InsuranceDetails.reset();
                    InsuranceDetails.SetRange("Level in Insurance Code", Rec."Level in Insurance Code");
                    InsuranceDetails.setrange("Type of Insurance Code", Rec."Type of Insurance Code");
                    InsuranceDetails.SetRange("From Date", Rec."From Date");
                    InsuranceDetails.SetRange("To Date", Rec."To Date");
                    InsuranceDetails.SetRange("Insurance Amount", Rec."Insurance Amount");
                    Report.RunModal(54205, true, true, InsuranceDetails);
                end;
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."No." := 0;
    end;
}