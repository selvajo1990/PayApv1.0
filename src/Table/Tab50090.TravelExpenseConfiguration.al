table 50090 "Travel & Expense Configuration"
{
    DataClassification = CustomerContent;
    Caption = 'Travel & Expense Configuration';
    LookupPageId = 60022;
    DrillDownPageId = 60022;
    fields
    {
        field(1; Code; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Code';
        }
        field(21; "Destination Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Destination Code';
            TableRelation = Destination;
            trigger OnValidate()
            var
                Destination: Record Destination;
            begin
                TestField("Travel & Expense Group Code");
                if Destination.Get("Destination Code") then;
                Rec.Destination := Destination.City;
                "Destination Type Description" := Destination."Destination Type Description";
            end;
        }
        field(22; "Destination"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Destination';
        }
        field(23; "Destination Type Description"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Destination Type Description';
        }
        field(24; "Expense Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Expense Code';
            TableRelation = "Expense Category" where("Travel Type" = filter(Claim));
            trigger OnValidate()
            var
                Expense: Record "Expense Category";
            begin
                TestField("Destination Code");
                if Expense.Get("Expense Code") then;
                "Expense Description" := Expense.Description;
                "Travel Payment Type" := Expense."Travel Payment Type";
                "Attachment Required" := Expense."Attachment Required";
                CheckCombination();
            end;
        }
        field(25; "Expense Description"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Expense Description';
        }
        field(26; "Travel Payment Type"; Option)
        {
            OptionMembers = "Per Day","Hourly","Fixed Amount","Actuals/ As per Bill","Per Kilometer";
            OptionCaption = 'Per Day,Hourly,Fixed Amount,Actuals/ As per Bill,Per Kilometer';
            DataClassification = CustomerContent;
            Caption = 'Travel Payment Type';
        }
        field(27; "Max Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Value';
        }
        field(28; Currency; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Currency';
            TableRelation = Currency;
        }
        field(29; "Attachment Required"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Attachment Required';
        }
        field(30; "Travel & Expense Group Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Travel & Expense Group Code';
            TableRelation = "Travel & Expense Group";
        }
    }

    keys
    {
        key(PK; Code)
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; Code, "Expense Description", "Travel Payment Type", Destination, "Destination Type Description")
        {

        }
        fieldgroup(Brick; Code, "Expense Description", "Travel Payment Type", Destination, "Destination Type Description")
        {

        }
    }
    local procedure CheckCombination()
    var
        TravelExpenseConfig: Record "Travel & Expense Configuration";
    begin
        TravelExpenseConfig.SetRange("Travel & Expense Group Code", Rec."Travel & Expense Group Code");
        TravelExpenseConfig.SetRange("Destination Code", Rec."Destination Code");
        TravelExpenseConfig.SetRange("Expense Code", Rec."Expense Code");
        if not TravelExpenseConfig.IsEmpty() then
            Error(StrSubstNo(CombinationErr, "Travel & Expense Group Code", "Destination Code", "Expense Code"));
    end;

    var
        CombinationErr: Label 'Combination %1, %2, %3 is already in use';

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