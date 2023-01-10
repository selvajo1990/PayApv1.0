xmlport 50023 "Salary Computation List"
{
    Direction = Export;
    Format = Xml;
    UseDefaultNamespace = true;
    UseRequestPage = false;
    schema
    {
        textelement(SalaryComputationList)
        {
            tableelement(SalaryComputationLine; "Salary Computation Line")
            {
                UseTemporary = true;
                fieldattribute(EmpNo; SalaryComputationLine."Employee No.")
                {

                }
                fieldattribute(EmpName; SalaryComputationLine."Employee Name")
                {

                }
                fieldattribute(SalaryClass; SalaryComputationLine."Salary Class")
                {

                }
                fieldattribute(PayPeriod; SalaryComputationLine."Pay Period")
                {

                }
            }
        }
    }
    procedure InsertTemp(SalaryComputationLineP: Record "Salary Computation Line")
    begin
        SalaryComputationLine.Init();
        SalaryComputationLine := SalaryComputationLineP;
        SalaryComputationLine.Insert();
    end;

}