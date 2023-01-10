codeunit 50025 "HRMS Management"
{
    trigger OnRun()
    begin
    end;

    procedure FindExpiryDocument(var TempEmployeeLevelIdentificationP: Record "Employee Level Identification" temporary; DateFormulaP: DateFormula): Decimal
    var
        EmployeeLevelIdentificationL: Record "Employee Level Identification";
        IdentificationL: Record Identification;
        DateFormulaL: DateFormula;
    begin
        TempEmployeeLevelIdentificationP.Reset();
        TempEmployeeLevelIdentificationP.DeleteAll();
        IdentificationL.SetFilter("Alert Formula", '>%1', DateFormulaL);
        if IdentificationL.FindSet() then
            repeat
                EmployeeLevelIdentificationL.SetRange(Code, IdentificationL."Identification Code");
                EmployeeLevelIdentificationL.SetRange("Expiry Date", CALCDATE(DateFormulaP, WORKDATE()), WORKDATE());
                if Format(DateFormulaP) = '' then
                    EmployeeLevelIdentificationL.SetRange("Expiry Date", WORKDATE(), CALCDATE(IdentificationL."Alert Formula", WORKDATE()));
                if EmployeeLevelIdentificationL.FindSet() then
                    repeat
                        TempEmployeeLevelIdentificationP.TransferFields(EmployeeLevelIdentificationL);
                        TempEmployeeLevelIdentificationP.Insert();
                    until EmployeeLevelIdentificationL.Next() = 0;
            until IdentificationL.Next() = 0;

        exit(TempEmployeeLevelIdentificationP.Count());
    end;

    procedure FindEndofService(var EndofService: Record "End of Service"): Integer
    begin
        EndofService.Reset();
        EndofService.SetRange("Last Working Day", CalcDate('<-CM>', Today()), CalcDate('<CM>', Today()));
        exit(EndofService.Count());
    end;

    procedure FindNewJoiners(var EmployeeP: Record Employee temporary): Decimal
    var
        Employee: Record Employee;
    begin
        EmployeeP.DeleteAll();
        EmployeeP.Reset();
        Employee.SetFilter("Employment Date", '>%1', 0D);
        if Employee.FindSet() then
            repeat
                if Employee."Employment Date" >= CalcDate('<-6M>', Today) then begin
                    EmployeeP := Employee;
                    EmployeeP.Insert();
                end;
            until Employee.Next() = 0;
        exit(EmployeeP.Count());
    end;

    procedure FindBirthday(var EmployeeP: Record Employee temporary): Decimal
    var
        Employee: Record Employee;
    begin
        EmployeeP.DeleteAll();
        EmployeeP.Reset();
        Employee.SetFilter("Birth Date", '>%1', 0D);
        if Employee.FindSet() then
            repeat
                if (Date2DMY(Employee."Birth Date", 2) = Date2DMY(Today(), 2)) then begin
                    EmployeeP := Employee;
                    EmployeeP.Insert();
                end;
            until Employee.Next() = 0;
        exit(EmployeeP.Count());
    end;

    procedure FindAnniversary(var EmployeeP: Record Employee temporary): Decimal
    var
        Employee: Record Employee;
    begin
        EmployeeP.DeleteAll();
        EmployeeP.Reset();
        Employee.SetFilter("Employment Date", '>%1', 0D);
        if Employee.FindSet() then
            repeat
                if (Date2DMY(Employee."Employment Date", 2) = Date2DMY(Today(), 2)) then begin
                    EmployeeP := Employee;
                    EmployeeP.Insert();
                end;
            until Employee.Next() = 0;
        exit(EmployeeP.Count());
    end;
    // Start #15 - 12/05/2019 - 103
    // procedure FindInterviewCandidates(var CandidateList: Record "Candidate Line" temporary): Decimal
    // var
    //     CandiadateLineL: Record "Candidate Line";
    // begin
    //     CandidateList.DeleteAll();
    //     CandidateList.Reset();
    //     CandiadateLineL.SetFilter("Next Interview Scheduled Date", '=%1', (Today() + 1));
    //     if CandiadateLineL.FindSet() then
    //         repeat
    //             CandidateList := CandiadateLineL;
    //             CandidateList.Insert();
    //         until CandiadateLineL.Next() = 0;
    //     exit(CandidateList.Count());
    // end;
    // Stop #15 - 12/05/2019 - 103
    procedure GetNoOfLeaveTakenForThePeriod(EmployeeNoP: Code[20]; AbsenceCodeP: Code[20]; StartDateP: Date; EndDateP: Date) NoOfLeaveTakenR: Decimal
    var
        EmployeeTimingL: Record "Employee Timing";
    begin
        EmployeeTimingL.SetRange("Employee No.", EmployeeNoP);
        EmployeeTimingL.SetRange("From Date", StartDateP, EndDateP);
        EmployeeTimingL.SetRange("First Half Status", AbsenceCodeP);
        NoOfLeaveTakenR := EmployeeTimingL.Count();
        EmployeeTimingL.SetRange("Second Half Status", AbsenceCodeP);
        NoOfLeaveTakenR += EmployeeTimingL.Count();
        exit(-(NoOfLeaveTakenR / 2) +
            CheckForOpeningBalance(EmployeeNoP, AbsenceCodeP, StartDateP, EndDateP) +
            CheckForLeaveEncashment(EmployeeNoP, AbsenceCodeP, StartDateP, EndDateP));
    end;

    procedure CheckForOpeningBalance(EmployeeNoP: Code[20]; AbsenceCodeP: Code[20]; StartDateP: Date; EndDateP: Date) OpeningBalanceR: Decimal
    var
        OpeningBalanceL: Record "Opening Balance";
    begin
        OpeningBalanceL.SetRange("Employee No.", EmployeeNoP);
        OpeningBalanceL.Setfilter("Pay Period", GetPayPeriod(StartDateP, EndDateP));
        OpeningBalanceL.SetRange(Code, AbsenceCodeP);
        OpeningBalanceL.SetRange(Type, OpeningBalanceL.Type::Absence);
        OpeningBalanceL.CalcSums(Value);
        OpeningBalanceR += OpeningBalanceL.Value;
    end;

    procedure GetPayPeriod(StartDateP: Date; EndDateP: Date) PayperiodTextR: Text
    begin
        if not (FORMAT(StartDateP, 0, '<Month Text>') + '-' + format(Date2DMY(StartDateP, 3)) = FORMAT(EndDateP, 0, '<Month Text>') + '-' + format(Date2DMY(EndDateP, 3))) then
            repeat
                PayperiodTextR += FORMAT(StartDateP, 0, '<Month Text>') + '-' + format(Date2DMY(StartDateP, 3)) + '|';
                StartDateP := CalcDate('<1M>', StartDateP);
            until (FORMAT(StartDateP, 0, '<Month Text>') + '-' + format(Date2DMY(StartDateP, 3)) = FORMAT(EndDateP, 0, '<Month Text>') + '-' + format(Date2DMY(EndDateP, 3)));
        PayperiodTextR += FORMAT(StartDateP, 0, '<Month Text>') + '-' + format(Date2DMY(StartDateP, 3));
        exit(PayperiodTextR);
    end;

    procedure CheckForLeaveEncashment(EmployeeNoP: Code[20]; AbsenceCodeP: Code[20]; StartDateP: Date; EndDateP: Date) OpeningBalanceR: Decimal
    var
        LeaveEncashmentL: Record "Leave Encashment";
    begin
        LeaveEncashmentL.SetRange("Employee No.", EmployeeNoP);
        LeaveEncashmentL.setrange("Leave Type", AbsenceCodeP);
        LeaveEncashmentL.SetRange("Compensation Date", StartDateP, EndDateP);
        LeaveEncashmentL.CalcSums("Encashment Days");
        exit(-LeaveEncashmentL."Encashment Days");
    end;

    procedure SendToApproval(var LeaveRequestP: Record "Leave Request")
    var
        ApprovalMgmtL: Codeunit "Approval Mgmt ATG";
        RecfRefL: RecordRef;
        ApprovalForL: Option "Leave Request";
        VariantL: Variant;
    begin
        VariantL := LeaveRequestP;
        RecfRefL.GetTable(VariantL);
        ApprovalMgmtL.CreateApprovalRequests(RecfRefL, ApprovalMgmtL.CheckApprovalEnabled(LeaveRequestP."Employee No.", ApprovalForL::"Leave Request"));
    end;

}