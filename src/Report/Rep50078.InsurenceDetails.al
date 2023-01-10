report 50078 "Insurence Details"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    RDLCLayout = './res/InsuranceDetails.rdl';

    dataset
    {
        dataitem("Insurance Information"; "Insurance Information")
        {
            DataItemTableView = sorting("Level in Insurance Code", "Type of Insurance Code", "From Date", "To Date", "Insurance Amount");
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
            column(No_; "No.")
            {

            }
            column(Insurance_Amount; "Insurance Amount")
            { }
            column(Type_of_Insurance_Code; "Type of Insurance Code")
            {

            }
            column(Type_of_Insurance_Description; "Type of Insurance Description") { }
            column(Level_in_Insurance_Code; "Level in Insurance Code") { }
            column(Level_in_Insurance_Description; "Level in Insurance Description") { }
            column(From_Date; "From Date") { }
            column(To_Date; "To Date") { }
            column(Company_Name; "Company Name")
            {

            }
            column(Contact_Number; "Contact Number")
            { }
            column(Contact_Person; "Contact Person")
            { }
            dataitem("Employee Information"; "Employee Information")
            {
                DataItemLinkReference = "Insurance Information";
                DataItemLink = "Document No." = field("No.");
                DataItemTableView = sorting("Document No.", "Line No.");

                column(Personal_Number; "Personal Number")
                { }
                column(Dependent; Dependent)
                { }
                column(Line_No_; "Line No.")
                { }
                column(Document_No_; "Document No.")
                { }
                column(Relationship; Relationship)
                {

                }
                column(Employee_Name; "Employee Name")
                { }
                column(Card_No_; "Card No.")
                { }
                column(DOJ; DOJ)
                { }
                column(Insurance_Card; "Insurance Card")
                { }
                column(Amount; Amount)
                { }
                column(From_DateL; "From Date")
                { }
                column(To_DateL; "To Date")
                { }

                trigger OnAfterGetRecord()
                begin
                    DOJ := 0D;
                    if EmployeeL.Get("Personal Number") then;
                    DOJ := EmployeeL."Employment Date";
                end;
            }


        }
    }
    trigger OnPreReport()
    begin
        CompanyInformationG.get();
        CompanyInformationG.CalcFields(Picture);
    end;


    var

        EmployeeL: record Employee;
        CompanyInformationG: Record "Company Information";
        DOJ: Date;


}