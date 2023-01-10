table 50027 "Earning Group Line"
{
    DataClassification = CustomerContent;
    Caption = 'Earning Group Line';

    fields
    {
        field(1; "Group Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Group Code';
        }
        field(2; "Group Description"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Group Description';
        }
        field(3; "Earning Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Earning Code';
            TableRelation = "Earning";

            trigger OnValidate()
            var
                EarningL: Record "Earning";
                Earning2L: Record "Earning";
                EarningGroupLineL: Record "Earning Group Line";
                HrSetupL: Record "Human Resources Setup";
                ComputationL: Record Computation;
                ComputationDetailsL: Record "Computation Line Detail";
                BaseCodeErr: Label 'You must select the %1:%2 before %3';
                SameEarningCodeErr: Label 'You cannot select the same %1 again';
            begin
                if "Earning Code" > '' then begin
                    EarningL.Get("Earning Code");
                    "Earning Description" := EarningL.Description;
                    "Payment Type" := EarningL."Payment Type";
                    "Base Code" := EarningL."Base Code";
                    "Affects Salary" := EarningL."Affects Salary";
                    "Show in Payslip" := EarningL."Show in Payslip";
                    "Pay Amount" := EarningL."Pay Amount";
                    "Pay With Salary" := EarningL."Pay With Salary";
                    Accrual := EarningL.Accrual;
                    "Accrual Type" := EarningL."Accrual Type";
                    Category := EarningL.Category;
                    "Computation Code" := EarningL."Computation Code";
                    Type := EarningL.Type;
                    "Day Type" := EarningL."Day Type";
                    "Minimum Number of Days" := EarningL."Minimum Number of Days";
                    "Minimum Duration" := EarningL."Minimum Duration";
                    Hourly := EarningL.Hourly;
                    HrSetupL.Get();
                    HrSetupL.TestField("HR Rounding Precision");
                    case true of
                        EarningL."Payment Type" = EarningL."Payment Type"::Percentage:
                            begin
                                EarningL.TestField("Base Code");
                                EarningGroupLineL.SetRange("Group Code", Rec."Group Code");
                                EarningGroupLineL.SetRange("Earning Code", EarningL."Base Code");
                                if EarningGroupLineL.IsEmpty() then Error(BaseCodeErr, EarningGroupLineL.FieldCaption("Earning Code"), EarningL."Base Code", Rec."Earning Code");
                                if EarningGroupLineL.FindFirst() then begin
                                    "Pay Percentage" := EarningL."Pay Percentage";
                                    Validate("Pay Amount", Round(EarningL."Pay Percentage" * EarningGroupLineL."Pay Amount" / 100, HrSetupL."HR Rounding Precision", HrSetupL.RoundingDirection()));
                                end;
                            end;
                        EarningL."Payment Type" = EarningL."Payment Type"::Computation:
                            begin
                                "Pay Amount" := 0;
                                ComputationL.Get(EarningL."Computation Code");
                                ComputationDetailsL.SetRange("Computation Code", ComputationL."Computation Code");
                                if ComputationDetailsL.FindSet() then
                                    repeat
                                        ComputationDetailsL.TestField(Percentage);
                                        Earning2L.Get(ComputationDetailsL."Earning Code");
                                        "Pay Amount" += Round(Earning2L."Pay Amount" * ComputationDetailsL.Percentage / 100, HrSetupL."HR Rounding Precision", HrSetupL.RoundingDirection());
                                    until ComputationDetailsL.Next() = 0;
                            end;
                    end;
                    EarningGroupLineL.SetRange("Group Code", Rec."Group Code");
                    EarningGroupLineL.SetRange("Earning Code", "Earning Code");
                    if not EarningGroupLineL.IsEmpty() then
                        Error(SameEarningCodeErr, EarningGroupLineL.FieldCaption("Earning Code"));
                end;
            end;
        }
        field(4; "Earning Description"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Earning Description';
        }
        field(5; "Payment Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = " ","Amount","Percentage","Computation";
            OptionCaption = ' ,Amount,Percentage,Computation';
            Caption = 'Payment Type';

            trigger OnValidate()
            begin
                "Base Code" := '';
                "Pay Percentage" := 0;
                "Pay Amount" := 0;
                "Computation Code" := '';
            end;
        }
        field(6; "Base Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Base Code';
            TableRelation = Earning;

            trigger OnValidate()
            var
                EarningGroupLineL: Record "Earning Group Line";
                HrSetupL: Record "Human Resources Setup";
                SameCodeErr: Label 'You cannot assign same %1 to %2';
                AddComponentErr: Label 'You have to add the component in the current group before selecting in %1';
            begin
                if "Base Code" = Rec."Earning Code" then Error(SameCodeErr, FieldCaption("Earning Code"), FieldCaption("Base Code"));
                EarningGroupLineL.SetRange("Group Code", "Group Code");
                EarningGroupLineL.SetRange("Earning Code", "Base Code");
                if EarningGroupLineL.IsEmpty() then
                    Error(AddComponentErr, FieldCaption("Base Code"));
                HrSetupL.Get();
                HrSetupL.TestField("HR Rounding Precision");
                EarningGroupLineL.FindFirst();
                Validate("Pay Amount", Round("Pay Percentage" * EarningGroupLineL."Pay Amount" / 100, HrSetupL."HR Rounding Precision", HrSetupL.RoundingDirection()));
            end;
        }
        field(7; "Pay Percentage"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Pay Percentage';
            MinValue = 0;

            trigger OnValidate()
            var
                HrSetupL: Record "Human Resources Setup";
                EarningGroupLineL: Record "Earning Group Line";
            begin
                HrSetupL.Get();
                HrSetupL.TestField("HR Rounding Precision");
                EarningGroupLineL.SetRange("Group Code", "Group Code");
                EarningGroupLineL.SetRange("Earning Code", "Base Code");
                if EarningGroupLineL.FindFirst() then Validate("Pay Amount", Round("Pay Percentage" * EarningGroupLineL."Pay Amount" / 100, HrSetupL."HR Rounding Precision", HrSetupL.RoundingDirection()));
            end;
        }
        field(8; "Pay Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Pay Amount';
            MinValue = 0;

            trigger OnValidate()
            begin
                TempEarningG.DeleteAll();
                UpdateComponent("Group Code", "Earning Code", "Pay Amount");
            end;
        }
        field(9; "Affects Salary"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Affects Salary';
        }
        field(10; "Show in payslip"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Show in Payslip';
        }
        field(11; "Line No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Line No.';
        }
        field(12; "Pay With Salary"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Pay With Salary';
        }
        field(13; Category; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = " ","Earning","Deduction";
            OptionCaption = ' ,Earning,Deduction';
            Caption = 'Category';
        }
        field(14; Type; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = " ","Constant","Adhoc","Employer Contribution";
            OptionCaption = ' ,Constant,Adhoc,Employer Contribution';
            Caption = 'Type';
        }
        field(15; Accrual; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Accrual';
        }
        field(16; "Accrual Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = " ","Gratuity Accrual","Air Ticket";
            OptionCaption = ' ,Gratuity Accrual,Air Ticket';
        }
        field(17; "Computation Code"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Computation;
            trigger OnValidate()
            var
                ComputationL: Record Computation;
                ComputationDetailsL: Record "Computation Line Detail";
                EarningGroupLineL: Record "Earning Group Line";
                HrSetupL: Record "Human Resources Setup";
            begin
                "Pay Amount" := 0;
                HrSetupL.Get();
                HrSetupL.TestField("HR Rounding Precision");
                ComputationL.Get("Computation Code");
                ComputationDetailsL.SetRange("Computation Code", ComputationL."Computation Code");
                if ComputationDetailsL.FindSet() then
                    repeat
                        ComputationDetailsL.TestField(Percentage);
                        EarningGroupLineL.SetRange("Group Code", "Group Code");
                        EarningGroupLineL.SetRange("Earning Code", ComputationDetailsL."Earning Code");
                        if EarningGroupLineL.FindFirst() then
                            "Pay Amount" += Round(EarningGroupLineL."Pay Amount" * ComputationDetailsL.Percentage / 100, HrSetupL."HR Rounding Precision", HrSetupL.RoundingDirection());
                    until ComputationDetailsL.Next() = 0;
            end;
        }
        field(20; "Day Type"; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Day Type';
            OptionMembers = " ","Any Day","Working Day","Week Off","Public Holiday";
            OptionCaption = ' ,Any Day,Working Day,Week Off,Public Holiday';
        }
        field(21; "Minimum Number of Days"; DateFormula)
        {
            DataClassification = CustomerContent;
            Caption = 'Minimum Number of Days';
        }
        field(22; "Minimum Duration"; Duration)
        {
            DataClassification = CustomerContent;
            Caption = 'Minimum Duration';
        }
        field(19; "Hourly"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Hourly';
        }
    }
    keys
    {
        key(PK; "Group Code", "Line No.")
        {
            Clustered = true;
        }
        key(SK; "Earning Code")
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
    var
        EarningGroupLineL: Record "Earning Group Line";
        ExistErr: Label 'You cannot delete this line. Because it is used in the %1 of another line';
    begin
        if "Earning Code" = '' then
            exit;
        EarningGroupLineL.SetRange("Group Code", "Group Code");
        EarningGroupLineL.SetRange("Base Code", "Earning Code");
        if not EarningGroupLineL.IsEmpty() then
            Error(ExistErr, EarningGroupLineL.FieldCaption("Base Code"));
    end;

    trigger OnRename()
    begin
    end;

    var
        TempEarningG: Record Earning temporary;

    procedure UpdateComponent(GroupCodeP: Code[20];
    EarningCodeP: Text;
    AmountP: Decimal)
    var
        EarningGroupLineL: Record "Earning Group Line";
        HrSetupL: Record "Human Resources Setup";
        FilterL: Text;
    begin
        HrSetupL.Get();
        HrSetupL.TestField("HR Rounding Precision");
        EarningGroupLineL.SetRange("Group Code", GroupCodeP);
        EarningGroupLineL.SetFilter("Base Code", UPPERCASE(EarningCodeP));
        if EarningGroupLineL.FindSet(true, false) then begin
            FilterL := '';
            repeat
                if FilterL = '' then
                    FilterL := EarningGroupLineL."Earning Code"
                else
                    FilterL += '|' + EarningGroupLineL."Earning Code";
                if TempEarningG.Get(EarningGroupLineL."Base Code") then AmountP := TempEarningG."Pay Amount";
                EarningGroupLineL."Pay Amount" := Round(AmountP * EarningGroupLineL."Pay Percentage" / 100, HrSetupL."HR Rounding Precision", HrSetupL.RoundingDirection());
                EarningGroupLineL.Modify();
                if not TempEarningG.Get(EarningGroupLineL."Earning Code") then begin
                    TempEarningG.Code := EarningGroupLineL."Earning Code";
                    TempEarningG."Pay Amount" := EarningGroupLineL."Pay Amount";
                    TempEarningG.Insert();
                end;
            until EarningGroupLineL.Next() = 0;
            // Evaluate(EarningCodeP, FilterL);
            GroupCodeP := GroupCodeP;
            UpdateComponent(GroupCodeP, FilterL, 0);
        end;
        // Avi : to calculate the Amount for the Computation Code dependants.
        EarningGroupLineL.SetRange("Base Code");
        EarningGroupLineL.SetFilter("Computation Code", '<>%1', '');
        if EarningGroupLineL.FindSet() then
            repeat
                EarningGroupLineL.Validate("Computation Code");
                EarningGroupLineL.Modify();
            until EarningGroupLineL.Next() = 0;

    end;
}
