table 50029 "Absence Group Line"
{
    DataClassification = CustomerContent;
    Caption = 'Absence Group Line';
    LookupPageId = "Absence Group Line List";
    DrillDownPageId = "Absence Group Line List";
    fields
    {
        field(1; "Absence Group Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Absence Group Code';
        }
        field(2; "Absence Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Absence Code';
            TableRelation = Absence;
            trigger OnValidate()
            var
                AbsenceL: Record Absence;
            begin
                AbsenceL.Get("Absence Code");
                "Absence Code" := AbsenceL."Absence Code";
                "Absence Description" := AbsenceL.Description;
                "Attachment Required" := AbsenceL."Attachment Required";
                "Attachment days" := AbsenceL."Attachment days";
                "Additional Days" := AbsenceL."Additional Days";
                "Additional Days Action" := AbsenceL."Additional Days Action";
                "Allow in Probation" := AbsenceL."Allow in Probation";
                "Probation Action" := AbsenceL."Probation Action";
                "Allow in Notice Period" := AbsenceL."Allow in Notice Period";
                "Notice Period Action" := AbsenceL."Notice Period Action";
                "Maximum Days at Once" := AbsenceL."Maximum Days at Once";
                "Minimum Days at Once" := AbsenceL."Minimum Days at Once";
                "Minimum Days Before Request" := AbsenceL."Minimum Days Before Request";
                "Minimum Days Between Request" := AbsenceL."Minimum Days Between Request";
                "Maximum Days in a Year" := AbsenceL."Maximum Days in a Year";
                "Maximum Times in a Year" := AbsenceL."Maximum Times in a Year";
                "Minimum Tenure" := AbsenceL."Minimum Tenure";
                "Maximum Times in Tenure" := AbsenceL."Maximum Times in Tenure";
                Accrual := AbsenceL.Accrual;
                "Maximum Accrual Days" := AbsenceL."Maximum Accrual Days";
                "Maximum Carry Forward Days" := AbsenceL."Maximum Carry Forward Days";
                "Assigned Days" := AbsenceL."Assigned Days";
                "Accrual Basis" := AbsenceL."Accrual Basis";
                "Apply More Than Accrued" := AbsenceL."Apply More Than Accrued";
            end;
        }
        field(3; "Absence Group Description"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Absence Group Description';
        }
        field(21; "Absence Description"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Absence Description';
        }
        field(29; "Attachment Required"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Attachment Required';
            trigger OnValidate()
            begin
                if not "Attachment Required" then
                    "Attachment days" := 0;
            end;
        }
        field(30; "Attachment days"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Attachment days';
            MinValue = 0;
        }
        field(31; "Additional Days"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Additional days';
            trigger OnValidate()
            begin
                if not "Additional Days" then
                    "Additional Days Action" := "Additional Days Action"::" ";
            end;
        }
        field(32; "Additional Days Action"; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Additional Days Action';
            OptionMembers = " ","Loss of Pay","Warning";
        }
        field(33; "Allow in Probation"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Allow in Probation';
            trigger OnValidate()
            begin
                if not "Allow in Probation" then
                    "Probation Action" := "Probation Action"::" ";
            end;
        }
        field(34; "Probation Action"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = " ","Warning","Loss of Pay","Extend Probation";
            OptionCaption = ' ,Warning,Loss of Pay,Extend Probation';
        }
        field(35; "Allow in Notice Period"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Allow in Notice Period';
            trigger OnValidate()
            begin
                if not "Allow in Notice Period" then
                    "Notice Period Action" := "Notice Period Action"::" ";
            end;
        }
        field(36; "Notice Period Action"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = " ","Warning","Loss of Pay","Extend Probation";
            OptionCaption = ' ,Warning,Loss of Pay,Extend Probation';
        }
        field(37; "Maximum Days at Once"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Maximum Days at Once';
            MinValue = 0;
        }
        field(38; "Minimum Days at Once"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Minimum Days at Once';
            MinValue = 0;
        }
        field(39; "Minimum Days Before Request"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Minimum Days Before Request';
            MinValue = 0;
        }
        field(40; "Minimum Days Between Request"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Minimum Days Between Request';
            MinValue = 0;
        }
        field(41; "Maximum Days in a Year"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Maximum Days in a Year';
            MinValue = 0;
        }
        field(42; "Maximum Times in a Year"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Maximum Times in a Year';
            MinValue = 0;
            trigger OnValidate()
            begin
                CheckForValidations();
            end;
        }
        field(43; "Minimum Tenure"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Minimum Tenure';
            MinValue = 0;
        }
        field(44; "Maximum Times in Tenure"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Maximum Times in Tenure';
            MinValue = 0;
            trigger OnValidate()
            begin
                CheckForValidations();
            end;
        }
        field(45; "Accrual"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Accrual';
            trigger OnValidate()
            begin
                if not Accrual then
                    "Maximum Accrual Days" := 0;
            end;
        }
        field(46; "Maximum Accrual Days"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Maximum Accrual Days';
            MinValue = 0;
        }
        field(47; "Maximum Carry Forward Days"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Maximum Carry Forward Days';
            MinValue = 0;
        }
        field(22; "Assigned Days"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Assigned Days';
            MinValue = 0;
        }
        field(48; "Accrual Basis"; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Accrual Basis';
            OptionMembers = "Anniversary","Biennial","Yearly";
            OptionCaption = 'Anniversary,Biennial,Yearly';
        }
        field(49; "Apply More Than Accrued"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Apply More Than Accrued';
        }
    }

    keys
    {
        key(PK; "Absence Group Code", "Absence Code")
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

    local procedure CheckForValidations()
    begin
        if "Maximum Times in a Year" > "Maximum Times in Tenure" then
            Error(MaxTimesInTenureErr, FieldCaption("Maximum Times in a Year"), FieldCaption("Maximum Times in Tenure"));
    end;

    var
        MaxTimesInTenureErr: Label '%1 can not be greater than %2';

}