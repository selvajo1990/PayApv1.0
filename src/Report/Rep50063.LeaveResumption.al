report 50063 "Leave Resumption"
{
    UsageCategory = None;
    Caption = 'Leave Resumption';
    ProcessingOnly = true;
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(General)
                {
                    field("Leave Request No."; LeaveResumptionG."Leave Request No.")
                    {
                        ApplicationArea = All;
                        Editable = false;
                        ToolTip = 'Specifies the value of the Leave Request No.';
                    }
                    field("Resumption Date"; LeaveResumptionG."Resumption Date")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Resumption Date';
                        trigger OnValidate()
                        begin
                            if LeaveResumptionG."Start Date" > LeaveResumptionG."Resumption Date" then
                                Error(ResumptionDateCantGreaterErr, LeaveResumptionG."Start Date");
                            if LeaveResumptionG."Resumption Date" <= LeaveResumptionG."End Date" then begin
                                LeaveResumptionG."Resumption Type" := LeaveResumptionG."Resumption Type"::"Early Return";
                                CalculateNoOfLeaveDays(LeaveResumptionG."Resumption Date", LeaveResumptionG."End Date");
                            end else begin
                                LeaveResumptionG."Resumption Type" := LeaveResumptionG."Resumption Type"::"Late Return";
                                CalculateNoOfLeaveDays(LeaveResumptionG."End Date" + 1, LeaveResumptionG."Resumption Date");
                            end;
                        end;
                    }
                    field("Resumption Days"; LeaveResumptionG."Resumption Days")
                    {
                        ApplicationArea = All;
                        Editable = false;
                        ToolTip = 'Specifies the value of the Resumption Days';
                    }
                    field("Resumption Type"; LeaveResumptionG."Resumption Type")
                    {
                        ApplicationArea = All;
                        Editable = false;
                        ToolTip = 'Specifies the value of the Resumption Type';
                    }
                }
            }
        }
        trigger OnQueryClosePage(CloseAction: Action): Boolean
        begin
            if CloseAction in [CloseAction::OK, CloseAction::LookupOK] then
                LeaveResumptionG.Insert(true);
        end;

        trigger OnOpenPage()
        begin
            LeaveRequestG.Get(LeaveResumptionG."Leave Request No.");
            LeaveResumptionG."Start Date" := LeaveRequestG."Start Date";
            LeaveResumptionG."End Date" := LeaveRequestG."End Date";
        end;
    }
    var
        LeaveRequestG: Record "Leave Request";
        LeaveResumptionG: Record "Leave Resumption";
        ResumptionDateCantGreaterErr: Label 'Resumption Date can''t be lesser than %1';

    procedure SetParams(LeaveRequestNoP: Code[20])
    begin
        LeaveResumptionG."Leave Request No." := LeaveRequestNoP;
    end;

    local procedure CalculateNoOfLeaveDays(FromDateP: date; ToDateP: Date)
    var
        EmployeeTimingL: Record "Employee Timing";
        AbsenceL: Record Absence;
    begin
        if (FromDateP = 0D) or (ToDateP = 0D) then
            exit;
        AbsenceL.get(LeaveRequestG."Absence Code");
        EmployeeTimingL.SetRange("Employee No.", LeaveRequestG."Employee No.");
        EmployeeTimingL.SetRange("From Date", FromDateP);
        EmployeeTimingL.FindFirst();
        LeaveResumptionG."Resumption Days" := abs(FromDateP - ToDateP) + 1;
        EmployeeTimingL.SetRange("From Date", FromDateP, ToDateP);
        EmployeeTimingL.SetFilter(EmployeeTimingL."First Half Status", '%1', 'Week Off');
        If not EmployeeTimingL.IsEmpty() and (not AbsenceL."Include Weekly Off") then
            LeaveResumptionG."Resumption Days" := LeaveResumptionG."Resumption Days" - EmployeeTimingL.Count();
        EmployeeTimingL.SetFilter(EmployeeTimingL."First Half Status", '%1', 'Public Holiday');
        If not EmployeeTimingL.IsEmpty() and (not AbsenceL."Include Public Holidays") then
            LeaveResumptionG."Resumption Days" := LeaveResumptionG."Resumption Days" - EmployeeTimingL.Count();
    end;

}