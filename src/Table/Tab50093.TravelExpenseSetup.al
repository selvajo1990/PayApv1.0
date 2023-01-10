table 50093 "Travel & Expense Setup"
{
    DataClassification = CustomerContent;
    Caption = 'Travel & Expense Setup';

    fields
    {
        field(1; "Primary Key"; Code[20])
        {
            DataClassification = CustomerContent;

        }
        field(21; "Travel & Expense Advance Nos."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Travel & Expense Advance Nos.';
            TableRelation = "No. Series";
        }
        field(22; "Travel Req. & Exp. Claim Nos."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Travel Requisition & Expense Claim';
            TableRelation = "No. Series";
        }
        field(23; "Travel & Expense Jnl. Template"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Travel & Expense Jnl. Template';
            TableRelation = "Gen. Journal Template";
        }
        field(24; "Travel & Expense Jnl. Batch"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Travel & Expense Jnl. Batch';
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name" = field("Travel & Expense Jnl. Template"));
        }
    }

    keys
    {
        key(PK; "Primary Key")
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