page 50104 "Employee Timing"
{
    PageType = List;
    SourceTable = "Employee Timing";
    Caption = 'Employee Timings';
    Editable = false;
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Calendar ID"; Rec."Calendar ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Calendar ID';
                }
                field("From Date"; Rec."From Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the From Date';
                }
                field("Week Day"; Rec."Week Day")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Week Day';
                }
                field("First Half Duration"; Rec."First Half Duration")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the First Half Duration';
                }
                field("First Half Status"; Rec."First Half Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the First Half Status';
                }
                field("Second Half Duration"; Rec."Second Half Duration")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Second Half Duration';
                }
                field("Second Half Status"; Rec."Second Half Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Second Half Status';
                }
                field("Break 1 Duration"; Rec."Break 1 Duration")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Break 1 Duration';
                }
                field("Break 2 Duration"; Rec."Break 2 Duration")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Break 2 Duration';
                }
                field("Break 3 Duration"; Rec."Break 3 Duration")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Break 3 Duration';
                }
                field("Total Hours"; Rec."Total Hours")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Total hours';
                }
                field("Actual In-Time"; Rec."Actual In-Time")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Actual In-Time';
                }
                field("Actual Out-Time"; Rec."Actual Out-Time")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Actual Out-Time';
                }
                field("Actal Hours Worked"; Rec."Actal Hours Worked")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Actal Hours Worked';
                }
                field("OT Hours"; Rec."OT Hours")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the OT Hours';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Clear Calendar")
            {
                Image = Delete;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = all;
                ToolTip = 'Executes the Clear Calendar action.';
                trigger OnAction()
                var
                    EmployeeTimingL: Record "Employee Timing";
                begin
                    EmployeeTimingL.SetRange("Employee No.", Rec."Employee No.");
                    if Confirm('Hey it will delete', true) then
                        EmployeeTimingL.DeleteAll();
                end;
            }
            action("Import Excel")
            {
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = All;
                Caption = 'Import Excel';
                Image = ImportExcel;
                ToolTip = 'Executes the Import Excel action.';

                trigger OnAction()
                begin
                    ImportEmployeeTimesheet();
                end;
            }
        }
    }
    var
        ExcelBuffer: Record "Excel Buffer";

    procedure ImportEmployeeTimesheet()
    var
        EmployeeTiming: Record "Employee Timing";
        EmployeeL: Record Employee;
        TotalRow: Integer;
        RowNo: Integer;
        FilterStartDateL: Date;
        FilterEndDateL: Date;
        DateL: Date;
        Filename: Text;
        Instr: InStream;
        Sheetname: Text;
        FileUploaded: Boolean;
        NewDateL: Date;
        NewStartDate: Date;
        NewEndDate: Date;
    begin
        FilterStartDateL := 0D;
        FilterEndDateL := 0D;
        NewStartDate := 0D;
        NewEndDate := 0D;
        FileUploaded := UploadIntoStream('Select Timesheet to Upload', '', '', Filename, Instr);

        if Filename = '' then
            exit;

        ExcelBuffer.DeleteAll();
        ExcelBuffer.Reset();
        Sheetname := ExcelBuffer.SelectSheetsNameStream(Instr);
        ExcelBuffer.OpenBookStream(Instr, Sheetname);
        ExcelBuffer.ReadSheet();

        if ExcelBuffer.FindLast() then
            TotalRow := ExcelBuffer."Row No.";

        for RowNo := 2 to TotalRow do begin
            Evaluate(DateL, GetValueAtIndex(RowNo, 2));
            NewDateL := DateL + 1;
            if RowNo = 2 then
                Evaluate(FilterStartDateL, GetValueAtIndex(RowNo, 2));
            NewStartDate := FilterStartDateL + 1;
            //Message('StartDate-%1', NewStartDate);
            if NewDateL > FilterEndDateL then
                FilterEndDateL := NewDateL;
            NewEndDate := FilterEndDateL + 1;

            EmployeeTiming.Get(GetValueAtIndex(RowNo, 1), NewDateL);
            Evaluate(EmployeeTiming."Actual In-Time", GetValueAtIndex(RowNo, 3));
            Evaluate(EmployeeTiming."Actual Out-Time", GetValueAtIndex(RowNo, 4));
            Evaluate(EmployeeTiming."Actal Hours Worked", GetValueAtIndex(RowNo, 5));
            //EmployeeL.Reset();
            if EmployeeL.Get(EmployeeTiming."Employee No.") and EmployeeL."Contract Employee" <> true then
                EmployeeTiming."OT Hours" := EmployeeTiming."Actal Hours Worked" - EmployeeTiming."Total Hours"
            else
                EmployeeTiming."OT Hours" := 0;
            EmployeeTiming.Modify(true);
        end;

        if FilterEndDateL = 0D then
            exit;

        Message('%1 rows imported successfully !!!', TotalRow - 1);
        //Rec.SetRange("From Date", FilterStartDateL, FilterEndDateL);
        Rec.SetRange("From Date", NewStartDate, NewEndDate);

    end;

    local procedure GetValueAtIndex(RowNoP: Integer; ColNoP: Integer): Text
    begin
        IF ExcelBuffer.Get(RowNoP, ColNoP) then
            exit(ExcelBuffer."Cell Value as Text");
    end;

}