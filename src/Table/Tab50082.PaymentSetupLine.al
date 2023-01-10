table 50082 "Payment Setup Line"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Earning Code"; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Earning Code';
        }
        field(2; "Reason Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Reason Code';
            TableRelation = "Reason Code";
            trigger OnValidate()
            var
                PaymentSetupLineL: Record "Payment Setup Line";
            begin
                CalcFields(Description);
                "From Days" := 1;
                PaymentSetupLineL.SetCurrentKey("Reason Code", "From Days");
                PaymentSetupLineL.SetRange("Earning Code", "Earning Code");
                PaymentSetupLineL.SetRange("Reason Code", "Reason Code");
                if PaymentSetupLineL.FindLast() then
                    "From Days" := PaymentSetupLineL."To Days" + 1;
            end;
        }
        field(3; "From Days"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'From Days';
            MinValue = 1;
            Editable = false;
            trigger OnValidate()
            var
                PaymentSetupLineL: Record "Payment Setup Line";
            begin
                PaymentSetupLineL.SetCurrentKey("Reason Code", "From Days");
                PaymentSetupLineL.SetRange("Earning Code", "Earning Code");
                PaymentSetupLineL.SetRange("Reason Code", "Reason Code");
                if PaymentSetupLineL.FindLast() and ("From Days" <= PaymentSetupLineL."To Days") then
                    Error(DaysCantBeLesserErr, FieldCaption("From Days"), PaymentSetupLineL."To Days");

            end;
        }
        field(21; "To Days"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'To Days';
            MinValue = 1;
            trigger OnValidate()
            var
                HrSetupL: Record "Human Resources Setup";
                PaymentSetupLineL: Record "Payment Setup Line";
            begin
                if "To Days" <= "From Days" then
                    Error(DaysCantBeLesserErr, FieldCaption("To Days"), "From Days");
                PaymentSetupLineL.SetCurrentKey("Earning Code", "Reason Code", "From Days");
                PaymentSetupLineL.SetRange("Earning Code", "Earning Code");
                PaymentSetupLineL.SetRange("Reason Code", "Reason Code");
                PaymentSetupLineL.SetFilter("To Days", '>=%1', "To Days");
                if not PaymentSetupLineL.IsEmpty() then
                    Error(RecordAlreadyExisyErr);
                HrSetupL.Get();
                HrSetupL.TestField("Gratuity Accrual Days");
                "No. of Years" := ("To Days" - "From Days" + 1) / HrSetupL."Gratuity Accrual Days";
            end;
        }
        field(22; Description; Text[50])
        {
            FieldClass = FlowField;
            Caption = 'Description';
            CalcFormula = lookup("Reason Code".Description where(Code = field("Reason Code")));
        }
        field(23; Days; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'No. of Days';
        }
        field(24; "Cancel Previous"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Cancel Previous';
        }
        field(25; "No. of Years"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'No. of Years';
            Editable = false;
        }
        field(26; "Add Days"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Define No. of Days';
            Editable = false;
        }

    }

    keys
    {
        key(PK; "Earning Code", "Reason Code", "From Days")
        {
            Clustered = true;
        }
    }

    var
        DaysCantBeLesserErr: Label '%1 can''t be lesser than %2';
        RecordAlreadyExisyErr: Label 'Record already exist with greater or lesser than the entered value. So you can''t enter this value.';
        AddDaysTxt: Label 'Add No. of Days';


    trigger OnInsert()
    begin
        "Add Days" := CopyStr(AddDaysTxt, 1, MaxStrLen("Add Days"));
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