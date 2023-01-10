page 50067 "Pay Period Subpage"
{
    PageType = ListPart;
    SourceTable = "Pay Period Line";
    Caption = 'Pay Period Lines';
    AutoSplitKey = true;
    DelayedInsert = true;
    DeleteAllowed = false;
    InsertAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Period Start Date"; Rec."Period Start Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Period Start Date';
                }
                field("Period End Date"; Rec."Period End Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Period End Date';
                }
                field("Pay Period"; Rec."Pay Period")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Pay Period';
                }
                field(Staus; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Status';
                }
                field(Comments; Rec.Comments)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Comments';
                }
            }
        }
    }
    actions
    {

        area(Processing)
        {
            action("Generate Pay Period")
            {
                Promoted = true;
                PromotedOnly = true;
                PromotedIsBig = true;
                Image = CreateSerialNo;
                PromotedCategory = Process;
                ApplicationArea = all;
                ToolTip = 'Executes the Generate Pay Period action.';
                trigger OnAction()
                var
                    PayPeriodLineL: Record "Pay Period Line";
                    PageFilterL: FilterPageBuilder;
                    FilterViewL: Text;
                    FilterRequiredErr: Label 'You have to provide the value to create pay period';
                    OnlyNumberErr: Label '%1 should have integer value';
                    OnlyDateErr: Label '%1 should have valid date';
                    PayPeriodErr: Label 'Pay Period created for %1 month';
                    EmptyFilterErr: Label 'Both field should have valid value';
                    NoofPeriodL: Integer;
                    PeriodStartDateL: Date;
                    PeriodEndDateL: Date;
                    LineNoL: Integer;
                    CounterL: Integer;
                begin
                    PageFilterL.AddRecord('Pay Period Filter', PayPeriodLineL);
                    PageFilterL.AddField('Pay Period Filter', PayPeriodLineL."No. of Period");
                    PageFilterL.AddField('Pay Period Filter', PayPeriodLineL."Period Start Date");
                    if PageFilterL.RunModal() then begin
                        FilterViewL := PageFilterL.GETVIEW('Pay Period Filter');
                        IF STRPOS(FilterViewL, 'WHERE') = 0 THEN
                            ERROR(FilterRequiredErr);
                        PayPeriodLineL.SetView(FilterViewL);
                        if not Evaluate(PeriodStartDateL, PayPeriodLineL.GetFilter("Period Start Date")) then
                            Error(OnlyDateErr, PayPeriodLineL.FieldCaption("Period Start Date"));
                        if not Evaluate(NoofPeriodL, PayPeriodLineL.GetFilter("No. of Period")) then
                            Error(OnlyNumberErr, PayPeriodLineL.FieldCaption("No. of Period"));

                        if (PeriodStartDateL = 0D) or (NoofPeriodL <= 0) then
                            Error(EmptyFilterErr);

                        PayPeriodLineL.Reset();
                        PayPeriodLineL.SetCurrentKey("Pay Cycle", "Period Start Date");
                        PayPeriodLineL.SetRange("Pay Cycle", Rec."Pay Cycle");
                        if PayPeriodLineL.FindLast() then
                            PeriodStartDateL := CalcDate('<1D>', PayPeriodLineL."Period End Date");

                        for CounterL := 1 to NoofPeriodL do begin
                            LineNoL += 10000;
                            PayPeriodLineL.Reset();
                            PayPeriodLineL."Pay Cycle" := Rec."Pay Cycle";
                            PayPeriodLineL."Period Start Date" := PeriodStartDateL;
                            PeriodEndDateL := CalcDate('<1M-1D>', PeriodStartDateL);
                            PeriodStartDateL := CalcDate('<1D>', PeriodEndDateL);
                            PayPeriodLineL."Pay Period" := FORMAT(PeriodEndDateL, 0, '<Month Text>') + '-' + format(Date2DMY(PeriodEndDateL, 3));
                            PayPeriodLineL."Period End Date" := PeriodEndDateL;
                            PayPeriodLineL.Insert();
                        end;
                    end;
                    Message(PayPeriodErr, NoofPeriodL);
                end;
            }
            action("Clear Pay Period")
            {
                Promoted = true;
                ApplicationArea = all;
                PromotedIsBig = true;
                PromotedOnly = true;
                Image = ClearLog;
                PromotedCategory = Process;
                ToolTip = 'Executes the Clear Pay Period action.';
                trigger OnAction()
                var
                    PayPeriodLineL: Record "Pay Period Line";
                    DeleteConfirmQst: Label 'You want to delete all the lines ?';
                begin
                    if Confirm(DeleteConfirmQst, false) then begin
                        PayPeriodLineL.SetRange("Pay Cycle", Rec."Pay Cycle");
                        PayPeriodLineL.DeleteAll(true);
                    end;
                end;
            }
        }
    }
    trigger OnOpenPage()
    begin
        Rec.SetCurrentKey("Period Start Date");
    end;
}