page 50047 "Absence Card"
{
    PageType = Card;
    SourceTable = Absence;
    Caption = 'Absence Card';
    UsageCategory = None;
    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Absence Code"; Rec."Absence Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Absence Code';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Description';
                }
                field("Assigned Days"; Rec."Assigned Days")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Assigned Days';
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Type';
                }
                field(Religion; Rec.Religion)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Religion';
                }
                field(Nationality; Rec.Nationality)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Nationality';
                }
                field(Gender; Rec.Gender)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Gender';
                }
                field("Include Weekly Off"; Rec."Include Weekly Off")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Include Weekly Off';
                }
                field("Include Public Holidays"; Rec."Include Public Holidays")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Include Public Holidays';
                }
                field("Attachment Required"; Rec."Attachment Required")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Attachment Required';
                    trigger OnValidate()
                    begin
                        MakeEditable();
                    end;
                }
                field("Attachment days"; Rec."Attachment days")
                {
                    ApplicationArea = all;
                    Editable = AttachmentDaysEditableG;
                    ToolTip = 'Specifies the value of the Attachment days';
                }
                field("Additional Days"; Rec."Additional Days")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Additional days';
                    trigger OnValidate()
                    begin
                        MakeEditable();
                    end;
                }
                field("Additional Days Action"; Rec."Additional Days Action")
                {
                    ApplicationArea = all;
                    Editable = AdditionalDaysActionEditableG;
                    ToolTip = 'Specifies the value of the Additional Days Action';
                }
                field("Additional Days LOP Code"; Rec."Additional Days LOP Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Additional/Late Resumption LOP Code';
                }
                field("Allow in Probation"; Rec."Allow in Probation")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Allow in Probation';
                    trigger OnValidate()
                    begin
                        MakeEditable();
                    end;
                }
                field("Probation Action"; Rec."Probation Action")
                {
                    ApplicationArea = all;
                    Editable = ProbationActionEditableG;
                    ToolTip = 'Specifies the value of the Probation Action';
                }
                group("Probabtion LOP")
                {
                    Caption = '';
                    Visible = Rec."Probation Action" = Rec."Probation Action"::"Loss of Pay";
                    field("Probation Period LOP Code"; Rec."Probation Period LOP Code")
                    {
                        ApplicationArea = all;
                        ToolTip = 'Specifies the value of the Probation Period LOP Code';
                    }
                }
                field("Allow in Notice Period"; Rec."Allow in Notice Period")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Allow in Notice Period';
                    trigger OnValidate()
                    begin
                        MakeEditable();
                    end;
                }
                field("Notice Period Action"; Rec."Notice Period Action")
                {
                    ApplicationArea = all;
                    Editable = NoticePeriodActionEditableG;
                    ToolTip = 'Specifies the value of the Notice Period Action';
                }
                group("Notice Period LOP")
                {
                    Caption = '';
                    Visible = Rec."Notice Period Action" = Rec."Notice Period Action"::"Loss of Pay";
                    field("Notice Period LOP Code"; Rec."Notice Period LOP Code")
                    {
                        ApplicationArea = all;
                        ToolTip = 'Specifies the value of the Notice Period LOP Code';
                    }
                }
                field("Accrual Basis"; Rec."Accrual Basis")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Basis';
                }
            }
            group(Validation)
            {
                field("Maximum Days at Once"; Rec."Maximum Days at Once")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Maximum Days at Once';
                }
                field("Minimum Days at Once"; Rec."Minimum Days at Once")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Minimum Days at Once';
                }
                field("Minimum Days Before Request"; Rec."Minimum Days Before Request")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Minimum Days Before Request';
                }
                field("Minimum Days Between Request"; Rec."Minimum Days Between Request")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Minimum Days Between Request';
                }
                field("Maximum Days in a Year"; Rec."Maximum Days in a Year")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Maximum Days in a Year';
                }
                field("Maximum Times in a Year"; Rec."Maximum Times in a Year")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Maximum Times in a Year';
                }
                field("Minimum Tenure"; Rec."Minimum Tenure")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Minimum Tenure';
                }
                field("Maximum Times in Tenure"; Rec."Maximum Times in Tenure")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Maximum Times in Tenure';
                }
                field(Accrual; Rec.Accrual)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Accrual';
                    trigger OnValidate()
                    begin
                        MakeEditable();
                    end;
                }
                field("Maximum Accrual Days"; Rec."Maximum Accrual Days")
                {
                    ApplicationArea = all;
                    Editable = MaxAccrualDaysEditable;
                    ToolTip = 'Specifies the value of the Maximum Accrual Days';
                }
                field("Apply More Than Accrued"; Rec."Apply More Than Accrued")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Apply More Than Accrued';
                }
                field("Maximum Carry Forward Days"; Rec."Maximum Carry Forward Days")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Maximum Carry Forward Days';
                }
            }
            part("Sick Leave Setup"; "Sick Leave Setup")
            {
                SubPageLink = "Absence Code" = field("Absence Code");
                Caption = 'Setup';
                ApplicationArea = all;
            }
            group(Computation)
            {
                field("Encashment computation"; Rec."Encashment computation")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Encashment computation';
                }
                field("Accruals computation"; Rec."Accruals computation")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Accruals computation';
                }
                field("Leave Salary Computation"; Rec."Leave Salary Computation")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Leave Salary Computation';
                }
            }

        }
    }
    var
        AttachmentDaysEditableG: Boolean;
        AdditionalDaysActionEditableG: Boolean;
        ProbationActionEditableG: Boolean;
        NoticePeriodActionEditableG: Boolean;
        MaxAccrualDaysEditable: Boolean;

    local procedure MakeEditable()
    begin
        AttachmentDaysEditableG := Rec."Attachment Required";
        AdditionalDaysActionEditableG := Rec."Additional Days";
        ProbationActionEditableG := Rec."Allow in Probation";
        NoticePeriodActionEditableG := Rec."Allow in Notice Period";
        MaxAccrualDaysEditable := Rec.Accrual;
    end;

    trigger OnOpenPage()
    begin
        MakeEditable();
    end;

    trigger OnAfterGetRecord()
    begin
        MakeEditable();
    end;


}