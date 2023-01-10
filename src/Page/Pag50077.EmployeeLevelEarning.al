page 50077 "Employee Level Earning"
{
    PageType = List;
    SourceTable = "Employee Level Earning";
    Caption = 'Employee Level Earning';
    UsageCategory = None;
    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Earning Code"; Rec."Earning Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Earning Code';
                }
                field("Payment Type"; Rec."Payment Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Payment Type';
                    //Editable = "Payment Type" = "Payment Type"::Percentage; Avi : Should be editable.
                }
                field("Base Code"; Rec."Base Code")
                {
                    ApplicationArea = All;
                    Editable = Rec."Payment Type" = Rec."Payment Type"::Percentage;
                    ToolTip = 'Specifies the value of the Base Code';
                }
                field("Computation Code"; Rec."Computation Code")
                {
                    ApplicationArea = All;
                    Editable = Rec."Payment Type" = Rec."Payment Type"::Computation;
                    ToolTip = 'Specifies the value of the Computation Code';
                }
                field("Pay Percentage"; Rec."Pay Percentage")
                {
                    ApplicationArea = All;
                    Editable = Rec."Payment Type" = Rec."Payment Type"::Percentage;
                    ToolTip = 'Specifies the value of the Pay Percentage';
                }
                field("Pay Amount"; Rec."Pay Amount")
                {
                    ApplicationArea = All;
                    Editable = Rec."Payment Type" = Rec."Payment Type"::Amount;
                    ToolTip = 'Specifies the value of the Pay Amount';
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
                field("Day Type"; Rec."Day Type")
                {
                    ApplicationArea = All;
                    Editable = Rec.Hourly and (Rec.Type = Rec.Type::Constant);
                    ToolTip = 'Specifies the value of the Day Type';
                }
                field("Minimum Number of Days"; Rec."Minimum Number of Days")
                {
                    ApplicationArea = All;
                    Editable = Rec.Hourly and (Rec.Type = Rec.Type::Constant);
                    ToolTip = 'Specifies the value of the Minimum Number of Days';
                }
                field("Minimum Duration"; Rec."Minimum Duration")
                {
                    ApplicationArea = All;
                    Editable = Rec.Hourly and (Rec.Type = Rec.Type::Constant);
                    ToolTip = 'Specifies the value of the Minimum Duration';
                }
            }
        }
    }
    trigger OnNewRecord(BelowxRec: Boolean)
    begin
    end;

    trigger OnDeleteRecord(): Boolean
    begin
    end;

    trigger OnModifyRecord(): Boolean
    begin
    end;

    procedure IsAllowedToEdit(): Boolean
    var
        EmployeeEarningHistoryL: Record "Employee Earning History";
    begin
        if EmployeeEarningHistoryL.Get(Rec."Employee No.", Rec."Group Code", Rec."From Date") and (EmployeeEarningHistoryL."To Date" > 0D) then
            exit(false);
        exit(true);
    end;
}