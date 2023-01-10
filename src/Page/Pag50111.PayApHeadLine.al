page 50111 "Pay Ap HeadLine"
{
    Caption = 'Pay Ap HeadLine';
    PageType = HeadlinePart;
    RefreshOnActivate = true;
    layout
    {
        area(Content)
        {
            group(Greeting)
            {
                field("Greeting Text"; RCHeadlinesPageCommon.GetGreetingText())
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = UserGreetingVisible;
                    ToolTip = 'Specifies the value of the GetGreetingText()';
                }
                field("Pay App"; PayApp)
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = UserGreetingVisible;
                    ToolTip = 'Specifies the value of the PayApp';
                    trigger OnDrillDown()
                    begin
                        Hyperlink(PayAppUrlTxt);
                    end;
                }
            }
        }
    }
    var
        RCHeadlinesPageCommon: Codeunit "RC Headlines Page Common";
        HeadlineManagement: Codeunit Headlines;
        PayApp: Text;
        UserGreetingVisible: Boolean;
        PayAppUrlTxt: Label 'https://aplicatech.com/microsoft-dynamics-365-gcc-payroll/';

    trigger OnOpenPage()
    begin
        RCHeadlinesPageCommon.HeadlineOnOpenPage(Page::"Pay Ap HeadLine");
        UserGreetingVisible := RCHeadlinesPageCommon.IsUserGreetingVisible();
        HeadlineManagement.GetHeadlineText('Want to know more about', HeadlineManagement.Emphasize('PayApp HR & Payroll solution ?'), PayApp);
    end;
}