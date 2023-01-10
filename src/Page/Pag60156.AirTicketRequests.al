page 60156 "Air Ticket Requests"
{

    PageType = List;
    SourceTable = "Air Ticket Request";
    Caption = 'Air Ticket Requests';
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    AssistEdit = true;
                    ToolTip = 'Specifies the value of the No.';
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
                field("Air Ticket Type"; Rec."Air Ticket Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Air Ticket Type';
                    trigger OnValidate()
                    begin
                        Rec."No. of Ticket" := 0;
                        Rec.Amount := 0;
                    end;
                }
                field("No. of Ticket"; Rec."No. of Ticket")
                {
                    ApplicationArea = All;
                    Editable = Rec."Air Ticket Type" = Rec."Air Ticket Type"::Ticket;
                    ToolTip = 'Specifies the value of the No. of Ticket';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    Editable = Rec."Air Ticket Type" = Rec."Air Ticket Type"::Amount;
                    ToolTip = 'Specifies the value of the Amount';
                }

                field("Requested Date"; Rec."Requested Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Request Date';
                }
                field("Approved Date"; Rec."Approved Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Approved Date';
                }

                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Status';
                }
                field("Pay with Salary"; Rec."Pay with Salary")
                {
                    ApplicationArea = All;
                    Editable = Rec."Air Ticket Type" = Rec."Air Ticket Type"::Amount;
                    ToolTip = 'Specifies the value of the Pay with Salary';
                }
            }
        }
    }

}
