page 50098 "Timing"
{
    PageType = Document;
    SourceTable = Timing;
    Caption = 'Timing';
    UsageCategory = None;
    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Calendar ID"; Rec."Calendar ID")
                {
                    ApplicationArea = All;
                    AssistEdit = true;
                    ToolTip = 'Specifies the value of the Calendar ID';
                    trigger OnAssistEdit()
                    begin
                        Rec.AssisEdit();
                    end;
                }
                field("From Date"; Rec."From Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the From Date';
                }
                field("Week Day"; Rec."Week Day")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Week Day';
                }
                field("No. of Working Days"; Rec."No. of Working Days")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. of Working Days';
                }
                field("No. of Weekend Days"; Rec."No. of Weekend Days")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. of Weekend Days';
                }
                group(HideSWD)
                {
                    Caption = '';
                    Editable = Rec."Starting No. of Weekend Day" = 0;
                    field("Starting No. of Working Day"; Rec."Starting No. of Working Day")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Starting No. of Working day';
                    }
                }
                group(HideSWO)
                {
                    Caption = '';
                    Editable = Rec."Starting No. of Working Day" = 0;
                    field("Starting No. of Weekend Day"; Rec."Starting No. of Weekend Day")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Starting No. of Weekend Day';
                    }

                }
            }
            part("Working Hours"; "Working Hour Subpage")
            {
                Caption = 'Working Hours';
                SubPageLink = "Calendar ID" = field("Calendar ID");
                ApplicationArea = all;
            }
            part("Update Holiday"; "Update Holiday Subpage")
            {
                Caption = 'Update Holiday';
                SubPageLink = "Calendar ID" = field("Calendar ID");
                ApplicationArea = all;
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Generate Template")
            {
                Caption = 'Generate Template';
                Image = Template;
                ApplicationArea = all;
                ToolTip = 'Executes the Generate Template action.';
                trigger OnAction()
                begin
                    Rec.GenerateTemplate();
                end;
            }

        }
    }

}