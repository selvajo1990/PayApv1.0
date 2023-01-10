table 50081 "Payroll Posting Group"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; Type; Option)
        {
            OptionMembers = " ","Earning","Absence","Loans","PASI/GOSI";
            OptionCaption = ' ,Earning,Absence,Loans,PASI/GOSI';
            DataClassification = CustomerContent;
        }
        field(2; "Earning Code"; code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = if (Type = const(Absence)) Absence
            else
            if (Type = const(Earning)) Earning else
            if (Type = const(Loans)) Loan;
            //if (type = const("PASI/GOSI")) "Pension Category";
            Caption = 'Code';
            trigger OnValidate()
            var
                EarCodeL: Record Earning;
                AbsenceL: Record Absence;
                LoansL: Record Loan;
            //asiL: record "Pension Category";
            begin
                Case Type of
                    Type::Earning:
                        if EarCodeL.Get("Earning Code") then
                            Description := EarCodeL.Description;
                    Type::Absence:
                        if AbsenceL.Get("Earning Code") then
                            Description := AbsenceL.Description;
                    Type::Loans:
                        if LoansL.Get("Earning Code") then
                            Description := LoansL."Loan Description";
                /*type::"PASI/GOSI":
                    if PasiL.Get("Earning Code") then
                        Description := PasiL.Description;*/
                end;
            end;
        }
        field(3; "Category"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = " ","Accruals","Salary","End of Service","Instalment","Encashment";
        }
        field(21; "Description"; Text[30])
        {
            DataClassification = CustomerContent;
        }
        field(22; "Credit Account"; code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "G/L Account";
        }
        field(23; "Debit Account"; code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "G/L Account";
        }
    }

    keys
    {
        key(primarykey; Type, "Earning Code", Category)
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}