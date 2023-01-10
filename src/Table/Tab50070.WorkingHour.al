table 50070 "Working Hour"
{
    DataClassification = CustomerContent;
    Caption = 'Working Hour';
    fields
    {
        field(1; "Calendar ID"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Calendar ID';
            Editable = false;
        }
        field(2; "From Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'From Date';
            Editable = false;
        }
        field(21; "To Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'To Date';
            Editable = false;
        }
        field(22; "Week Day"; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Week Day';
            Editable = false;
        }
        field(23; "Day Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = "Working Day","Week Off","Public Holiday";
            OptionCaption = 'Working Day,Week Off,Public Holiday';
            Editable = false;
        }
        field(24; "Start Time"; Time)
        {
            DataClassification = CustomerContent;
            Caption = 'Start Time';
            trigger OnValidate()
            begin
                "End Time" := 0T;
                "Total Hours" := 0;
                "To Date" := 0D;
                "First Half Hours" := 0;
                "Second Half Hours" := 0;
            end;
        }
        field(25; "End Time"; Time)
        {
            DataClassification = CustomerContent;
            Caption = 'End Time';
            trigger OnValidate()
            var
                StartDateTimeL: DateTime;
                EndDateTimeL: DateTime;
            begin
                TestField("Start Time");
                TestField("End Time");

                StartDateTimeL := CreateDateTime("From Date", "Start Time");
                EndDateTimeL := CreateDateTime("From Date", "End Time");
                "Total Hours" := EndDateTimeL - StartDateTimeL;
                "To Date" := "From Date";
                if "Total Hours" <= 0 then begin
                    "To Date" := "From Date" + 1;
                    EndDateTimeL := CreateDateTime("To Date", "End Time");
                    "Total Hours" := EndDateTimeL - StartDateTimeL;
                end;
                "Total Hours" := Abs("Total Hours");
            end;
        }
        field(26; "First Half Hours"; Duration)
        {
            DataClassification = CustomerContent;
            Caption = 'First Half Hours';
            trigger OnValidate()
            begin
                TestField("Total Hours");
                if "First Half Hours" > "Total Hours" then
                    Error(FirstHalfValidateErr, FieldCaption("First Half Hours"), FieldCaption("Total Hours"));
                "Second Half Hours" := "Total Hours" - "First Half Hours";
            end;
        }
        field(27; "Second Half Hours"; Duration)
        {
            DataClassification = CustomerContent;
            Caption = 'Second Half Hours';
            Editable = false;
        }
        field(28; "Break 1 - Start Time"; Time)
        {
            DataClassification = CustomerContent;
            Caption = 'Break 1 - Start Time';
        }
        field(29; "Break 1 - End Time"; Time)
        {
            DataClassification = CustomerContent;
            Caption = 'Break 1 - End Time';
        }
        field(30; "Break 2 - Start Time"; Time)
        {
            DataClassification = CustomerContent;
            Caption = 'Break 2 - Start Time';
        }
        field(31; "Break 2 - End Time"; Time)
        {
            DataClassification = CustomerContent;
            Caption = 'Break 2 - End Time';
        }
        field(32; "Break 3 - Start Time"; Time)
        {
            DataClassification = CustomerContent;
            Caption = 'Break 3 - Start Time';
        }
        field(33; "Break 3 - End Time"; Time)
        {
            DataClassification = CustomerContent;
            Caption = 'Break 3 - End Time';
        }
        field(34; "Total Hours"; Duration)
        {
            DataClassification = CustomerContent;
            Caption = 'Total Hours';
            Editable = false;
        }
    }

    keys
    {
        key(PK; "Calendar ID", "From Date")
        {
            Clustered = true;
        }
    }

    var
        FirstHalfValidateErr: Label '%1 cannot be greater than %2';
        CalendarCreatedTxt: Label 'Calendar is created for %1 days';

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

    procedure GenerateCalendar()
    var
        TimingL: Record Timing;
        WorkingHourL: Record "Working Hour";
        TempWorkingHourL: Record "Working Hour" temporary;
        NoOfDaysL: Integer;
        LastYearL: Integer;
        CounterL: Integer;
        InputYearL: Integer;
        LastDateL: Date;
        OptionNoOfYearTxt: Label '1,2,3,4,5';
        SelectionTxt: Label 'Select No. of Years for calendar creation';
    begin
        InputYearL := Dialog.StrMenu(OptionNoOfYearTxt, 1, SelectionTxt);
        if InputYearL = 0 then
            exit;

        TempWorkingHourL.DeleteAll();
        CounterL := 0;
        WorkingHourL.Reset();
        WorkingHourL.SetCurrentKey("Calendar ID", "From Date");
        WorkingHourL.SetRange("Calendar ID", Rec."Calendar ID");
        if WorkingHourL.FindSet(false, false) then
            repeat
                CounterL += 1;
                if WorkingHourL."Day Type" = WorkingHourL."Day Type"::"Working Day" then begin
                    WorkingHourL.TestField("From Date");
                    WorkingHourL.TestField("End Time");
                    WorkingHourL.TestField("First Half Hours");
                    WorkingHourL.TestField("Total Hours");
                end;
                TempWorkingHourL.Init();
                TempWorkingHourL.TransferFields(WorkingHourL);
                TempWorkingHourL.Insert();
            until (WorkingHourL.Next() = 0) or (CounterL = 7);

        WorkingHourL.FindLast();
        LastDateL := WorkingHourL."From Date";
        LastYearL := Date2DMY(WorkingHourL."From Date", 3) - 1;

        for CounterL := 1 to InputYearL do begin
            LastYearL += 1;
            NoOfDaysL += DMY2DATE(31, 12, LastYearL) - DMY2DATE(31, 12, LastYearL - 1);
        end;

        if WorkingHourL.Count() = 7 then
            NoOfDaysL := NoOfDaysL - 7;

        for CounterL := 1 to NoOfDaysL do begin
            TempWorkingHourL.SetRange("Week Day", TimingL.GetDayAsText(LastDateL + CounterL));
            TempWorkingHourL.FindFirst();

            WorkingHourL.Init();
            WorkingHourL.TransferFields(TempWorkingHourL);
            WorkingHourL."Calendar ID" := "Calendar ID";
            WorkingHourL."From Date" := LastDateL + CounterL;
            WorkingHourL."Week Day" := CopyStr(TempWorkingHourL.GetFilter("Week Day"), 1, 30);
            if WorkingHourL."Day Type" <> WorkingHourL."Day Type"::"Week Off" then
                WorkingHourL.Validate("End Time");
            WorkingHourL.Insert();
        end;
        Message(CalendarCreatedTxt, NoOfDaysL);
    end;

    procedure AssignCalendarToEmployee()
    begin
    end;
}