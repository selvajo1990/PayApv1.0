page 60190 "Employee Loan Request"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Loan Request";
    //Created by SKR 17-01-2023
    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field("Loan Request No."; "Loan Request No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Loan Request No.';
                }
                field("Employee No."; "Employee No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Employee No.';
                }
                field("Employee Name"; "Employee Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Employee Name';
                }
                field("Loan Type"; "Loan Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Loan Type';
                }
                field("Loan Description"; "Loan Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Loan Description';
                }
                field(Amount; Amount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of Loan Amout';
                }
                field(Status; Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Status of the Loan Request';
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