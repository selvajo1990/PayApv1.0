page 50070 "Salary Computation Subpage"
{
    PageType = ListPart;
    Caption = 'Salary Computation Subpage';
    SourceTable = "Salary Computation Line";
    SourceTableView = where(Type = filter(<> "Employer Contribution"), "Affects Salary" = filter(true));
    AutoSplitKey = true;
    DelayedInsert = true;

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
                field(Category; Rec.Category)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Category';
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Type';
                }
                field("Pay With Salary"; Rec."Pay With Salary")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Pay With Salary';
                }
                field("Show in Payslip"; Rec."Show in Payslip")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Show in Payslip';
                }
                field("Affects Salary"; Rec."Affects Salary")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Affects Salary';
                }
            }
        }
    }

}