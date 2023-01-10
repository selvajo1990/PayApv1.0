codeunit 50029 "Employee Chart Mgmt"
{
    trigger OnRun()
    begin
    end;

    procedure UpdateEmployeeDepartmentData(var BusinessChartBuffer: Record "Business Chart Buffer")
    var
        Department: Record Department;
        DepartmentCount: Integer;
        Counter: Integer;
        PrintValueLbl: Label '%1 (%2)';
    begin
        BusinessChartBuffer.Initialize();
        BusinessChartBuffer.AddMeasure(Department.FieldCaption("No. of Employee"), 1, BusinessChartBuffer."Data Type"::Integer, BusinessChartBuffer."Chart Type"::Pie);
        BusinessChartBuffer.SetXAxis(Department.TableCaption(), BusinessChartBuffer."Data Type"::String);
        Department.SetAutoCalcFields("No. of Employee");
        if Department.FindSet() then
            repeat
                DepartmentCount := Department."No. of Employee";
                if DepartmentCount > 0 then begin
                    Counter += 1;
                    BusinessChartBuffer.AddColumn(StrSubstNo(PrintValueLbl, Department.Description, DepartmentCount));
                    BusinessChartBuffer.SetValueByIndex(0, Counter - 1, DepartmentCount);
                end;
            until Department.Next() = 0;
    end;

    procedure UpdateEmployeeLeaveData(var BusinessChartBuffer: Record "Business Chart Buffer")
    var
        Absence: Record Absence;
        AbsenceCount: Decimal;
        Counter: Integer;
        PrintValueLbl: Label '%1 (%2)';
    begin
        BusinessChartBuffer.Initialize();
        BusinessChartBuffer.AddMeasure('No. of Absence', 1, BusinessChartBuffer."Data Type"::Integer, BusinessChartBuffer."Chart Type"::Doughnut);
        BusinessChartBuffer.SetXAxis(Absence.TableCaption(), BusinessChartBuffer."Data Type"::String);
        if Absence.FindSet() then
            repeat
                AbsenceCount := GetNoOfAbsence(Absence."Absence Code");
                if AbsenceCount > 0 then begin
                    Counter += 1;
                    BusinessChartBuffer.AddColumn(StrSubstNo(PrintValueLbl, Absence.Description, AbsenceCount));
                    BusinessChartBuffer.SetValueByIndex(0, Counter - 1, AbsenceCount);
                end;
            until Absence.Next() = 0;
    end;

    local procedure GetNoOfAbsence(AbsenceCode: Code[20]): Decimal
    var
        LeaveRequest: Record "Leave Request";
        AbsenceCount: Decimal;
    begin
        AbsenceCount := 0;
        LeaveRequest.SetCurrentKey("Absence Code");
        LeaveRequest.SetRange("Absence Code", AbsenceCode);
        if LeaveRequest.FindSet() then
            repeat
                if (Today() >= LeaveRequest."Start Date") and (Today() <= LeaveRequest."End Date") then
                    AbsenceCount += 1;
            until LeaveRequest.Next() = 0;
        exit(AbsenceCount);
    end;
}