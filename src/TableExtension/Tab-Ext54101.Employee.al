tableextension 54101 "Employee" extends Employee
{
    fields
    {
        field(60000; "Accommodation Type"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Accommodation Type';
            TableRelation = Accommodation;
        }
        field(60001; "Accommodation Start Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Accommodation Start Date';
        }
        field(60002; "Accommodation End Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Accommodation End Date';
        }
        field(60003; "Notes"; Text[150])
        {
            DataClassification = CustomerContent;
            Caption = 'Notes';
        }
        field(60004; "Marital Status"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = " ","Single","Married","Widowed","Divorced";
            OptionCaption = ' ,Single,Married,Widowed,Divorced';
            Caption = 'Marital Status';
        }
        field(60005; "No. of Dependent"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Employee Relative" where("Employee No." = field("No."), Dependent = filter(true)));
            Caption = 'No. of Dependent';
        }
        field(60006; "Language Code"; code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Language;
            Caption = 'Language Code';
        }
        field(60007; "Employee Nationality"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Country/Region";
            Caption = 'Employee Nationality';
            trigger OnValidate()
            var
                CountryRegionL: Record "Country/Region";
            begin
                CountryRegionL.Reset();
                CountryRegionL.SetRange(Code, "Employee Nationality");
                if CountryRegionL.FindFirst() then
                    Rec."Air Fare" := CountryRegionL."Air Fare";
            end;
        }
        field(60008; "Employer Nationality"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Country/Region";
            Caption = 'Employer Nationality';
        }
        field(60009; "Probation Start Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Probation Start Date';
            trigger OnValidate()
            var
                StartDateValidationErr: Label 'If you change %1. It will remove the %2 & %3';
            begin
                if "Probation End Date" > 0D then
                    if Confirm(StartDateValidationErr, false, Rec.FieldCaption("Probation Start Date"),
                        Rec.FieldCaption("Probation End Date"), Rec.FieldCaption("Probation Period")) then begin
                        Clear("Probation Period");
                        Clear("Probation End Date");
                    end;

            end;
        }
        field(60010; "Probation End Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Probation End Date';
            Editable = false;
        }
        field(60011; "Probation Period"; DateFormula)
        {
            DataClassification = CustomerContent;
            Caption = 'Probation Period';
            trigger OnValidate()

            begin
                TestField("Probation Start Date");
                "Probation End Date" := CalcDate("Probation Period", "Probation Start Date");
            end;
        }
        field(60012; "Salary Class"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Salary Class';
            TableRelation = "Salary Class";
        }
        field(60013; Grade; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Grade';
            TableRelation = Grade;
            trigger OnValidate()
            begin
                TestField("Sub Grade", '');
            end;
        }
        field(60014; "Sub Grade"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Sub Grade';
            TableRelation = "Sub Grade"."Sub Grade" where(Grade = field(Grade));
            trigger OnValidate()
            var
                SubGradeL: Record "Sub Grade";
            begin
                if SubGradeL.Get(Grade, "Sub Grade") then;
                "Sub Grade" := SubGradeL."Sub Grade";
                "Sub Grade Description" := SubGradeL."Sub Grade Description";

                "Absence Group" := SubGradeL."Absence Group";
                Calendar := SubGradeL.Calendar;
                "Pay Cycle" := SubGradeL."Pay Cycle";
                "Air Ticket Group" := SubGradeL."Air Ticket Group";
                Validate("Salary Class", SubGradeL."Salary Class");
                Validate("Earning Group", SubGradeL."Earning Group");
                Validate("Loan & Advance Group", SubGradeL."Loan & Advance Group");
                Commit();
            end;
        }
        field(60015; "Sub Grade Description"; Text[50])
        {
            FieldClass = FlowField;
            Caption = 'Sub Grade Description';
            CalcFormula = lookup("Sub Grade"."Sub Grade Description" where(Grade = field(Grade), "Sub Grade" = field("Sub Grade")));
            Editable = false;
        }
        field(60016; "Earning Group"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Earning Group';
            TableRelation = "Earning Group";
        }
        field(60017; "Absence Group"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Absence Group';
            TableRelation = "Absence Group"."Absence Group Code";
        }

        field(60018; "Password"; Text[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Password';
            ExtendedDatatype = Masked;
            //Added for Salary Slip Access
        }

        // field id is free - 60019
        field(60020; "Pay Cycle"; Code[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Pay Cycle';
            TableRelation = "Pay Cycle";
        }
        field(60021; "Air Ticket Group"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Air Ticket Group';
            TableRelation = "Air Ticket Group";
        }

        // field id is free - 60022
        field(60023; Calendar; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Calendar';
            TableRelation = Timing;
        }
        field(60024; Age; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Age';
        }
        field(60025; Religion; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Religion';
            TableRelation = Religion;
        }
        field(60026; "Job Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Job Code';
            Editable = false;
        }
        field(60027; "Gratuity Accrual Start Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Gratuity Accrual Start Date';
            trigger OnValidate()
            begin
                TestField("Employment Date");
                if ("Gratuity Accrual Start Date" < "Employment Date") and ("Gratuity Accrual Start Date" > 0D) then
                    Error(DateValidationLbl, FieldCaption("Gratuity Accrual Start Date"), FieldCaption("Employment Date"));
            end;
        }
        field(60028; "Leave Accrual Start Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Leave Accrual Start Date';
            trigger OnValidate()
            begin
                TestField("Employment Date");
                if ("Leave Accrual Start Date" < "Employment Date") and ("Leave Accrual Start Date" > 0D) then
                    Error(DateValidationLbl, FieldCaption("Leave Accrual Start Date"), FieldCaption("Employment Date"));
            end;
        }
        field(60029; "Last Calendar Day"; Date)
        {
            Caption = 'Last Calendar Day';
            FieldClass = FlowField;
            CalcFormula = max("Employee Timing"."From Date" where("Employee No." = field("No.")));
        }

        field(60030; "Notice Period Start Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Notice Period Start Date';
            trigger OnValidate()
            begin
                TestField("Termination Date", 0D);
                if "Notice Period Start Date" = 0D then begin
                    "Termination Date" := 0D;
                    Clear("Notice Period");
                end;
            end;
        }
        field(60031; "Notice Period"; DateFormula)
        {
            DataClassification = CustomerContent;
            Caption = 'Notice Period';
            trigger OnValidate()
            var
                EndofServiceL: Record "End of Service";
            begin

                EndofServiceL.SetRange("Employee No.", "No.");
                if EndofServiceL.FindLast() then begin
                    EndofServiceL."Last Working Day" := CalcDate("Notice Period", "Notice Period Start Date");
                    EndofServiceL.Modify();
                    "Termination Date" := EndofServiceL."Last Working Day";
                    exit;
                end;

                EndofServiceL.Init();
                EndofServiceL.Validate("End of Service No.");
                EndofServiceL.Validate("Employee No.", "No.");
                EndofServiceL."Last Working Day" := CalcDate("Notice Period", "Notice Period Start Date");
                EndofServiceL.Insert(true);
                "Termination Date" := EndofServiceL."Last Working Day";
            end;
        }
        field(60032; "Sponsor Type"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Sponsor Type';
            TableRelation = "Sponsor Type";
        }
        field(60033; "MOL ID"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'MOL ID';
        }
        field(60034; "Payment Type"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Payment Type';
            TableRelation = "Payment Type";
        }
        field(60035; "Travel & Expense Group"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Travel & Expense Group';
            TableRelation = "Travel & Expense Group";
        }
        field(60036; "Loan & Advance Group"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Loan & Advance Group';
            TableRelation = "Loan Group";
        }

        field(60037; "Air Ticket Accrual Start Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Air Ticket Accrual Start Date';
            trigger OnValidate()
            var
                LoanRequest: Record "Loan Request";
            begin
                if "Air Ticket Accrual Start Date" > 0D then begin
                    TestField("Employment Date");
                    if "Air Ticket Accrual Start Date" < "Employment Date" then
                        Error(DateValidationLbl, FieldCaption("Air Ticket Accrual Start Date"), FieldCaption("Employment Date"));
                    TestField("Air Ticket Group");
                    TestField("Flight Destination Code");
                    LoanRequest.IsPayPeriodClosed("Air Ticket Accrual Start Date", "No.", rec."Pay Cycle");
                end;
            end;
        }
        field(60038; "Flight Destination Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Flight Destination Code';
            TableRelation = "Flight Destination";
        }
        field(60040; "Last User Modified"; Code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Last User Modified';
        }
        field(60041; Manager; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Manager';
        }
        field(60042; "Line Manager"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Line Manager';
            TableRelation = Employee."No." where(Manager = const(true));

            trigger OnValidate()
            var
                EmployeeL: Record Employee;
            begin
                EmployeeL.Reset();
                EmployeeL.SetRange("No.", "Line Manager");
                if EmployeeL.FindFirst() then
                    Rec."Line Manager Name" := EmployeeL.FullName();
            end;
        }
        field(60043; "Last Salary Paid Pate"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Last Salary Paid Date';
            Editable = false;
        }
        field(60044; "HR Manager"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'HR Manager';
            Editable = false;
        }
        field(60045; "HR Manager Name"; Text[30])
        {
            Caption = 'HR Manager Name';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(60046; "Work Location"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Work Location';
            TableRelation = Location.Code;
        }
        field(60047; "Line Manager Name"; Text[30])
        {
            Caption = 'Line Manager Name';
            DataClassification = CustomerContent;
            Editable = false;
            //FieldClass = FlowField;
            //CalcFormula = lookup(Employee."First Name" where("No." = field("Line Manager")));
        }
        field(60048; "Years Completed"; Text[30])
        {
            Caption = 'Years Completed';
            DataClassification = CustomerContent;
            Editable = false;
            //DecimalPlaces = 1;
        }
        field(60049; Department; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Department';
            TableRelation = Department."Department Code";
        }
        field(60050; "Air Fare"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Air Fare';
        }
        field(60051; "Bank Branch Name"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Bank Branch Name';
        }
        field(60052; "Contract Employee"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Contract Employee';
        }
        // Suganya-aplica
        field(60053; "Native Address"; Text[250])
        {
            DataClassification = ToBeClassified;
        }

        field(60054; "Native Contact No."; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(60055; "Bank Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(60056; "WPS Bank Code"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(60057; "Insurance Level"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Insurance Levels";
        }
        // Suganya-aplica
        field(60058; "Last Salary Increment Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Last Salary Increment Date';
            Editable = false;
        }
        modify("Employment Date")
        {
            trigger OnAfterValidate()
            var
                NoOfYears: Integer;
                NoOfMonths: Integer;
            begin
                TestField("Gratuity Accrual Start Date", 0D);
                if "Employment Date" = 0D then begin
                    Rec."Probation Start Date" := 0D;
                    Rec."Years Completed" := '';
                end
                else
                    if Rec."Employment Date" > 0D then begin
                        Rec."Probation Start Date" := "Employment Date";
                        NoOfYears := Date2DMY(Today(), 3) - Date2DMY("Employment Date", 3);
                        NoOfMonths := Date2DMY(Today(), 2) - Date2DMY("Employment Date", 2);
                        Rec."Years Completed" := Format(NoOfYears) + ' Years & ' + Format(NoOfMonths) + ' Months';
                        Rec.Modify();
                    end;
            end;
        }
        /*modify(Address)
        {
            Caption = 'Country Address';
        }
        modify("Address 2")
        {
            Caption = 'Local Address';
        }*/
        modify("Job Title")
        {
            TableRelation = Designation.Description;
        }
        modify("Last Name")
        {
            trigger OnAfterValidate()
            begin
                Rec."Search Name" := FullName();
            end;
        }
        modify("Search Name")
        {
            Caption = 'Full Name';
        }
    }
    keys
    {
        key(Key6; Manager)
        {

        }
    }

    var
        DateValidationLbl: Label '%1 should be greater than %2';
        ToDateValidationErr: Label '%1 should not be earlier than %2: %3';
        FromDateValidationErr: Label '%1 should not be earlier than %2: %3';
        cdeDocNo: Code[20];
    // added a one function to get No. parameter suganya-m
    procedure GetDocumentNo(DocumentNo: Code[20])
    begin
        cdeDocNo := DocumentNo;
    end;

    procedure CreateUpdateEarningGroupLines(FromDateP: Date)
    var
        EarningGroupLineL: Record "Earning Group Line";
        EmployeeLevelEarningL: Record "Employee Level Earning";
        EmployeeEarningHistoryL: Record "Employee Earning History";
        EmployeeEarningHistory2L: Record "Employee Earning History";
        SalaryIncLine: Record "Salary Increment Line";
    begin
        EmployeeEarningHistoryL.SetCurrentKey("Employee No.", "From Date");
        EmployeeEarningHistoryL.SetRange("Employee No.", "No.");
        //EmployeeEarningHistoryL.SetRange("Group Code", xRec."Earning Group");
        EmployeeEarningHistoryL.SetRange("Component Type", EmployeeEarningHistoryL."Component Type"::Earning);
        if EmployeeEarningHistoryL.FindLast() then begin
            EmployeeEarningHistoryL."To Date" := FromDateP - 1;

            if EmployeeEarningHistoryL."To Date" < EmployeeEarningHistoryL."From Date" then
                Error(ToDateValidationErr, EmployeeEarningHistory2L.FieldCaption("To Date"), EmployeeEarningHistory2L.FieldCaption("From Date"), EmployeeEarningHistory2L."From Date");
            EmployeeEarningHistoryL.Modify();
        end;

        if FromDateP < "Employment Date" then
            Error(FromDateValidationErr, EmployeeEarningHistory2L.FieldCaption("From Date"), FieldCaption("Employment Date"), "Employment Date");

        EmployeeEarningHistory2L.Init();
        EmployeeEarningHistory2L."Employee No." := "No.";
        EmployeeEarningHistory2L."Group Code" := "Earning Group";
        EmployeeEarningHistory2L."From Date" := FromDateP;
        EmployeeEarningHistory2L."Component Type" := EmployeeEarningHistory2L."Component Type"::Earning;
        EmployeeEarningHistory2L."To Date" := CalcDate('<10Y>', EmployeeEarningHistory2L."From Date");
        EmployeeEarningHistory2L.Insert();

        SalaryIncLine.Reset();
        SalaryIncLine.SetCurrentKey("Document No.", "Employee No.", "Line No.");
        SalaryIncLine.SetRange("Document No.", cdeDocNo);
        if not SalaryIncLine.FindFirst() then begin
            EarningGroupLineL.SetRange("Group Code", "Earning Group");
            if EarningGroupLineL.FindSet() then
                repeat
                    EmployeeLevelEarningL.Init();
                    EmployeeLevelEarningL."Employee No." := "No.";
                    EmployeeLevelEarningL."Group Code" := EarningGroupLineL."Group Code";
                    EmployeeLevelEarningL."From Date" := FromDateP;
                    EmployeeLevelEarningL."To Date" := CalcDate('<10Y>', EmployeeEarningHistory2L."From Date");
                    EmployeeLevelEarningL.Validate("Earning Code", EarningGroupLineL."Earning Code");
                    EmployeeLevelEarningL.Insert();
                until EarningGroupLineL.Next() = 0;
        end
        else begin
            // suganya-m added a new coding start
            SalaryIncLine.Reset();
            SalaryIncLine.SetCurrentKey("Document No.", "Employee No.", "Line No.");
            SalaryIncLine.SetRange("Document No.", cdeDocNo);
            if SalaryIncLine.FindSet() then
                repeat
                    EmployeeLevelEarningL.Init();
                    EmployeeLevelEarningL."Employee No." := SalaryIncLine."Employee No.";
                    EmployeeLevelEarningL."Group Code" := SalaryIncLine."Earning Group Code";
                    EmployeeLevelEarningL."From Date" := FromDateP;
                    EmployeeLevelEarningL."To Date" := CalcDate('<10Y>', EmployeeEarningHistory2L."From Date");
                    EmployeeLevelEarningL.Validate("Earning Code", SalaryIncLine."Earning Code");
                    EmployeeLevelEarningL.Insert();
                until SalaryIncLine.Next() = 0; // suganya-m added a new coding end
        end;
    end;

    procedure CreateUpdateAbsenceGroupLine(FromDateP: Date)
    var
        EmployeeEarningHistoryL: Record "Employee Earning History";
        EmployeeEarningHistory2L: Record "Employee Earning History";
        AbsenceGroupLineL: Record "Absence Group Line";
        EmployeeLevelAbsenceL: Record "Employee Level Absence";
        LeaveBalanceSummaryL: Record "Leave Balance Summary";

    begin
        EmployeeEarningHistoryL.SetCurrentKey("Employee No.", "From Date");
        EmployeeEarningHistoryL.SetRange("Employee No.", "No.");
        // EmployeeEarningHistoryL.SetRange("Group Code", xRec."Absence Group"); Avi: If there is a change of Earning Group, then problem accurs in From Date.
        EmployeeEarningHistoryL.SetRange("Component Type", EmployeeEarningHistoryL."Component Type"::Absence);
        if EmployeeEarningHistoryL.FindLast() then begin
            EmployeeEarningHistoryL."To Date" := FromDateP - 1;
            if EmployeeEarningHistoryL."To Date" < EmployeeEarningHistoryL."From Date" then
                Error(ToDateValidationErr, EmployeeEarningHistory2L.FieldCaption("To Date"), EmployeeEarningHistory2L.FieldCaption("From Date"), EmployeeEarningHistory2L."From Date");
            EmployeeEarningHistoryL.Modify();
        end;
        if FromDateP < "Employment Date" then
            Error(FromDateValidationErr, EmployeeEarningHistory2L.FieldCaption("From Date"), FieldCaption("Employment Date"), "Employment Date");
        EmployeeEarningHistory2L.Init();
        EmployeeEarningHistory2L."Employee No." := "No.";
        EmployeeEarningHistory2L."Group Code" := "Absence Group";
        EmployeeEarningHistory2L."From Date" := FromDateP;
        EmployeeEarningHistory2L."Component Type" := EmployeeEarningHistory2L."Component Type"::Absence;
        EmployeeEarningHistory2L."To Date" := CalcDate('<10Y>', EmployeeEarningHistory2L."From Date");
        EmployeeEarningHistory2L.Insert();

        AbsenceGroupLineL.SetRange("Absence Group Code", "Absence Group");
        if AbsenceGroupLineL.FindSet() then
            repeat
                EmployeeLevelAbsenceL.Init();
                EmployeeLevelAbsenceL."Employee No." := "No.";
                EmployeeLevelAbsenceL."Group Code" := AbsenceGroupLineL."Absence Group Code";
                EmployeeLevelAbsenceL."From Date" := FromDateP;
                EmployeeLevelAbsenceL."Absence Code" := AbsenceGroupLineL."Absence Code";
                EmployeeLevelAbsenceL.Validate("Absence Code");
                EmployeeLevelAbsenceL.Insert();
                LeaveBalanceSummaryL.CreateUpdateEntry("No.", AbsenceGroupLineL."Absence Code", AbsenceGroupLineL."Assigned Days", 0);
            until AbsenceGroupLineL.Next() = 0;
    end;

    procedure CreateUpdateLoanGroupLine(FromDate: Date)
    var
        EmployeeEarningHistoryL: Record "Employee Earning History";
        EmployeeEarningHistory2L: Record "Employee Earning History";
        LoanGroupLine: Record "Loan Group Line";
        EmployeeLevelLoan: Record "Employee Level Loan";
    begin
        EmployeeEarningHistoryL.SetCurrentKey("Employee No.", "From Date");
        EmployeeEarningHistoryL.SetRange("Employee No.", "No.");
        EmployeeEarningHistoryL.SetRange("Component Type", EmployeeEarningHistoryL."Component Type"::Loan);
        if EmployeeEarningHistoryL.FindLast() then begin
            EmployeeEarningHistoryL."To Date" := FromDate - 1;
            if EmployeeEarningHistoryL."To Date" < EmployeeEarningHistoryL."From Date" then
                Error(ToDateValidationErr, EmployeeEarningHistory2L.FieldCaption("To Date"), EmployeeEarningHistory2L.FieldCaption("From Date"), EmployeeEarningHistory2L."From Date");
            EmployeeEarningHistoryL.Modify();
        end;

        if FromDate < "Employment Date" then
            Error(FromDateValidationErr, EmployeeEarningHistory2L.FieldCaption("From Date"), FieldCaption("Employment Date"), "Employment Date");

        EmployeeEarningHistory2L.Init();
        EmployeeEarningHistory2L."Employee No." := "No.";
        EmployeeEarningHistory2L."Group Code" := "Loan & Advance Group";
        EmployeeEarningHistory2L."From Date" := FromDate;
        EmployeeEarningHistory2L."Component Type" := EmployeeEarningHistory2L."Component Type"::Loan;
        EmployeeEarningHistory2L."To Date" := CalcDate('<10Y>', EmployeeEarningHistory2L."From Date");
        EmployeeEarningHistory2L.Insert();

        LoanGroupLine.SetRange("Loan Group Code", "Loan & Advance Group");
        if LoanGroupLine.FindSet() then
            repeat
                EmployeeLevelLoan.Init();
                EmployeeLevelLoan."Employee No." := "No.";
                EmployeeLevelLoan."Loan Group Code" := LoanGroupLine."Loan Group Code";
                EmployeeLevelLoan."From Date" := FromDate;
                LoanGroupLine.TestField("Loan Code");
                EmployeeLevelLoan.Validate("Loan Code", LoanGroupLine."Loan Code");
                EmployeeLevelLoan.Insert();
            until LoanGroupLine.Next() = 0;
    end;

    procedure CreateUpdateAirTicketGroup(FromDate: Date)
    var
        EmployeeEarningHistoryL: Record "Employee Earning History";
        EmployeeEarningHistory2L: Record "Employee Earning History";
        AirTicketGroup: Record "Air Ticket Group";
        EmployeeLevelAirTicket: Record "Employee Level Air Ticket";
    begin
        EmployeeEarningHistoryL.SetCurrentKey("Employee No.", "From Date");
        EmployeeEarningHistoryL.SetRange("Employee No.", "No.");
        EmployeeEarningHistoryL.SetRange("Component Type", EmployeeEarningHistoryL."Component Type"::"Air Ticket");
        if EmployeeEarningHistoryL.FindLast() then begin
            EmployeeEarningHistoryL."To Date" := FromDate - 1;
            if EmployeeEarningHistoryL."To Date" < EmployeeEarningHistoryL."From Date" then
                Error(ToDateValidationErr, EmployeeEarningHistory2L.FieldCaption("To Date"), EmployeeEarningHistory2L.FieldCaption("From Date"), EmployeeEarningHistory2L."From Date");
            EmployeeEarningHistoryL.Modify();
        end;

        if FromDate < "Employment Date" then
            Error(FromDateValidationErr, EmployeeEarningHistory2L.FieldCaption("From Date"), FieldCaption("Employment Date"), "Employment Date");

        EmployeeEarningHistory2L.Init();
        EmployeeEarningHistory2L."Employee No." := "No.";
        EmployeeEarningHistory2L."Group Code" := "Air Ticket Group";
        EmployeeEarningHistory2L."From Date" := FromDate;
        EmployeeEarningHistory2L."Component Type" := EmployeeEarningHistory2L."Component Type"::"Air Ticket";
        EmployeeEarningHistory2L."To Date" := CalcDate('<10Y>', EmployeeEarningHistory2L."From Date");
        EmployeeEarningHistory2L.Insert();

        AirTicketGroup.SetRange("Air Ticket Group Code", "Air Ticket Group");
        if AirTicketGroup.FindSet() then
            repeat
                EmployeeLevelAirTicket.Init();
                EmployeeLevelAirTicket.TransferFields(AirTicketGroup, false);
                EmployeeLevelAirTicket."Employee No." := "No.";
                EmployeeLevelAirTicket.Validate("Air Ticket Code", AirTicketGroup."Air Ticket Group Code");
                EmployeeLevelAirTicket.Validate("Air Ticket Group Code", AirTicketGroup."Air Ticket Group Code");
                EmployeeLevelAirTicket."From Date" := FromDate;
                EmployeeLevelAirTicket.Insert();
            until AirTicketGroup.Next() = 0;
    end;

    trigger OnAfterInsert()
    var
        UserSetup: Record "User Setup";
        HumanResourcesSetup: Record "Human Resources Setup";
        EmployeeL: Record Employee;
    begin
        /*UserSetup.Get(UserId);
        Rec."Last User Modified" := UserSetup."User ID";
        Rec.Modify();*/
        If HumanResourcesSetup.Get("HR Manager") then
            Rec."HR Manager" := HumanResourcesSetup."HR Manager";
        if EmployeeL.Get(Rec."HR Manager") then
            Rec."HR Manager Name" := EmployeeL.FullName();
    end;

    trigger OnAfterModify()
    var
        UserSetup: Record "User Setup";
    begin
        UserSetup.Get(UserId);
        Rec."Last User Modified" := UserSetup."User ID";
        Rec.Modify();
    end;

    trigger OnAfterRename()
    var
        UserSetup: Record "User Setup";
    begin
        UserSetup.Get(UserId);
        Rec."Last User Modified" := UserSetup."User ID";
        Rec.Modify();
    end;

    trigger OnModify()
    var
        UserSetup: Record "User Setup";
    begin
        UserSetup.Get(UserId);
        Rec."Last User Modified" := UserSetup."User ID";
        Rec.Modify();
    end;

    trigger OnRename()
    var
        UserSetup: Record "User Setup";
    begin
        UserSetup.Get(UserId);
        Rec."Last User Modified" := UserSetup."User ID";
        Rec.Modify();
    end;
}