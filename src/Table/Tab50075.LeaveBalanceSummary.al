table 50075 "Leave Balance Summary"
{
    DataClassification = CustomerContent;
    Caption = 'Leave Balance Summary';

    fields
    {
        field(1; "Employee No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Employee No.';
            TableRelation = Employee;
        }
        field(2; "Absence Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Absence Code';
            TableRelation = Absence;
        }
        field(21; "Assigned Days"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Assigned Days';
            MinValue = 0;
        }
        field(22; "Leave Balance"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Leave Balance';
            MinValue = 0;
        }
        field(23; "Carry Forward Days"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Carry Forward Days';
            MinValue = 0;
        }
        field(24; "Leave Taken"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Leave Taken';
            MinValue = 0;
        }

    }

    keys
    {
        key(PK; "Employee No.", "Absence Code")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin
    end;

    procedure CreateUpdateEntry(EmployeeNoP: Code[20]; AbsenceCodeP: Code[20]; AssignedDaysP: Decimal; CarryForwardDaysP: Decimal)
    begin
        if not get(EmployeeNoP, AbsenceCodeP) then begin
            init();
            "Employee No." := EmployeeNoP;
            "Absence Code" := AbsenceCodeP;
            Insert();
        end;
        "Assigned Days" := AssignedDaysP;
        "Carry Forward Days" := CarryForwardDaysP;
        "Leave Balance" := ("Assigned Days" + "Carry Forward Days") - "Leave Taken";
        Modify();
    end;

    procedure UpdateLeaveBalance(EmployeeNoP: Code[20]; AbsenceCodeP: Code[20]; LeaveTakenP: Decimal)
    var
        CompanyL: Record Company;
    begin
        if not Get(EmployeeNoP, AbsenceCodeP) then begin
            CompanyL.FindSet();
            repeat
                ChangeCompany(CompanyL.Name);
                CompanyL.Next(1);
            until Get(EmployeeNoP, AbsenceCodeP);
        end;
        "Leave Taken" += LeaveTakenP;
        "Leave Balance" := ("Assigned Days" + "Carry Forward Days") - "Leave Taken";
        Modify();
    end;

    procedure ClearLeaveBalance(EmployeeNoP: Code[20]; AbsenceCodeP: Code[20]; AssignedDaysP: Decimal; CarryForwardDaysP: Decimal; PayCycleLineP: Record "Pay Period Line")
    begin
        if Get(EmployeeNoP, AbsenceCodeP) then begin
            "Assigned Days" := AssignedDaysP;
            "Leave Taken" := CheckAnyLeaveTakenForOpeningMonth(EmployeeNoP, AbsenceCodeP, PayCycleLineP);
            "Carry Forward Days" := CarryForwardDaysP;
            "Leave Balance" := ("Assigned Days" + "Carry Forward Days") - "Leave Taken";
            Modify();
        end;
    end;

    local procedure CheckAnyLeaveTakenForOpeningMonth(EmployeeNoP: Code[20]; AbsenceCodeP: Code[20]; PayCycleLineP: Record "Pay Period Line") NoofLeaveTakenR: Decimal
    var
        EmployeeTimingL: Record "Employee Timing";
    begin
        EmployeeTimingL.SetRange("Employee No.", EmployeeNoP);
        EmployeeTimingL.SetRange("From Date", PayCycleLineP."Period Start Date", PayCycleLineP."Period End Date");
        EmployeeTimingL.SetRange("First Half Status", AbsenceCodeP);
        NoofLeaveTakenR := EmployeeTimingL.Count();
        EmployeeTimingL.SetRange("Second Half Status", AbsenceCodeP);
        NoofLeaveTakenR += EmployeeTimingL.Count();
        exit(NoofLeaveTakenR / 2);
    end;
}