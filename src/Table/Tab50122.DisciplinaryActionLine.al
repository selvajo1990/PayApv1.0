table 50122 "Disciplinary Action Line"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Reason Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Conduct Code';
            TableRelation = "Reason Code";
            trigger OnValidate()
            var
                ConductCodeL: Record "Reason Code";
            begin
                if ConductCodeL.Get("Reason Code") then;
                "Reason Description" := ConductCodeL."Description";
            end;
        }
        field(5; "Reason Description"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Reason Description';
            Editable = false;
        }
        field(2; "Disciplinary Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Disciplinary Code';
        }
        field(10; "Notes"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Notes';
        }
        field(4; "Occurance No."; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = "One","Two","Three","Four","Five","Six","Seven","Eight","Nine","Ten";
            OptionCaption = 'One,Two,Three,Four,Five,Six,Seven,Eight,Nine,Ten';
            Caption = 'Occurance No.';
            Editable = false;

            trigger OnValidate()
            begin

                /* BreachOfConductG.reset();
                 BreachOfConductG.SetRange("Breach Code", "Breach Code");
                 BreachOfConductG.SetRange("Breach Code", "Breach Code");
                 BreachOfConductG.SetRange("Occurance No.", "Occurance No.");
                 if BreachOfConductG.FindFirst() then
                     Error(AlreadyErr);*/
            end;
        }
        field(3; "Line No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(6; "Days"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Days';
        }
        field(7; Percentage; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Percentage';
        }
        field(8; "Computation Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Computation Code';
            TableRelation = "Computation Line Detail";
        }
        field(9; "Warning Letter"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Warning Letter';
        }
    }

    keys
    {
        key(PK; "Reason Code", "Disciplinary Code", "Line No.")
        {
            Clustered = true;
        }
    }
    var

        DisciplinaryActionLineG: record "Disciplinary Action Line";
    //AlreadyErr: Label 'Occurance is already exist';

    trigger OnInsert()
    begin
        IF (Days <> 0) OR (Percentage <> 0) then
            TestField("Computation Code");

        DisciplinaryActionLineG.reset();
        DisciplinaryActionLineG.SetRange("Disciplinary Code", "Disciplinary Code");
        DisciplinaryActionLineG.SetRange("Reason Code", "Reason Code");


        Validate("Occurance No.", DisciplinaryActionLineG.Count());
    end;

    trigger OnModify()
    begin
        IF (Days <> 0) OR (Percentage <> 0) then
            TestField("Computation Code");


    end;
}