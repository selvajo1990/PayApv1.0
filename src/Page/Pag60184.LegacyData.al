page 60184 "Legacy Data"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Legacy Data";
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater("Legacy Data")
            {
                field(Date; rec.Date)
                {
                    ApplicationArea = all;
                }
                field("Employee Code"; rec."Employee Code")
                {
                    ApplicationArea = All;
                }
                field("Employee Name"; rec."Employee Name")
                {
                    ApplicationArea = All;
                }
                field("MOL Code"; rec."MOL Code")
                {
                    ApplicationArea = all;
                }
                field(Attendance; rec.Attendance)
                {
                    ApplicationArea = all;
                }
                field("Cost Center"; rec."Cost Center")
                {
                    ApplicationArea = all;
                }
                field(Basic; rec.Basic)
                {
                    ApplicationArea = all;
                }
                field(HRA; rec.HRA)
                {
                    ApplicationArea = all;
                }
                field("Additional Allownace"; rec."Additional Allownace")
                {
                    ApplicationArea = all;
                }
                field(Incentive; rec.Incentive)
                {
                    ApplicationArea = all;
                }
                field(Cell; rec.Cell)
                {
                    ApplicationArea = all;
                }
                field(Transport; rec.Transport)
                {
                    ApplicationArea = all;
                }
                field(Total; rec.Total)
                {
                    ApplicationArea = all;
                }
                field("Advance Deduction"; rec."Advance Deduction")
                {
                    ApplicationArea = all;
                }
                field("Loan Deduction"; rec."Loan Deduction")
                {
                    ApplicationArea = all;
                }
                field("Other Deduction"; rec."Other Deduction")
                {
                    ApplicationArea = all;
                }
                field("Other Addition"; rec."Other Addition")
                {
                    ApplicationArea = all;
                }
                field("Net Payable"; rec."Net Payable")
                {
                    ApplicationArea = all;
                }
                field("WPS Fixed"; rec."WPS Fixed")
                {
                    ApplicationArea = all;
                }
                field("WPS Variable"; rec."WPS Variable")
                {
                    ApplicationArea = all;
                }
                field("NET WPS"; rec."NET WPS")
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    var
        myInt: Integer;
}