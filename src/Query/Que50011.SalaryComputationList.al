query 50011 "Salary Computation List"
{
    elements
    {
        dataitem(SalaryComputationLine; "Salary Computation Line")
        {
            column(Employee_No_; "Employee No.")
            {

            }
            column(Employee_Name; "Employee Name")
            {

            }
            column(Salary_Class; "Salary Class")
            {

            }
            column(Pay_Period; "Pay Period")
            {

            }
            filter(Employee_No_Filter; "Employee No.")
            {

            }

        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}