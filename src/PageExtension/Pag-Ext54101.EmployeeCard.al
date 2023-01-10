pageextension 54101 "Employee Card" extends "Employee Card"
{
    layout
    {
        modify("No.")
        {
            ShowMandatory = true;
            /*trigger OnAfterValidate()
            var
                HRSetup: Record "Human Resources Setup";
                EmployeeL: Record Employee;
            begin
                if HRSetup.Get and (HRSetup."HR Manager" <> '') then begin
                    EmployeeL.Reset();
                    EmployeeL.SetRange("No.", HRSetup."HR Manager");
                    if EmployeeL.FindFirst() then begin
                        Rec."HR Manager" := EmployeeL."HR Manager";
                        Rec."HR Manager Name" := EmployeeL.FullName();
                    end;
                end;
            end;*/
        }
        modify("Job Title")
        {
            ShowMandatory = true;
            Caption = 'Designation';
        }
        modify("Termination Date")
        {
            Enabled = false;
        }
        modify("Middle Name")
        {
            Enabled = false;
            Visible = false;
        }
        modify(Initials)
        {
            Visible = false;
        }
        modify(Administration)
        {
            Caption = 'Employee Status';
        }
        modify("Employment Date")
        {
            ShowMandatory = true;
        }
        modify("Resource No.")
        {
            Visible = false;
        }
        modify("Search Name")
        {
            Editable = false;
        }
        modify("Salespers./Purch. Code")
        {
            Visible = false;
        }
        modify("Alt. Address Code")
        {
            Visible = false;
        }
        modify("Alt. Address Start Date")
        {
            Visible = false;
        }
        modify("Alt. Address End Date")
        {
            Visible = false;
        }
        modify("Social Security No.")
        {
            Caption = 'Emirates ID';
        }
        modify("Union Code")
        {
            Visible = false;
        }
        modify("Union Membership No.")
        {
            Visible = false;
        }
        moveafter("Last Name"; "Search Name")
        //moveafter(Payments; "Address & Contact")
        addafter("Job Title")
        {
            field("Work Location"; Rec."Work Location")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Work Location';
                ShowMandatory = true;
            }
            field(Department; rec.Department)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Department';
            }

            field("Line Manager"; Rec."Line Manager")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Line Manager';
                ShowMandatory = true;
            }
            field("Line Manager Name"; Rec."Line Manager Name")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Line Manager Name';
                ShowMandatory = true;
            }
        }
        // suganya-aplica
        moveafter("Line Manager Name"; Gender)
        moveafter(Gender; "Company E-Mail")
        moveafter("Company E-Mail"; "Last Date Modified")
        movebefore("Company E-Mail"; "Phone No.2")
        // suganya-aplica 

        addafter("Last Date Modified")
        {
            field("Last User Modified"; Rec."Last User Modified")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the value of the Last User Modified';
            }

            field(Manager; Rec.Manager)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Line Mgr.';
            }

            /* field("HR Manager"; Rec."HR Manager")
             {
                 ApplicationArea = All;
                 ToolTip = 'Specifies the value of the HR Manager';
             }
            field("HR Manager Name"; Rec."HR Manager Name")
             {
                 ApplicationArea = All;
                 ToolTip = 'Specifies the value of the HR Manager Name';
             }*/
            field("Years Completed"; Rec."Years Completed")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Completed Years';
            }
            // Commented by suganya-aplica
            /*field("Contract Employee"; "Contract Employee")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Contract Employee';
            }*/ // Commented by suganya-aplica

        }

        addafter("Birth Date")
        {
            field(Age; Rec.Age)
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the value of the Age';
            }
            field("Marital Status"; Rec."Marital Status")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Marital Status';
            }
            field("No. of Dependent"; Rec."No. of Dependent")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the No. of Dependent';
            }
            field("Language Code"; Rec."Language Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Language Code';
                Visible = false;
            }
            field("Employee Nationality"; Rec."Employee Nationality")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Employee Nationality';
            }
            field("Employer Nationality"; Rec."Employer Nationality")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Employer Nationality';
                Visible = false;
            }
            field(Religion; Rec.Religion)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Religion';
            }
        }
        modify(Payments)
        {
            Caption = 'Sponsor / Payment';
        }
        addbefore("Employee Posting Group")
        {
            field("Sponsor Type"; Rec."Sponsor Type")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Sponsor Type';
            }
        }
        //Suganya-aplica
        addafter("SWIFT Code")
        {
            field("WPS Bank Code"; rec."WPS Bank Code")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the WPS Bank Code';
            }
            field("Insurance Level"; rec."Insurance Level")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Insurance Level';
            }
        }
        addafter(General)
        {
            group("Employment")
            {

                field("Probation Start Date"; Rec."Probation Start Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Probation Start Date';
                    ShowMandatory = true;
                }
                field("Probation Period"; Rec."Probation Period")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Probation Period';
                    ShowMandatory = true;
                }
                field("Probation End Date"; Rec."Probation End Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Probation End Date';
                }

                field("Notice Period Start Date"; Rec."Notice Period Start Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Notice Period Start Date';
                }
                field("Notice Period"; Rec."Notice Period")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Notice Period';
                }
                field("Last Salary Paid Pate"; Rec."Last Salary Paid Pate")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Last Salary Paid Date';
                }
            }
            group("Pay Ap")
            {
                Caption = 'Pay Ap';

                field(Grade; Rec.Grade)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Grade';
                    ShowMandatory = true;
                }
                field("Sub Grade"; Rec."Sub Grade")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Sub Grade';
                }
                field("Sub Grade Description"; Rec."Sub Grade Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Sub Grade Description';
                    Visible = false;
                }
                field("Salary Class"; Rec."Salary Class")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Salary Class';
                    ShowMandatory = true;
                }
                field("Absence Group"; Rec."Absence Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Absence Group';
                }
                field("Earning Group"; Rec."Earning Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Earning Group';
                    ShowMandatory = true;
                }

                field(Calendar; Rec.Calendar)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Calendar';
                    ShowMandatory = true;
                }
                field("Pay Cycle"; Rec."Pay Cycle")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Pay Cycle';
                    ShowMandatory = true;
                }
                field("Payment Type"; Rec."Payment Type")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Payment Type';
                }
                field("Travel & Expense Group"; Rec."Travel & Expense Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Travel & Expense Group';
                }
                field("Loan & Advance Group"; Rec."Loan & Advance Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Loan & Advance Group';
                }
                field("Gratuity Accrual Start Date"; Rec."Gratuity Accrual Start Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Gratuity Accrual Start Date';
                }
                field("Leave Accrual Start Date"; Rec."Leave Accrual Start Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Leave Accrual Start Date';
                }
                field(Password; Rec.Password)
                {
                    ApplicationArea = All;
                    //ExtendedDatatype = Masked;
                    //  Visible = IsVisible;
                }
                group("Air Ticket")
                {
                    field("Air Ticket Group"; Rec."Air Ticket Group")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Air Ticket Group';
                    }
                    field("Flight Destination Code"; Rec."Flight Destination Code")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Flight Destination Code';
                    }
                    field("Air Fare"; "Air Fare")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Air Fare';
                        Editable = false;
                    }
                    field("Air Ticket Accrual Start Date"; Rec."Air Ticket Accrual Start Date")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Air Ticket Accrual Start Date';
                    }
                }
            }
        }
        movebefore(Administration; "Address & Contact")

        // Suganya-aplica
        addafter("Employee Posting Group")
        {
            field("Bank Name"; rec."Bank Name")
            {
                ApplicationArea = all;
                TableRelation = "Bank Account";
                ToolTip = 'Specifies the value of the Bank Name';
            }
        }
        addafter("E-Mail")
        {
            field("Native Address"; rec."Native Address")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Native Address';
            }
            field("Native Contact No."; rec."Native Contact No.")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Native Contact No.';
            }
        }
        // Suganya-aplica
        modify(Pager)
        {
            Visible = false;
        }
        addafter(Payments)
        {
            group(AccommodationTab)
            {
                Caption = 'Accommodation';

                field("Accommodation Type"; Rec."Accommodation Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Accommodation Type';
                }
                field("Accommodation Start Date"; Rec."Accommodation Start Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Accommodation Start Date';
                }
                field("Accommodation End Date"; Rec."Accommodation End Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Accommodation End Date';
                }
                field(Notes; Rec.Notes)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Notes';
                }
            }
        }
        moveafter("Notice Period"; "Termination Date")
        movebefore("Probation Start Date"; "Employment Date")
        // Suganya-aplica
        modify("Statistics Group Code")
        {
            Visible = false;
        }// Suganya-aplica
        addafter("Statistics Group Code")
        {
            field("MOL ID"; Rec."MOL ID")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Labor ID';
            }
        }
        // Suganya-aplica
        modify("Application Method")
        {
            Visible = false;
        }// Suganya-aplica
        addafter("Application Method")
        {
            field("Bank Branch Name"; "Bank Branch Name")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Application Method';
            }
        }
    }
    actions
    {
        modify("Misc. Articles &Overview")
        {
            Visible = false;
        }
        modify("Co&nfidential Info. Overview")
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
        addafter("Q&ualifications")
        {
            /* action(Accommodation)
            {
                Caption = 'Accommodation';
                Image = Home;
                ApplicationArea = All;
                RunObject = page Accommodations;
                RunPageMode = View;
            } */
            /*action("Designation")
            {
                ApplicationArea = All;
                Image = ExpandDepositLine;
                Caption = 'Designation';
                RunObject = page "Employee Level Designations";
                RunPageLink = "Employee No." = field("No.");
                ToolTip = 'Executes the Designation action.';
            }*/
            /*action("Employee Items")
            {
                ApplicationArea = All;
                Image = "Item";
                Caption = 'Loaned Items';
                RunObject = page "Employee Assets";
                RunPageLink = "Employee No." = field("No.");
                ToolTip = 'Executes the Loaned Items action.';
            }*/
            action(Idendification)
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
                action("Confirm")
                {
                    Caption = 'Confirm';
                    ApplicationArea = all;
                    Image = Confirm;
                    ToolTip = 'Executes the Confirm action.';
                    trigger OnAction()
                    var
                        EmployeeEarningHistoryL: Record "Employee Earning History";
                        PageFilterL: FilterPageBuilder;
                        FromDateL: date;
                        FromDateMandatoryErr: Label '%1 must have value';
                        FromDateValidationErr: Label '%1 should not be earlier than %2: %3';
                    begin
                        Rec.TestField("Earning Group");
                        Rec.TestField("Employment Date");
                        PageFilterL.AddRecord('Group Filter', EmployeeEarningHistoryL);
                        PageFilterL.AddField('Group Filter', EmployeeEarningHistoryL."From Date");
                        if PageFilterL.RunModal() then begin
                            EmployeeEarningHistoryL.SetView(PageFilterL.GetView('Group Filter'));
                            if EmployeeEarningHistoryL.GetFilter("From Date") = '' then
                                Error(FromDateMandatoryErr, EmployeeEarningHistoryL.FieldCaption("From Date"));
                            Evaluate(FromDateL, EmployeeEarningHistoryL.GetFilter("From Date"));
                            if FromDateL < Rec."Employment Date" then
                                Error(FromDateValidationErr, EmployeeEarningHistoryL.FieldCaption("From Date"), Rec.FieldCaption("Employment Date"), Rec."Employment Date");
                            Rec.CreateUpdateEarningGroupLines(FromDateL);
                            if Rec."Absence Group" > '' then
                                Rec.CreateUpdateAbsenceGroupLine(FromDateL);
                            if Rec."Loan & Advance Group" > '' then
                                Rec.CreateUpdateLoanGroupLine(FromDateL);
                            if Rec."Air Ticket Group" > '' then
                                Rec.CreateUpdateAirTicketGroup(FromDateL);
                        end;
                    end;
                }
                action("Employee Level Earning")
                {
                    Caption = 'Employee Earning';
                    ApplicationArea = All;
                    Image = EmployeeAgreement;
                    RunPageView = sorting("From Date", "To Date") order(ascending);
                    RunObject = page "Employee Group History";
                    RunPageLink = "Employee No." = field("No."), "Component Type" = filter(Earning);
                    ToolTip = 'Executes the Employee Earning action.';
                }
                action("Employee Level Absence")
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
        addafter(History)
        {
            group("Assets")
            {
                Caption = 'Assets';
                Image = FixedAssets;
                action("Employee Assets")
                {
                    ApplicationArea = All;
                    Image = "Item";
                    Caption = 'Employee Assets';
                    RunObject = page "Employee Assets";
                    RunPageLink = "Employee No." = field("No.");
                    ToolTip = 'Executes the Employee Assets action.';
                }
            }
            group("Disciplinary")
            {
                Caption = 'Disciplinary';
                Image = AddAction;
                action("Disciplinary Actions")
                {
                    ApplicationArea = All;
                    Image = HumanResources;
                    Caption = 'Disciplinary Actions';
                    RunObject = page "Employee Disciplinary Action";
                    RunPageLink = "Employee No." = field("No.");
                    ToolTip = 'Executes the Disciplinary action.';
                }
            }
        }
    }
    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if Rec."No." > '' then
            Rec.TestField("Employment Date");
    end;

    trigger OnOpenPage()
    var
        NoOfYears: Integer;
        NoOfMonths: Integer;
    //TotalMonths: Integer;
    //CurrentDateL: Integer;
    //EmployementDateL: Integer;
    //DateFormatLbl: Label '<Year4><Month,2><Day,2>';
    begin
        if Rec."Employment Date" > 0D then begin
            NoOfYears := Date2DMY(Today(), 3) - Date2DMY("Employment Date", 3);
            NoOfMonths := Date2DMY(Today(), 2) - Date2DMY("Employment Date", 2);
            //TotalMonths := (12 * NoOfYears + NoOfMonths);
            //Message('%1&%2', NoOfYears, NoOfMonths);
            Rec."Years Completed" := Format(NoOfYears) + ' Years & ' + Format(NoOfMonths) + ' Months';
            Rec.Modify();
        end;
        /*if Rec."Employment Date" > 0D then begin
            Evaluate(CurrentDateL, FORMAT(Today(), 10, DateFormatLbl));
            Evaluate(EmployementDateL, FORMAT(Rec."Employment Date", 10, DateFormatLbl));
            Rec."Years Completed" := (CurrentDateL - EmployementDateL) DIV 10000;
            Rec.Modify();
        end;*/
    end;

    // trigger OnAfterGetRecord()
    // var
    //     NoOfYears: Integer;
    //     NoOfMonths: Integer;
    // begin
    //     if Rec."Employment Date" > 0D then begin
    //         NoOfYears := Date2DMY(Today(), 3) - Date2DMY("Employment Date", 3);
    //         NoOfMonths := Date2DMY(Today(), 2) - Date2DMY("Employment Date", 2);
    //         Rec."Years Completed" := Format(NoOfYears) + ' Years & ' + Format(NoOfMonths) + ' Months';
    //         Rec.Modify();
    //     end;
    // end;

    trigger OnModifyRecord(): Boolean
    var
        UserSetup: Record "User Setup";
    begin
        if UserSetup.Get() then begin
            Rec."Last User Modified" := UserSetup."User ID";
            Rec.Modify();
        end;
    end;

    // trigger OnOpenPage()
    // begin
    //     Clear(IsVisible);
    //     if (UserId = 'BCDEV\APLICA02') then
    //         IsVisible := true
    //     else
    //         IsVisible := false;
    // end;

    // var
    //     IsVisible: Boolean;
}
