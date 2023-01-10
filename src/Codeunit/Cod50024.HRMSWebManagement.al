codeunit 50024 "HRMS Web Management"
{
    trigger OnRun()
    begin
    end;

    procedure PrintPaySlip(EmployeeNoP: Code[20]; SalaryClassP: Code[20]; PayPeriodP: Code[30]; var PdfDocumentP: BigText)
    var
        TempBlobL: Codeunit "Temp Blob";
        Base64Convert: Codeunit "Base64 Convert";
        OutStreamL: OutStream;
        InStreamL: InStream;
        ReportPrintFailedErr: Label 'Report printing failed';
        FilterLbl: Label '<?xml version="1.0" standalone="yes"?><ReportParameters name="Salary Slip" id="54104"><Options><Field name="SalaryClassG">%1</Field><Field name="PayPeriodG">%2</Field><Field name="EmployeeNoG">%3</Field></Options><DataItems><DataItem name="Employee">VERSION(1) SORTING(Field1)</DataItem><DataItem name="SalaryClassFilter">VERSION(1) SORTING(Field1)</DataItem><DataItem name="SalaryComputationLineEarnings">VERSION(1) SORTING(Field1)</DataItem></DataItems></ReportParameters>';
    begin
        Clear(TempBlobL);
        TempBlobL.CreateOutStream(OutStreamL, TextEncoding::UTF8);
        if not Report.SaveAs(54104, StrSubstNo(FilterLbl, SalaryClassP, PayPeriodP, EmployeeNoP), ReportFormat::Pdf, OutStreamL) then
            Error(ReportPrintFailedErr);
        TempBlobL.CreateInStream(InStreamL);

        PdfDocumentP.AddText(Base64Convert.ToBase64(InStreamL));
    end;

    procedure EmployeeList(EmployeeNoP: Code[20]; var EmployeeListP: XmlPort "Employee List")
    var
        EmployeeL: Record Employee;
        EmployeeReplicaL: Record "Employee ATG";
    begin
        if EmployeeReplicaL.Get(EmployeeNoP) then begin
            EmployeeL.ChangeCompany(EmployeeReplicaL."Company ATG");
            Message(EmployeeL.CurrentCompany());
            EmployeeL.SetRange("No.", EmployeeNoP);
            EmployeeL.FindFirst();
            EmployeeListP.InsertTemp(EmployeeL);
        end else
            Error('Employee ID doesn''t exist')
    end;

    procedure EmployeeTeamMember(ReportingCodeP: Code[20]; var EmployeeTeamListP: XmlPort "Employee Team Member")
    var
        EmployeeTeamMemberL: Record "Designation";
        CountL: Integer;
    begin
        EmployeeTeamMemberL.SetRange("Reporting To", ReportingCodeP);
        EmployeeTeamMemberL.SetRange("Position Assigned", true);
        if EmployeeTeamMemberL.FindFirst() then
            repeat
                CountL += 1;
                EmployeeTeamListP.InsertTemp(EmployeeTeamMemberL);
            until EmployeeTeamMemberL.Next() = 0;
        if CountL = 0 then
            Error('Employee ID doesn''t have team member');
    end;

    procedure SalaryComputationList(EmployeeNoP: Code[20]; var SalaryComputationP: XmlPort "Salary Computation List")
    var
        SalaryComputationLineL: Record "Salary Computation Line";
        EmployeeReplicaL: Record "Employee ATG";
    begin
        EmployeeReplicaL.Get(EmployeeNoP);
        SalaryComputationLineL.ChangeCompany(EmployeeReplicaL."Company ATG");
        SalaryComputationLineL.SetCurrentKey("Employee No.", "Pay Period");
        SalaryComputationLineL.SetRange("Employee No.", EmployeeNoP);
        SalaryComputationLineL.SetRange("Line Type", SalaryComputationLineL."Line Type"::Absence);
        if not SalaryComputationLineL.IsEmpty() then begin
            SalaryComputationLineL.FindSet();
            repeat
                SalaryComputationP.InsertTemp(SalaryComputationLineL);
            until SalaryComputationLineL.Next() = 0;
        end else
            Error('Salary not calculated yet')
    end;

    procedure EmployeeLeaveDetails(EmployeeNoP: Code[20]; var EmployeeLeaveDetailsP: XmlPort "Employee Leave Details")
    var
        EmployeeL: Record Employee;
        EmployeeReplicaL: Record "Employee ATG";
        EmployeeLevelAbsenceL: Record "Employee Level Absence";
        EmployeeEarningHistoryL: Record "Employee Earning History";
    begin
        EmployeeReplicaL.Get(EmployeeNoP);
        EmployeeL.ChangeCompany(EmployeeReplicaL."Company ATG");
        EmployeeLevelAbsenceL.ChangeCompany(EmployeeReplicaL."Company ATG");
        EmployeeEarningHistoryL.ChangeCompany(EmployeeReplicaL."Company ATG");
        EmployeeL.Get(EmployeeNoP);
        EmployeeEarningHistoryL.SetRange("Employee No.", EmployeeL."No.");
        EmployeeEarningHistoryL.SetRange("Group Code", EmployeeL."Absence Group");
        EmployeeEarningHistoryL.SetFilter("From Date", '<=%1', Today());
        EmployeeEarningHistoryL.SetFilter("To Date", '>=%1', Today());
        if not EmployeeEarningHistoryL.FindFirst() then
            error(NoAbsenceCodeForEmployeeErr);
        EmployeeLevelAbsenceL.SetRange("Employee No.", EmployeeL."No.");
        EmployeeLevelAbsenceL.SetRange("Group Code", EmployeeEarningHistoryL."Group Code");
        EmployeeLevelAbsenceL.SetRange("From Date", EmployeeEarningHistoryL."From Date");
        if EmployeeLevelAbsenceL.IsEmpty() then
            Error(NoAbsenceCodeForEmployeeErr);
        EmployeeLeaveDetailsP.SetEmployeeRecord(EmployeeL);
        repeat
            EmployeeLeaveDetailsP.InsertTemp(EmployeeLevelAbsenceL);
        until EmployeeLevelAbsenceL.Next() = 0;
    end;

    procedure EmployeeLeaveValidate(EmployeeNoP: Code[20]; AbsenceCodeP: Text; StartDateP: Date; EndDateP: Date; FromSessionP: Integer; ToSessionP: Integer; var EmployeeLeaveRequestP: XmlPort "Employee Leave Request")
    var
        LeaveRequestL: Record "Leave Request";
        EmployeeReplicaL: Record "Employee ATG";
    begin
        EmployeeReplicaL.Get(EmployeeNoP);
        LeaveRequestL.ChangeCompany(EmployeeReplicaL."Company ATG");
        LeaveRequestL.Init();
        LeaveRequestL.Validate("Employee No.", EmployeeNoP);
        LeaveRequestL.Validate("Absence Code", uppercase(AbsenceCodeP));
        LeaveRequestL.Validate("Start Date", StartDateP);
        LeaveRequestL.Validate("End Date", EndDateP);
        LeaveRequestL.Validate("From Period", FromSessionP);
        LeaveRequestL.Validate("To Period", ToSessionP);
        EmployeeLeaveRequestP.InsertTempRecord(LeaveRequestL);
    end;

    procedure ApplyLeave(EmployeeNoP: Code[20]; AbsenceCodeP: Text; StartDateP: Date; EndDateP: Date; FromSessionP: Integer; ToSessionP: Integer; ReasonP: Text[250]; var EmployeeLeaveRequestP: XmlPort "Employee Leave Request")
    var
        LeaveRequestL: Record "Leave Request";
        EmployeeReplicaL: Record "Employee ATG";
        HRMSManagementL: Codeunit "HRMS Management";
    begin
        EmployeeReplicaL.Get(EmployeeNoP);
        LeaveRequestL.ChangeCompany(EmployeeReplicaL."Company ATG");
        LeaveRequestL.Init();
        LeaveRequestL.Validate("Employee No.", EmployeeNoP);
        LeaveRequestL.Validate("Absence Code", uppercase(AbsenceCodeP));
        LeaveRequestL.Validate("Start Date", StartDateP);
        LeaveRequestL.Validate("End Date", EndDateP);
        LeaveRequestL.Validate("From Period", FromSessionP);
        LeaveRequestL.Validate("To Period", ToSessionP);
        LeaveRequestL.Status := LeaveRequestL.Status::Open;
        LeaveRequestL.Reason := ReasonP;
        LeaveRequestL.Insert(true);
        HRMSManagementL.SendToApproval(LeaveRequestL);
        EmployeeLeaveRequestP.InsertTempRecord(LeaveRequestL);
    end;

    procedure ShowApprovalEnteries(EmployeeNoP: Code[20]; var EmployeeApprovalP: XmlPort "Employee Approvals")
    var
        EmployeeL: Record "Employee ATG";
        ApprovalEntryL: Record "Approval Entry ATG";
        CompanyL: Record Company;
        CountL: Integer;
    begin
        CompanyL.FindSet();
        EmployeeL.Get(EmployeeNoP);
        repeat
            ApprovalEntryL.ChangeCompany(CompanyL.Name);
            ApprovalEntryL.SetRange("Approver ID", EmployeeL."No. ATG");
            ApprovalEntryL.SetRange(Status, ApprovalEntryL.Status::Open);
            if ApprovalEntryL.FindSet() then
                repeat
                    CountL += 1;
                    EmployeeApprovalP.InsertIntoTemp(ApprovalEntryL);
                until ApprovalEntryL.Next() = 0
        until CompanyL.Next() = 0;
        if CountL = 0 then
            Error('No Pending Approvals found');
    end;

    procedure ViewLeaveApprovalEntry(LeaveRequestNoP: Code[20]; var EmployeeLeaveRequestP: XmlPort "Employee Leave Request")
    var
        LeaveRequestL: Record "Leave Request";
        CompanyL: Record Company;
    begin
        if LeaveRequestL.Get(LeaveRequestNoP) then
            EmployeeLeaveRequestP.InsertTempRecord(LeaveRequestL)
        else begin
            CompanyL.FindSet();
            repeat
                LeaveRequestL.ChangeCompany(CompanyL.Name);
                CompanyL.Next(1);
            until LeaveRequestL.Get(LeaveRequestNoP);
            if not LeaveRequestL.IsEmpty() then
                EmployeeLeaveRequestP.InsertTempRecord(LeaveRequestL)
            else
                Error('Leave Request not found');
        end;
    end;

    procedure LeaveRequestApproval(ApprovalCodeP: Integer; ApprovalEntryNoP: Integer; LeaveRequestNoP: code[20]; CommentP: Text[250])
    var
        CompanyL: Record Company;
        ApprovalEntryL: Record "Approval Entry ATG";
        ApprovalMgtL: Codeunit "Approval Mgmt ATG";
    begin
        ApprovalEntryL.SetRange("Entry No.", ApprovalEntryNoP);
        ApprovalEntryL.SetRange("Document No.", LeaveRequestNoP);
        if not ApprovalEntryL.FindFirst() then begin
            CompanyL.FindSet();
            repeat
                ApprovalEntryL.ChangeCompany(CompanyL.Name);
                ApprovalEntryL.SetRange("Entry No.", ApprovalEntryNoP);
                ApprovalEntryL.SetRange("Document No.", LeaveRequestNoP);
                CompanyL.Next(1);
            until ApprovalEntryL.FindFirst();
        end;
        case ApprovalCodeP of
            1:
                ApprovalMgtL.ApproveApprovalRequests(ApprovalEntryL);
            2:
                ApprovalMgtL.RejectApprovalRequests(ApprovalEntryL);
        end;
    end;

    procedure EmployeeLeaveRequestList(EmployeeNoP: Code[20]; var EmployeeLeaveRequestP: XmlPort "Employee Leave Request")
    var
        LeaveRequestL: Record "Leave Request";
        EmployeeReplicaL: Record "Employee ATG";
    begin
        EmployeeReplicaL.Get(EmployeeNoP);
        LeaveRequestL.ChangeCompany(EmployeeReplicaL."Company ATG");
        LeaveRequestL.SetRange("Employee No.", EmployeeNoP);
        if not LeaveRequestL.IsEmpty() then begin
            LeaveRequestL.FindFirst();
            repeat
                EmployeeLeaveRequestP.InsertTempRecord(LeaveRequestL)
            until LeaveRequestL.Next() = 0;
        end else
            Error('No leave request found');

    end;

    var
        NoAbsenceCodeForEmployeeErr: Label 'Employee has not been assigned with any absence codes';
}