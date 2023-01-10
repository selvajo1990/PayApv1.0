table 50114 "Employee ATG"
{
    DataClassification = OrganizationIdentifiableInformation;
    Caption = 'Employee';
    DataPerCompany = false;
    Description = 'Table created for workflow purposes. Shared accross all the companies.';

    fields
    {
        field(1; "No. ATG"; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Employee No.';
        }
        field(21; "Name ATG"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Employee Name';
        }
        field(22; "Company ATG"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Company';
        }
        field(23; "Email ID ATG"; Text[80])
        {
            DataClassification = CustomerContent;
            Caption = 'Email ID';
        }
        field(24; "Designation Code ATG"; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Designation Code';
        }
        field(25; "Description ATG"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Description';
        }
        field(26; "Reporting To ATG"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Reporting To';
        }
        field(27; "Reporting To Designation ATG"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Reporting To Designation';
        }

    }

    keys
    {
        key(PK; "No. ATG")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {

        fieldgroup(DropDown; "No. ATG", "Name ATG", "Company ATG")
        {

        }
    }

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

    procedure InsertUpdateRecord(EmployeeNoP: Code[20]; EmployeeNameP: Text[100]; CompanyP: Text[100]; EmailIDP: text[80]; DesignationP: Code[20]; ReportingToP: Code[20]; ReportingToDesigP: Code[20]; DesigDescP: Text[100])
    begin
        if not Get(EmployeeNoP) then begin
            Init();
            "No. ATG" := EmployeeNoP;
            Insert();
        end;
        if CompanyP > '' then
            "Company ATG" := CompanyP;
        if EmployeeNameP > '' then
            "Name ATG" := EmployeeNameP;
        if DesignationP > '' then
            "Designation Code ATG" := DesignationP;
        if ReportingToP > '' then
            "Reporting To ATG" := ReportingToP;
        if ReportingToDesigP > '' then
            "Reporting To Designation ATG" := ReportingToDesigP;
        if EmailIDP > '' then
            "Email ID ATG" := EmailIDP;
        if DesigDescP > '' then
            "Description ATG" := DesigDescP;
        Modify();

    end;

}