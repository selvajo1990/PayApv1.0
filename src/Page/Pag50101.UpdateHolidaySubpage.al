page 50101 "Update Holiday Subpage"
{
    PageType = ListPart;
    SourceTable = "Update Holiday";
    Caption = 'Update Holiday Subpage';
    DeleteAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Calendar ID"; Rec."Calendar ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Calendar ID';
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Date';
                }
                field("Week Day"; Rec."Week Day")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Week Day';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description';
                }
                field("Day Type"; Rec."Day Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Day Type';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Public Holiday")
            {
                Caption = 'Public Holiday';
                Image = UpdateDescription;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = all;
                ToolTip = 'Executes the Public Holiday action.';
                trigger OnAction()
                var
                    EmployeeSelectionListL: Page "Assign Calendar";

                begin
                    Rec.TestField(Date);
                    EmployeeSelectionListL.SetDefaultValue(rec.Date, 0D, Rec."Calendar ID", false, CopyStr(format(Rec."Day Type"), 1, 20));
                    EmployeeSelectionListL.RunModal();
                end;
            }
            action("Show Assigned Employee")
            {
                Caption = 'Show Assigned Employee';
                Image = ShowList;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = all;
                ToolTip = 'Executes the Show Assigned Employee action.';
                trigger OnAction()
                var
                    EmployeeL: Record Employee;
                    EmployeeTimingL: Record "Employee Timing";
                    EmployeeListL: Page "Employee List";
                    FilterL: Text;
                begin
                    EmployeeTimingL.Reset();
                    EmployeeTimingL.SetCurrentKey("Employee No.", "Calendar ID", "From Date");
                    EmployeeL.FindSet();
                    repeat
                        EmployeeTimingL.SetRange("Employee No.", EmployeeL."No.");
                        EmployeeTimingL.SetRange("Calendar ID", Rec."Calendar ID");
                        EmployeeTimingL.SetRange("From Date", Rec.Date);
                        EmployeeTimingL.setrange("First Half Status", Format(Rec."Day Type")); // Avi : to show the records only if holiday updated employees.
                        if not EmployeeTimingL.IsEmpty() then
                            FilterL += EmployeeL."No." + '|';
                    until EmployeeL.Next() = 0;
                    if FilterL > '' then
                        FilterL := CopyStr(FilterL, 1, STRLEN(FilterL) - 1);

                    EmployeeL.Reset();
                    if FilterL > '' then
                        EmployeeL.SetFilter("No.", FilterL)
                    else
                        EmployeeL.SetFilter("No.", '%1', FilterL);
                    EmployeeListL.SetTableView(EmployeeL);
                    EmployeeListL.RunModal();
                end;
            }

        }
    }
}