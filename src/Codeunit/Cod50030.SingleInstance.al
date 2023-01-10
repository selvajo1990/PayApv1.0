codeunit 50030 "Single Instance"
{
    SingleInstance = true;

    procedure SetEmpNo(EmployeeNo: Code[20])
    var
    begin
        EmpNo := EmployeeNo;
    end;

    procedure GetEmpNo(): Code[20]
    begin
        exit(EmpNo);
    end;

    var
        EmpNo: Code[20];
}