xmlport 50021 "Employee List"
{
    Direction = Export;
    Format = Xml;
    UseDefaultNamespace = true;
    UseRequestPage = false;
    schema
    {
        textelement(EmployeeList)
        {
            tableelement(Employee; Employee)
            {
                UseTemporary = true;
                fieldelement(EmployeeNo; Employee."No.")
                { }
                fieldelement(Name; Employee."First Name")
                { }
                fieldelement(LastName; Employee."Last Name")
                { }
                fieldelement(Address; Employee.Address)
                {

                }
                fieldelement(Address2; Employee."Address 2")
                {

                }
                fieldelement(PhoneNo; Employee."Phone No.")
                {

                }
                fieldelement(BirthDate; Employee."Birth Date")
                {

                }
                fieldelement(Gender; Employee.Gender)
                {

                }
                fieldelement(Religion; Employee.Religion)
                {

                }
                fieldelement(MaritalStatus; Employee."Marital Status")
                {

                }
                fieldelement(NoOfDependent; Employee."No. of Dependent")
                {

                }
                fieldelement(Email; Employee."E-Mail")
                {

                }
                fieldelement(BankAccountNo; Employee."Bank Account No.")
                {

                }
                fieldelement(BankBranchNo; Employee."Bank Branch No.")
                {

                }
                fieldelement(SalaryClass; Employee."Salary Class")
                {

                }
                fieldelement(JobCode; Employee."Job Code")
                {

                }
                fieldelement(JobTitle; Employee."Job Title")
                {

                }
                textelement(EmpPicture)
                {
                    TextType = BigText;
                    trigger OnBeforePassVariable()
                    var
                        EmployeeL: Record Employee;
                        TempBlobL: Codeunit "Temp Blob";
                        Base64: Codeunit "Base64 Convert";
                        OutStreamL: OutStream;
                        InStreamL: InStream;
                    begin
                        Clear(TempBlobL);
                        EmployeeL.ChangeCompany(CompanyNameG);
                        EmployeeL.Get(Employee."No.");
                        if EmployeeL.Image.HasValue() then begin
                            TempBlobL.CreateOutStream(OutStreamL);
                            EmployeeL.Image.ExportStream(OutStreamL);
                            TempBlobL.CreateInStream(InStreamL);
                            EmpPicture.AddText(Base64.ToBase64(InStreamL));
                        end;
                    end;
                }
                textelement(TeamMemberCount)
                {
                    trigger OnBeforePassVariable()
                    var
                        DesignationL: Record Designation;
                    begin
                        if Employee."Job Code" > '' then begin
                            // DesignationL.ChangeCompany(CompanyNameG);
                            // DesignationL.SetAutoCalcFields("Employee No.");
                            DesignationL.SetRange("Reporting To", Employee."Job Code");
                            DesignationL.SetFilter("Employee No.", '>%1', '');
                            TeamMemberCount := format(DesignationL.Count());
                        end;
                    end;
                }
                textelement(TenureDays)
                {
                    trigger OnBeforePassVariable()
                    begin
                        if Employee."Employment Date" > 0D then
                            TenureDays := format(Today() - Employee."Employment Date" + 1);
                    end;
                }
            }
        }
    }
    var
        CompanyNameG: Text;

    procedure InsertTemp(var EmployeeP: Record Employee)

    begin
        Employee := EmployeeP;
        CompanyNameG := EmployeeP.CurrentCompany();
    end;
}