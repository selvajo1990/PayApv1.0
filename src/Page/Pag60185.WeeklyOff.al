page 60185 "Weekly Off"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Weekly Off";
    SourceTableView = where(Updated = filter(false));
    DelayedInsert = true;
    Caption = 'Update Week Off';

    layout
    {
        area(Content)
        {
            repeater("Weekly Off Lists")
            {
                field("Employee No."; rec."Employee No.")
                {
                    ApplicationArea = All;
                    Caption = 'Employee No.';
                    TableRelation = Employee;

                }
                field("Employee Name"; rec."Employee Name")
                {
                    ApplicationArea = all;
                    Caption = 'Employee Name';
                    Editable = true;

                }
                field("Week off Date"; rec."Week off Date")
                {
                    ApplicationArea = all;
                    Caption = 'Week Off Date';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Export to Excel")
            {
                ApplicationArea = all;
                RunObject = xmlport "Export Week Off";
                Image = Export;
            }
            action("Import From Excel")
            {
                ApplicationArea = all;
                RunObject = xmlport "Import Week Off";
                Image = Import;

                trigger OnAction()
                begin
                    CurrPage.Update();
                end;
            }
            action("Update WeekOff")
            {
                ApplicationArea = All;
                Image = UpdateShipment;


                trigger OnAction()
                begin
                    if Confirm('Do you want to update Week Off ?', true) then begin
                        recEmployeeWeekOff.Reset();
                        recEmployeeWeekOff.SetRange(Updated, false);
                        if recEmployeeWeekOff.FindSet() then
                            repeat
                                recEmployeeTiming.Reset();
                                recEmployeeTiming.SetRange("Employee No.", recEmployeeWeekOff."Employee No.");
                                recEmployeeTiming.SetRange("From Date", recEmployeeWeekOff."Week off Date");
                                if recEmployeeTiming.FindSet() then
                                    repeat
                                        recEmployeeTiming."First Half Status" := 'Week Off';
                                        recEmployeeTiming."First Half Duration" := '';
                                        recEmployeeTiming."Second Half Status" := '';
                                        recEmployeeTiming."Second Half Duration" := '';
                                        recEmployeeTiming."Break 1 Duration" := '';
                                        recEmployeeTiming."Break 2 Duration" := '';
                                        recEmployeeTiming."Break 3 Duration" := '';
                                        recEmployeeTiming."Total Hours" := 0;
                                        recEmployeeTiming."Actal Hours Worked" := 0;
                                        recEmployeeTiming."Actual In-Time" := 0T;
                                        recEmployeeTiming."Actual Out-Time" := 0T;
                                        recEmployeeTiming.Modify();
                                    until recEmployeeTiming.Next() = 0;
                                recEmployeeWeekOff.Updated := true;
                                recEmployeeWeekOff.Modify()
                            until recEmployeeWeekOff.Next() = 0;
                        Message('Updated');
                    end;
                end;
            }
        }
    }

    trigger OnClosePage()
    begin

    end;

    var
        recEmployeeTiming: Record "Employee Timing";
        recEmployeeWeekOff: Record "Weekly Off";
}