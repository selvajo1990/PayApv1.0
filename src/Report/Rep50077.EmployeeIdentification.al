report 50077 "Employee Identification"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    RDLCLayout = './res/EmployeeIdentification.rdl';

    dataset
    {
        dataitem("Employee Level Identification"; "Employee Level Identification")
        {
            DataItemTableView = sorting("Employee No.", Code, "Line No");
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
            column(Employee_Name; "Employee Name")
            {

            }
            column(Issued_Date; "Issued Date")
            { }
            column(Expiry_Date; "Expiry Date")
            { }
            column(Code; Code)
            { }
            column(Description; Description)
            { }
            column(AgencyName; AgencyName)
            { }
            column(SI; SI)
            { }
            column(FilterDes; FilterDes)
            {

            }
            column(Serial_No_; "Serial No.")
            { }
            trigger OnPreDataItem()
            begin
                if Identification <> '' then
                    Setfilter(Code, Identification);
                SetRange("Expiry Date", FromDate, Todate);
            end;

            trigger OnAfterGetRecord()
            begin
                SI += 1;
                FilterDes := '';
                AgencyName := '';
                EmployeeR.Get("Employee No.");
                IssueAgency.reset();
                IssueAgency.setrange("Issuing Agency Code", "Issuing Agency");
                if IssueAgency.FindFirst() then
                    AgencyName := IssueAgency.Description;

                FilterDes := 'Expiry Details from ' + FORMAT(FromDate, 0, '<Day,2>-<Month TEXT,3>-<Year,2>') + ' To ' + FORMAT(ToDate, 0, '<Day,2>-<Month TEXT,3>-<Year,2>');
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group("Identification Filter")
                {
                    field("From Date"; FromDate)
                    {
                        ApplicationArea = All;
                        Caption = 'From Date';
                        ToolTip = 'Specifies the value of the From Date';

                    }
                    field("To date"; Todate)
                    {
                        ApplicationArea = all;
                        Caption = 'To Date';
                        ToolTip = 'Specifies the value of the To Date';
                    }
                    field("Identification1"; Identification)
                    {
                        ApplicationArea = all;
                        CAption = 'Identification Type';
                        TableRelation = Identification;
                        ToolTip = 'Specifies the value of the Identification Type';
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

        If (FromDate = 0D) or (Todate = 0D) then
            Error(DateFilterErr);


    end;

    var
        IssueAgency: record "Issuing Agency";
        CompanyInformationG: Record "Company Information";
        EmployeeR: record "Employee";
        DateFilterErr: Label 'From Date or To Date should have some value';
        FromDate: Date;
        Todate: Date;
        AgencyName: text;
        SI: Integer;
        Identification: Text;
        FilterDes: text;
}