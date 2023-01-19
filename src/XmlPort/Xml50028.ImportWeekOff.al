xmlport 50028 "Import Week Off"
{
    Direction = Import;
    Format = VariableText;
    //UseDefaultNamespace = true;
    //UseRequestPage = false;
    FieldSeparator = ',';
    FileName = 'Week Off List.csv';


    schema
    {
        textelement(root)
        {
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

                trigger OnBeforeInsertRecord()
                begin
                    WeeklyOff.Updated := false;
                end;
            }
        }
    }

    trigger OnPostXmlPort()
    begin
        Message('Weekly Off Updated.');

    end;

    var
        myInt: Integer;
}