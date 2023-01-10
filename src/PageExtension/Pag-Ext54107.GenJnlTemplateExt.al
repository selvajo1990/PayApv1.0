pageextension 54107 "GenJnlTemplateExt" extends "General Journal Templates"
{
    layout
    {
        // Add changes to page layout here
        addafter(Recurring)
        {
            field("Payroll Template"; Rec."Payroll Template")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Payroll Template';
            }
        }
    }

}