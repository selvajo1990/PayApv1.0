page 50046 "Absence List"
{
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = Absence;
    CardPageId = "Absence Card";
    Caption = 'Absences';
    Editable = false;
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
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description';
                }
                field("Assigned Days"; Rec."Assigned Days")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Assigned Days';
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Type';
                }
                field(Religion; Rec.Religion)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Religion';
                }
                field(Nationality; Rec.Nationality)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Nationality';
                }
                field(Gender; Rec.Gender)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Gender';
                }
            }
        }
        area(Factboxes)
        {

        }
    }

}