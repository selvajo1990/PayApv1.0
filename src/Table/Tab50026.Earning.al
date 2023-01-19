table 50026 "Earning"
{
    DataClassification = CustomerContent;
    Caption = 'Earning';
    LookupPageId = Earnings;

    fields
    {
        field(1; Code; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Earning Code';
        }
        field(2; Description; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Description';
        }
        field(3; Category; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = " ","Earning","Deduction";
            OptionCaption = ' ,Earning,Deduction';
            Caption = 'Category';
        }
        field(4; Type; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = " ","Constant","Adhoc","Employer Contribution";
            OptionCaption = ' ,Constant,Adhoc,Employer Contribution';
            Caption = 'Type';
            trigger OnValidate()
            begin
                ResetOverTimeValues();
                Hourly := false;
            end;
        }
        field(5; Accrual; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Accrual';
        }
        field(6; "Affects Salary"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Affects Salary';
        }
        field(7; "Show in payslip"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Show in payslip';
        }
        field(8; "Payment Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = " ","Amount","Percentage","Computation";
            OptionCaption = ' ,Amount,Percentage,Computation';
            Caption = 'Payment Type';
        }
        field(9; "Pay Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Pay Amount';
            MinValue = 0;
        }
        field(10; "Base Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Base Code';
            TableRelation = "Earning";

            trigger OnValidate()
            var
                SameCodeErr: Label 'You cannot assign same %1 to %2';
            begin
                if "Base Code" = Rec."Code" then Error(SameCodeErr, FieldCaption("Code"), FieldCaption("Base Code"));
            end;
        }
        field(11; "Pay Percentage"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Pay Percentage';
            MinValue = 0;
        }
        field(12; "Pay With Salary"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Pay With Salary';
            Description = 'To be removed.';
        }
        field(13; "Accrual Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = " ","Gratuity Accrual","Air Ticket";
            OptionCaption = ' ,Gratuity Accrual,Air Ticket';
            trigger OnValidate()
            begin
                if "Accrual Type" <> "Accrual Type"::"Air Ticket" then
                    "Pay on Anniversary" := false;
            end;
        }
        field(14; "Computation Code"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Computation;
        }
        field(15; "First Month Computation"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = "Prorata","Full Amount";
            Caption = 'First Month Computation';
            OptionCaption = 'Prorata,Full Amount';
        }
        field(16; "Confirmed"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = "Prorata","Full Amount";
            Caption = 'Confirmed';
            OptionCaption = 'Prorata,Full Amount';
        }
        field(17; "Last Month Computation"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = "Prorata","Full Amount";
            Caption = 'Last Month Computation';
            OptionCaption = 'Prorata,Full Amount';
        }
        field(18; "Pay on Anniversary"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Pay on Aniversary';
        }
        field(19; "Hourly"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Hourly';
            trigger OnValidate()
            begin
                ResetOverTimeValues();
            end;
        }
        field(20; "Day Type"; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Day Type';
            OptionMembers = " ","Any Day","Working Day","Week Off","Public Holiday";
            OptionCaption = ' ,Any Day,Working Day,Week Off,Public Holiday';
            trigger OnValidate()
            begin
                TestField("Day Type");
            end;
        }
        field(21; "Minimum Number of Days"; DateFormula)
        {
            DataClassification = CustomerContent;
            Caption = 'Minimum Number of Days';
            trigger OnValidate()
            var
                NoofDaysLbl: Label '%1D';
            begin
                Evaluate("Minimum Number of Days", StrSubstNo(NoofDaysLbl, CALCDATE("Minimum Number of Days", WorkDate()) - WorkDate()));
            end;
        }
        field(22; "Minimum Duration"; Duration)
        {
            DataClassification = CustomerContent;
            Caption = 'Minimum Duration';
        }
        /*field(23; "Applicable for OT"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Applicable for OT';
        }
        field(24; "OT% for Normal Days"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'OT% for Normal Days';
        }
        field(25; "OT% for Holidays"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'OT% for Holidays';
        }*/
    }
    keys
    {
        key(PK; Code)
        {
            Clustered = true;
        }
    }
    var
        RenameRestrictedErr: Label 'You cannot rename the %1';

    trigger OnInsert()
    begin
    end;

    trigger OnModify()
    begin
    end;

    trigger OnDelete()
    var
        EarningGroupLineL: Record "Earning Group Line";
        CodeAttachedErr: Label '%1 is assinged in %2 for %3. You cannot delete';
    begin
        EarningGroupLineL.SetRange("Earning Code", Rec.Code);
        if EarningGroupLineL.FindFirst() then Error(CodeAttachedErr, Rec.FieldCaption(Code), EarningGroupLineL.TableCaption(), EarningGroupLineL."Group Code");
    end;

    trigger OnRename()
    begin
        Error(RenameRestrictedErr, FieldCaption(Code));
    end;

    local procedure ResetOverTimeValues()
    begin
        if (Hourly) and (Type = Type::Constant) then
            "Day Type" := "Day Type"::"Any Day"
        else
            "Day Type" := "Day Type"::" ";

        clear("Minimum Number of Days");
        "Minimum Duration" := 0;
        Accrual := false;
    end;
}
