report 50074 Loan
{
    UsageCategory = Administration;
    ApplicationArea = All;
    RDLCLayout = './res/Loan.rdl';

    dataset
    {
        dataitem("Loan Request"; "Loan Request")
        {
            DataItemTableView = sorting("Loan Request No.");
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
            column(LoanType; LoanType)
            {

            }
            column(Loan_Description; "Loan Description")
            {

            }
            column(Loan_Request_No_; "Loan Request No.")
            {

            }
            column(Amount; Amount)
            {

            }
            column(Instalment_Amount; "Instalment Amount")
            {

            }
            column(No__of_Instalment; "No. of Instalment")
            {

            }
            column(Notes; Notes)
            {

            }
            column(Paid_Amount; "Paid Amount")
            {

            }
            column(Unpaid_Amount; "Unpaid Amount")
            {

            }
            column(lastdeductiondate; lastdeductiondate)
            {

            }
            column(LastInstalmentDate; LastInstalmentDate)
            {

            }

            trigger OnPreDataItem()
            begin
                if "Personal Number" <> '' then
                    Setfilter("Employee No.", "Personal Number");

                if LoanType <> '' then
                    SetRange("Loan Type", LoanType);

                if ("From Date" <> 0D) and ("To Date" <> 0D) then
                    SetRange("Requested date", "From Date", "To Date");

            end;

            trigger OnAfterGetRecord()
            begin
                "Paid Amount" := 0;
                "Unpaid Amount" := 0;
                LastInstalmentDate := 0D;
                lastdeductiondate := 0D;
                instalmentDetails.Reset();
                instalmentDetails.SetRange("Loan Request No.", "Loan Request No.");
                if instalmentDetails.FindSet() then
                    repeat
                        if instalmentDetails.Status = instalmentDetails.Status::Paid then begin
                            "Paid Amount" += instalmentDetails."Deduction Amount";
                            lastdeductiondate := instalmentDetails."Deduction Date";

                        end else
                            if instalmentDetails.Status = instalmentDetails.Status::Unpaid then
                                "Unpaid Amount" += instalmentDetails."Deduction Amount";

                        LastInstalmentDate := instalmentDetails."Deduction Date";
                    until instalmentDetails.Next() = 0;
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
                    field("Loan Type"; LoanType)
                    {
                        ApplicationArea = All;
                        TableRelation = "Loan";
                        ToolTip = 'Specifies the value of the LoanType';

                    }
                    field("PersonalNumber"; "Personal Number")
                    {
                        ApplicationArea = all;
                        ToolTip = 'Specifies the value of the Personal Number';
                        // TableRelation = Employee;
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
                                "Personal Number" := EmployeeList.GetSelectionFilter();

                            end;
                        end;

                    }
                    field("FromDate"; "From Date")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the From Date';

                    }
                    field("ToDate"; "To Date")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the To Date';

                    }
                }
            }
        }
    }
    trigger OnPreReport()
    begin
        CompanyInformationG.get();
        CompanyInformationG.CalcFields(Picture);
    end;

    var
        CompanyInformationG: Record "Company Information";

        instalmentDetails: Record "Instalment Detail";
        "From Date": Date;
        "To Date": Date;
        LoanType: Text;
        "Personal Number": Text;
        "Paid Amount": Decimal;
        "Unpaid Amount": Decimal;
        lastdeductiondate: Date;
        LastInstalmentDate: Date;

}