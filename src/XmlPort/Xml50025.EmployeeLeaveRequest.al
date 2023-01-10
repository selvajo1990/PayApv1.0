xmlport 50025 "Employee Leave Request"
{
    Direction = Export;
    Format = Xml;
    UseDefaultNamespace = true;
    UseRequestPage = false;
    schema
    {
        textelement(EmployeeLeaveRequest)
        {
            tableelement(LeaveRequest; "Leave Request")
            {
                UseTemporary = true;
                fieldelement(LeaveRequestNo; LeaveRequest."No.")
                {

                }
                fieldelement(EmployeeNo; LeaveRequest."Employee No.")
                {

                }
                textelement(EmployeeFirstName)
                {

                }
                textelement(EmployeeLastName)
                {

                }
                fieldelement(LeaveType; LeaveRequest.Description)
                {

                }
                textelement(StartDate)
                {
                    trigger OnBeforePassVariable()
                    begin
                        StartDate := Format(LeaveRequest."Start Date", 0, '<Year4>-<Month,2>-<Day,2>')
                    end;

                }
                textelement(EndDate)
                {
                    trigger OnBeforePassVariable()
                    begin
                        EndDate := Format(LeaveRequest."End Date", 0, '<Year4>-<Month,2>-<Day,2>')
                    end;
                }
                fieldelement(FromSession; LeaveRequest."From Period")
                {

                }
                fieldelement(ToSession; LeaveRequest."To Period")
                {

                }
                fieldelement(Holidays; LeaveRequest.Hoildays)
                {

                }
                fieldelement(Weekend; LeaveRequest.Weekends)
                {

                }
                fieldelement(LeaveDays; LeaveRequest."Leave Days")
                {

                }
                fieldelement(CurrentBalance; LeaveRequest."Current Balance")
                {

                }
                fieldelement(BalanceAsOnStartDate; LeaveRequest."Balance As On Start Date")
                {

                }
                fieldelement(ClosingBalance; LeaveRequest."Closing Balance")
                {

                }
                fieldelement(LeaveStatus; LeaveRequest.Status)
                {

                }
                trigger OnAfterGetRecord()
                var
                    EmployeeL: Record Employee;
                    CompanyL: Record Company;
                begin
                    if not EmployeeL.Get(LeaveRequest."Employee No.") then begin
                        CompanyL.FindSet();
                        repeat
                            EmployeeL.ChangeCompany(CompanyL.Name);
                            CompanyL.Next(1);
                        until EmployeeL.Get(LeaveRequest."Employee No.");
                    end;
                    EmployeeFirstName := EmployeeL."First Name";
                    EmployeeLastName := EmployeeL."Last Name";
                end;
            }
        }
    }
    procedure InsertTempRecord(Var LeaveRequestTempP: Record "Leave Request")
    begin
        LeaveRequest.Init();
        LeaveRequest := LeaveRequestTempP;
        LeaveRequest.Insert();
    end;


}