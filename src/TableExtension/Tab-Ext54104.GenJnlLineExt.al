tableextension 54104 "GenJnlLineExt" extends "Gen. Journal Line"
{
    fields
    {
        // Add changes to table fields here
        field(54101; "Sal. Computation No."; code[20])
        {
            DataClassification = CustomerContent;
            Editable = false;

        }
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