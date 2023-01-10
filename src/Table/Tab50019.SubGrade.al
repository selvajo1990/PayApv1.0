table 50019 "Sub Grade"
{
    DataClassification = CustomerContent;
    Caption = 'Sub Grade';
    LookupPageId = "Sub Grades";
    fields
    {
        field(1; Grade; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Grade';
            TableRelation = Grade;
        }
        field(2; "Sub Grade"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Sub Grade';
        }
        field(3; "Sub Grade Description"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Sub Grade Description';
        }
        field(4; "Earning Group"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Earning Group';
            TableRelation = "Earning Group";
        }
        field(5; "Absence Group"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Absence Group';
            TableRelation = "Absence Group";
        }
        field(6; "Loan & Advance Group"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Loan & Advance Group';
            TableRelation = "Loan Group";
        }
        field(8; "Calendar"; Code[20]) // check this field
        {
            DataClassification = CustomerContent;
            Caption = 'Calendar';
        }
        field(9; "Pay Cycle"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Pay Cycle';
            TableRelation = "Pay Cycle";
            trigger OnValidate()
            var
                SubGradeL: Record "Sub Grade";
            begin
                SubGradeL.SetRange("Salary Class", "Salary Class");
                SubGradeL.SetFilter("Sub Grade", '<>%1', "Sub Grade");
                if SubGradeL.FindFirst() and ("Pay Cycle" <> SubGradeL."Pay Cycle") then
                    Error(SameSalaryClassErr, TableCaption(), FieldCaption("Salary Class"), FieldCaption("Pay Cycle"));
            end;
        }
        field(10; "Air Ticket Group"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Air Ticket Group';
            TableRelation = "Air Ticket Group";
        }
        field(12; "Salary Class"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Salary Class';
            TableRelation = "Salary Class";
            // trigger OnValidate()
            // var
            //     SubLevelL: Record "Sub Level";
            // begin
            //     SubLevelL.SetRange("Salary Class", "Salary Class");
            //     if SubLevelL.FindFirst() then
            //         Error(SameSalaryClassErr, FieldCaption("Salary Class"), TableCaption());
            // end;
        }
    }

    keys
    {
        key(PK; Grade, "Sub Grade")
        {
            Clustered = true;
        }
        key(SK; "Salary Class")
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

    var
        SameSalaryClassErr: Label '%1 with same %2 must have same %3';

}