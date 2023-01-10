table 50098 "Flight Cost"
{
    DataClassification = CustomerContent;
    Caption = 'Flight Cost';
    LookupPageId = "Flight Costs";
    DrillDownPageId = "Flight Costs";

    fields
    {
        field(1; "Flight Destination Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Flight Destination';
            TableRelation = "Flight Destination";
            trigger OnValidate()
            var
                FlightDestination: Record "Flight Destination";
            begin
                if FlightDestination.Get("Flight Destination Code") then;
                "Flight Destination" := FlightDestination.City;
            end;
        }
        field(2; "Class Type"; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Class Type';
            OptionMembers = Economy,First,Business;
            OptionCaption = 'Economy,First,Business';
        }
        field(3; Category; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Category';
            TableRelation = "Age Group";
        }
        field(4; "Start Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Start Date';
            trigger OnValidate()
            var
                FlightCost: Record "Flight Cost";
                DateErr: Label 'Start Date %1 should be earlier than previous %2';
            begin
                "End Date" := 0D;
                if "Start Date" > 0D then begin
                    TestField("Flight Destination Code");
                    TestField(Category);
                    FlightCost.SetRange("Flight Destination Code", "Flight Destination Code");
                    FlightCost.SetRange("Class Type", "Class Type");
                    FlightCost.SetRange(Category, Category);
                    if FlightCost.FindLast() then
                        if (Rec."Start Date" <= FlightCost."Start Date") and (FlightCost."Start Date" > 0D) then
                            Error(StrSubstNo(DateErr, Rec."Start Date", FlightCost."Start Date"))
                        else begin
                            FlightCost."End Date" := "Start Date" - 1;
                            FlightCost.Modify();
                        end;
                end;
            end;
        }
        field(5; "End Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'End Date';
            trigger OnValidate()
            var
                DateErr: Label '%1 can''t be earlier than %2';
            begin
                if "End Date" < "Start Date" then
                    Error(StrSubstNo(DateErr, FieldCaption("End Date"), FieldCaption("Start Date")));
            end;
        }
        field(21; "Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Amount';
        }
        field(22; "Flight Destination"; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Flight Destination';
            Editable = false;
        }
    }

    keys
    {
        key(PK; "Flight Destination Code", "Class Type", Category, "Start Date")
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