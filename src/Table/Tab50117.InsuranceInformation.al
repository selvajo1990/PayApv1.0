table 50117 "Insurance Information"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "No."; Integer)
        {
            DataClassification = CustomerContent;
            AutoIncrement = true;
        }
        field(2; "Level in Insurance Code"; Code[30])
        {
            TableRelation = "Insurance Levels";
            Caption = 'Insurance Levels';

            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                "Insurance Levels".Get("Level in Insurance Code");

                "Level in Insurance Description" := "Insurance Levels".Description;
            end;

        }
        field(3; "Type of Insurance Code"; Code[30])
        {

            TableRelation = "Types Of Insurance";
            DataClassification = CustomerContent;
            Caption = 'Insurance Types';



            trigger OnValidate()
            begin
                if "Types Of Insurance".Get("Type of Insurance Code") then;
                "Type of Insurance Description" := "Types Of Insurance".Description;
            end;

        }
        field(4; "From Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(5; "To Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(6; "Insurance Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                TestField("Type of Insurance Code");
                TestField("Level in Insurance Code");
                TestField("From Date");
                TestField("To Date");
                InsuranceInformation.Reset();
                InsuranceInformation.SetRange("Type of Insurance Code", "Type of Insurance Code");
                InsuranceInformation.SetRange("Level in Insurance Code", "Level in Insurance Code");
                if InsuranceInformation.FindSet() then
                    repeat
                        if (("From Date" > InsuranceInformation."From Date") and ("From Date" < InsuranceInformation."To Date")) or (("From Date" > InsuranceInformation."From Date") and ("From Date" < InsuranceInformation."To Date")) then
                            if InsuranceInformation."Insurance Amount" = "Insurance Amount" then
                                Error('Record already exist');
                    UNTIL InsuranceInformation.NEXT() = 0;


            end;

        }
        field(7; "Company Name"; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(8; "Policy Number"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(9; "Contact Person"; Text[30])
        {
            DataClassification = CustomerContent;
        }
        field(10; "E-Mail ID"; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(11; Address; text[100])
        {
            DataClassification = CustomerContent;
        }
        field(12; "Contact Number"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(13; "Type of Insurance Description"; Text[30])
        {
            DataClassification = CustomerContent;
        }
        field(14; "Level in Insurance Description"; Text[30])
        {
            DataClassification = CustomerContent;
        }


    }

    keys
    {
        key(PK; "Level in Insurance code", "Type of Insurance Code", "From Date", "To Date", "Insurance Amount")
        {
            Clustered = true;
        }


    }

    var
        EmployeeInfomation: record "Employee Information";
        "Insurance Levels": record "Insurance Levels";
        "Types Of Insurance": record "Types Of Insurance";
        InsuranceInformation: record "Insurance Information";


    trigger OnInsert()
    begin
        TestField("Type of Insurance Code");
    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin
        EmployeeInfomation.reset();
        EmployeeInfomation.setrange("Document No.", "No.");
        EmployeeInfomation.DeleteAll();
    end;

    trigger OnRename()
    begin

    end;

}