report 50068 "Update Employee Components"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    ProcessingOnly = true;
    Caption = 'Update Employee Components';
    Description = 'This Report has been created for Uploading/Correcting the data only';
    dataset
    {
        dataitem(Employee; Employee)
        {
            RequestFilterFields = "No.";
            trigger OnPreDataItem()
            begin
                if Employee.GetFilter("No.") = '' then
                    Error('You have to select employee no.');

                if (EarningsG or TimingsG) and (FromDateG = 0D) then
                    Error(FromDateMandatoryErr);
            end;

            trigger OnAfterGetRecord()
            begin
                if EarningsG then begin
                    Employee.TestField("Employment Date");
                    if Employee."Employment Date" > FromDateG then begin
                        Employee.CreateUpdateEarningGroupLines(Employee."Employment Date");
                        Employee.CreateUpdateAbsenceGroupLine(Employee."Employment Date");
                        if Employee."Air Ticket Group" > '' then
                            Employee.CreateUpdateAirTicketGroup(Employee."Employment Date");
                        if Employee."Loan & Advance Group" > '' then
                            Employee.CreateUpdateLoanGroupLine(Employee."Employment Date");
                    end else begin
                        Employee.CreateUpdateEarningGroupLines(FromDateG);
                        Employee.CreateUpdateAbsenceGroupLine(FromDateG);
                        if Employee."Air Ticket Group" > '' then
                            Employee.CreateUpdateAirTicketGroup(FromDateG);
                        if Employee."Loan & Advance Group" > '' then
                            Employee.CreateUpdateLoanGroupLine(FromDateG);
                    end;
                end;

                if TimingsG then
                    UpdateCalendar();

                if DeleteHistoryG then
                    DeleteEmployeeEanings();

                if UpdateEaningTypeG then
                    UpdateEarningType();

            end;

            trigger OnPostDataItem()
            begin
                // if UpdateDesigG then
                //     UpdateEmployeeDesignation();
                if EmployeeReplicaG then
                    CreateEmployeeReplica();
            end;

        }
    }

    requestpage
    {
        SaveValues = true;
        layout
        {
            area(Content)
            {
                group("Update/ Create")
                {
                    field("Assign Components"; EarningsG)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Earning, Absense, Loan & Air Ticket will be assigned if group is attached in the payap';
                    }
                    field("Update Calendar"; TimingsG)
                    {
                        ApplicationArea = All;
                        ToolTip = 'If employee is assigned with any calendar in Payap tab, it will assigned to him';
                    }
                    field("From Date"; FromDateG)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Components will be updated based this date';
                    }
                    field("Delete Component History"; DeleteHistoryG)
                    {
                        ApplicationArea = all;
                        ToolTip = 'Earning, Absense, Loan & Air Ticket will be deleted';
                    }
                    field("Update Earning Type"; UpdateEaningTypeG)
                    {
                        ApplicationArea = all;
                        ToolTip = 'Employee level Earning Code Type will be updated based on Earning Group of employee';
                    }
                    field("Earning Code"; EarningCodeG)
                    {
                        ApplicationArea = All;
                        TableRelation = Earning;
                        ToolTip = 'Earning code must have value if Update Earning Type is true';
                    }
                    field("Create Employee Replica"; EmployeeReplicaG)
                    {
                        ApplicationArea = all;
                        ToolTip = 'Please Update the Designation before you Proceed';
                    }
                    // field("Update Employee in Desig"; UpdateDesigG)
                    // {
                    //     ApplicationArea = all;
                    //     Caption = 'Update Employee No. in Designation';
                    // }
                }
            }
        }


    }

    var
        EarningsG: Boolean;
        TimingsG: Boolean;
        FromDateG: Date;
        DeleteHistoryG: Boolean;
        UpdateEaningTypeG: Boolean;
        EmployeeReplicaG: Boolean;
        // UpdateDesigG: Boolean;
        EarningCodeG: Code[20];
        FromDateMandatoryErr: Label 'From Date should have value';

    local procedure UpdateCalendar()
    var
        WorkingHourL: Record "Working Hour";
        EmployeeTimingL: Record "Employee Timing";
        AbsenceL: Record Absence;
        TimeDurationLbl: Label '%1 - %2';
    begin
        WorkingHourL.SetRange("Calendar ID", Employee.Calendar);
        WorkingHourL.SetFilter("From Date", '>=%1', FromDateG);
        if Employee."Employment Date" > FromDateG then
            WorkingHourL.SetFilter("From Date", '>=%1', Employee."Employment Date"); // Avi : Changed to from Date from Employment Date
        if WorkingHourL.FindSet() then
            repeat
                if not EmployeeTimingL.get(Employee."No.", WorkingHourL."From Date") then begin
                    EmployeeTimingL.Init();
                    EmployeeTimingL."Employee No." := Employee."No.";
                    EmployeeTimingL."From Date" := WorkingHourL."From Date";
                    EmployeeTimingL.Insert();
                end;
                EmployeeTimingL."Week Day" := WorkingHourL."Week Day";
                if WorkingHourL."Start Time" <> 0T then begin
                    EmployeeTimingL."First Half Duration" := CopyStr(StrSubstNo(TimeDurationLbl, WorkingHourL."Start Time", WorkingHourL."Start Time" + WorkingHourL."First Half Hours"), 1, 100);
                    EmployeeTimingL."Second Half Duration" := CopyStr(StrSubstNo(TimeDurationLbl, WorkingHourL."Start Time" + WorkingHourL."First Half Hours", WorkingHourL."End Time"), 1, 100);
                end;
                if WorkingHourL."Break 1 - Start Time" <> 0T then
                    EmployeeTimingL."Break 1 Duration" := CopyStr(StrSubstNo(TimeDurationLbl, WorkingHourL."Break 1 - Start Time", WorkingHourL."Break 1 - End Time"), 1, 100);
                if WorkingHourL."Break 2 - Start Time" <> 0T then
                    EmployeeTimingL."Break 2 Duration" := CopyStr(StrSubstNo(TimeDurationLbl, WorkingHourL."Break 2 - Start Time", WorkingHourL."Break 2 - End Time"), 1, 100);
                if WorkingHourL."Break 3 - Start Time" <> 0T then
                    EmployeeTimingL."Break 3 Duration" := CopyStr(StrSubstNo(TimeDurationLbl, WorkingHourL."Break 3 - Start Time", WorkingHourL."Break 3 - End Time"), 1, 100);
                EmployeeTimingL."Calendar ID" := Employee.Calendar;
                if not AbsenceL.Get(EmployeeTimingL."First Half Status") then
                    EmployeeTimingL."First Half Status" := CopyStr(Format(WorkingHourL."Day Type"), 1, 20);
                if not AbsenceL.Get(EmployeeTimingL."Second Half Status") then
                    EmployeeTimingL."Second Half Status" := CopyStr(Format(WorkingHourL."Day Type"), 1, 20);
                EmployeeTimingL.Modify();
            until WorkingHourL.Next() = 0;
    end;

    local procedure DeleteEmployeeEanings()
    var
        EmployeeEarningHistoryL: Record "Employee Earning History";
        EmployeeLevelEarningL: Record "Employee Level Earning";
        EmployeeLevelAbsenceL: Record "Employee Level Absence";
        EmployeeAirTicket: Record "Employee Level Air Ticket";
        EmployeeLoan: Record "Employee Level Loan";
    begin
        EmployeeLevelAbsenceL.SetRange("Employee No.", Employee."No.");
        EmployeeLevelAbsenceL.DeleteAll();

        EmployeeLevelEarningL.SetRange("Employee No.", Employee."No.");
        EmployeeLevelEarningL.DeleteAll();

        EmployeeEarningHistoryL.SetRange("Employee No.", Employee."No.");
        EmployeeEarningHistoryL.DeleteAll();

        EmployeeAirTicket.SetRange("Employee No.", Employee."No.");
        EmployeeAirTicket.DeleteAll();

        EmployeeLoan.SetRange("Employee No.", Employee."No.");
        EmployeeLoan.DeleteAll();
    end;

    local procedure UpdateEarningType()
    var
        EmployeeLevelEarningL: Record "Employee Level Earning";
        EarningGroup: Record "Earning Group Line";
        EarningErr: Label 'Earning code must have value';
    begin
        if EarningCodeG = '' then
            Error(EarningErr);

        Employee.TestField("Earning Group");

        EarningGroup.SetRange("Group Code", Employee."Earning Group");
        EarningGroup.SetRange("Earning Code", EarningCodeG);
        EarningGroup.FindFirst();

        EmployeeLevelEarningL.SetRange("Employee No.", Employee."No.");
        EmployeeLevelEarningL.SetRange("Group Code", Employee."Earning Group");
        EmployeeLevelEarningL.SetRange("Earning Code", EarningCodeG);
        EmployeeLevelEarningL.ModifyAll(Type, EarningGroup.Type);
    end;

    local procedure CreateEmployeeReplica()
    var
        EmployeeReplicaL: Record "Employee ATG";
        EmployeeL: Record Employee;
        EmployeeLevelDesignationL: Record "Employee Level Designation";
        ReportingToDesignationL: Record "Employee Level Designation";
    begin
        EmployeeL.FindFirst();
        repeat
            EmployeeLevelDesignationL.SetRange("Employee No.", EmployeeL."No.");
            EmployeeLevelDesignationL.SetRange("Primary Position", true);
            if EmployeeLevelDesignationL.FindFirst() then begin
                ReportingToDesignationL.SetRange("Designation Code", EmployeeLevelDesignationL."Reporting To");
                if ReportingToDesignationL.FindFirst() then
                    ;
            end;
            EmployeeReplicaL.InsertUpdateRecord(EmployeeL."No.", EmployeeL.FullName(), CopyStr(EmployeeL.CurrentCompany(), 1, 100), EmployeeL."Company E-Mail", EmployeeLevelDesignationL."Designation Code", ReportingToDesignationL."Employee No.", ReportingToDesignationL."Designation Code", EmployeeLevelDesignationL.Description);
        until EmployeeL.Next() = 0;
    end;

    local procedure UpdateEmployeeDesignation()
    var
        EmployeeLevelDesignationL: Record "Employee Level Designation";
        DesignationL: Record Designation;
    begin
        EmployeeLevelDesignationL.FindSet();
        repeat
            DesignationL.Get(EmployeeLevelDesignationL."Designation Code");
            DesignationL."Employee No." := EmployeeLevelDesignationL."Employee No.";
            DesignationL.Modify();
        until EmployeeLevelDesignationL.Next() = 0;
    end;
}