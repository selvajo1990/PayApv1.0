page 60175 "Employee Login"
{
    Caption = 'Employee Login';
    PageType = Card;
    UsageCategory = None;
    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Employee No"; EmployeeNoG)
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                    TableRelation = Employee."No.";
                }
                field(Password; PasswordG)
                {
                    ApplicationArea = All;
                    ExtendedDatatype = Masked;
                    ShowMandatory = true;
                }
            }
        }
    }

    var
        GetEpmNoCU: Codeunit "Single Instance";
        EmployeeNoG: Code[20];
        PasswordG: Text[20];


    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        EmployeeL: Record Employee;
    begin
        if CloseAction = CloseAction::LookupCancel then
            Error('');

        if (EmployeeNoG = '') or (PasswordG.Trim() = '') then
            Error('Provide both Employee No. & Password to continue');

        EmployeeL.Reset();
        //EmployeeL.SetRange("No.", EmployeeNoG);
        //EmployeeL.SetRange(Password, PasswordG);
        //if not EmployeeL.FindFirst() then
        if EmployeeL.Get(EmployeeNoG) and (EmployeeL.Password <> PasswordG) then
            //if EmployeeL.FindFirst() then begin
            //if PasswordG <> EmployeeL.Password then
            Error('Please Enter the correct Password to continue');
        //end;


        GetEpmNoCU.SetEmpNo(EmployeeNoG);
        exit(true);
    end;

}