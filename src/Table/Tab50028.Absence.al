table 50028 "Absence"
{
    DataClassification = CustomerContent;
    Caption = 'Absence';
    LookupPageId = "Absence List";

    fields
    {
        field(1; "Absence Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Absence Code';
        }
        field(21; Description; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Description';
        }
        field(22; "Assigned Days"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Assigned Days';
            MinValue = 0;
        }
        field(23; Type; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = "Paid","Unpaid";
            OptionCaption = 'Paid,Unpaid';
            Caption = 'Type';
        }
        field(24; Religion; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Religion;
            Caption = 'Religion';
        }
        field(25; Nationality; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Country/Region";
            Caption = 'Nationality';
        }
        field(26; Gender; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = " ","Female","Male";
            OptionCaption = ' ,Female,Male';
            Caption = 'Gender';
        }
        field(27; "Include Weekly Off"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Include Weekly Off';
        }
        field(28; "Include Public Holidays"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Include Public Holidays';
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
                if not "Allow in Probation" then begin
                    "Probation Action" := "Probation Action"::" ";
                    "Probation Period LOP Code" := '';
                end;
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
                if not "Allow in Notice Period" then begin
                    "Notice Period Action" := "Notice Period Action"::" ";
                    "Notice Period LOP Code" := '';
                end;
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
            trigger OnValidate()
            begin
                if "Maximum Days at Once" > "Assigned Days" then
                    Error(MaxDaysAtOnceErr, FieldCaption("Maximum Days at Once"), FieldCaption("Assigned Days"));
            end;
        }
        field(38; "Minimum Days at Once"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Minimum Days at Once';
            MinValue = 0;
            trigger OnValidate()
            begin
                if "Minimum Days at Once" < 0.5 then
                    Error(MinDaysAtOnceErr, FieldCaption("Minimum Days at Once"));
            end;
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
            trigger OnValidate()
            begin
                if not "Additional Days" then begin
                    if "Maximum Days in a Year" > "Assigned Days" then
                        Error(MaxDaysAtOnceErr, FieldCaption("Maximum Days in a Year"), FieldCaption("Assigned Days"));
                end else
                    if ("Maximum Days in a Year" <= "Assigned Days") and ("Maximum Days in a Year" > 0) then
                        Error(MaxDaysCanNotbeLesserErr, FieldCaption("Maximum Days in a Year"), FieldCaption("Assigned Days"));
                Clear("Maximum Times in a Year");
            end;
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
        field(48; "Accrual Basis"; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Basis';
            OptionMembers = "Anniversary","Biennial","Yearly";
            OptionCaption = 'Anniversary,Biennial,Yearly';
        }
        field(49; "Apply More Than Accrued"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Apply More Than Accrued';
        }
        field(50; "Encashment computation"; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Encashment computation';
            TableRelation = Computation;
        }
        field(51; "Accruals computation"; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Accruals computation';
            TableRelation = Computation;
        }
        field(52; "Deduction computation"; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Deduction computation';
            TableRelation = Computation;
            Description = 'This is not used and can be removed';
        }
        field(53; "Leave Salary Computation"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Leave Salary Computation';
            TableRelation = Computation;
        }
        field(54; "Additional Days LOP Code"; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Additional/Late Resumption LOP Code';
            TableRelation = Absence where(Type = filter(unpaid));
        }
        field(55; "Probation Period LOP Code"; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Probation Period LOP Code';
            TableRelation = Absence where(Type = filter(unpaid));
        }
        field(56; "Notice Period LOP Code"; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Notice Period LOP Code';
            TableRelation = Absence where(Type = filter(unpaid));
        }
    }

    keys
    {
        key(PK; "Absence Code")
        {
            Clustered = true;
        }
    }
    var
        MaxTimesInTenureErr: Label '%1 can not be greater than %2';
        MaxDaysAtOnceErr: Label '%1 can not be greater than %2';
        MinDaysAtOnceErr: Label '%1 can not be lesser than 0.5 days';
        MaxTimesInYearCanNotbeGrtErr: Label '%1 can not be greater than the double of %2';
        DeleteNotPossibleErr: Label 'The record already assigned to the Group. So you can''t delete.';
        MaxDaysCanNotbeLesserErr: Label '%1 can not be lesser than %2';

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    var
        AbsenceGroupLineL: Record "Absence Group Line";
    begin
        AbsenceGroupLineL.SetRange("Absence Code", "Absence Code");
        if not AbsenceGroupLineL.IsEmpty() then
            Error(DeleteNotPossibleErr);
    end;

    trigger OnRename()
    begin

    end;

    local procedure CheckForValidations()
    begin
        if ("Maximum Times in a Year" > "Maximum Times in Tenure") and ("Maximum Times in Tenure" > 0) then
            Error(MaxTimesInTenureErr, FieldCaption("Maximum Times in a Year"), FieldCaption("Maximum Times in Tenure"));
        if ("Maximum Times in a Year" > (2 * "Maximum Days in a Year")) and ("Maximum Days in a Year" > 0) then
            Error(MaxTimesInYearCanNotbeGrtErr, FieldCaption("Maximum Times in a Year"), FieldCaption("Maximum Days in a Year"))
        else
            if ("Maximum Times in a Year" > (2 * "Assigned Days")) and ("Maximum Days in a Year" = 0) then
                error(MaxTimesInYearCanNotbeGrtErr, FieldCaption("Maximum Times in a Year"), FieldCaption("Assigned Days"));
    end;

    procedure GetStartDateAndEndDate(EmploymentDateP: Date; CurrentDateP: Date; AccrualBasicP: Option "Anniversary","Biennial","Yearly"; var StartDateP: Date; var EndDateP: Date)
    begin
        case AccrualBasicP of
            AccrualBasicP::Yearly:
                begin
                    StartDateP := CalcDate('<-CY>', CurrentDateP);
                    EndDateP := CalcDate('<CY>', CurrentDateP);
                    if StartDateP < EmploymentDateP then
                        StartDateP := EmploymentDateP;
                end;
            AccrualBasicP::Anniversary:
                begin
                    StartDateP := EmploymentDateP;
                    if Date2DMY(CurrentDateP, 3) <> Date2DMY(StartDateP, 3) then begin
                        StartDateP := DMY2Date(Date2DMY(StartDateP, 1), Date2DMY(StartDateP, 2), Date2DMY(CurrentDateP, 3));
                        if StartDateP > CurrentDateP then
                            StartDateP := CalcDate('<-1Y>', StartDateP);
                    end;
                    EndDateP := CalcDate('<1Y>', StartDateP) - 1;
                end;
            AccrualBasicP::Biennial:
                begin
                    StartDateP := EmploymentDateP;
                    EndDateP := CalcDate('<CY>', StartDateP); // This will give Employement Year End Date
                    EndDateP := CalcDate('<1Y>', EndDateP); // This is for adding an additional Year.
                    if CurrentDateP < EndDateP then
                        exit;
                    repeat
                        EndDateP := CalcDate('<2Y>', EndDateP);
                    until (CurrentDateP < EndDateP);
                    StartDateP := CalcDate('<-2Y>', EndDateP) + 1;
                end;
        end;
    end;
}