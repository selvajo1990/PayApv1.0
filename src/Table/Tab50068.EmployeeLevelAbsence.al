table 50068 "Employee Level Absence"
{
    DataClassification = CustomerContent;
    Caption = 'Employee Level Absence';
    DrillDownPageId = "Employee Level Absence";
    LookupPageId = "Employee Level Absence";
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
        field(4; "Absence Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Absence Code';
            TableRelation = Absence;
            trigger OnValidate()
            var
                AbsenceGroupLineL: Record "Absence Group Line";
            begin
                // Start Avi
                AbsenceGroupLineL.Get("Group Code", "Absence Code");
                "Absence Description" := AbsenceGroupLineL."Absence Description";
                "Attachment Required" := AbsenceGroupLineL."Attachment Required";
                "Attachment days" := AbsenceGroupLineL."Attachment days";
                "Additional Days" := AbsenceGroupLineL."Additional Days";
                "Additional Days Action" := AbsenceGroupLineL."Additional Days Action";
                "Allow in Probation" := AbsenceGroupLineL."Allow in Probation";
                "Probation Action" := AbsenceGroupLineL."Probation Action";
                "Allow in Notice Period" := AbsenceGroupLineL."Allow in Notice Period";
                "Notice Period Action" := AbsenceGroupLineL."Notice Period Action";
                "Maximum Days at Once" := AbsenceGroupLineL."Maximum Days at Once";
                "Minimum Days at Once" := AbsenceGroupLineL."Minimum Days at Once";
                "Minimum Days Before Request" := AbsenceGroupLineL."Minimum Days Before Request";
                "Minimum Days Between Request" := AbsenceGroupLineL."Minimum Days Between Request";
                "Maximum Days in a Year" := AbsenceGroupLineL."Maximum Days in a Year";
                "Maximum Times in a Year" := AbsenceGroupLineL."Maximum Times in a Year";
                "Minimum Tenure" := AbsenceGroupLineL."Minimum Tenure";
                "Maximum Times in Tenure" := AbsenceGroupLineL."Maximum Times in Tenure";
                Accrual := AbsenceGroupLineL.Accrual;
                "Maximum Accrual Days" := AbsenceGroupLineL."Maximum Accrual Days";
                "Maximum Carry Forward Days" := AbsenceGroupLineL."Maximum Carry Forward Days";
                "Assigned Days" := AbsenceGroupLineL."Assigned Days";
                "Accrual Basis" := AbsenceGroupLineL."Accrual Basis";
                "Apply More Than Accrued" := AbsenceGroupLineL."Apply More Than Accrued";
                // Stop Avi
            end;
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
            OptionMembers = " ","Warning","Loss of Pay","Extend Notice Period";
            OptionCaption = ' ,Warning,Loss of Pay,Extend Notice Period';
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
        key(PK; "Employee No.", "Group Code", "From Date", "Absence Code")
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