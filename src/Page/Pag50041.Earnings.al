page 50041 "Earnings"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    CardPageId = "Earning Card";
    SourceTable = "Earning";
    Editable = false;
    Caption = 'Earnings';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Earning Code';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description';
                }
                field(Category; Rec.Category)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Category';
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Type';
                }
                /*field("Applicable for OT"; "Applicable for OT")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the component is Applicable for OT';
                }
                field("OT% for Normal Days"; "OT% for Normal Days")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the OT% for Normal Days';
                }
                field("OT% for Holidays"; "OT% for Holidays")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the OT% for Holidays';
                }*/
            }
        }
        area(Factboxes)
        {
        }
    }
}
