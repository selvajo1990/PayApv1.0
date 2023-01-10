page 50080 "Employer Deduction List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Salary Computation Header";
    Caption = 'Employer Deduction List';
    CardPageId = "Employer Deduction";
    ModifyAllowed = false;
    InsertAllowed = false;
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
                field("Accrual Posting Status"; Rec."Accrual Posting Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Accrual Posting Status';
                }
            }
        }
    }


}