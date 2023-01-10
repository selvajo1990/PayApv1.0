page 50040 "HR Role Center"
{
    PageType = RoleCenter;
    Caption = 'Human Resource Manager';
    layout
    {
        area(RoleCenter)
        {
            part("HeadLine RC Pay Ap"; "Pay Ap HeadLine")
            {
                ApplicationArea = All;
            }
            part("Human Resource Cue"; "Human Resource Cue")
            {
                Caption = ' ';
                ApplicationArea = Basic, Suite;
            }

            part("Employee Department Chart"; "Employee Department Chart")
            {
                Caption = 'Employee Department';
                ApplicationArea = all;
            }
            part("Employee Absence Chart"; "Employee Leave Chart")
            {
                Caption = 'Employee Absence';
                ApplicationArea = all;
            }
            // part("Notes"; "My Notes")
            // {
            //     ApplicationArea = All;
            // }
        }
    }

    actions
    {
        area(Sections)
        {
            group("Human Resources")
            {
                action(Employees)
                {
                    ApplicationArea = All;
                    RunObject = page "Employee List";
                    RunPageView = where(Status = filter(Active | Inactive));
                    Caption = 'Employees';
                    Image = Employee;
                    ToolTip = 'Executes the Employees action.';
                }
                action("Past Employees")
                {
                    ApplicationArea = All;
                    RunObject = page "Past Employee List";
                    Image = Employee;
                    ToolTip = 'Executes the Past Employees action.';
                }
                action(Departments)
                {
                    ApplicationArea = All;
                    RunObject = page Departments;
                    Caption = 'Departments';
                    Image = Departments;
                    ToolTip = 'Executes the Departments action.';
                }
                action(Designations)
                {
                    ApplicationArea = All;
                    RunObject = page Designation;
                    Caption = 'Designations';
                    Image = ExpandDepositLine;
                    ToolTip = 'Executes the Designations action.';
                }
                action(Religions)
                {
                    ApplicationArea = All;
                    RunObject = page Religions;
                    Caption = 'Religions';
                    Image = Replan;
                    ToolTip = 'Executes the Religions action.';
                }
                action(Accommodation)
                {
                    ApplicationArea = All;
                    Image = Home;
                    RunObject = page Accommodations;
                    Caption = 'Accommodations';
                    ToolTip = 'Executes the Accommodations action.';
                }
                action("Loan Types")
                {
                    ApplicationArea = All;
                    RunObject = page "Employee Asset Types";
                    Caption = 'Employee Asset Types';
                    Image = Loaner;
                    ToolTip = 'Executes the Loan Types action.';
                }
                /*action("Loan Items")
                {
                    ApplicationArea = All;
                    RunObject = page "Employee Asset Items";
                    Caption = 'Employee Asset Items';
                    Image = Item;
                    ToolTip = 'Executes the Loan Items action.';
                }*/
                action("Bank Accounts")
                {
                    ApplicationArea = All;
                    RunObject = page "Bank Account Master";
                    Caption = 'Bank Accounts';
                    Image = BankAccount;
                    ToolTip = 'Executes the Bank Accounts action.';
                }
                action("Issuing Agencies")
                {
                    ApplicationArea = All;
                    RunObject = page "Issuing Agency";
                    Caption = 'Issuing Agencies';
                    Image = Agreement;
                    ToolTip = 'Executes the Issuing Agencies action.';
                }
                action(Identification)
                {
                    ApplicationArea = All;
                    RunObject = page Identification;
                    Caption = 'Identification';
                    Image = Indent;
                    ToolTip = 'Executes the Identification action.';
                }
                action("Sponsor Types")
                {
                    ApplicationArea = All;
                    RunObject = page "Sponsor Types";
                    Caption = 'Sponsor Type';
                    Image = SalesPerson;
                    ToolTip = 'Executes the Sponsor Type action.';
                }
                action("Paymeny Types")
                {
                    ApplicationArea = All;
                    RunObject = page "Payment Types";
                    Caption = 'Payment Types';
                    Image = Payables;
                    ToolTip = 'Executes the Payment Types action.';
                }
                action("Level Type")
                {
                    ApplicationArea = All;
                    RunObject = page 60165;
                    Caption = 'Insurance Levels';
                    Image = Insurance;
                    ToolTip = 'Executes the Insurance Levels action.';

                }
                action("Insurance Type")
                {
                    ApplicationArea = all;
                    RunObject = page 60166;
                    Caption = 'Insurance Type';
                    Image = Insurance;
                    ToolTip = 'Executes the Insurance Type action.';
                }
            }
            group(Payroll)
            {
                action("Salary Class")
                {
                    ApplicationArea = All;
                    RunObject = page "Salary Class List";
                    Caption = 'Salary Class';
                    Image = Category;
                    ToolTip = 'Executes the Salary Class action.';
                }
                action(Levels)
                {
                    ApplicationArea = All;
                    RunObject = page Grades;
                    Caption = 'Grades';
                    Image = Line;
                    ToolTip = 'Executes the Grades action.';
                }
                action("Sub Grades")
                {
                    ApplicationArea = All;
                    RunObject = page "Sub Grades";
                    Caption = 'Sub Grades';
                    Image = LinesFromJob;
                    ToolTip = 'Executes the Sub Grades action.';
                }
                action("Pay Cycle")
                {
                    ApplicationArea = All;
                    RunObject = page "Pay Cycle List";
                    Caption = 'Pay Cycles';
                    Image = PaymentDays;
                    ToolTip = 'Executes the Pay Cycles action.';
                }
                action(Earnings)
                {
                    ApplicationArea = All;
                    RunObject = page Earnings;
                    Caption = 'Earnings';
                    Image = Documents;
                    ToolTip = 'Executes the Earnings action.';
                }
                action("Earning Group")
                {
                    ApplicationArea = All;
                    RunObject = page "Earning Group List";
                    Caption = 'Earning Groups';
                    Image = Documents;
                    ToolTip = 'Executes the Earning Groups action.';
                }
                action(Absence)
                {
                    ApplicationArea = All;
                    RunObject = page "Absence List";
                    Caption = 'Absences';
                    Image = Absence;
                    ToolTip = 'Executes the Absences action.';
                }
                action("Absence Group")
                {
                    ApplicationArea = All;
                    RunObject = page "Absence Group List";
                    Caption = 'Absence Groups';
                    Image = AbsenceCalendar;
                    ToolTip = 'Executes the Absence Groups action.';
                }
                action(Computation)
                {
                    ApplicationArea = All;
                    RunObject = page "Computation List";
                    Caption = 'Computations';
                    Image = Calculate;
                    ToolTip = 'Executes the Computations action.';
                }
                action(Calendar)
                {
                    ApplicationArea = All;
                    RunObject = page "Timing List";
                    Caption = 'Calendar';
                    Image = Timeline;
                    ToolTip = 'Executes the Calendar action.';
                }
                action("Loans & Advances")
                {
                    ApplicationArea = All;
                    RunObject = page Loans;
                    Image = Loaner;
                    ToolTip = 'Executes the Loans & Advances action.';
                }
                action("Loan Groups")
                {
                    ApplicationArea = All;
                    RunObject = page "Loan Groups";
                    Image = Loaner;
                    ToolTip = 'Executes the Loan Groups action.';
                }
                /*action("Pension/PASI/GOSI Category")
                {
                    ApplicationArea = all;
                    RunObject = page "Pension Category List";
                    Image = ListPage;
                    ToolTip = 'Executes the Pension/PASI/GOSI Category action.';
                }*/
                /*Action("Pension/PASI/GOSI")
                {
                    ApplicationArea = All;
                    RunObject = page PensionPasiGosiList;
                    Image = ListPage;
                    ToolTip = 'Executes the Pension/PASI/GOSI action.';
                }*/
                Action("Disciplinary Actions")
                {
                    ApplicationArea = All;
                    RunObject = page "Disciplinary Action List";
                    Image = ListPage;
                    ToolTip = 'Executes & Opens the page Disciplinary Action';
                }

            }
            group(Transactions)
            {
                action("Leave Request")
                {
                    ApplicationArea = All;
                    RunObject = page "Leave Request List";
                    Caption = 'Leave Request';
                    Image = AbsenceCategory;
                    ToolTip = 'Executes the Leave Request action.';
                }
                action("End of Service")
                {
                    ApplicationArea = All;
                    RunObject = page "End of Service List";
                    Caption = 'End of Service';
                    Image = TerminationDescription;
                    ToolTip = 'Executes the End of Service action.';
                }
                action("Opening Balance")
                {
                    ApplicationArea = All;
                    RunObject = page "Opening Balance";
                    Caption = 'Opening Balance';
                    Image = BankAccountRec;
                    ToolTip = 'Executes the Opening Balance action.';
                }
                action("Withhold Salary")
                {
                    ApplicationArea = All;
                    RunObject = page "Withhold Salary";
                    Caption = 'Withhold Salary';
                    Image = ServiceHours;
                    ToolTip = 'Executes the Withhold Salary action.';
                }
                action("Adhoc Payments")
                {
                    ApplicationArea = All;
                    RunObject = page "Adhoc Payment";
                    Caption = 'Adhoc Payments';
                    Image = Payment;
                    ToolTip = 'Executes the Adhoc Payments action.';
                }
                action("Leave Encashment")
                {
                    ApplicationArea = all;
                    RunObject = page "Leave Encashment";
                    Caption = 'Leave Encashment';
                    Image = Payables;
                    ToolTip = 'Executes the Leave Encashment action.';
                }
                action("Loan Request List")
                {
                    ApplicationArea = All;
                    RunObject = Page "Loan Request List";
                    Caption = 'Loan & Advance Requests';
                    Image = Loaner;
                    ToolTip = 'Executes the Loan & Advance Requests action.';
                }
                action("Insurance Details List")
                {
                    ApplicationArea = All;
                    RunObject = Page "Insurance Details Lists";
                    Caption = 'Insurance Details';
                    Image = Insurance;
                    ToolTip = 'Executes the Insurance Details action.';
                }
                Action("Employee Disciplinary Action")
                {
                    ApplicationArea = All;
                    RunObject = page "Employee Disciplinary Action";
                    Image = ListPage;
                    ToolTip = 'Executes the Employee Disciplinary action.';
                }
                action("Air Ticket Requests")
                {
                    Image = Item;
                    ApplicationArea = All;
                    RunObject = page "Air Ticket Requests";
                    ToolTip = 'Executes the Air Ticket Requests action.';
                }
                action("Salary Increments")
                {
                    ApplicationArea = All;
                    RunObject = page "Salary Increment List";
                    Image = ListPage;
                    ToolTip = 'Executes the Salary Increments action.';
                }
                Action("Employee Timing")
                {
                    ApplicationArea = All;
                    RunObject = page "Employee Timing";
                    Image = ListPage;
                    ToolTip = 'Executes the Employee Timing action.';
                }
                /*action("Advance PASI/ GOSI")
                {
                    ApplicationArea = All;
                    RunObject = page "AdvancePasi/GosiList";
                    Caption = 'Advance PASI/ GOSI';
                    Image = ListPage;
                    ToolTip = 'Executes the Advance PASI/ GOSI action.';
                }*/
            }
            group("Computation Details")
            {
                action("Salary Computation Display")
                {
                    ApplicationArea = All;
                    RunObject = page "Salary Computation List";
                    Caption = 'Salary Computation Display';
                    Image = ShowSelected;
                    ToolTip = 'Executes the Salary Computation Display action.';
                }
                action("Employer Deduction")
                {
                    ApplicationArea = All;
                    RunObject = page "Employer Deduction List";
                    Caption = 'Accruals & Deductions';
                    Image = ShowList;
                    ToolTip = 'Executes the Accruals & Deductions action.';
                }
            }
            group("Travel & Expenses")
            {
                Caption = 'Travel & Expenses';
                action("Travel & Expense Groups")
                {
                    Image = Item;
                    ApplicationArea = All;
                    RunObject = page "Travel & Expense Group";
                    ToolTip = 'Executes the Travel & Expense Groups action.';
                }
                action("Destination Types")
                {
                    Image = Item;
                    ApplicationArea = All;
                    RunObject = page "Destination Types";
                    ToolTip = 'Executes the Destination Types action.';
                }
                action("Destinations")
                {
                    Image = Item;
                    ApplicationArea = All;
                    RunObject = page Destinations;
                    ToolTip = 'Executes the Destinations action.';
                }
                action("Mode of Transports")
                {
                    Image = Item;
                    ApplicationArea = All;
                    RunObject = page "Mode of Transports";
                    ToolTip = 'Executes the Mode of Transports action.';
                }
                action("Purpose of Visits")
                {
                    Image = Item;
                    ApplicationArea = All;
                    RunObject = page "Purpose of Visits";
                    ToolTip = 'Executes the Purpose of Visits action.';
                }
                action("Expense Category")
                {
                    Image = Item;
                    ApplicationArea = All;
                    RunObject = page "Expense Category";
                    ToolTip = 'Executes the Expense Category action.';
                }
                action("Travel & Expense Configuration")
                {
                    Image = Item;
                    ApplicationArea = All;
                    RunObject = page "Travel & Expense Configuration";
                    ToolTip = 'Executes the Travel & Expense Configuration action.';
                }
                action("Travel & Expense Advances")
                {
                    Image = Item;
                    ApplicationArea = All;
                    RunObject = page "Travel & Expense Advances";
                    ToolTip = 'Executes the Travel & Expense Advances action.';
                }
                action("Travel Requisition & Expense Claims")
                {
                    Image = Item;
                    ApplicationArea = All;
                    RunObject = page "Travel Req & Expense Claim";
                    ToolTip = 'Executes the Travel Requisition & Expense Claims action.';
                }
            }
            group("Air Tickets")
            {
                action("Age Group")
                {
                    ApplicationArea = All;
                    RunObject = page "Age Group";
                    Caption = 'Age Group';
                    Image = Aging;
                    ToolTip = 'Executes the Age Group action.';
                }
                action("Flight Destinations")
                {
                    Image = Item;
                    ApplicationArea = All;
                    RunObject = page "Flight Destinations";
                    ToolTip = 'Executes the Flight Destinations action.';
                }
                action("Flight Costs")
                {
                    Image = Item;
                    ApplicationArea = All;
                    RunObject = page "Flight Costs";
                    ToolTip = 'Executes the Flight Costs action.';
                }
                action("Air Ticket Groups")
                {
                    Image = Item;
                    ApplicationArea = All;
                    RunObject = page "Air Ticket Groups";
                    ToolTip = 'Executes the Air Ticket Groups action.';
                }

            }
            group(Workflows)
            {
                action("Workflow Groups")
                {
                    ApplicationArea = all;
                    RunObject = page "workflow groups atg";
                    Caption = 'Workflow Groups';
                    Image = WorkflowSetup;
                    ToolTip = 'Executes the Workflow Groups action.';
                }
                action("Approval Setup")
                {
                    ApplicationArea = all;
                    RunObject = page "Approval Setup ATG";
                    Caption = 'Approval Setup';
                    Image = ApprovalSetup;
                    ToolTip = 'Executes the Approval Setup action.';
                }
                action("Approval User Setup")
                {
                    ApplicationArea = all;
                    RunObject = page "Approval USer setup atg";
                    Caption = 'Approval User Setup';
                    Image = UserSetup;
                    ToolTip = 'Executes the Approval User Setup action.';
                }
                action("Approval Entry")
                {
                    ApplicationArea = all;
                    RunObject = page "Approval Entry ATG";
                    Caption = 'Approval Entry';
                    Image = Approval;
                    ToolTip = 'Executes the Approval Entry action.';
                }
                action("Request to Approve")
                {
                    ApplicationArea = all;
                    RunObject = page "Request to Approve ATG";
                    Caption = 'Request to Approve';
                    Image = SendApprovalRequest;
                    ToolTip = 'Executes the Request to Approve action.';
                }
                action("Notification Entry")
                {
                    ApplicationArea = all;
                    RunObject = page "Notification Entry ATG";
                    Caption = 'Notification Entry';
                    Image = Entry;
                    ToolTip = 'Executes the Notification Entry action.';
                }
                action("Sent Notification Entry")
                {
                    ApplicationArea = all;
                    RunObject = page "Sent Notification Entry ATG";
                    Caption = 'Sent Notification Entry';
                    Image = Entry;
                    ToolTip = 'Executes the Sent Notification Entry action.';
                }

            }
            // group(Recruitment)
            // {
            //     action("Projects")
            //     {
            //         ApplicationArea = All;
            //         RunObject = page "Project";
            //         Caption = 'Projects';
            //         Image = Task;
            //         ToolTip = 'Executes the Projects action.';
            //     }
            //     action("Applicants")
            //     {
            //         ApplicationArea = All;
            //         RunObject = page "Applicant";
            //         Caption = 'Applicants';
            //         Image = Employee;
            //         ToolTip = 'Executes the Applicants action.';
            //     }
            //     action("Media")
            //     {
            //         ApplicationArea = All;
            //         RunObject = page "Media List";
            //         Caption = 'Media';
            //         Image = Item;
            //         ToolTip = 'Executes the Media action.';
            //     }
            //     action("Media Type")
            //     {
            //         ApplicationArea = All;
            //         RunObject = page "MediaTypeList";
            //         Caption = 'Media Type';
            //         Image = Item;
            //         ToolTip = 'Executes the Media Type action.';
            //     }
            //     // Start #15 - 12/05/2019 - 103
            //     action("Candidates")
            //     {
            //         ApplicationArea = All;
            //         RunObject = page "CandidateList";
            //         Caption = 'Candidates';
            //         Image = Item;
            //         ToolTip = 'Executes the Candidates action.';
            //     }
            //     action("Interview Rounds")
            //     {
            //         ApplicationArea = All;
            //         RunObject = page "Interview Round";
            //         Caption = 'Interview Rounds';
            //         Image = Item;
            //         ToolTip = 'Executes the Interview Rounds action.';
            //     }
            //     action("Current Openings")
            //     {
            //         ApplicationArea = All;
            //         RunObject = page CurrentOpening;
            //         Caption = 'Current Openings';
            //         Image = Item;
            //         ToolTip = 'Executes the Current Openings action.';
            //     }
            // Stop #15 - 12/05/2019 - 103
            //}
        }

        area(Processing)
        {
            group(Setup)
            {
                action("Human Resources Setup")
                {
                    ApplicationArea = All;
                    RunObject = page "Human Resources Setup";
                    Caption = 'Human Resources Setup';
                    Image = Setup;
                    ToolTip = 'Executes the Human Resources Setup action.';
                }
                action("Payroll Posting Setup")
                {
                    ApplicationArea = All;
                    RunObject = page "Payroll Posting Setup";
                    Caption = 'Payroll Posting Setup';
                    Image = Setup;
                    ToolTip = 'Executes the Payroll Posting Setup action.';
                }
                action("Travel & Expense Setup")
                {
                    ApplicationArea = All;
                    RunObject = page "Travel & Expense Setup";
                    Caption = 'Travel & Expense Setup';
                    Image = Setup;
                    ToolTip = 'Executes the Travel & Expense Setup action.';
                }

            }
            group("Salary Processing")
            {
                action("Salary Computation")
                {
                    ApplicationArea = All;
                    RunObject = report "Salary Computation";
                    Caption = 'Salary Computation';
                    Image = Start;
                    ToolTip = 'Executes the Salary Computation action.';
                }
                action("Payroll Journals")
                {
                    ApplicationArea = All;
                    RunObject = page "PayrollJnl";
                    Caption = 'Payroll Journals';
                    Image = Journal;
                    ToolTip = 'Executes the Payroll Journals action.';

                }

                action("Update Employee Components")
                {
                    ApplicationArea = all;
                    Image = Start;
                    RunObject = report "Update Employee Components";
                    ToolTip = 'Executes the Update Employee Components action.';
                }
            }
        }
        area(Reporting)
        {
            group("Reports")
            {
                action("Salary Slip")
                {
                    ApplicationArea = All;
                    RunObject = report "Salary Slip";
                    Caption = 'Salary Slip';
                    Image = PrintDocument;
                    ToolTip = 'Executes the Salary Slip action.';
                }
                action("Salary Register")
                {
                    ApplicationArea = All;
                    RunObject = report "Salary Register";
                    Caption = 'Salary Register';
                    Image = PrintReport;
                    ToolTip = 'Executes the Salary Register action.';
                }
                action("Leave Balance Summary")
                {
                    ApplicationArea = All;
                    RunObject = report "Leave Balance Summary";
                    Caption = 'Leave Balance Summary';
                    Image = Holiday;
                    ToolTip = 'Executes the Leave Balance Summary action.';
                }
                action("WPS")
                {
                    ApplicationArea = All;
                    RunObject = report "WPS Report";
                    Caption = 'WPS';
                    Image = WIPEntries;
                    ToolTip = 'Executes the WPS action.';
                }
                action("WPS 2")
                {
                    ApplicationArea = All;
                    Caption = 'WPS 2';
                    RunObject = report "New WPS";
                    Image = Report;
                    ToolTip = 'Executes the WPS 2 action.';
                }
                action("Employee Master")
                {
                    ApplicationArea = All;
                    RunObject = report "Employee Master";
                    Image = Employee;
                    ToolTip = 'Executes the Employee Master action.';
                }
                action("Accruals & Deductions")
                {
                    ApplicationArea = All;
                    RunObject = report "Accruals & Employee Deductions";
                    Image = TaxDetail;
                    ToolTip = 'Executes the Accruals & Deductions action.';
                }
                action("Loan")
                {
                    ApplicationArea = All;
                    RunObject = report "Loan";
                    Caption = 'Loan';
                    Image = Report;
                    ToolTip = 'Executes the Loan action.';
                }
                action("Leave")
                {
                    ApplicationArea = All;
                    RunObject = report "Leave";
                    Caption = 'Leave';
                    Image = Report;
                    ToolTip = 'Executes the Leave action.';
                }
                action("Salary Comparision")
                {
                    ApplicationArea = all;
                    Image = CompareCost;
                    RunObject = report "Salary Comparision";
                    ToolTip = 'Executes the Salary Comparision action.';
                }
                action("Identification Expiry")
                {
                    ApplicationArea = all;
                    Image = Employee;
                    RunObject = report "Employee Identification";
                    ToolTip = 'Executes the Identification Expiry action.';
                }
                action("Dependent")
                {
                    ApplicationArea = All;
                    RunObject = report "Dependent";
                    Caption = 'Dependent';
                    Image = Report;
                    ToolTip = 'Executes the Dependent action.';
                }
                action("Full and Final")
                {
                    ApplicationArea = All;
                    RunObject = report "Full & Final";
                    Caption = 'Full and Final';
                    Image = Report;
                    ToolTip = 'Executes the Full and Final action.';
                }
                action("Travel and Expenses")
                {
                    ApplicationArea = All;
                    RunObject = report "Travel & Expenses";
                    Caption = 'Travel and Expenses';
                    Image = Report;
                    ToolTip = 'Executes the Travel and Expenses action.';
                }
            }
        }
    }
}
