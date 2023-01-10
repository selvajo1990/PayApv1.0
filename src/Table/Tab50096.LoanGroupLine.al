table 50096 "Loan Group Line"
{
    DataClassification = CustomerContent;
    Caption = 'Loan Group Line';

    fields
    {
        field(1; "Loan Group Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Loan Group Code';
        }
        field(2; "Loan Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Loan Code';
            TableRelation = Loan;
            trigger OnValidate()
            var
                Loan: Record Loan;
            begin
                if Loan.Get("Loan Code") then;
                Rec.TransferFields(Loan, false);
            end;
        }
        field(21; "Loan Description"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Loan Description';
        }
        field(22; "Computation Basis"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = " ","Amount","Percentage";
            OptionCaption = ' ,Amount,Percentage';
            Caption = 'Computation Basis';
        }
        field(23; "Earning Code"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Earning;
            Caption = 'Earning Code';
        }
        field(24; Percentage; Decimal)
        {
            DataClassification = CustomerContent;
            MinValue = 0;
            Caption = 'Percentage';
        }
        field(25; Amount; Decimal)
        {
            DataClassification = CustomerContent;
            MinValue = 0;
            Caption = 'Amount';
        }
        field(26; "Minimum Tenure"; Decimal)
        {
            DataClassification = CustomerContent;
            MinValue = 0;
            Caption = 'Minimum Tenure';
        }
        field(27; "No. of Instalment"; Integer)
        {
            DataClassification = CustomerContent;
            MinValue = 0;
            Caption = 'No. of Instalment';
        }
        field(28; "Allow in Notice Period"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Allow in Notice Period';
        }
        field(29; "Allow Multiple Loan"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Allow Multiple Loan';
        }
        field(30; "Allow Multiple Time"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Allow Multiple Time';
        }
        field(31; "Minimum Days Between Request"; DateFormula)
        {
            DataClassification = CustomerContent;
            Caption = 'Minimum Days Between Request';
        }
        field(32; "End of Service"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'End of Service';
        }
        field(33; "Include in Salary"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Include in Salary';
        }
        field(34; "Minimum Tenure Formula"; DateFormula)
        {
            DataClassification = CustomerContent;
            Caption = 'Minimum Tenure Formula';
            trigger OnValidate()
            begin
                if StrPos(Format("Minimum Tenure Formula"), 'D') = 0 then
                    Error('Minimum Tenure must be in Days');
            end;
        }
    }

    keys
    {
        key(PK; "Loan Group Code", "Loan Code")
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