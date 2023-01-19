table 50131 "Document Request"
{
    DataClassification = ToBeClassified;
    LookupPageId = "Document Requests";
    //Created by SKR 16-01-2023
    fields
    {
        field(1; "Req ID"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Request ID';
        }
        field(2; "Employee No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Employee No.';
            TableRelation = Employee;

            trigger OnValidate()
            var
                EmployeeL: Record Employee;
            begin
                EmployeeL.Reset();
                EmployeeL.SetRange("No.", Rec."Employee No.");
                if EmployeeL.FindFirst() then
                    Rec."Employee Name" := EmployeeL."Search Name";
            end;
        }
        field(3; "Employee Name"; Text[250])
        {
            Caption = 'Employee Name';
            FieldClass = FlowField;
            CalcFormula = lookup(Employee."Search Name" where("No." = field("Employee No.")));
            Editable = false;
        }
        field(4; "Request Date"; Date)
        {
            Caption = 'Request Date';
            DataClassification = CustomerContent;
        }
        field(5; "Requested Document"; Option)
        {
            Caption = 'Requested Document';
            DataClassification = CustomerContent;
            OptionMembers = " ","Salary Certificate","No Objection Certificate";
            OptionCaption = ' ,Salary Certificate, No Objection Certificate';

            trigger OnValidate()
            begin
                TestField("Employee No.");
                TestField("Request Date");
            end;
        }
        field(6; Status; Option)
        {
            Caption = 'Status';
            DataClassification = CustomerContent;
            OptionMembers = "Open","Pending Approval","Approved","Rejected";
            OptionCaption = 'Open,Pending Approval,Approved,Rejected';
        }
        field(7; "Issued Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Issued Date';

            trigger OnValidate()
            begin
                if Rec.Status <> Rec.Status::Approved then
                    Error('Issued Dated can be Updated only if the status is Approved');
            end;
        }
    }

    keys
    {
        key(PK; "Req ID")
        {
            Clustered = true;
        }
    }

    var
        HRSetup: Record "Human Resources Setup";
        NoSeriesMgmt: Codeunit NoSeriesManagement;
        NoSeriesG: Code[20];

    trigger OnInsert()
    begin
        IF "Req ID" = '' THEN BEGIN
            HRSetup.Get();
            HRSetup.TESTFIELD("Document Req No.");
            NoSeriesMgmt.InitSeries(HRSetup."Document Req No.", '', 0D, "Req ID", NoSeriesG);
        END;
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

}