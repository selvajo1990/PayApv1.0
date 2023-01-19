page 60189 "Employee Directory"
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = Employee;
    SourceTableView = where(Manager = const(true));
    Editable = false;
    //Created by SKR 16-01-2023

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("No."; "No.")
                {
                    ApplicationArea = All;
                    Caption = 'ID';
                }
                field("Search Name"; "Search Name")
                {
                    ApplicationArea = All;
                    Caption = 'Name';
                }
                field("Job Title"; "Job Title")
                {
                    ApplicationArea = All;
                    Caption = 'Designation';
                }
                field(Extension; Extension)
                {
                    ApplicationArea = All;
                    Caption = 'Extension No.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}