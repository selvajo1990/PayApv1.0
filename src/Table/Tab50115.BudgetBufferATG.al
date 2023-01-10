table 50115 "Budget Buffer ATG"
{
    fields
    {
        field(1; "Line Type"; Option)
        {
            OptionMembers = " ","Earning","Absence","Loans","PASI/GOSI";
            OptionCaption = ' ,Earning,Absence,Loans,PASI/GOSI';
            DataClassification = CustomerContent;
        }
        field(2; Code; Code[20])
        { DataClassification = CustomerContent; }
        field(3; "Category"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = " ","Accruals","Salary","End of Service","Instalment",Encashment,"Travel & Expense";
        }
        field(4; "Dimension Value Code 1"; Code[20])
        { DataClassification = CustomerContent; }
        field(5; "Dimension Value Code 2"; Code[20])
        { DataClassification = CustomerContent; }
        field(6; "Dimension Value Code 3"; Code[20])
        { DataClassification = CustomerContent; }
        field(7; "Dimension Value Code 4"; Code[20])
        { DataClassification = CustomerContent; }
        field(8; "Dimension Value Code 5"; Code[20])
        { DataClassification = CustomerContent; }
        field(9; "Dimension Value Code 6"; Code[20])
        { DataClassification = CustomerContent; }
        field(10; "Dimension Value Code 7"; Code[20])
        { DataClassification = CustomerContent; }
        field(11; "Dimension Value Code 8"; Code[20])
        { DataClassification = CustomerContent; }
        field(12; Date; Date)
        { DataClassification = CustomerContent; }
        field(13; Amount; Decimal)
        { DataClassification = CustomerContent; }
        field(14; "Description"; Text[100])
        { DataClassification = CustomerContent; }
    }
    keys
    {
        key(PK; "Line Type", Code, Category, "Dimension Value Code 1", "Dimension Value Code 2", "Dimension Value Code 3", "Dimension Value Code 4", "Dimension Value Code 5", "Dimension Value Code 6", "Dimension Value Code 7", "Dimension Value Code 8", "Date")
        {
        }
    }
}