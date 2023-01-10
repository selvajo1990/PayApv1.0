page 50092 "Employee Group History"
{
    PageType = List;
    SourceTable = "Employee Earning History";
    Caption = 'Employee Group History';
    Editable = false;
    UsageCategory = None;
    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Group Code"; Rec."Group Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Group Code';
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
                field("No. of Earning Components"; Rec."No. of Earning Components")
                {
                    ApplicationArea = All;
                    Visible = EarningComponentsEditableG;
                    ToolTip = 'Specifies the value of the No. of Earning Components';
                }
                field("No. of Absence Components"; Rec."No. of Absence Components")
                {
                    ApplicationArea = All;
                    Visible = AbsenceComponentEditableG;
                    ToolTip = 'Specifies the value of the No. of Absence Components';
                }
                field("No. of Loan Components"; Rec."No. of Loan Components")
                {
                    ApplicationArea = All;
                    Visible = LoanVisible;
                    ToolTip = 'Specifies the value of the Loan Types';
                }
                field("Air Ticket Component"; Rec."Air Ticket Component")
                {
                    ApplicationArea = All;
                    Visible = AirTicketVisible;
                    ToolTip = 'Specifies the value of the Air Ticket Component';
                }
            }
        }

    }
    trigger OnAfterGetRecord()
    begin
        EarningComponentsEditableG := (Rec."Component Type" = Rec."Component Type"::Earning);
        AbsenceComponentEditableG := (Rec."Component Type" = Rec."Component Type"::Absence);
        LoanVisible := (Rec."Component Type" = Rec."Component Type"::Loan);
        AirTicketVisible := (Rec."Component Type" = Rec."Component Type"::"Air Ticket");
    end;

    var
        EarningComponentsEditableG: Boolean;
        AbsenceComponentEditableG: Boolean;
        AirTicketVisible: Boolean;
        LoanVisible: Boolean;
}