table 50067 "Opening Balance"
{
    DataClassification = CustomerContent;
    Caption = 'Opening Balance';
    DrillDownPageId = "Opening Balance";
    LookupPageId = "Opening Balance";

    fields
    {
        field(1; "Entry No"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Entry No.';
            AutoIncrement = true;
            Editable = false;
        }
        field(21; "Employee No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Employee No.';
            TableRelation = Employee."No.";
            trigger OnValidate()
            var
                EmployeeL: Record Employee;
            begin
                CalcFields("Employee Name");
                if EmployeeL.Get("Employee No.") then;
                "Pay Cycle" := EmployeeL."Pay Cycle";
            end;
        }
        field(22; "Pay Period"; Code[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Pay Period';
            TableRelation = "Pay Period Line"."Pay Period" where("Pay Cycle" = field("Pay Cycle"));
        }
        field(23; "Type"; Option)
        {
            OptionMembers = " ",Earning,Absence;
            OptionCaption = ' ,Earning,Absence';
            DataClassification = CustomerContent;
            Caption = 'Type';
            trigger OnValidate()
            begin
                Code := '';
                Value := 0;
                Amount := 0;
            end;
        }
        field(24; "Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Code';
            TableRelation = if (Type = const(Absence)) Absence where(Accrual = filter('Yes'))
            else
            if (Type = const(Earning)) Earning where(Accrual = filter('Yes'));
        }
        field(25; "Employee Name"; Text[50])
        {
            Caption = 'Employee Name';
            FieldClass = FlowField;
            CalcFormula = lookup(Employee."First Name" where("No." = field("Employee No.")));
        }
        field(26; "Value"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Value';
        }
        field(27; "Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Amount';
        }
        field(28; "Comment"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Comment';
        }
        field(29; "Pay Cycle"; Code[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Pay Cycle';
            Description = 'For Developer Use';
            Editable = false;
        }

    }

    keys
    {
        key(PK; "Entry No")
        {
            Clustered = true;
        }
        key(SK; "Pay Period")
        {

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