xmlport 50026 "Employee Approvals"
{
    Direction = Export;
    Format = Xml;
    UseDefaultNamespace = true;
    UseRequestPage = false;
    schema
    {
        textelement(ApprovalEntries)
        {
            tableelement(ApprovalEntry; "Approval Entry ATG")
            {
                UseTemporary = true;
                fieldelement(ApprovalEntryNo; ApprovalEntry."Entry No.")
                { }
                fieldelement(LeaveRequestNo; ApprovalEntry."Document No.")
                { }
                textelement(EmployeeNo)
                { }
                textelement(EmployeeName)
                { }
                textelement(PhoneNo)
                { }
                textelement(Role)
                { }
                textelement(LeaveDescription)
                { }
                textelement(LeaveFromDate)
                { }
                textelement(LeaveToDate)
                { }
                textelement(FromPeriod)
                { }
                textelement(ToPeriod)
                { }

                trigger OnAfterGetRecord()
                var
                    LeaveRequestL: Record "Leave Request";
                    CompanyL: Record Company;
                    EmployeeL: Record Employee;
                    AbsenceL: Record Absence;
                    ChangeCompanyL: Boolean;
                begin
                    if not LeaveRequestL.Get(ApprovalEntry."Document No.") then begin
                        CompanyL.FindSet();
                        ChangeCompanyL := true;
                        repeat
                            LeaveRequestL.ChangeCompany(CompanyL.Name);
                            EmployeeL.ChangeCompany(CompanyL.Name);
                            CompanyL.Next(1);
                        until LeaveRequestL.Get(ApprovalEntry."Document No.") and EmployeeL.Get(ApprovalEntry."Sender ID");
                    end else
                        EmployeeL.Get(ApprovalEntry."Sender ID");
                    AbsenceL.Get(LeaveRequestL."Absence Code");
                    EmployeeNo := EmployeeL."No.";
                    EmployeeName := EmployeeL.FullName();
                    PhoneNo := EmployeeL."Phone No.";
                    Role := EmployeeL."Job Title";
                    LeaveFromDate := format(LeaveRequestL."Start Date", 0, '<Year4>-<Month,2>-<Day,2>');
                    LeaveToDate := format(LeaveRequestL."End Date", 0, '<Year4>-<Month,2>-<Day,2>');
                    FromPeriod := Format(LeaveRequestL."From Period");
                    ToPeriod := Format(LeaveRequestL."To Period");
                    LeaveDescription := AbsenceL.Description;
                end;
            }
        }
    }

    procedure InsertIntoTemp(ApprovalEntryP: Record "Approval Entry ATG")
    begin
        ApprovalEntry.Init();
        ApprovalEntry := ApprovalEntryP;
        ApprovalEntry.Insert();
    end;
}