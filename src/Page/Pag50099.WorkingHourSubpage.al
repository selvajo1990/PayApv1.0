page 50099 "Working Hour Subpage"
{
    PageType = ListPart;
    SourceTable = "Working Hour";
    Caption = 'Working Hour Subpage';
    DeleteAllowed = false;
    InsertAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
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
                field("Day Type"; Rec."Day Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Day Type';
                }
                field("Start Time"; Rec."Start Time")
                {
                    ApplicationArea = All;
                    Editable = Rec."Day Type" = Rec."Day Type"::"Working Day";
                    ToolTip = 'Specifies the value of the Start Time';
                }
                field("End Time"; Rec."End Time")
                {
                    ApplicationArea = All;
                    Editable = Rec."Day Type" = Rec."Day Type"::"Working Day";
                    ToolTip = 'Specifies the value of the End Time';
                }
                field("First Half Hours"; Rec."First Half Hours")
                {
                    ApplicationArea = All;
                    Editable = Rec."Day Type" = Rec."Day Type"::"Working Day";
                    ToolTip = 'Specifies the value of the First Half Hours';

                }
                field("Second Half Hours"; Rec."Second Half Hours")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Second Half Hours';
                }
                field("To Date"; Rec."To Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the To Date';
                }
                field("Break 1 - Start Time"; Rec."Break 1 - Start Time")
                {
                    ApplicationArea = All;
                    Editable = Rec."Day Type" = Rec."Day Type"::"Working Day";
                    ToolTip = 'Specifies the value of the Break 1 - Start Time';
                }
                field("Break 1 - End Time"; Rec."Break 1 - End Time")
                {
                    ApplicationArea = All;
                    Editable = Rec."Day Type" = Rec."Day Type"::"Working Day";
                    ToolTip = 'Specifies the value of the Break 1 - End Time';
                }
                field("Break 2 - Start Time"; Rec."Break 2 - Start Time")
                {
                    ApplicationArea = All;
                    Editable = Rec."Day Type" = Rec."Day Type"::"Working Day";
                    ToolTip = 'Specifies the value of the Break 2 - Start Time';
                }
                field("Break 2 - End Time"; Rec."Break 2 - End Time")
                {
                    ApplicationArea = All;
                    Editable = Rec."Day Type" = Rec."Day Type"::"Working Day";
                    ToolTip = 'Specifies the value of the Break 2 - End Time';
                }
                field("Break 3 - Start Time"; Rec."Break 3 - Start Time")
                {
                    ApplicationArea = All;
                    Editable = Rec."Day Type" = Rec."Day Type"::"Working Day";
                    ToolTip = 'Specifies the value of the Break 3 - Start Time';
                }
                field("Break 3 - End Time"; Rec."Break 3 - End Time")
                {
                    ApplicationArea = All;
                    Editable = Rec."Day Type" = Rec."Day Type"::"Working Day";
                    ToolTip = 'Specifies the value of the Break 3 - End Time';
                }
                field("Total Hours"; Rec."Total Hours")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Total Hours';
                }
            }

        }

    }
    actions
    {
        area(Processing)
        {
            action("Generate Calendar")
            {
                Caption = 'Generate Calendar';
                Image = AddWatch;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = all;
                ToolTip = 'Executes the Generate Calendar action.';
                trigger OnAction()
                var
                    WorkingHourL: Record "Working Hour";
                begin
                    WorkingHourL.SetRange("Calendar ID", Rec."Calendar ID");
                    if WorkingHourL.IsEmpty() then
                        Error(WorkingHourMissingErr, WorkingHourL.TableCaption());
                    Rec.GenerateCalendar();
                    CurrPage.Editable(false);
                end;
            }
            action("Assign Calendar")
            {
                Caption = 'Assign Calendar';
                Image = AddContacts;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = all;
                ToolTip = 'Executes the Assign Calendar action.';
                trigger OnAction()
                var
                    WorkingHourL: Record "Working Hour";
                    EmployeeSelectionListL: Page "Assign Calendar";
                    StartDateL: Date;
                    IncompleteTemplateErr: Label 'Calendar to be generated before assigning to employee';
                begin
                    WorkingHourL.SetRange("Calendar ID", Rec."Calendar ID");
                    if WorkingHourL.Count() <= 7 then
                        Error(IncompleteTemplateErr);
                    WorkingHourL.FindFirst();
                    StartDateL := WorkingHourL."From Date";
                    WorkingHourL.FindLast();
                    EmployeeSelectionListL.SetDefaultValue(StartDateL, WorkingHourL."To Date", Rec."Calendar ID", true, '');
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
                    EmployeeTimingL.SetCurrentKey("Employee No.", "Calendar ID");
                    EmployeeL.FindSet();
                    repeat
                        EmployeeTimingL.SetRange("Employee No.", EmployeeL."No.");
                        EmployeeTimingL.SetRange("Calendar ID", Rec."Calendar ID");
                        if not EmployeeTimingL.IsEmpty() then
                            FilterL += EmployeeL."No." + '|';
                    until EmployeeL.Next() = 0;
                    if FilterL > '' then
                        FilterL := CopyStr(FilterL, 1, STRLEN(FilterL) - 1);

                    EmployeeL.Reset();
                    if FilterL > '' then
                        EmployeeL.SetFilter("No.", FilterL)
                    else
                        EmployeeL.SetRange("No.", '');
                    EmployeeListL.SetTableView(EmployeeL);
                    EmployeeListL.RunModal();
                end;
            }
            /*  action("Clear Calendar")
             {
                 Image = Delete;
                 Promoted = true;
                 PromotedCategory = Process;
                 PromotedIsBig = true;
                 PromotedOnly = true;
                 trigger OnAction()
                 var
                     WorkingHourL: Record "Working Hour";
                 begin
                     WorkingHourL.SetRange("Calendar ID", "Calendar ID");
                     if Confirm('Hey it will delete', true) then
                         WorkingHourL.DeleteAll();
                 end;
             } */
        }
    }
    trigger OnModifyRecord(): Boolean
    begin
        WorkingHourG.SetRange("Calendar ID", Rec."Calendar ID");
        if WorkingHourG.Count() > 7 then
            Error(WorkingHourModifyErr);
    end;

    var
        WorkingHourG: Record "Working Hour";
        WorkingHourMissingErr: Label '%1 must have template';
        WorkingHourModifyErr: Label 'You are not allowed to modify';


}
