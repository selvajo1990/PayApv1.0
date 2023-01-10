page 60158 "Salary Increment Subpage"
{

    PageType = ListPart;
    SourceTable = "Salary Increment Line";
    Caption = 'Salary Increment Subpage';
    AutoSplitKey = true;
    DelayedInsert = true;

    layout
    {
        area(content)
        {
            repeater(General)
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
                field("Earning Group Code"; Rec."Earning Group Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Earning Group Code';
                }
                field("Earning Code"; Rec."Earning Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Earning Code';
                }
                field("Payment Type"; Rec."Payment Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Payment Type';
                }
                field(Value; Rec.Value)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Value';
                }
                field("Current Amount"; Rec."Current Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Current Amount';
                }
                field("New Amount"; Rec."New Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the New Amount';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Employee Earning Histroy")
            {
                Caption = 'Employee Earning Histroy';
                ApplicationArea = All;
                Image = History;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Promoted = true;
                ShortcutKey = 'ctrl + H';
                RunObject = page "Employee Group History";
                RunPageLink = "Employee No." = field("Employee No."), "Component Type" = filter(Earning);
                ToolTip = 'Executes the Employee Earning Histroy action.';
            }
        }
    }

}
