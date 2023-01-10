page 50049 "Absence Group Subpage"
{
    PageType = ListPart;
    SourceTable = "Absence Group Line";
    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Absence Code"; Rec."Absence Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Absence Code';
                }
                field("Absence Description"; Rec."Absence Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Absence Description';
                }
                field("Assigned Days"; Rec."Assigned Days")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Assigned Days';
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
                field("Maximum Carry Forward Days"; Rec."Maximum Carry Forward Days")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Maximum Carry Forward Days';
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