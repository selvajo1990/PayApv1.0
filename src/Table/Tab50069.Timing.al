table 50069 "Timing"
{
    DataClassification = CustomerContent;
    Caption = 'Timings';
    fields
    {
        field(1; "Calendar ID"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Calendar ID';
        }
        field(21; "From Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'From Date';
            trigger OnValidate()
            begin
                "Week Day" := '';
                if "From Date" > 0D then
                    "Week Day" := GetDayAsText("From Date");
            end;
        }
        field(22; "Week Day"; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Week Day';
            Editable = false;
        }
        field(23; "No. of Working Days"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'No. of Working Days';
            MaxValue = 7;
            MinValue = 0;
            trigger OnValidate()
            begin
                "No. of Weekend Days" := 0;
                "Starting No. of Working Day" := 0;
                "Starting No. of Weekend Day" := 0;
                if "No. of Working Days" > 0 then
                    "No. of Weekend Days" := 7 - "No. of Working Days";
            end;
        }
        field(24; "No. of Weekend Days"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'No. of Weekend Days';
            Editable = false;
        }
        field(25; "Starting No. of Working Day"; Integer)
        {
            DataClassification = CustomerContent;
            MinValue = 0;
            Caption = 'Starting No. of Working day';
            trigger OnValidate()
            begin
                if "Starting No. of Working Day" > "No. of Working Days" then
                    Error(StartingDayErr, FieldCaption("Starting No. of Working Day"), FieldCaption("No. of Working Days"));
            end;
        }
        field(26; "Starting No. of Weekend Day"; Integer)
        {
            DataClassification = CustomerContent;
            MinValue = 0;
            Caption = 'Starting No. of Weekend Day';
            trigger OnValidate()
            begin
                if "Starting No. of Weekend Day" > "No. of Weekend Days" then
                    Error(StartingDayErr, FieldCaption("Starting No. of Weekend Day"), FieldCaption("No. of Weekend Days"));
            end;
        }
    }

    keys
    {
        key(PK; "Calendar ID")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; "Calendar ID", "From Date")
        {

        }
    }
    var
        HrSetupG: Record "Human Resources Setup";
        NoSeriesMgtG: Codeunit NoSeriesManagement;
        NoSeriesG: Code[20];
        StartingDayErr: Label '%1 cannot be greater than %2';

        WorkingHoursExistErr: Label '%1 is already generated for Calendar ID %2';
        CalendarTemplateCreatedTxt: Label 'Calendar template created';

    trigger OnInsert()
    begin
        IF "Calendar ID" = '' THEN BEGIN
            HrSetupG.Get();
            HrSetupG.TESTFIELD("Timing Nos.");
            NoSeriesMgtG.InitSeries(HrSetupG."Timing Nos.", '', 0D, "Calendar ID", NoSeriesG);
        END;
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

    procedure AssisEdit(): Boolean
    begin
        HrSetupG.Get();
        HrSetupG.TESTFIELD("Timing Nos.");
        IF NoSeriesMgtG.SelectSeries(HrSetupG."Timing Nos.", '', NoSeriesG) THEN BEGIN
            NoSeriesMgtG.SetSeries("Calendar ID");
            EXIT(TRUE);
        END;
    end;

    procedure GetDayAsText(DateP: Date): Text[30]
    var
        DateL: Record Date;
    begin
        DateL.Get(DateL."Period Type"::Date, DateP);
        exit(DateL."Period Name");
    end;

    procedure GenerateTemplate()
    var
        WorkingHourL: Record "Working Hour";
        CountL: Integer;
        Counter2L: Integer;
        DateFormulaLbl: Label '<%1D>';
        StartingNoErr: Label 'Both %1 & %2 cannot be empty';
    begin
        WorkingHourL.SetRange("Calendar ID", Rec."Calendar ID");
        if not WorkingHourL.IsEmpty() then
            Error(WorkingHoursExistErr, WorkingHourL.TableCaption(), Rec."Calendar ID");

        TestField("No. of Working Days");

        if ("Starting No. of Weekend Day" = 0) and ("Starting No. of Working Day" = 0) then
            Error(StartingNoErr, FieldCaption("Starting No. of Weekend Day"), FieldCaption("Starting No. of Working Day"));

        Counter2L := "Starting No. of Weekend Day";
        if "Starting No. of Working Day" > 0 then
            Counter2L := "Starting No. of Working Day";
        for CountL := 0 to 6 do begin
            WorkingHourL.Init();
            WorkingHourL."Calendar ID" := Rec."Calendar ID";
            WorkingHourL."From Date" := CalcDate(StrSubstNo(DateFormulaLbl, CountL), Rec."From Date");
            WorkingHourL."Week Day" := GetDayAsText(WorkingHourL."From Date");
            case true of
                "Starting No. of Working Day" > 0:
                    if Counter2L > "No. of Working Days" then
                        WorkingHourL."Day Type" := WorkingHourL."Day Type"::"Week Off"
                    else
                        WorkingHourL."Day Type" := WorkingHourL."Day Type"::"Working Day";
                "Starting No. of Weekend Day" > 0:
                    if Counter2L > "No. of Weekend Days" then
                        WorkingHourL."Day Type" := WorkingHourL."Day Type"::"Working Day"
                    else
                        WorkingHourL."Day Type" := WorkingHourL."Day Type"::"Week Off";
            end;
            if Counter2L = 7 then
                Counter2L := 0;
            Counter2L += 1;
            WorkingHourL.Insert();
        end;
        Message(CalendarTemplateCreatedTxt);
    end;
}