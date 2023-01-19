table 50035 "Leave Request"
{
    DataClassification = CustomerContent;
    Caption = 'Leave Request';
    LookupPageId = "Leave Request List";
    fields
    {
        field(1; "No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'No.';
            trigger OnValidate()
            begin
                IF "No." <> xRec."No." THEN BEGIN
                    HrSetupG.ChangeCompany(CurrentCompany());
                    HrSetupG.Get();
                    NoSeriesMgtG.TestManual(HrSetupG."Leave Request Nos.");
                END;
            end;
        }
        field(2; "Employee No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Employee;
            Caption = 'Employee No.';
            NotBlank = true;
            trigger OnValidate()
            begin
                CalcFields("Employee Name");
                if ("Employee No." = '') or (xRec."Employee No." <> "Employee No.") then begin
                    "Absence Code" := '';
                    ClearFields();
                end;
            end;
        }
        field(3; "Absence Code"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Absence;
            Caption = 'Absence Code';
            NotBlank = true;
            trigger OnLookup()
            var
                EmployeeL: Record Employee;
            begin
                TestField("Employee No.");
                EmployeeL.Get("Employee No.");
                EmployeeL.TestField("Absence Group");
                OnLookupAbsenceCode();
            end;

            trigger OnValidate()
            var
                EmployeeL: Record Employee;
                AbsenceL: Record Absence;
                DifferentReligionErr: Label 'The %1 can be applied by %2 religion only.';
                NationalityErr: Label 'Employee with %1 nationality can only avail %2.';
                GenderErr: Label '%1 is specific only to gender : %2';
            begin
                if ("Absence Code" = '') or (xRec."Absence Code" <> "Absence Code") then
                    ClearFields();
                EmployeeL.ChangeCompany(CurrentCompany());
                AbsenceL.ChangeCompany(CurrentCompany());
                AbsenceL.Get("Absence Code");
                EmployeeL.Get("Employee No.");
                Description := AbsenceL.Description;
                if (EmployeeL.Religion <> AbsenceL.Religion) and (AbsenceL.Religion > '') then
                    Error(DifferentReligionErr, AbsenceL.Description, AbsenceL.Religion);
                if (EmployeeL."Employee Nationality" <> AbsenceL.Nationality) and (AbsenceL.Nationality > '') then
                    Error(NationalityErr, AbsenceL.Nationality, AbsenceL.Description);
                if (EmployeeL.Gender <> AbsenceL.Gender) and (AbsenceL.Gender > AbsenceL.Gender::" ") then
                    Error(GenderErr, AbsenceL.Description, AbsenceL.Gender);
                CalculateLeaveDays();
            end;
        }
        field(4; "Start Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Start Date';
            NotBlank = true;
            trigger OnValidate()
            var
                EmployeeL: Record Employee;
                PayPeriodLineL: record "Pay Period Line";
                StartDateErr: Label '%1 should be greater than %2 %3';
                PayPeriodDateErr: Label 'Pay Period has been closed, So you cannot request for Leave in the month of %1';
                EmployeeTerminatedErr: Label '%1 already left, so you can''t apply leave for the employee.';
            begin
                // "End Date" := "Start Date";
                "To Period" := "To Period"::"Second Half";
                EmployeeL.ChangeCompany(CurrentCompany());
                EmployeeL.Get("Employee No.");
                EmployeeL.TestField("Employment Date");
                if EmployeeL."Employment Date" > "Start Date" then
                    Error(StartDateErr, FieldCaption("Start Date"), EmployeeL.FieldCaption("Employment Date"), EmployeeL."Employment Date");
                if (EmployeeL."Termination Date" < "Start Date") and (EmployeeL."Termination Date" > 0D) then
                    Error(EmployeeTerminatedErr, EmployeeL."No.");
                /*PayPeriodLineL.Reset();
                PayPeriodLineL.Setfilter("Period Start Date", '<=%1', "Start Date");
                PayPeriodLineL.SetFilter("Period End Date", '>=%1', "Start Date");
                PayPeriodLineL.SetRange(Status, PayPeriodLineL.Status::Closed);
                if PayPeriodLineL.FindFirst() then
                    Error(PayPeriodDateErr, PayPeriodLineL."Pay Period");*/ //Command By SKR 19-01-2023
                if ("Start Date" <> xrec."Start Date") and (CurrFieldNo = FieldNo("Start Date")) and (xrec."Start Date" > 0D) then
                    OnLookupAbsenceCode();
                CalculateLeaveDays();
            end;
        }
        field(5; "End Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'End Date';
            NotBlank = true;
            trigger OnValidate()
            var
                EndDateErr: Label '%1 should be future date';
            begin
                if "Start Date" > "End Date" then
                    Error(EndDateErr, FieldCaption("End Date"));
                "To Period" := "To Period"::"Second Half";
                CalculateLeaveDays();
            end;

        }
        field(6; Hoildays; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Holidays';
            Editable = false;
        }
        field(7; Weekends; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Weekends';
            Editable = false;
        }
        field(8; "Leave Days"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Leave Days';
            Editable = false;
        }
        field(9; Location; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Location';
        }
        field(10; "Contact No."; Text[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Contact No.';
            ExtendedDatatype = PhoneNo;
        }
        field(11; "Current Balance"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Current Balance';
            Editable = false;
        }
        field(12; "Balance As On Start Date"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Balance As On Start Date';
            Editable = false;
        }
        field(13; "Closing Balance"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Closing Balance';
            Editable = false;
        }
        field(21; "From Period"; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'From Period';
            OptionMembers = "First Half","Second Half";
            OptionCaption = 'First Half,Second Half';
            trigger OnValidate()
            begin
                CalculateLeaveDays();
            end;
        }
        field(22; "To Period"; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'To Period';
            OptionMembers = "First Half","Second Half";
            OptionCaption = 'First Half,Second Half';
            trigger OnValidate()
            begin
                CalculateLeaveDays();
            end;

        }
        field(23; "Status"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = " ",Open,Approved,"Pending Approval",Rejected,Delegated;
            OptionCaption = ' ,Open,Approved,Pending Approval,Rejected,Delegated';
            Caption = 'Status';
        }
        field(24; "LOP Days"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'LOP Days';
        }
        field(25; "LOP Reason"; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'LOP Reason';
            OptionMembers = " ","Addiotional Days","Probation Period","Notice Period";
            OptionCaption = ' ,Additional Days,Probation Period,Notice Period';
        }
        field(26; "Employee Name"; Text[250])
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Employee."First Name" where("No." = field("Employee No.")));
            Caption = 'Employee Name';
        }
        field(27; Reason; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Reason';
        }
        field(28; Description; Text[50])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(29; Password; Text[20])
        {
            Caption = 'Password';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }
    var
        HrSetupG: Record "Human Resources Setup";
        EmployeeG: Record Employee;
        AbsenceG: Record Absence;
        NoSeriesMgtG: Codeunit NoSeriesManagement;
        HRMSManagementG: Codeunit "HRMS Management";
        NoSeriesG: Code[20];
        CompanyNameG: Text;
        MaxDaysAtOnceErr: Label 'You can apply maximum of %1 day(s) at once.';
        MinDaysAtOnceErr: Label 'You have to apply leave for minimum of %1 day(s)';
        MinDayBeforeReqErr: Label 'You must apply leave minimum %1 day(s) before.';
        MinDaysBetweenReqErr: Label 'You are eligible to apply %1 leave only after %2 day(s) from %3';
        MaxTimesInYearErr: Label 'You can apply %1 leave only %2 in a year';
        MaxTimesInTenureErr: Label 'You are already availed %1. So you are not eligible anymore.';
        AdditionaDaysErr: Label 'Additional day are not allowed.';
        AllowInProbationErr: Label '%1 can not be availed in Probation Period.';
        LeaveAlreadyAppliedErr: Label 'Leave request already exist.';
        MoreThanAccurredErr: Label 'You can''t apply more than Accrued';
        DeleteNotPossibleErr: Label 'You can''t delete the Request';
        ModifyNotAllowedErr: Label 'Leave approved so modifications to the record not allowed';
        exceededtheLeaveLimitIdTxt: Label '2751b488-ca52-42ef-b6d7-d7b4ba841e80', Comment = 'Locked';
        ProbationPeriodIdTxt: Label 'cb28c63d-4daf-453a-b41b-a8de9963d563', Comment = 'Locked';
        ProbationActionTxt: Label 'You are applying the leave in Probabtion Period';
        ExceedLimitNotificationTxt: Label 'You have exceeded the Leave Limit';
        AllowInNoticePeriodErr: Label '%1 can not be availed in Notice Period.';
        NoticePeriodIdTxt: Label '2751b488-ca52-42ef-b6d7-d7b4ba841e80', Comment = 'Locked';
        NoticePeriodTxt: Label 'You are applying the leave in Notice Period';

    trigger OnInsert()
    begin
        IF "No." = '' THEN BEGIN
            HrSetupG.ChangeCompany(CurrentCompany());
            HrSetupG.Get();
            HrSetupG.TESTFIELD("Leave Request Nos.");
            NoSeriesMgtG.InitSeries(HrSetupG."Leave Request Nos.", '', 0D, "No.", NoSeriesG);
            Status := Status::Open;
        END;
    end;

    trigger OnModify()
    var
        LeaveBalanaceSummaryL: Record "Leave Balance Summary";
        LeaveRequestL: Record "Leave Request";
    begin
        Clear(CompanyNameG);
        if not LeaveRequestL.Get("No.") then begin
            LeaveRequestL.ChangeCompany(CurrentCompany());
            CompanyNameG := CurrentCompany();
        end;
        if (Status = Status::Approved) and (Status = LeaveRequestL.Status) then
            Error(ModifyNotAllowedErr);
        if (Status = Status::Approved) and (LeaveRequestL.Status <> Status) then begin
            UpdateEmployeeCalendar();
            LeaveBalanaceSummaryL.UpdateLeaveBalance("Employee No.", "Absence Code", "Leave Days");
        end;
    end;

    trigger OnDelete()
    begin
        if Status > Status::" " then
            Error(DeleteNotPossibleErr);
    end;

    trigger OnRename()
    begin

    end;

    procedure AssisEdit(): Boolean
    begin
        HrSetupG.Get();
        HrSetupG.TESTFIELD("Leave Request Nos.");
        IF NoSeriesMgtG.SelectSeries(HrSetupG."Leave Request Nos.", '', NoSeriesG) THEN BEGIN
            NoSeriesMgtG.SetSeries("No.");
            EXIT(TRUE);
        END;
    end;

    local procedure CalculateLeaveDays()
    var
        EmployeeLevelAbsenceL: Record "Employee Level Absence";
        LeaveRequestL: Record "Leave Request";
        NoOfDaysL: Integer;
        StartDateL: Date;
        EndDateL: date;
    begin
        "LOP Days" := 0;
        EmployeeG.ChangeCompany(CurrentCompany());
        AbsenceG.ChangeCompany(CurrentCompany());
        LeaveRequestL.ChangeCompany(CurrentCompany());
        EmployeeLevelAbsenceL.ChangeCompany(CurrentCompany());
        AbsenceG.Get("Absence Code");
        EmployeeG.Get("Employee No.");
        LeaveRequestL.SetRange("Employee No.", "Employee No.");
        LeaveRequestL.SetFilter("No.", '<>%1', "No.");
        LeaveRequestL.SetFilter("Start Date", '..%1', "Start Date");
        LeaveRequestL.SetFilter("End Date", '%1..', "Start Date");
        if not LeaveRequestL.IsEmpty() then
            CheckForLeaveResumption(LeaveRequestL);

        EmployeeLevelAbsenceL.Reset();
        EmployeeLevelAbsenceL.SetRange("Absence Code", "Absence Code");
        EmployeeLevelAbsenceL.SetRange("Employee No.", "Employee No.");
        EmployeeLevelAbsenceL.FindLast();
        CheckProbationAndNoticePeriod(EmployeeLevelAbsenceL);
        if not CalculateNoOfLeaveDays() then
            exit;
        LeaveRequestL.SetRange("Absence Code", "Absence Code");
        LeaveRequestL.SetRange("Start Date");
        LeaveRequestL.SetRange("End Date");
        NoOfDaysL := "Start Date" - Today();
        if (NoOfDaysL < EmployeeLevelAbsenceL."Minimum Days Before Request") and (EmployeeLevelAbsenceL."Minimum Days Before Request" > 0) then
            error(MinDayBeforeReqErr, EmployeeLevelAbsenceL."Minimum Days Before Request");
        if ("Leave Days" > EmployeeLevelAbsenceL."Maximum Days at Once") and (EmployeeLevelAbsenceL."Maximum Days at Once" > 0) then
            Error(MaxDaysAtOnceErr, EmployeeLevelAbsenceL."Maximum Days at Once");
        if ("Leave Days" < EmployeeLevelAbsenceL."Minimum Days at Once") and (EmployeeLevelAbsenceL."Minimum Days at Once" > 0) then
            Error(MinDaysAtOnceErr, EmployeeLevelAbsenceL."Minimum Days at Once");
        AbsenceG.GetStartDateAndEndDate(EmployeeG."Employment Date", "Start Date", EmployeeLevelAbsenceL."Accrual Basis", StartDateL, EndDateL);
        LeaveRequestL.SetRange("Start Date", StartDateL, EndDateL);
        if LeaveRequestL.FindLast() then begin
            NoOfDaysL := ("Start Date" - LeaveRequestL."End Date") + 1;
            if (NoOfDaysL < EmployeeLevelAbsenceL."Minimum Days Between Request") and (EmployeeLevelAbsenceL."Minimum Days Between Request" > 0) then
                Error(MinDaysBetweenReqErr, EmployeeLevelAbsenceL."Absence Description", EmployeeLevelAbsenceL."Minimum Days Between Request", LeaveRequestL."End Date");
            LeaveRequestL.FindSet();
            NoOfDaysL := LeaveRequestL.Count();
            if (NoOfDaysL = EmployeeLevelAbsenceL."Maximum Times in Tenure") and (EmployeeLevelAbsenceL."Maximum Times in Tenure" > 0) then
                Error(MaxTimesInTenureErr, EmployeeLevelAbsenceL."Absence Description");
            if ((Date2DMY(LeaveRequestL."Start Date", 3) = Date2DMY(Today(), 3)) and
                (NoOfDaysL > EmployeeLevelAbsenceL."Maximum Times in a Year")) and
                (EmployeeLevelAbsenceL."Maximum Times in a Year" > 0)
            then
                Error(MaxTimesInYearErr, EmployeeLevelAbsenceL."Absence Description", EmployeeLevelAbsenceL."Maximum Times in a Year");
            //LeaveRequestL.CalcSums("Leave Days");
            // if (LeaveRequestL."Leave Days" + "Leave Days" > EmployeeLevelAbsenceL."Maximum Accrual Days") and (EmployeeLevelAbsenceL.Accrual) then
            //     Error(MaxAccuralReachedErr, EmployeeLevelAbsenceL."Absence Description");
        end;
        CheckProbationAndNoticePeriod(EmployeeLevelAbsenceL);
        CalculateLeaveBalance(EmployeeLevelAbsenceL);
        CheckForAttachmentRequired(EmployeeLevelAbsenceL);
    end;

    local procedure OnLookupAbsenceCode()
    var
        EmployeeLevelAbsenceL: Record "Employee Level Absence";
        EmployeeEarningHistoryL: Record "Employee Earning History";
        EmployeeAbsenceCodeL: Page "Employee Absence Code";
    begin
        EmployeeG.ChangeCompany(CurrentCompany());
        EmployeeEarningHistoryL.ChangeCompany(CurrentCompany());
        EmployeeLevelAbsenceL.ChangeCompany(CurrentCompany());

        EmployeeG.Get("Employee No.");
        EmployeeEarningHistoryL.SetRange("Employee No.", "Employee No.");
        EmployeeEarningHistoryL.SetRange("Group Code", EmployeeG."Absence Group");
        EmployeeEarningHistoryL.SetFilter("From Date", '<=%1', Today());
        if "Start Date" > 0D then
            EmployeeEarningHistoryL.SetFilter("From Date", '<=%1', "Start Date");
        EmployeeEarningHistoryL.SetFilter("To Date", '>=%1', Today());
        if "End Date" > 0D then
            EmployeeEarningHistoryL.SetFilter("To Date", '>=%1', "End Date");
        EmployeeEarningHistoryL.FindFirst();
        EmployeeLevelAbsenceL.SetRange("Employee No.", "Employee No.");
        EmployeeLevelAbsenceL.SetRange("Group Code", EmployeeG."Absence Group");
        EmployeeLevelAbsenceL.SetRange("From Date", EmployeeEarningHistoryL."From Date");
        EmployeeAbsenceCodeL.SetTableView(EmployeeLevelAbsenceL);
        EmployeeAbsenceCodeL.LookupMode(true);
        if (EmployeeAbsenceCodeL.RunModal() = Action::LookupOK) then
            EmployeeAbsenceCodeL.SetSelectionFilter(EmployeeLevelAbsenceL);
        EmployeeLevelAbsenceL.FindFirst();
        validate("Absence Code", EmployeeLevelAbsenceL."Absence Code");
    end;

    local procedure CalculateLeaveBalance(EmployeeLevelAbsenceP: Record "Employee Level Absence")
    var
        LeaveBalanceL: Record "Leave Balance Summary";
        NoOfWorkingDaysL: Integer;
        PerDayLeaveL: Decimal;
        StartDateL: Date;
        EndDateL: Date;
    begin
        LeaveBalanceL.ChangeCompany(CurrentCompany());
        LeaveBalanceL.get("Employee No.", "Absence Code");
        if (LeaveBalanceL."Leave Taken" + "Leave Days" > EmployeeLevelAbsenceP."Assigned Days") Then
            if not EmployeeLevelAbsenceP."Additional Days" then
                Error(AdditionaDaysErr)
            else
                CheckForAdditionalAction(EmployeeLevelAbsenceP);
        if AbsenceG.Accrual then begin
            EmployeeG.TestField("Leave Accrual Start Date");
            AbsenceG.GetStartDateAndEndDate(EmployeeG."Leave Accrual Start Date", Today(), EmployeeLevelAbsenceP."Accrual Basis", StartDateL, EndDateL);
            NoOfWorkingDaysL := (Today() - StartDateL) + 1;
            if EmployeeLevelAbsenceP."Accrual Basis" = EmployeeLevelAbsenceP."Accrual Basis"::Biennial then
                PerDayLeaveL := EmployeeLevelAbsenceP."Assigned Days" / 730
            else
                PerDayLeaveL := EmployeeLevelAbsenceP."Assigned Days" / 365;
            if StartDateL = EmployeeG."Leave Accrual Start Date" then
                "Current Balance" := (NoOfWorkingDaysL * PerDayLeaveL) + HRMSManagementG.GetNoOfLeaveTakenForThePeriod("Employee No.", "Absence Code", StartDateL, Today())
            else
                "Current Balance" := LeaveBalanceL."Carry Forward Days" + (NoOfWorkingDaysL * PerDayLeaveL) + HRMSManagementG.GetNoOfLeaveTakenForThePeriod("Employee No.", "Absence Code", StartDateL, Today());
            AbsenceG.GetStartDateAndEndDate(EmployeeG."Leave Accrual Start Date", "Start Date", EmployeeLevelAbsenceP."Accrual Basis", StartDateL, EndDateL);
            NoOfWorkingDaysL := ("Start Date" - StartDateL) + 1;
            if StartDateL = EmployeeG."Leave Accrual Start Date" then
                "Balance As On Start Date" := (NoOfWorkingDaysL * PerDayLeaveL) + HRMSManagementG.GetNoOfLeaveTakenForThePeriod("Employee No.", "Absence Code", StartDateL, "Start Date")
            else
                "Balance As On Start Date" := LeaveBalanceL."Carry Forward Days" + (NoOfWorkingDaysL * PerDayLeaveL) + HRMSManagementG.GetNoOfLeaveTakenForThePeriod("Employee No.", "Absence Code", StartDateL, "Start Date");
            if ("Balance As On Start Date" < "Leave Days") and (not EmployeeLevelAbsenceP."Apply More Than Accrued") then
                Error(MoreThanAccurredErr);
            NoOfWorkingDaysL := ("End Date" - StartDateL) + 1;
            if StartDateL = EmployeeG."Leave Accrual Start Date" then
                "Closing Balance" := (NoOfWorkingDaysL * PerDayLeaveL) - "Leave Days" + HRMSManagementG.GetNoOfLeaveTakenForThePeriod("Employee No.", "Absence Code", StartDateL, "End Date")
            else
                "Closing Balance" := LeaveBalanceL."Carry Forward Days" + (NoOfWorkingDaysL * PerDayLeaveL) - "Leave Days" + HRMSManagementG.GetNoOfLeaveTakenForThePeriod("Employee No.", "Absence Code", StartDateL, "End Date");
        end else begin
            AbsenceG.GetStartDateAndEndDate(EmployeeG."Employment Date", "Start Date", EmployeeLevelAbsenceP."Accrual Basis", StartDateL, EndDateL);
            "Current Balance" := LeaveBalanceL."Leave Balance";
            "Balance As On Start Date" := "Current Balance";
            if "End Date" <= EndDateL then
                "Closing Balance" := "Balance As On Start Date" - "Leave Days"
            else begin
                AbsenceG.GetStartDateAndEndDate(EmployeeG."Employment Date", "End Date", EmployeeLevelAbsenceP."Accrual Basis", StartDateL, EndDateL);
                "Closing Balance" := LeaveBalanceL."Assigned Days" - ("End Date" - StartDateL + 1);
            end;
        end;
    end;

    local procedure CalculateNoOfLeaveDays(): Boolean
    var
        EmployeeTimingL: Record "Employee Timing";
    begin
        if ("Start Date" = 0D) or ("End Date" = 0D) then
            exit(false);
        if ("Start Date" = "End Date") then begin
            if ("From Period" = "To Period") then
                "Leave Days" := 0.5
            else
                "Leave Days" := ("End Date" - "Start Date") + 1;
        end else begin
            "Leave Days" := ("End Date" - "Start Date") + 1;
            if "From Period" = "From Period"::"Second Half" then
                "Leave Days" -= 0.5;
            if "To Period" = "To Period"::"First Half" then
                "Leave Days" -= 0.5;
        end;
        Weekends := 0;
        Hoildays := 0;
        EmployeeTimingL.ChangeCompany(CurrentCompany());
        EmployeeTimingL.Reset();
        EmployeeTimingL.SetRange("Employee No.", "Employee No.");
        EmployeeTimingL.SetRange("From Date", "Start Date", "End Date");
        EmployeeTimingL.SetFilter(EmployeeTimingL."First Half Status", '%1', 'Week Off');
        If not EmployeeTimingL.IsEmpty() then begin
            if not AbsenceG."Include Weekly Off" then
                "Leave Days" := "Leave Days" - EmployeeTimingL.Count();
            Weekends := EmployeeTimingL.Count();
        end;
        EmployeeTimingL.SetFilter(EmployeeTimingL."First Half Status", '%1', 'Public Holiday');
        If not EmployeeTimingL.IsEmpty() then begin
            if not AbsenceG."Include Public Holidays" then
                "Leave Days" := "Leave Days" - EmployeeTimingL.Count();
            Hoildays := EmployeeTimingL.Count();
        end;
        exit(true);
    end;

    local procedure CheckForAttachmentRequired(EmployeeLevelAbsenceP: Record "Employee Level Absence")
    begin
        if (not EmployeeLevelAbsenceP."Attachment Required") or ("Leave Days" < EmployeeLevelAbsenceP."Attachment days") then
            exit;
    end;

    local procedure CheckProbationAndNoticePeriod(EmployeeLevelAbsenceP: Record "Employee Level Absence")
    var
        LeaveBalanceL: Record "Leave Balance Summary";
    begin
        LeaveBalanceL.ChangeCompany(CurrentCompany());
        if ("Start Date" > 0D) and ("Start Date" < EmployeeG."Probation End Date") then
            if not EmployeeLevelAbsenceP."Allow in Probation" then
                Error(AllowInProbationErr, EmployeeLevelAbsenceP."Absence Description")
            else
                case EmployeeLevelAbsenceP."Probation Action" of
                    EmployeeLevelAbsenceP."Probation Action"::Warning:
                        ShowWarningMessage(ProbationActionTxt, GetProbabtionActionNotificationID());
                    EmployeeLevelAbsenceP."Probation Action"::"Loss of Pay":
                        begin
                            LeaveBalanceL.Get("Employee No.", "Absence Code");
                            "LOP Days" := "Leave Days";
                            "LOP Reason" := "LOP Reason"::"Probation Period";
                        end;
                // EmployeeLevelAbsenceP."Probation Action"::"Extend Probation":
                //     begin
                //         EmployeeG."Probation End Date" := CalcDate(Format("Leave Days") + 'D', EmployeeG."Probation End Date");
                //         EmployeeG.Modify();
                //     end;
                end;
        // Notice Period 
        if ("Start Date" > 0D) and ("Start Date" <= EmployeeG."Termination Date") and ("Start Date" >= EmployeeG."Notice Period Start Date") then
            if not EmployeeLevelAbsenceP."Allow in Notice Period" then
                Error(AllowInNoticePeriodErr, EmployeeLevelAbsenceP."Absence Description")
            else
                case EmployeeLevelAbsenceP."Notice Period Action" of
                    EmployeeLevelAbsenceP."Notice Period Action"::Warning:
                        ShowWarningMessage(NoticePeriodTxt, GetNoticePeriodNotificationID());
                    EmployeeLevelAbsenceP."Notice Period Action"::"Loss of Pay":
                        begin
                            LeaveBalanceL.Get("Employee No.", "Absence Code");
                            "LOP Days" := "Leave Days";
                            "LOP Reason" := "LOP Reason"::"Notice Period";
                        end;
                // EmployeeLevelAbsenceP."Notice Period Action"::"Extend Notice Period":
                //     begin
                //         EmployeeG."Termination Date" := CalcDate(Format("Leave Days") + 'D', EmployeeG."Termination Date");
                //         EmployeeG.Modify();
                //     end;
                end;
    end;

    local procedure UpdateEmployeeCalendar()
    var
        EmployeeTimingL: Record "Employee Timing";
        EmployeeLevelAbsenceL: Record "Employee Level Absence";
        AbsenceL: Record Absence;
        CountL: Integer;
        LOPCodeL: Code[20];
        StartDateL: Date;
        EndDateL: Date;
    begin
        if CompanyNameG > '' then begin
            AbsenceL.ChangeCompany(CompanyNameG);
            EmployeeTimingL.ChangeCompany(CompanyNameG);
            EmployeeLevelAbsenceL.ChangeCompany(CompanyNameG);
            EmployeeG.ChangeCompany(CompanyNameG);
        end;
        AbsenceL.Get("Absence Code");
        EmployeeTimingL.SetRange("Employee No.", "Employee No.");
        EmployeeTimingL.SetRange("From Date", "Start Date", "End Date");
        if not (AbsenceL."Include Public Holidays" and AbsenceL."Include Weekly Off") then
            EmployeeTimingL.SetFilter("First Half Status", '<>%1&<>%2', 'Public Holiday', 'Week Off')
        else
            if not AbsenceL."Include Public Holidays" then
                EmployeeTimingL.SetFilter("First Half Status", '<>%1', 'Public Holiday')
            else
                if not AbsenceL."Include Weekly Off" then
                    EmployeeTimingL.SetFilter("First Half Status", '<>%1', 'Week Off');
        if EmployeeTimingL.FindSet() then
            repeat
                if ("Start Date" = EmployeeTimingL."From Date") and ("From Period" = "From Period"::"Second Half") then
                    EmployeeTimingL."Second Half Status" := "Absence Code"
                else
                    if ("End Date" = EmployeeTimingL."From Date") and ("To Period" = "To Period"::"First Half") then
                        EmployeeTimingL."First Half Status" := "Absence Code"
                    else begin
                        EmployeeTimingL."First Half Status" := "Absence Code";
                        EmployeeTimingL."Second Half Status" := "Absence Code";
                    end;
                EmployeeTimingL.Modify();
            until EmployeeTimingL.Next() = 0;
        if "LOP Days" > 0 then begin
            case "LOP Reason" of
                "LOP Reason"::"Addiotional Days":
                    LOPCodeL := AbsenceL."Additional Days LOP Code";
                "LOP Reason"::"Notice Period":
                    LOPCodeL := AbsenceL."Notice Period LOP Code";
                "LOP Reason"::"Probation Period":
                    LOPCodeL := AbsenceL."Probation Period LOP Code";
            end;
            EmployeeLevelAbsenceL.SetRange("Employee No.", "Employee No.");
            EmployeeLevelAbsenceL.SetFilter("From Date", '<=%1', "Start Date");
            EmployeeLevelAbsenceL.FindLast();
            if not EmployeeLevelAbsenceL.Accrual then begin
                EmployeeG.get("Employee No.");
                AbsenceG.GetStartDateAndEndDate(EmployeeG."Employment Date", "Start Date", EmployeeLevelAbsenceL."Accrual Basis", StartDateL, EndDateL);
                if "End Date" > EndDateL then
                    EmployeeTimingL.SetRange("From Date", "Start Date", EndDateL);
            end;
            EmployeeTimingL.FindLast();
            repeat
                CountL += 1;
                EmployeeTimingL."First Half Status" := LOPCodeL;
                EmployeeTimingL."Second Half Status" := LOPCodeL;
                EmployeeTimingL.Modify();
                EmployeeTimingL.Next(-1);
            until CountL = "LOP Days";
        end;
        ExtendProbationAndNoticePeriod();
    end;

    local procedure CheckForLeaveResumption(var LeaveRequestP: Record "Leave Request")
    var
        LeaveResumptionL: Record "Leave Resumption";
    begin
        LeaveResumptionL.ChangeCompany(CurrentCompany());
        LeaveRequestP.FindFirst();
        LeaveResumptionL.SetRange("Leave Request No.", LeaveRequestP."No.");
        if "Start Date" <= LeaveRequestP."End Date" then begin
            LeaveResumptionL.SetFilter("Resumption Date", '<=%1', "Start Date");
            if LeaveResumptionL.IsEmpty() then
                Error(LeaveAlreadyAppliedErr);
        end else begin
            LeaveResumptionL.SetFilter("Resumption Date", '>=%1', "Start Date");
            if not LeaveResumptionL.IsEmpty() then
                Error(LeaveAlreadyAppliedErr);
        end;
    end;

    local procedure ClearFields()
    begin
        "Start Date" := 0D;
        "End Date" := 0D;
        Weekends := 0;
        Hoildays := 0;
        "Leave Days" := 0;
        "Current Balance" := 0;
        "Balance As On Start Date" := 0;
        "Closing Balance" := 0;
    end;

    local procedure CheckForAdditionalAction(EmployeeLevelAbsenceP: Record "Employee Level Absence")
    var
        LeaveBalanceL: Record "Leave Balance Summary";
        StartDateL: Date;
        EndDateL: date;
    begin
        LeaveBalanceL.ChangeCompany(CurrentCompany());
        case EmployeeLevelAbsenceP."Additional Days Action" of
            EmployeeLevelAbsenceP."Additional Days Action"::Warning:
                ShowWarningMessage(ExceedLimitNotificationTxt, GetExceedLimitNotificationID());
            EmployeeLevelAbsenceP."Additional Days Action"::"Loss of Pay":
                begin
                    LeaveBalanceL.Get("Employee No.", "Absence Code");
                    "LOP Days" := "Leave Days" - LeaveBalanceL."Leave Balance";
                    if not EmployeeLevelAbsenceP.Accrual then begin
                        AbsenceG.GetStartDateAndEndDate(EmployeeG."Employment Date", "End Date", EmployeeLevelAbsenceP."Accrual Basis", StartDateL, EndDateL);
                        if "End Date" > StartDateL then
                            "LOP Days" := "Leave Days" - LeaveBalanceL."Leave Balance" - ("End Date" - StartDateL + 1);
                    end;
                    if "LOP Days" > 0 then
                        "LOP Reason" := "LOP Reason"::"Addiotional Days";
                end;
        end;
    end;

    local procedure ShowWarningMessage(WarningMessageP: Text; MessageIDP: Guid)
    var
        NotificationL: Notification;
    begin
        NotificationL.Id(MessageIDP);
        NotificationL.Message(WarningMessageP);
        NotificationL.Scope(NotificationScope::LocalScope);
        NotificationL.Send();
    end;

    local procedure GetExceedLimitNotificationID(): Guid
    var
        ExceedLimitIDL: Guid;
    begin
        EVALUATE(ExceedLimitIDL, exceededtheLeaveLimitIdTxt);
        EXIT(ExceedLimitIDL);
    end;

    local procedure GetProbabtionActionNotificationID(): Guid
    var
        ProbabtionActionIDL: Guid;
    begin
        EVALUATE(ProbabtionActionIDL, ProbationPeriodIdTxt);
        EXIT(ProbabtionActionIDL);
    end;

    local procedure GetNoticePeriodNotificationID(): Guid
    var
        NoticePeriodIDL: Guid;
    begin
        EVALUATE(NoticePeriodIDL, NoticePeriodIdTxt);
        EXIT(NoticePeriodIDL);
    end;

    local procedure ExtendProbationAndNoticePeriod()
    var
        EndOfServiceL: Record "End of Service";
        EmployeeLevelAbsenceL: Record "Employee Level Absence";
    begin
        if CompanyNameG > '' then begin
            EmployeeLevelAbsenceL.ChangeCompany(CompanyNameG);
            EmployeeG.ChangeCompany(CompanyNameG);
            EndOfServiceL.ChangeCompany(CompanyNameG);
        end;
        EmployeeLevelAbsenceL.SetRange("Employee No.", "Employee No.");
        EmployeeLevelAbsenceL.SetFilter("From Date", '<=%1', "End Date");
        EmployeeLevelAbsenceL.SetRange("Absence Code", "Absence Code");
        EmployeeLevelAbsenceL.FindLast();
        EmployeeG.Get("Employee No.");
        if ("Start Date" > 0D) and
            ("Start Date" < EmployeeG."Probation End Date") and
            (EmployeeLevelAbsenceL."Probation Action" = EmployeeLevelAbsenceL."Probation Action"::"Extend Probation")
        then begin
            EmployeeG."Probation End Date" := CalcDate(Format("Leave Days") + 'D', EmployeeG."Probation End Date");
            EmployeeG.Modify();
        end;
        // Notice Period 
        if ("Start Date" > 0D) and
            ("Start Date" <= EmployeeG."Termination Date") and
            ("Start Date" >= EmployeeG."Notice Period Start Date") and
            (EmployeeLevelAbsenceL."Notice Period Action" = EmployeeLevelAbsenceL."Notice Period Action"::"Extend Notice Period")
        then begin
            EmployeeG."Termination Date" := CalcDate(Format("Leave Days") + 'D', EmployeeG."Termination Date");
            EmployeeG.Modify();
            EndOfServiceL.SetRange("Employee No.", "Employee No.");
            if EndOfServiceL.FindLast() then begin
                EndOfServiceL."Last Working Day" := EmployeeG."Termination Date";
                EndOfServiceL.Modify();
            end;
        end;
    end;
}