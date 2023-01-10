table 50064 "Accrual Setup Line"
{
    DataClassification = CustomerContent;
    Caption = 'Accrual Setup Line';
    fields
    {
        field(1; "Earning Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Earning Code';
        }

        field(2; "From Days"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'From Days';
            MinValue = 1;
            BlankZero = true;
            trigger OnValidate()
            begin
                "To Days" := 0;
                "No. of Years" := 0;
            end;
        }
        field(21; "To Days"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'To Days';
            BlankZero = true;
            trigger OnValidate()
            begin
                HrSetupG.Get();
                HrSetupG.TestField("Gratuity Accrual Days");
                TestField("From Days");
                if "From Days" > "To Days" then
                    Error(FromDayValidateErr, FieldCaption("From Days"), FieldCaption("To Days"));
                "No. of Years" := ("To Days" - "From Days" + 1) / HrSetupG."Gratuity Accrual Days";
            end;
        }

        field(22; "No. Of Days"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'No. Of Days';
            MinValue = 0;
            BlankZero = true;
        }
        field(23; "No. of Years"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'No. of Years';
            Editable = false;
        }

    }

    keys
    {
        key(PK; "Earning Code", "From Days")
        {
            Clustered = true;
        }
        key(SK; "To Days")
        {

        }
    }

    var
        HrSetupG: Record "Human Resources Setup";
        FromDayValidateErr: Label '%1 can''t be greater than %2';

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