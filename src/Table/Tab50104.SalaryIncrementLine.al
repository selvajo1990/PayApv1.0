table 50104 "Salary Increment Line"
{
    DataClassification = CustomerContent;
    Caption = 'Salary Increment Line';
    fields
    {
        field(1; "Document No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Document No.';
        }
        field(2; "Line No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Line No.';
        }
        field(3; "Employee No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Employee No.';
            TableRelation = Employee;
            trigger OnValidate()
            var
                Employee: Record Employee;

            begin
                Rec.Init();
                Rec."Earning Code" := '';
                CalcFields("Employee Name");
                if Employee.Get("Employee No.") then;
                "Earning Group Code" := Employee."Earning Group";
            end;
        }
        field(4; "Earning Group Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Earning Group Code';
            Editable = false;
            TableRelation = "Earning Group";
        }
        field(5; "Earning Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Earning Code';
            TableRelation = Earning;
            trigger OnLookup()
            var
                EarningGroupLine: Record "Earning Group Line";
                EmployeeEarning: Record "Employee Level Earning";
                EarningGroupList: Page "Earning Group Line";
            begin
                "Current Amount" := 0;
                "Payment Type" := "Payment Type"::" ";

                Clear(EarningGroupList);
                EarningGroupLine.SetRange("Group Code", "Earning Group Code");
                EarningGroupList.SetTableView(EarningGroupLine);
                EarningGroupList.SetRecord(EarningGroupLine);
                EarningGroupList.LookupMode(true);
                if EarningGroupList.RunModal() = Action::LookupOK then begin
                    EarningGroupList.GetRecord(EarningGroupLine);

                    EmployeeEarning.SetRange("Employee No.", "Employee No.");
                    EmployeeEarning.SetRange("Group Code", EarningGroupLine."Group Code");
                    EmployeeEarning.SetRange("Earning Code", EarningGroupLine."Earning Code");
                    EmployeeEarning.FindLast();
                    "Current Amount" := EmployeeEarning."Pay Amount";
                    "Earning Code" := EarningGroupLine."Earning Code";
                    case true of
                        EmployeeEarning."Payment Type" = EmployeeEarning."Payment Type"::Amount:
                            Validate("Payment Type", Rec."Payment Type"::Amount);
                        EmployeeEarning."Payment Type" = EmployeeEarning."Payment Type"::Percentage:
                            Validate("Payment Type", Rec."Payment Type"::Percentage);
                    end;
                end;
            end;
        }
        field(21; "Employee Name"; Text[50])
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Employee."First Name" where("No." = field("Employee No.")));
            Editable = false;
            Caption = 'Employee Name';
        }
        field(22; "Current Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Current Amount';
            Editable = false;
        }
        field(23; "Payment Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = " ",Amount,Percentage;
            OptionCaption = ' ,Amount,Percentage';
            Caption = 'Payment Type';
            Editable = false;
            trigger OnValidate()
            begin
                "New Amount" := 0;
            end;
        }
        field(24; "New Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'New Amount';
            Editable = false;
        }
        field(25; Value; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Value';
            MinValue = 0;
            trigger OnValidate()
            var
                HrSetup: Record "Human Resources Setup";
            begin
                HrSetup.Get();
                case true of
                    "Payment Type" = Rec."Payment Type"::Amount:
                        "New Amount" := "Current Amount" + Value;
                    "Payment Type" = Rec."Payment Type"::Percentage:
                        "New Amount" := Round(("Current Amount" / 100 * Value), HrSetup."HR Rounding Precision", HrSetup.RoundingDirection()) + "Current Amount";
                end;
            end;
        }
    }

    keys
    {
        key(PK; "Document No.", "Employee No.", "Earning Group Code", "Earning Code", "Line No.")
        {
            Clustered = true;
        }
    }
    var
        SalaryIncrementHdr: Record "Salary Increment Header";


    trigger OnInsert()
    begin
        CheckStatus();
    end;

    trigger OnModify()
    begin
        CheckStatus();
    end;

    trigger OnDelete()
    begin
        CheckStatus();
    end;

    trigger OnRename()
    begin
        CheckStatus();
    end;

    procedure CheckStatus()
    begin
        SalaryIncrementHdr.Get("Document No.");
        SalaryIncrementHdr.TestField(Status, SalaryIncrementHdr.Status::Open);
    end;
}