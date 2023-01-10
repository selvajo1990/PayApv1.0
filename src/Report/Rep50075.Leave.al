report 50075 "Leave"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    RDLCLayout = './res/Leave.rdl';
    DefaultLayout = RDLC;
    dataset
    {
        dataitem("Leave Request"; "Leave Request")
        {
            DataItemTableView = sorting("No.");
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
            column(No; "No.")
            {

            }
            column(SI; SI)
            { }
            column(Employee_No_; "Employee No.")
            {

            }
            column(Employee_Name; "Employee Name")
            {

            }
            column(DepartmentName; DepartmentName)
            { }
            column(AbsenceDescription; AbsenceDescription)
            {

            }
            column(Start_Date; "Start Date")
            {

            }
            column(End_Date; "End Date")
            {

            }
            column(Leave_Days; "Leave Days")
            {

            }

            column(Status; Status)
            {

            }
            column(FilterDes; FilterDes)
            {

            }

            trigger OnPreDataItem()
            begin
                if "PersonalNumber" <> '' then
                    Setfilter("No.", "PersonalNumber");
                if (FromDate <> 0D) and (ToDate <> 0D) then
                    SetRange("Start Date", FromDate, ToDate);
                if AbsenceType <> '' then
                    Setfilter("Absence Code", AbsenceType);

            end;

            trigger OnAfterGetRecord()
            begin
                AbsenceDescription := '';
                DepartmentName := '';
                SI += 1;
                FilterDes := '';

                EmployeeR.Get("Employee No.");

                AbsenceR.reset();
                AbsenceR.setrange("Employee No.", "Employee No.");
                AbsenceR.SetRange("Absence Code", "Absence Code");
                if AbsenceR.FindFirst() then
                    AbsenceDescription := AbsenceR."Absence Description";

                EmployeeLevelDesigR.reset();
                EmployeeLevelDesigR.SetRange("Employee No.", EmployeeR."No.");
                EmployeeLevelDesigR.SetRange("Primary Position", true);
                if EmployeeLevelDesigR.Findfirst() then begin
                    departmentR.Get(EmployeeLevelDesigR.Department);
                    DepartmentName := departmentR.Description;
                end;
                FilterDes := 'Leave details from ' + format(FromDate, 0, '<Day,2>-<Month TEXT,3>-<Year,2>') + ' to ' + Format(ToDate, 0, '<Day,2>-<Month TEXT,3>-<Year,2>');
            end;
        }

    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Parameter)
                {


                    field("From Date"; FromDate)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the FromDate';

                    }
                    field("To Date"; ToDate)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the ToDate';

                    }
                    field("Absence Type"; AbsenceType)
                    {
                        TableRelation = Absence;
                        ApplicationArea = all;
                        ToolTip = 'Specifies the value of the AbsenceType';
                    }
                    field("Employee No."; PersonalNumber)
                    {
                        ApplicationArea = all;
                        ToolTip = 'Specifies the value of the PersonalNumber';
                        // TableRelation = Employee."No.";
                        trigger OnLookup(var Text: Text): Boolean
                        var
                            EmployeeL: Record Employee;
                            EmployeeList: Page "Employee List";
                        begin
                            EmployeeL.reset();
                            clear(EmployeeList);
                            EmployeeList.SetRecord(EmployeeL);
                            EmployeeList.SetTableView(EmployeeL);
                            EmployeeList.LookupMode(true);
                            if EmployeeList.RunModal() = Action::LookupOK then begin
                                EmployeeList.SetSelection(EmployeeL);
                                PersonalNumber := EmployeeList.GetSelectionFilter();
                            end;
                        end;

                    }
                }
            }
        }
    }
    trigger OnPreReport()
    begin
        SI := 0;
        CompanyInformationG.get();
        CompanyInformationG.CalcFields(Picture);

    end;

    var
        EmployeeR: record Employee;
        AbsenceR: record "Employee Level Absence";
        EmployeeLevelDesigR: record "Employee Level Designation";
        departmentR: record Department;
        CompanyInformationG: Record "Company Information";

        FromDate: Date;
        ToDate: Date;
        PersonalNumber: Text;
        AbsenceType: Text;
        AbsenceDescription: text;
        DepartmentName: text;
        FilterDes: text;
        SI: Integer;

}