page 60002 "Workflow Group ATG"
{
    PageType = Document;
    SourceTable = "Workflow Group ATG";
    Caption = 'Workflow Group ATG';
    UsageCategory = None;
    layout
    {
        area(Content)
        {
            field(Code; Rec.Code)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Code';
            }
            field(Description; Rec.Description)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Description';
            }
            part("Workflow Group Members"; "Workflow Group Member ATG")
            {
                ApplicationArea = all;
                SubPageLink = "Workflow Group Code" = field(Code);
            }
        }
    }
}