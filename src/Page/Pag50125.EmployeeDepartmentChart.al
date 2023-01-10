page 50125 "Employee Department Chart"
{
    PageType = CardPart;
    ApplicationArea = all;
    UsageCategory = Administration;
    Caption = 'Employee Department Chart';
    layout
    {
        area(Content)
        {
            /* field(StatusText; StatusText)
            {
                Caption = 'Status Text';
                ApplicationArea = All;
                ShowCaption = false;
                Enabled = false;
            } */

            usercontrol(BusinessChart; "Microsoft.Dynamics.Nav.Client.BusinessChart")
            {
                ApplicationArea = All;
                trigger AddInReady()
                begin
                    IsChartAddInReady := true;
                    UpdateChart();
                end;

                trigger Refresh()
                begin
                    if IsChartAddInReady then
                        UpdateChart();
                end;

                trigger DataPointClicked(point: JsonObject)
                begin

                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        StatusText := 'Title';
    end;

    procedure UpdateChart()
    begin
        if not IsChartAddInReady then
            exit;

        ChartMgmt.UpdateEmployeeDepartmentData(BusinessChartBuffer);
        BusinessChartBuffer.Update(CurrPage.BusinessChart);

    end;

    var
        BusinessChartBuffer: Record "Business Chart Buffer";
        ChartMgmt: Codeunit "Employee Chart Mgmt";
        StatusText: Text;
        IsChartAddInReady: Boolean;
}