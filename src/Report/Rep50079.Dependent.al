report 50079 "Dependent"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    RDLCLayout = './res/Dependence.rdl';

    dataset
    {
        dataitem(EmployeeRelative; "Employee Relative")
        {
            RequestFilterFields = "Employee No.";
            DataItemTableView = sorting("Employee No.", "Line No.");
            column(CompanyInformationG_Name; CompanyInformationG.Name)
            { }
            column(CompanyInformationG_Picture; CompanyInformationG.Picture)
            { }
            column(CompanyInformationG_Address; CompanyInformationG.Address)
            { }
            column(CompanyInformationG_Address2; CompanyInformationG."Address 2")
            { }
            column(CompanyInformationG_Phone; CompanyInformationG."Phone No.")
            { }
            column(CompanyInformationG_Email; CompanyInformationG."E-Mail")
            { }
            column(Employee_No_; "Employee No.")
            {

            }
            column(Emergency_Contact; "Emergency Contact")
            {

            }
            column(Air_Ticket; "Air Ticket")
            {

            }
            column(Relative_Code; "Relative Code")
            {

            }
            column(First_Name; "First Name")
            {

            }
            column(Birth_Date; "Birth Date")
            {

            }
            column(Gender; Gender)
            { }
            column(Line_No_; "Line No.")
            { }
            column(EmployeeName; EmployeeName)
            { }
            trigger OnAfterGetRecord()
            begin
                EmployeeName := '';
                EmployeeL.Get("Employee No.");
                EmployeeName := EmployeeL."First Name" + ' ' + EmployeeL."Last Name";

            end;
        }
    }
    trigger OnPreReport()
    begin
        CompanyInformationG.get();
        CompanyInformationG.CalcFields(Picture);
    end;

    var
        EmployeeL: Record Employee;
        CompanyInformationG: Record "Company Information";
        EmployeeName: Text;
}