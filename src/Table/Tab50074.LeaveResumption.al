table 50074 "Leave Resumption"
{
    DataClassification = CustomerContent;
    Caption = 'Leave Resumption';
    fields
    {
        field(1; "Leave Request No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Leave Request No.';
            TableRelation = "Leave Request";
        }
        field(2; "Line No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Line No.';
        }
        field(3; "Start Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Start Date';
        }
        field(4; "End Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'End Date';
        }
        field(21; "Resumption Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Resumption Date';
        }
        field(22; "Resumption Days"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Resumption Days';
        }
        field(23; "Resumption Type"; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Resumption Type';
            OptionMembers = " ","Early Return","Late Return";
            OptionCaption = ' ,Early Return,Late Return';
        }
        field(24; "Resumption Action"; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Resumption Action';
            OptionMembers = " ","Loss of Pay","Deduct Balance";
            OptionCaption = ' ,Loss of Pay,Deduct Balance';
        }
        field(25; "Status"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = " ",Open,Approved,"Pending Approval",Rejected,Delegated;
            OptionCaption = ' ,Open,Approved,Pending Approval,Rejected,Delegated';
            Caption = 'Status';
        }
    }
    keys
    {
        key(PK; "Leave Request No.", "Line No.")
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    begin
        if "Line No." = 0 then
            "Line No." := GetNextLineNo();
    end;

    trigger OnModify()
    var
        LeaveRequestL: Record "Leave Request";
        LeaveBalanaceSummaryL: Record "Leave Balance Summary";
    begin
        LeaveRequestL.Get("Leave Request No.");
        if (Status = Status::Approved) and (Status <> xRec.Status) then begin
            UpdateEmployeeCalendar();
            LeaveBalanaceSummaryL.UpdateLeaveBalance(LeaveRequestL."Employee No.", LeaveRequestL."Absence Code", -"Resumption Days");
        end;
    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin
    end;

    procedure GetNextLineNo(): Integer
    var
        LeaveResumptionL: Record "Leave Resumption";
    begin
        LeaveResumptionL.SetRange("Leave Request No.", "Leave Request No.");
        if LeaveResumptionL.FindLast() then
            exit(LeaveResumptionL."Line No." + 10000);
        exit(10000);
    end;

    local procedure UpdateEmployeeCalendar()
    var
        EmployeeTimingsL: Record "Employee Timing";
        WorkingHourL: Record "Working Hour";
        LeaveRequestL: Record "Leave Request";
        AbsenceL: Record Absence;
    begin
        LeaveRequestL.Get("Leave Request No.");
        AbsenceL.Get(LeaveRequestL."Absence Code");
        if "Resumption Type" = "Resumption Type"::"Early Return" then begin
            EmployeeTimingsL.SetRange("Employee No.", LeaveRequestL."Employee No.");
            EmployeeTimingsL.SetRange("From Date", LeaveRequestL."Start Date");
            EmployeeTimingsL.FindFirst();
            WorkingHourL.SetRange("Calendar ID", EmployeeTimingsL."Calendar ID");
            WorkingHourL.SetRange("From Date", "Resumption Date", LeaveRequestL."End Date");
            WorkingHourL.FindSet();
            repeat
                EmployeeTimingsL.SetRange("From Date", WorkingHourL."From Date");
                if EmployeeTimingsL.FindFirst() then begin
                    EmployeeTimingsL."First Half Status" := CopyStr(Format(WorkingHourL."Day Type"), 1, MaxStrLen(EmployeeTimingsL."First Half Status"));
                    EmployeeTimingsL."Second Half Status" := CopyStr(Format(WorkingHourL."Day Type"), 1, MaxStrLen(EmployeeTimingsL."second Half Status"));
                    EmployeeTimingsL.Modify();
                end;
            until WorkingHourL.Next() = 0;
        end else begin
            EmployeeTimingsL.SetRange("Employee No.", LeaveRequestL."Employee No.");
            EmployeeTimingsL.SetRange("From Date", LeaveRequestL."End Date" + 1, "Resumption Date");
            if not (AbsenceL."Include Public Holidays" and AbsenceL."Include Weekly Off") then
                EmployeeTimingsL.SetFilter("Week Day", '<>%1&<>%2', 'Public Holiday', 'Week Off')
            else
                if not AbsenceL."Include Public Holidays" then
                    EmployeeTimingsL.SetFilter("Week Day", '<>%1', 'Public Holiday')
                else
                    if not AbsenceL."Include Weekly Off" then
                        EmployeeTimingsL.SetFilter("Week Day", '<>%1', 'Week Off');
            if "Resumption Action" = "Resumption Action"::"Loss of Pay" then begin
                AbsenceL.TestField("Additional Days LOP Code");
                EmployeeTimingsL.ModifyAll("First Half Status", AbsenceL."Additional Days LOP Code");
                EmployeeTimingsL.ModifyAll("Second Half Status", AbsenceL."Additional Days LOP Code");
            end else begin
                EmployeeTimingsL.ModifyAll("First Half Status", LeaveRequestL."Absence Code");
                EmployeeTimingsL.ModifyAll("Second Half Status", LeaveRequestL."Absence Code");
            end;
            // LeaveBalanceL.Get(LeaveRequestL."Employee No.", LeaveRequestL."Absence Code");
            // LOPDaysL := "Resumption Days" - LeaveBalanceL."Leave Balance";
            // if LOPDaysL > 0 then begin
            //     EmployeeTimingsL.FindLast();
            //     EmployeeLevelAbsenceL.SetRange("Employee No.", LeaveRequestL."Employee No.");
            //     EmployeeLevelAbsenceL.SetFilter("From Date", '<=%1', "Resumption Date");
            //     EmployeeLevelAbsenceL.SetRange("Absence Code", LeaveRequestL."Absence Code");
            //     EmployeeLevelAbsenceL.FindFirst();
            //     case EmployeeLevelAbsenceL."Additional Days Action" of
            //         EmployeeLevelAbsenceL."Additional Days Action"::Warning:
            //             ShowWarningMessage('You have exceeded the Leave Limit');
            //         EmployeeLevelAbsenceL."Additional Days Action"::"Loss of Pay":
            //         repeat
            //             EmployeeTimingsL."First Half Status" := AbsenceL."Additional Days LOP Code";
            //             EmployeeTimingsL."Second Half Status" := AbsenceL."Additional Days LOP Code";
            //             EmployeeTimingsL.Modify();
            //             EmployeeTimingsL.Next(-1);
            //             LOPDaysL -= 1;
            //         until LOPDaysL = 0;
            //     end;
            // 
            // end;
        end;
    end;

    local procedure ShowWarningMessage(WarningMessageP: Text)
    var
        NotificationL: Notification;
    begin
        NotificationL.Message(WarningMessageP);
        NotificationL.Scope(NotificationScope::LocalScope);
        NotificationL.Send();
    end;
}
