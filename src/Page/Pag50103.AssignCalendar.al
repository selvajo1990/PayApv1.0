page 50103 "Assign Calendar"
{
    PageType = Card;
    SourceTable = Employee;
    SourceTableTemporary = true;
    InsertAllowed = false;
    DelayedInsert = false;
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Visible = HideCalendarG;
                field("Calendar Start Date"; CalendarStartDateG)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the CalendarStartDateG';
                }
                field("Calendar End Date"; CalendarEndDateG)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the CalendarEndDateG';
                }
                field("Assign Calendar From"; AssignCalendarFromG)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the AssignCalendarFromG';
                    trigger OnValidate()
                    var
                        AssignFromDateErr: Label 'Assign Calendar From must be in between Calendar Start Date & Calendar End Date';
                    begin
                        if AssignCalendarFromG > 0D then
                            if AssignCalendarFromG > 0D then
                                if not (AssignCalendarFromG >= CalendarStartDateG) and (AssignCalendarFromG <= CalendarEndDateG) then begin
                                    Error(AssignFromDateErr);
                                    CurrPage."Employee Selection".Page.Update(false);
                                end;

                        CurrPage."Employee Selection".Page.SetDataFilter(AssignCalendarFromG, CalendarIdG, HideCalendarG, CalendarStartDateG, DayTypeG);
                    end;
                }
            }
            part("Employee Selection"; "Employee Selection Subpage")
            {
                Caption = 'Employee Selection';
                ApplicationArea = all;
            }
        }
    }

    var
        AssignCalendarFromG: Date;
        CalendarStartDateG: Date;
        CalendarEndDateG: Date;
        CalendarIdG: Code[20];
        HideCalendarG: Boolean;
        DayTypeG: Text[20];

    trigger OnOpenPage()
    begin
        CurrPage."Employee Selection".Page.SetDataFilter(0D, CalendarIdG, HideCalendarG, CalendarStartDateG, DayTypeG);
    end;

    procedure SetDefaultValue(CalendarStartDateP: Date; CalendarEndDateP: Date; CalendarIdP: Code[20]; HideCalendarP: Boolean; DayTypeP: Text[20])
    begin
        CalendarStartDateG := CalendarStartDateP;
        CalendarEndDateG := CalendarEndDateP;
        CalendarIdG := CalendarIdP;
        HideCalendarG := HideCalendarP;
        DayTypeG := DayTypeP;
    end;

}