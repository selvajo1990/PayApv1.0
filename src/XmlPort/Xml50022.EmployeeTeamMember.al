xmlport 50022 "Employee Team Member"
{
    Direction = Export;
    Format = Xml;
    UseDefaultNamespace = true;
    schema
    {
        textelement(EmployeeTeamMember)
        {
            tableelement(EmployeeTeam; "Designation")
            {
                UseTemporary = true;
                fieldelement(JobCode; EmployeeTeam."Designation Code")
                {

                }
                fieldelement(EmployeeNo; EmployeeTeam."Employee No.")
                {

                }
                textelement(Name)
                {

                }
                fieldelement(Department; EmployeeTeam.Department)
                {

                }
                fieldelement(ReportingTo; EmployeeTeam."Reporting To")
                {

                }
                fieldelement(JobTitle; EmployeeTeam.Description)
                {

                }
                textelement(Dob)
                {

                }
                textelement(EmploymentDate)
                {

                }
                textelement(Gender)
                {

                }
                textelement(TeamCount)
                {
                    trigger OnBeforePassVariable()
                    var
                        DesignationL: Record Designation;
                    begin
                        TeamCount := '0';
                        DesignationL.SetRange("Reporting To", EmployeeTeam."Designation Code");
                        DesignationL.SetRange("Position Assigned", true);
                        if not DesignationL.IsEmpty() then
                            TeamCount := Format(DesignationL.Count());
                    end;
                }
                textelement(EmpPicture)
                {
                    TextType = BigText;
                    trigger OnBeforePassVariable()
                    var
                        EmployeeL: Record Employee;
                        EmployeeReplicaL: Record "Employee ATG";
                        TempBlobL: Codeunit "Temp Blob";
                        Base64: Codeunit "Base64 Convert";
                        OutStreamL: OutStream;
                        InStreamL: InStream;
                    begin
                        Clear(TempBlobL);
                        Clear(EmpPicture);
                        EmployeeReplicaL.Get(EmployeeTeam."Employee No.");
                        EmployeeL.ChangeCompany(EmployeeReplicaL."Company ATG");
                        EmployeeL.Get(EmployeeTeam."Employee No.");
                        if EmployeeL.Image.HasValue() then begin
                            TempBlobL.CreateOutStream(OutStreamL);
                            EmployeeL.Image.ExportStream(OutStreamL);
                            TempBlobL.CreateInStream(InStreamL);
                            EmpPicture.AddText(Base64.ToBase64(InStreamL));
                        end;
                    end;

                }
                trigger OnAfterGetRecord()
                var
                    EmployeeL: Record Employee;
                    EmployeeReplicaL: Record "Employee ATG";
                begin
                    // EmployeeTeam.CalcFields("Employee No.");
                    EmployeeReplicaL.Get(EmployeeTeam."Employee No.");
                    EmployeeL.ChangeCompany(EmployeeReplicaL."Company ATG");
                    EmployeeL.Get(EmployeeTeam."Employee No.");
                    Dob := format(EmployeeL."Birth Date");
                    EmploymentDate := Format(EmployeeL."Employment Date");
                    Gender := Format(EmployeeL.Gender);
                    Name := EmployeeL.FullName();
                end;
            }
        }
    }
    procedure InsertTemp(var DesignationP: Record Designation)
    begin
        EmployeeTeam.Init();
        EmployeeTeam.ChangeCompany(DesignationP.CurrentCompany());
        EmployeeTeam := DesignationP;
        EmployeeTeam.Insert();
    end;
}