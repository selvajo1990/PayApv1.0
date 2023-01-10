page 50102 "Employee Selection Subpage"
{
    PageType = ListPart;
    SourceTable = Employee;
    Caption = 'Employee Selection';
    DeleteAllowed = false;
    InsertAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(Employee)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                }
                field("Full Name"; Rec.FullName())
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the FullName()';
                }
                field("Employment Date"; Rec."Employment Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the date when the employee began to work for the company.';
                }
                field("Last Posted Pay Period"; LastPostedPayPeriodG)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the LastPostedPayPeriodG';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Assign Calendar")
            {
                Caption = 'Assign Calendar';
                Image = Add;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = HideCalendarG;
                ApplicationArea = all;
                ToolTip = 'Executes the Assign Calendar action.';
                trigger OnAction()
                var
                    EmployeeL: Record Employee;
                    WorkingHourL: Record "Working Hour";
                    EmployeeTimingL: Record "Employee Timing";
                    AbsenceL: Record Absence;
                    TimeDurationLbl: Label '%1 - %2';
                    FromDateMandatoryErr: Label 'From Date should have value';
                begin
                    if FromDatG = 0D then
                        Error(FromDateMandatoryErr);

                    CurrPage.SetSelectionFilter(Rec);
                    EmployeeL.Copy(Rec);

                    if EmployeeL.FindSet() then
                        repeat
                            WorkingHourL.SetRange("Calendar ID", CalendarIdG);
                            WorkingHourL.SetFilter("From Date", '>=%1', FromDatG);
                            if EmployeeL."Employment Date" > FromDatG then
                                WorkingHourL.SetFilter("From Date", '>=%1', EmployeeL."Employment Date"); // Avi : Changed to from Date from Employment Date
                            WorkingHourL.FindSet();
                            repeat
                                if not EmployeeTimingL.get(EmployeeL."No.", WorkingHourL."From Date") then begin
                                    EmployeeTimingL.Init();
                                    EmployeeTimingL."Employee No." := EmployeeL."No.";
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
                                EmployeeTimingL."Calendar ID" := CalendarIdG;
                                // EmployeeTimingL."First Half Status" := CopyStr(Format(WorkingHourL."Day Type"), 1, 20);
                                // EmployeeTimingL."Second Half Status" := CopyStr(Format(WorkingHourL."Day Type"), 1, 20);
                                if not AbsenceL.Get(EmployeeTimingL."First Half Status") then
                                    EmployeeTimingL."First Half Status" := CopyStr(Format(WorkingHourL."Day Type"), 1, 20);
                                if not AbsenceL.Get(EmployeeTimingL."Second Half Status") then
                                    EmployeeTimingL."Second Half Status" := CopyStr(Format(WorkingHourL."Day Type"), 1, 20);
                                EmployeeTimingL."Total Hours" := WorkingHourL."Total Hours";
                                EmployeeTimingL.Modify();
                            until WorkingHourL.Next() = 0;
                            EmployeeL.Calendar := CalendarIdG;
                            EmployeeL.Modify();
                        until EmployeeL.Next() = 0;
                    Message('Calendar assigned to employee');
                end;
            }
            action("Update Holiday")
            {
                Caption = 'Update Holiday';
                Image = Holiday;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = all;
                Visible = not HideCalendarG;
                ToolTip = 'Executes the Update Holiday action.';
                trigger OnAction()
                var
                    EmployeeL: Record Employee;
                    EmployeeTimingL: Record "Employee Timing";
                    HolidayUpdateLbl: Label 'Holiday Updated';
                begin
                    CurrPage.SetSelectionFilter(Rec);
                    EmployeeL.Copy(Rec);
                    if EmployeeL.FindSet() then begin
                        repeat
                            EmployeeTimingL.Get(EmployeeL."No.", HolidayDateG);
                            EmployeeTimingL."First Half Status" := DayTypeG;
                            EmployeeTimingL."Second Half Status" := DayTypeG;
                            EmployeeTimingL.Modify();
                        until EmployeeL.Next() = 0;
                        Message(HolidayUpdateLbl);
                    end;
                    Rec.Reset();
                end;
            }
        }
    }
    var
        LastPostedPayPeriodG: Text;
        CalendarIdG: Code[20];
        FromDatG: Date;
        HideCalendarG: Boolean;
        HolidayDateG: Date;
        DayTypeG: Text[20];

    procedure SetDataFilter(FromDateP: Date; CalendarIdP: Code[20]; HideCalendarP: Boolean; HolidayDateP: Date; DayTypeP: Text[20])
    var
        FilterL: Text;
        EmployeeTimingL: Record "Employee Timing";
    begin
        //Message('A-%1', FromDateP);
        CalendarIdG := CalendarIdP;
        FromDatG := FromDateP;
        HideCalendarG := HideCalendarP;
        HolidayDateG := HolidayDateP;
        DayTypeG := DayTypeP;
        if FromDateP = 0D then begin
            Rec.Reset();
            exit;
        end;

        Rec.Reset();
        Rec.SetFilter("Employment Date", '>=%1', FromDateP);
        Rec.SetFilter("Sub Grade", '>%1', '');
        if Rec.FindSet() then
            repeat
                if not (Rec.Calendar = '') then
                    FilterL += Rec."No." + '|';
            until Rec.Next() = 0;

        Rec.Reset();
        Rec.SetAutoCalcFields("Last Calendar Day");
        Rec.SetFilter("Last Calendar Day", '=%1', FromDateP - 1);
        if Rec.FindSet() then
            repeat
                FilterL += Rec."No." + '|';
            until Rec.Next() = 0;

        if FilterL > '' then
            FilterL := CopyStr(FilterL, 1, STRLEN(FilterL) - 1);
        Rec.Reset();
        Rec.SetFilter("No.", FilterL);
        if FilterL = '' then
            Rec.SetFilter("No.", '%1', FilterL);
    end;
}