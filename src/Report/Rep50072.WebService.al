report 50072 "Web Service"
{
    ProcessingOnly = true;
    UsageCategory = None;
    dataset
    {
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    field("Approval Code"; ApprovalCode)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the ApprovalCode';

                    }
                    field("Approval Entry No"; EntryNo)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the EntryNo';
                    }
                    field("Leave Request No"; LeaveRequest)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the LeaveRequest';
                    }
                    field("Employee No"; EmployeeNoG)
                    {
                        ApplicationArea = all;
                        ToolTip = 'Specifies the value of the EmployeeNoG';
                    }
                }
            }
        }

        trigger OnQueryClosePage(CloseAction: Action): Boolean
        var
            EmployeeLeaveRequestP: XmlPort "Employee Leave Request";
        begin
            HRMSManagement.ApplyLeave('VX004', 'SL', Today(), Today(), 0, 0, 'ReasonP: Text[250]; var', EmployeeLeaveRequestP);
        end;
    }

    var
        HRMSManagement: Codeunit "HRMS Web Management";
        ApprovalCode: Integer;
        EntryNo: Integer;
        LeaveRequest: Code[20];
        EmployeeNoG: Code[20];
}