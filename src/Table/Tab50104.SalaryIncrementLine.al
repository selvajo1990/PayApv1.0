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
            //Editable = false;
            TableRelation = "Earning Group";

            trigger OnValidate()
            var
                SalaryIncHeader: Record "Salary Increment Header";
                recSalaryIncLine: Record "Salary Increment Line";
            begin
                // Suganya-m added
                IF SalaryIncHeader.Get("Document No.") then
                    Validate("Employee No.", SalaryIncHeader."Employee No.");

                recSalaryIncLine.Reset();
                recSalaryIncLine.SetCurrentKey("Document No.", "Employee No.", "Line No.");
                recSalaryIncLine.SetRange("Document No.", "Document No.");
                if recSalaryIncLine.FindLast() then
                    "Line No." := recSalaryIncLine."Line No." + 10000;
                // Suganya-m added
            end;
        }
        field(5; "Earning Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Earning Code';
            // TableRelation = Earning;
            TableRelation = "Earning Group Line" where("Group Code" = field("Earning Group Code"));

            trigger OnLookup()
            var
                EarningGroupLine: Record "Earning Group Line";
                EmployeeEarning: Record "Employee Level Earning";
                EarningGroupList: Page "Earning Group Line";
                EarningDetails: Record Earning;
                recSalaryIncLine: Record "Salary Increment Line";
                SameEarningCodeErr: Label 'You cannot select the same %1 again';
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

                    // added and commented a new code by suganya-m
                    EarningGroupLine.Reset();
                    EarningGroupLine.SetRange("Group Code", Rec."Earning Group Code");
                    if EarningGroupLine.Find() then begin
                        Rec."Earning Code" := EarningGroupLine."Earning Code";
                        Rec."Payment Type" := EarningGroupLine."Payment Type";
                        if rec."Payment Type" = rec."Payment Type"::Amount then begin
                            rec.Value := EarningGroupLine."Pay Amount";
                            rec."Current Amount" := EarningGroupLine."Pay Amount";
                        end;

                        if Rec."Payment Type" = Rec."Payment Type"::Percentage then
                            Rec."Value Percentage" := EarningGroupLine."Pay Percentage";
                    end;
                    // added and commented a new code by suganya-m

                    /* EmployeeEarning.SetRange("Employee No.", "Employee No.");
                     EmployeeEarning.SetRange("Group Code", EarningGroupLine."Group Code");
                     EmployeeEarning.SetRange("Earning Code", EarningGroupLine."Earning Code");
                     EmployeeEarning.FindLast();
                     "Current Amount" := EmployeeEarning."Pay Amount";
                     "Earning Code" := EarningGroupLine."Earning Code";
                     "Base Code" := EarningGroupLine."Base Code"; // added by suganya-m
                     case true of
                         EmployeeEarning."Payment Type" = EmployeeEarning."Payment Type"::Amount:
                             Validate("Payment Type", Rec."Payment Type"::Amount);
                         EmployeeEarning."Payment Type" = EmployeeEarning."Payment Type"::Percentage:
                             Validate("Payment Type", Rec."Payment Type"::Percentage);
                     end;*/
                end;

                //Validate("Earning Code"); // added by suganya-m
            end;

            trigger OnValidate()
            var
                recSalaryIncLine: Record "Salary Increment Line";
                SameEarningCodeErr: Label 'You cannot select the same %1 again';
            begin
                recSalaryIncLine.Reset();
                recSalaryIncLine.SetRange("Document No.", "Document No.");
                recSalaryIncLine.SetRange("Earning Group Code", "Earning Group Code");
                recSalaryIncLine.SetRange("Earning Code", "Earning Code");
                if recSalaryIncLine.FindFirst() then
                    Error(SameEarningCodeErr, recSalaryIncLine."Earning Code");

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
                recEmpLevelEarning: Record "Employee Level Earning";
            begin
                HrSetup.Get();
                case true of
                    "Payment Type" = Rec."Payment Type"::Amount:
                        "New Amount" := "Current Amount" + Value;
                    "Payment Type" = Rec."Payment Type"::Percentage:
                        "New Amount" := Round(("Current Amount" / 100 * Value), HrSetup."HR Rounding Precision", HrSetup.RoundingDirection()) + "Current Amount";
                end;
                // Added by suganya-m
                TempEarningG.DeleteAll();
                UpdateComponent("Employee No.", "Earning Group Code", "Earning Code", Value);
            end;
        }
        field(26; "Value Percentage"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Value Percentage';
            MinValue = 0;
            trigger OnValidate()
            var
                HrSetup: Record "Human Resources Setup";
                HrSetupL: Record "Human Resources Setup";
                EmployeeEarningGroupL: Record "Employee Level Earning";
                recSalaryIncLine: Record "Salary Increment Line";

            begin
                // HrSetup.Get();
                HrSetupL.Get();
                HrSetupL.TestField("HR Rounding Precision");
                recSalaryIncLine.SetRange("Employee No.", rec."Employee No.");
                recSalaryIncLine.SetRange("Earning Group Code", rec."Earning Group Code");
                recSalaryIncLine.SetRange("Earning Code", rec."Base Code");
                //recSalaryIncLine.SetRange("From Date", "From Date"); // New
                if recSalaryIncLine.FindFirst() then
                    Validate("Current Amount", Round(rec."Value Percentage" * recSalaryIncLine."Current Amount" / 100, HrSetupL."HR Rounding Precision", HrSetupL.RoundingDirection()));
                "New Amount" := "Current Amount";
                // commented by suganya-m   //"New Amount" := Round(("Current Amount" / 100 * "Value Percentage"), HrSetup."HR Rounding Precision", HrSetup.RoundingDirection()) + "Current Amount";
            end;
        }
        field(27; Inserted; Boolean)
        {
            DataClassification = CustomerContent;

        }

        field(28; "Base Code"; Code[20])
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Document No.", "Employee No.", "Earning Group Code", "Earning Code", "Line No.")
        {
            Clustered = true;
        }
        key(Pk1; "Document No.", "Employee No.", "Line No.")
        {
        }
    }
    var
        SalaryIncrementHdr: Record "Salary Increment Header";
        IsEditable: Boolean;
        TempEarningG: Record Earning temporary;


    trigger OnInsert()
    var
        recSalaryIncLine: Record "Salary Increment Line";
    begin
        CheckStatus();

        // Suganya-m added
        recSalaryIncLine.SetCurrentKey("Document No.", "Employee No.", "Line No.");
        recSalaryIncLine.Reset();
        recSalaryIncLine.SetRange("Document No.", "Document No.");
        if recSalaryIncLine.FindLast() then
            "Line No." := recSalaryIncLine."Line No." + 10000;


        Clear(IsEditable);
        if Rec.Value > '0' then
            IsEditable := false else
            IsEditable := true;
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

    //added a coding for updating value by suganya-m
    procedure UpdateComponent(EmployeeNoP: Code[20]; GroupCodeP: Code[20]; EarningCodeP: Text; AmountP: Decimal)
    var
        EmployeeLevelEarningL: Record "Employee Level Earning";
        recSalaryIncHeader: Record "Salary Increment Header";
        recSalaryIncLine: Record "Salary Increment Line";
        HrSetupL: Record "Human Resources Setup";
        FilterL: Text;
    begin
        recSalaryIncHeader.Get("Document No.");

        HrSetupL.Get();
        HrSetupL.TestField("HR Rounding Precision");
        recSalaryIncLine.SetRange("Document No.", "Document No.");
        recSalaryIncLine.SetRange("Employee No.", EmployeeNoP);
        recSalaryIncLine.SetRange("Earning Group Code", GroupCodeP);
        recSalaryIncLine.SetFilter("Base Code", UPPERCASE(EarningCodeP));
        // recSalaryIncLine.SetRange("From Date", recSalaryIncHeader."Effective Date"); // New
        if recSalaryIncLine.FindSet(true, false) then begin
            FilterL := '';
            repeat
                if FilterL = '' then
                    FilterL := recSalaryIncLine."Earning Code"
                else
                    FilterL += '|' + recSalaryIncLine."Earning Code";

                if TempEarningG.Get(recSalaryIncLine."Base Code") then
                    AmountP := TempEarningG."Pay Amount";
                recSalaryIncLine."New Amount" := Round(AmountP * recSalaryIncLine."Value Percentage" / 100, HrSetupL."HR Rounding Precision", HrSetupL.RoundingDirection());
                // recSalaryIncLine."New Amount" := recSalaryIncLine."Current Amount";
                recSalaryIncLine.Modify();
                if not TempEarningG.Get(recSalaryIncLine."Earning Code") then begin
                    TempEarningG.Code := recSalaryIncLine."Earning Code";
                    TempEarningG."Pay Amount" := recSalaryIncLine."New Amount";
                    TempEarningG.Insert();
                end;
            until recSalaryIncLine.Next() = 0;
            //Evaluate(EarningCodeP, FilterL);
            GroupCodeP := GroupCodeP;
            UpdateComponent(EmployeeNoP, GroupCodeP, FilterL, 0);
        end;
        /* EmployeeLevelEarningL.SetRange("Base Code");
         EmployeeLevelEarningL.SetFilter("Computation Code", '<>%1', '');
         if EmployeeLevelEarningL.FindSet() then
             repeat
                 EmployeeLevelEarningL.Validate("Computation Code");
                 EmployeeLevelEarningL.Modify();
             until EmployeeLevelEarningL.Next() = 0;*/
    end;

}