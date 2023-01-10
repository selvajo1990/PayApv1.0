xmlport 50024 "Employee Leave Details"
{
    Direction = Export;
    Format = Xml;
    UseDefaultNamespace = true;
    UseRequestPage = false;
    schema
    {
        textelement(EmployeeLeaveTypes)
        {
            textelement(EmployeeNo)
            {

            }
            textelement(FirstName)
            {

            }
            textelement(LastName)
            {

            }
            textelement(EmployeeAbsenses)
            {
                tableelement(EmployeeLevelAbsence; "Employee Level Absence")
                {
                    UseTemporary = true;
                    fieldelement(LeaveType; EmployeeLevelAbsence."Absence Code")
                    {
                    }
                    fieldelement(Name; EmployeeLevelAbsence."Absence Description")
                    {

                    }
                }
            }
        }
    }
    procedure SetEmployeeRecord(EmployeeP: Record Employee)
    begin
        EmployeeG := EmployeeP;
        EmployeeNo := EmployeeG."No.";
        LastName := EmployeeG."Last Name";
        FirstName := EmployeeG."First Name";
    end;

    procedure InsertTemp(EmployeeLevelAbsenceP: Record "Employee Level Absence")
    begin
        EmployeeLevelAbsence.Init();
        EmployeeLevelAbsence := EmployeeLevelAbsenceP;
        EmployeeLevelAbsence.Insert();
    end;

    var
        EmployeeG: Record Employee;
}