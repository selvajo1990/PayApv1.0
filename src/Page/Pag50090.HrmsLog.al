page 50090 "Hrms Log"
{
    PageType = List;
    SourceTable = "HRMS Log";
    Editable = false;
    Caption = 'Reporting To Histroy';
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Record ID"; format(Rec."Record ID"))
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Record ID)';
                }
                field("Field Name"; Rec."Field Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Field Name';
                }
                field("Field Value"; Rec."Field Value")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Field Value';
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
            }
        }
    }

}