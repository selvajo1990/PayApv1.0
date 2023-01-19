xmlport 50027 "Export Week Off"
{
    Direction = Export;
    Format = VariableText;
    //UseDefaultNamespace = true;
    //UseRequestPage = false;
    FieldSeparator = ',';
    FileName = 'Week Off List.csv';

    schema
    {
        textelement(root)
        {
            tableelement(Heading; Integer)
            {
                SourceTableView = where(Number = const(1));
                textelement(txtEmployeeNo) { }
                textelement(txtEmployeeName) { }
                textelement(txtWeekOffDate) { }
            }

            tableelement(WeeklyOff; "Weekly Off")
            {
                //UseTemporary = true;
                fieldattribute(EmployeeNo; WeeklyOff."Employee No.")
                {

                }
                fieldattribute(EmployeeName; WeeklyOff."Employee Name")
                {

                }
                fieldattribute(WeekOffDate; WeeklyOff."Week Off Date")
                {

                }
            }
        }
    }

    trigger OnInitXmlPort()
    begin
        txtEmployeeNo := 'Employee No.';
        txtEmployeeName := 'Employee Name';
        txtWeekOffDate := 'Week Off Date';
    end;

    var
        myInt: Integer;
}