tableextension 54106 "GLEntryExt" extends "G/L Entry"
{
    fields
    {
        field(54102; "Pay Period"; code[20])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(54103; "Payroll Jnl. Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = " ","Salary","Accrual","EOS";
            OptionCaption = ' ,Salary,Accrual,EOS';
            Caption = 'Payroll Jnl. Type';
            Editable = false;
        }


    }
}

