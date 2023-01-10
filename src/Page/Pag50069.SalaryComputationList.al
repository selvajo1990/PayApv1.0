page 50069 "Salary Computation List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Salary Computation Header";
    Caption = 'Salary Computation Display List';
    CardPageId = "Salary Computation Dispaly";
    DeleteAllowed = true;
    InsertAllowed = false;
    ModifyAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Computation No."; Rec."Computation No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Computation No.';
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
                field("No. of Employee"; Rec."No. of Employee")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. of Employee';
                }
                field("Created DateTime"; Rec."Created DateTime")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Created DateTime';
                }
                field("Pay Period"; Rec."Pay Period")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Pay Period';
                }
                field("Total Net Pay"; Rec."Total Net Pay")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Total Net Pay';
                }

            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Create Journal Lines")
            {
                ApplicationArea = All;
                Image = Calculate;
                Caption = 'Create Journal Entries';
                ToolTip = 'Executes the Create Journal Entries action.';

                trigger OnAction();
                var
                    SalCompL: Record "Salary Computation Header";
                    RepPayCalc: Report "Payroll Jnl. Calculate";
                begin
                    Rec.TestField(Status, Rec.Status::Open);
                    SalCompL.Reset();
                    SalCompL.SetRange("Computation No.", Rec."Computation No.");
                    clear(RepPayCalc);
                    RepPayCalc.SetParameters(1);
                    RepPayCalc.SetTableView(SalCompL);
                    RepPayCalc.Run();
                    CurrPage.Update();
                end;
            }

        }
    }
}