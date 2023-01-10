page 60176 "ESS Role Center"
{
    PageType = RoleCenter;
    ApplicationArea = All;
    UsageCategory = Administration;
    Caption = 'ESS';

    layout
    {
        area(RoleCenter)
        {
            group(Group1)
            {
                part("ESS Headline"; "ESS Headline")
                {
                    ApplicationArea = All;
                }
                part("Employee Cue"; "ESS Cue")
                {
                    ApplicationArea = Basic, Suite;
                }
                part(Part; "Employee Leave Chart")
                {
                    ApplicationArea = All;

                }
            }
        }
    }

    actions
    {
        area(Embedding)
        {
            action(SalarySlip)
            {
                ApplicationArea = All;
                Caption = 'Salary Slip';
                RunObject = report "Salary Slip";
                //trigger OnAction()
                //begin
                //sess
                //end;
            }
            action(LeaveRequest)
            {
                ApplicationArea = All;
                Caption = 'Leave Request';
                RunObject = page "Leave Request List";
            }
        }
    }

}