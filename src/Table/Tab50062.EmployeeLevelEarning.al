table 50062 "Employee Level Earning"
{
    DataClassification = CustomerContent;
    Caption = 'Employee Level Earning';
    LookupPageId = "Employee Level Earning";
    DrillDownPageId = "Employee Level Earning";

    fields
    {
        field(1; "Employee No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Employee No.';
        }
        field(2; "Group Code"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Group Code';
        }
        field(3; "From Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'From Date';
        }
        field(4; "Earning Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Earning Code';
            TableRelation = "Earning";

            trigger OnValidate()
            var
                EarningGroupLineL: Record "Earning Group Line";
                EmployeeEarningGroupL: Record "Employee Level Earning";
                HrSetupL: Record "Human Resources Setup";
                BaseCodeErr: Label 'You must select the %1:%2 before %3';
                SameEarningCodeErr: Label 'You cannot select the same %1 again';
            begin
                if "Earning Code" > '' then begin
                    EarningGroupLineL.SetRange("Group Code", "Group Code");
                    EarningGroupLineL.SetRange("Earning Code", "Earning Code");
                    EarningGroupLineL.FindFirst();
                    "Earning Description" := EarningGroupLineL."Earning Description";
                    "Payment Type" := EarningGroupLineL."Payment Type";
                    "Base Code" := EarningGroupLineL."Base Code";
                    "Affects Salary" := EarningGroupLineL."Affects Salary";
                    "Show in Payslip" := EarningGroupLineL."Show in Payslip";
                    "Pay With Salary" := EarningGroupLineL."Pay With Salary";
                    "Pay Amount" := EarningGroupLineL."Pay Amount";
                    Accural := EarningGroupLineL.Accrual;
                    "Accrual Type" := EarningGroupLineL."Accrual Type";
                    Category := EarningGroupLineL.Category;
                    Hourly := EarningGroupLineL.Hourly;
                    "Day Type" := EarningGroupLineL."Day Type";
                    "Minimum Number of Days" := EarningGroupLineL."Minimum Number of Days";
                    "Minimum Duration" := EarningGroupLineL."Minimum Duration";
                    Type := EarningGroupLineL.Type;
                    case true of
                        EarningGroupLineL."Payment Type" = EarningGroupLineL."Payment Type"::Percentage:
                            begin
                                EarningGroupLineL.TestField("Base Code");
                                EmployeeEarningGroupL.SetRange("Employee No.", Rec."Employee No.");
                                EmployeeEarningGroupL.SetRange("Group Code", Rec."Group Code");
                                EmployeeEarningGroupL.SetRange("Earning Code", EarningGroupLineL."Base Code");
                                EmployeeEarningGroupL.SetRange("From Date", "From Date"); // New
                                if EmployeeEarningGroupL.IsEmpty() then
                                    Error(BaseCodeErr, EmployeeEarningGroupL.FieldCaption("Earning Code"), EarningGroupLineL."Base Code", Rec."Earning Code");
                                if EmployeeEarningGroupL.FindFirst() then begin
                                    HrSetupL.Get();
                                    HrSetupL.TestField("HR Rounding Precision");
                                    "Pay Percentage" := EarningGroupLineL."Pay Percentage";
                                    if not EarningGroupLineL.Hourly then //Suraj
                                        Validate("Pay Amount", Round(EarningGroupLineL."Pay Percentage" * EmployeeEarningGroupL."Pay Amount" / 100, HrSetupL."HR Rounding Precision", HrSetupL.RoundingDirection()));
                                end;
                            end;
                        EarningGroupLineL."Payment Type" = EarningGroupLineL."Payment Type"::Computation:
                            begin
                                if not EarningGroupLineL.Hourly then
                                    "Pay Amount" := EarningGroupLineL."Pay Amount";
                                Validate("Computation Code", EarningGroupLineL."Computation Code");
                            end;
                    end;
                    EmployeeEarningGroupL.SetRange("Employee No.", Rec."Employee No.");
                    EmployeeEarningGroupL.SetRange("Group Code", Rec."Group Code");
                    EmployeeEarningGroupL.SetRange("Earning Code", "Earning Code");
                    EmployeeEarningGroupL.SetRange("From Date", "From Date"); // New
                    if EmployeeEarningGroupL.FindFirst() then
                        Error(SameEarningCodeErr, EmployeeEarningGroupL.FieldCaption("Earning Code"));
                end;
            end;
        }

        field(21; "Earning Description"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Earning Description';
        }
        field(22; "Payment Type"; Option)
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
        field(23; "Base Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Base Code';
            TableRelation = Earning;

            trigger OnValidate()
            var
                EmployeeEarningGroupL: Record "Employee Level Earning";
                HrSetupL: Record "Human Resources Setup";
                SameCodeErr: Label 'You cannot assign same %1 to %2';
                AddComponentErr: Label 'You have to add the component in the current group before selecting in %1';
            begin
                if "Base Code" = Rec."Earning Code" then
                    Error(SameCodeErr, FieldCaption("Earning Code"), FieldCaption("Base Code"));
                EmployeeEarningGroupL.SetRange("Employee No.", "Employee No.");
                EmployeeEarningGroupL.SetRange("Group Code", "Group Code");
                EmployeeEarningGroupL.SetRange("Earning Code", "Base Code");
                EmployeeEarningGroupL.SetRange("From Date", "From Date"); // New
                if EmployeeEarningGroupL.IsEmpty() then
                    Error(AddComponentErr, FieldCaption("Base Code"));
                HrSetupL.Get();
                HrSetupL.TestField("HR Rounding Precision");
                EmployeeEarningGroupL.FindFirst();
                Validate("Pay Amount", Round("Pay Percentage" * EmployeeEarningGroupL."Pay Amount" / 100, HrSetupL."HR Rounding Precision", HrSetupL.RoundingDirection()));
            end;
        }
        field(24; "Pay Percentage"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Pay Percentage';
            MinValue = 0;

            trigger OnValidate()
            var
                HrSetupL: Record "Human Resources Setup";
                EmployeeEarningGroupL: Record "Employee Level Earning";
            begin
                HrSetupL.Get();
                HrSetupL.TestField("HR Rounding Precision");
                EmployeeEarningGroupL.SetRange("Employee No.", "Employee No.");
                EmployeeEarningGroupL.SetRange("Group Code", "Group Code");
                EmployeeEarningGroupL.SetRange("Earning Code", "Base Code");
                EmployeeEarningGroupL.SetRange("From Date", "From Date"); // New
                if EmployeeEarningGroupL.FindFirst() then
                    Validate("Pay Amount", Round("Pay Percentage" * EmployeeEarningGroupL."Pay Amount" / 100, HrSetupL."HR Rounding Precision", HrSetupL.RoundingDirection()));
            end;
        }
        field(25; "Pay Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Pay Amount';
            MinValue = 0;

            trigger OnValidate()
            begin
                TempEarningG.DeleteAll();
                UpdateComponent("Employee No.", "Group Code", "Earning Code", "Pay Amount");
            end;
        }
        field(26; "Affects Salary"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Affects Salary';
        }
        field(27; "Show in payslip"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Show in Payslip';
        }
        field(28; "To Date"; Date)
        {
            Caption = 'To Date';
            FieldClass = FlowField;
            CalcFormula = lookup("Employee Earning History"."To Date" where("Employee No." = field("Employee No."), "Group Code" = field("Group Code"), "From Date" = field("From Date")));
            Editable = false;
        }
        field(29; "Pay With Salary"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Pay With Salary';
        }
        field(30; Category; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = " ","Earning","Deduction";
            OptionCaption = ' ,Earning,Deduction';
            Caption = 'Category';
        }
        field(31; Type; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = " ","Constant","Adhoc","Employer Contribution";
            OptionCaption = ' ,Constant,Adhoc,Employer Contribution';
            Caption = 'Type';
        }
        field(32; Accural; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Accrual';
        }
        field(33; "Accrual Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = " ","Gratuity Accrual","Air Ticket";
            OptionCaption = ' ,Gratuity Accrual,Air Ticket';
        }
        field(34; "Computation Code"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Computation;
            trigger OnValidate()
            var
                ComputationL: Record Computation;
                ComputationDetailsL: Record "Computation Line Detail";
                EmployeeLevelEarningL: Record "Employee Level Earning";
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
                        EmployeeLevelEarningL.SetRange("Employee No.", "Employee No.");
                        EmployeeLevelEarningL.SetRange("Earning Code", ComputationDetailsL."Earning Code");
                        EmployeeLevelEarningL.SetRange("From Date", "From Date");
                        if EmployeeLevelEarningL.FindFirst() then
                            if Not Hourly then
                                "Pay Amount" += Round(EmployeeLevelEarningL."Pay Amount" * ComputationDetailsL.Percentage / 100, HrSetupL."HR Rounding Precision", HrSetupL.RoundingDirection());

                    until ComputationDetailsL.Next() = 0;
            end;
        }
        field(35; "Day Type"; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Day Type';
            OptionMembers = " ","Any Day","Working Day","Week Off","Public Holiday";
            OptionCaption = ' ,Any Day,Working Day,Week Off,Public Holiday';
        }
        field(36; "Minimum Number of Days"; DateFormula)
        {
            DataClassification = CustomerContent;
            Caption = 'Minimum Number of Days';
        }
        field(37; "Minimum Duration"; Duration)
        {
            DataClassification = CustomerContent;
            Caption = 'Minimum Duration';
        }
        field(38; "Hourly"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Hourly';
        }
    }
    keys
    {
        key(PK; "Employee No.", "Group Code", "From Date", "Earning Code")
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
    var
        EmployeeLevelEarningL: Record "Employee Level Earning";
        ExistErr: Label 'You cannot delete this line. Because it is used in the %1 of another line';
    begin
        if "Earning Code" = '' then exit;
        EmployeeLevelEarningL.SetRange("Employee No.", "Employee No.");
        EmployeeLevelEarningL.SetRange("Base Code", Rec."Earning Code");
        EmployeeLevelEarningL.SetRange("From Date", "From Date"); // New
        if not EmployeeLevelEarningL.IsEmpty() then
            Error(ExistErr, EmployeeLevelEarningL.FieldCaption("Base Code"));
    end;

    trigger OnRename()
    begin
    end;

    var
        TempEarningG: Record Earning temporary;

    procedure UpdateComponent(EmployeeNoP: Code[20]; GroupCodeP: Code[20]; EarningCodeP: Text; AmountP: Decimal)
    var
        EmployeeLevelEarningL: Record "Employee Level Earning";
        HrSetupL: Record "Human Resources Setup";
        FilterL: Text;
    begin
        HrSetupL.Get();
        HrSetupL.TestField("HR Rounding Precision");
        EmployeeLevelEarningL.SetRange("Employee No.", "Employee No.");
        EmployeeLevelEarningL.SetRange("Group Code", GroupCodeP);
        EmployeeLevelEarningL.SetFilter("Base Code", UPPERCASE(EarningCodeP));
        EmployeeLevelEarningL.SetRange("From Date", "From Date"); // New
        if EmployeeLevelEarningL.FindSet(true, false) then begin
            FilterL := '';
            repeat
                if FilterL = '' then
                    FilterL := EmployeeLevelEarningL."Earning Code"
                else
                    FilterL += '|' + EmployeeLevelEarningL."Earning Code";
                if TempEarningG.Get(EmployeeLevelEarningL."Base Code") then
                    AmountP := TempEarningG."Pay Amount";

                EmployeeLevelEarningL."Pay Amount" := Round(AmountP * EmployeeLevelEarningL."Pay Percentage" / 100, HrSetupL."HR Rounding Precision", HrSetupL.RoundingDirection());
                EmployeeLevelEarningL.Modify();
                if not TempEarningG.Get(EmployeeLevelEarningL."Earning Code") then begin
                    TempEarningG.Code := EmployeeLevelEarningL."Earning Code";
                    TempEarningG."Pay Amount" := EmployeeLevelEarningL."Pay Amount";
                    TempEarningG.Insert();
                end;
            until EmployeeLevelEarningL.Next() = 0;
            // Evaluate(EarningCodeP, FilterL);
            GroupCodeP := GroupCodeP;
            UpdateComponent(EmployeeNoP, GroupCodeP, FilterL, 0);
        end;
        EmployeeLevelEarningL.SetRange("Base Code");
        EmployeeLevelEarningL.SetFilter("Computation Code", '<>%1', '');
        if EmployeeLevelEarningL.FindSet() then
            repeat
                EmployeeLevelEarningL.Validate("Computation Code");
                EmployeeLevelEarningL.Modify();
            until EmployeeLevelEarningL.Next() = 0;
    end;
}
