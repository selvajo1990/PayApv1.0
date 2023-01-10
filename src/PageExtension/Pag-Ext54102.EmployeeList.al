pageextension 54102 "Employee List" extends "Employee List"
{
    layout
    {
        // Add changes to page layout here
        addafter("Last Name")
        {
            field(Password; Rec.Password)
            {
                Visible = IsVisibleG;
            }
        }
    }
    actions
    {
        modify("Misc. Articles &Overview")
        {
            Visible = false;
        }
        modify("Absences by Ca&tegories")
        {
            Visible = false;
        }
        modify("A&bsences")
        {
            Visible = false;
        }
        modify("Con&fidential Info. Overview")
        {
            Visible = false;
        }
        addafter("Q&ualifications")
        {
            action(Accommodation)
            {
                Caption = 'Accommodation';
                Image = Home;
                ApplicationArea = All;
                RunObject = page Accommodations;
                RunPageMode = View;
                ToolTip = 'Executes the Accommodation action.';
            }
            action("Designation")
            {
                ApplicationArea = All;
                Image = ExpandDepositLine;
                Caption = 'Designation';
                RunObject = page "Employee Level Designations";
                RunPageLink = "Employee No." = field("No.");
                ToolTip = 'Executes the Designation action.';
            }
            action("Employee Assets")
            {
                ApplicationArea = All;
                Image = "Item";
                Caption = 'Employee Assets';
                RunObject = page "Employee Assets";
                RunPageLink = "Employee No." = field("No.");
                ToolTip = 'Executes the Loaned Items action.';
            }
            action(Identification)
            {
                ApplicationArea = All;
                Image = Find;
                Caption = 'Identification';
                RunObject = page "Employee Level Identification";
                RunPageLink = "Employee No." = field("No.");
                ToolTip = 'Executes the Identification action.';
            }
            action("Bank Details")
            {
                ApplicationArea = All;
                Image = BankAccount;
                Caption = 'Bank Details';
                RunObject = page "Bank Account Details";
                RunPageLink = "Employee No." = field("No.");
                ToolTip = 'Executes the Bank Details action.';
            }
        }
        addafter("E&mployee")
        {
            group("Pay Ap Aplica")
            {
                Caption = 'Pay Ap';
                Image = PayrollStatistics;

                action("Earning")
                {
                    Caption = 'Employee Earnings';
                    ApplicationArea = All;
                    Image = EmployeeAgreement;
                    RunPageView = sorting("From Date", "To Date") order(ascending);
                    RunObject = page "Employee Group History";
                    RunPageLink = "Employee No." = field("No."), "Component Type" = filter(Earning);
                    ToolTip = 'Executes the Employee Earnings action.';
                }
                action("Absence")
                {
                    Caption = 'Employee Absence';
                    ApplicationArea = All;
                    Image = EmployeeAgreement;
                    RunPageView = sorting("From Date", "To Date") order(ascending);
                    RunObject = page "Employee Group History";
                    RunPageLink = "Employee No." = field("No."), "Component Type" = filter(Absence);
                    ToolTip = 'Executes the Employee Absence action.';
                }
                action("Employee Level Loan")
                {
                    Caption = 'Employee Loan';
                    ApplicationArea = All;
                    Image = Loaner;
                    RunPageView = sorting("From Date", "To Date") order(ascending);
                    RunObject = page "Employee Group History";
                    RunPageLink = "Employee No." = field("No."), "Component Type" = filter(Loan);
                    ToolTip = 'Executes the Employee Loan action.';
                }
                action("Employee Level Air Ticket")
                {
                    Caption = 'Employee Air Ticket';
                    ApplicationArea = All;
                    Image = BookingsLogo;
                    RunPageView = sorting("From Date", "To Date") order(ascending);
                    RunObject = page "Employee Group History";
                    RunPageLink = "Employee No." = field("No."), "Component Type" = filter("Air Ticket");
                    ToolTip = 'Executes the Employee Air Ticket action.';
                }
                action("Timings")
                {
                    Caption = 'Timings';
                    ApplicationArea = All;
                    Image = Timeline;
                    RunObject = page "Employee Timing";
                    RunPageLink = "Employee No." = field("No.");
                    ToolTip = 'Executes the Timings action.';
                }
            }
        }
    }
    /*trigger OnOpenPage()
    var

    begin
        Clear(IsVisibleG);
        if (UserId = 'BCDEV\APLICA02') then
            IsVisibleG := true
        else
            IsVisibleG := false;
    end;*/

    var
        IsVisibleG: Boolean;

    procedure SetSelection(var EmployeeP: Record Employee)
    begin
        CurrPage.SETSELECTIONFILTER(EmployeeP);
    end;

    procedure GetSelectionFilter(): Text
    var
        EmployeeL: Record Employee;
        SelectionFilterL: Codeunit SelectionFilterManagement;
        RecRefL: RecordRef;
    begin
        CurrPage.SETSELECTIONFILTER(EmployeeL);
        RecRefL.GetTable(EmployeeL);
        EXIT(SelectionFilterL.GetSelectionFilter(RecRefL, EmployeeL.FIELDNO("No.")));
    end;
}