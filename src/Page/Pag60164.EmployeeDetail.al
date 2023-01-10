page 60164 "Employee Detail"
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Employee Information";
    AutoSplitKey = true;
    DelayedInsert = true;

    layout
    {
        area(Content)
        {

            repeater(GroupName1)
            {
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Type';
                    trigger OnValidate()
                    begin
                        if Rec.type = Rec.type::self then
                            Fieldeditable := false
                        else
                            Fieldeditable := true;
                    end;

                }
                field("Personal Number"; Rec."Personal Number")
                {

                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Personal Number';

                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Employee Name';
                }
                Field(Relationship; Rec.Relationship)
                {
                    ApplicationArea = All;
                    Editable = Fieldeditable;
                    ToolTip = 'Specifies the value of the Relationship';
                }
                field(Dependent; Rec.Dependent)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Dependent';
                }

                field("From Date"; Rec."From Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the From Date';
                }
                field("To Date"; Rec."To Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the To Date';
                }
                field("Insurance Card"; Rec."Insurance Card")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Insurance Card';
                }
                field("Card No."; Rec."Card No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Card No.';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Amount';
                }
            }
        }

    }

    var
        Fieldeditable: boolean;

    trigger oninit()
    begin

    end;

    trigger OnOpenPage()
    begin
        if Rec.type = Rec.Type::Self then
            Fieldeditable := false
        else
            Fieldeditable := true;
    end;

    trigger OnAfterGetRecord()
    begin
        if Rec.type = Rec.Type::Self then
            Fieldeditable := false
        else
            Fieldeditable := true;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        if Rec.type = Rec.Type::Self then
            Fieldeditable := false
        else
            Fieldeditable := true;

    end;

}