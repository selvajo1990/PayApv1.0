page 50082 "Employer Deduction Subpage"
{
    PageType = ListPart;
    SourceTable = "Salary Computation Line";
    Editable = false;
    InsertAllowed = false;
    DeleteAllowed = false;
    Caption = 'Employer Deduction Subpage';
    SourceTableView = where(Type = filter("Employer Contribution" | " "), Category = filter(Deduction | Absence | Earning));
    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Employee No."; Rec."Employee No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Employee No.';
                }

                field("Employee Name"; Rec."Employee Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Employee Name';
                }
                field("Salary Class"; Rec."Salary Class")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Salary Class';
                }
                field("Line Type"; Rec."Line Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Line Type';
                }
                field("Earning Group"; Rec."Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Code';
                }
                field("Posting Category"; Rec."Posting Category")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Posting Category';
                }
                field("Pay Period"; Rec."Pay Period")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Pay Period';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Amount';
                }
                field("Total Amount"; Rec."Total Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Total Amount';
                }
                field("Accrual Value"; Rec."Accrual Value")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Accrual Value';
                }
                field("Total Accrual Value"; Rec."Total Accrual Value")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Total Accrual Value';
                }
            }
        }
    }

}