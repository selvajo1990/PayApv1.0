page 60178 "ESS Headline"
{
    PageType = HeadlinePart;
    RefreshOnActivate = true;
    layout
    {
        area(Content)
        {
            group(Welcome)
            {
                field("Welcome Text"; WelcomeText)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        WelcomeText: Text;

    trigger OnOpenPage()
    var
        UserSetupL: Record "User Setup";
        EmployeeL: Record Employee;
        SingleIns: Codeunit "Single Instance";
    begin
        if (UserSetupL.Get()) and (UserSetupL."Is ESS User") then
            EmployeeL.Reset();
        EmployeeL.SetRange("No.", SingleIns.GetEmpNo());
        if EmployeeL.FindFirst() then
            WelcomeText := 'Welcome  ' + EmployeeL.FullName();
    end;
}