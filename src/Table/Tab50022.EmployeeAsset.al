table 50022 "Employee Asset"
{
    DataClassification = CustomerContent;
    Caption = 'Employee Asset';
    LookupPageId = "Employee Assets";

    fields
    {
        field(1; "Employee No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Employee No.';
            TableRelation = Employee;
            trigger OnValidate()
            var
                EmployeeL: Record Employee;
            begin
                EmployeeL.Reset();
                EmployeeL.SetRange("No.", "Employee No.");
                if EmployeeL.FindFirst() then
                    Rec."Employee Name" := EmployeeL."First Name";
            end;
        }
        field(2; "Employee Name"; Text[50])
        {
            Caption = 'Employee Name';
            FieldClass = FlowField;
            CalcFormula = lookup(Employee."First Name" where("No." = Field("Employee No.")));
            Editable = false;
        }
        field(3; "Asset Type"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Asset Type';
            TableRelation = "Employee Asset Type";
        }
        field(4; "Returned Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Returned Date';
        }
        /*field(5; "Actual Return Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Actual Return Date';
            /*trigger OnValidate()
            var
                EAssetItemL: Record "Employee Asset Item";
            begin
                EAssetItemL.Get("Asset Type", "Asset Item");
                EAssetItemL.TestField("Item Allotted", true);
                EAssetItemL."Item Allotted" := false;
                EAssetItemL.Modify();
            end;
        }*/
        field(6; "Asset Item"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Mag Barcode';
            //TableRelation = "No. Series";
            /*TableRelation = "Employee Asset Item"."Asset Item No." where(Code = field("Asset Type"), "Item Allotted" = filter('No'));

            trigger OnValidate()
            var
                EAssetItemL: Record "Employee Asset Item";
            begin
                if ("Asset Item" > '') and (EAssetItemL.Get("Asset Type", "Asset Item")) then begin
                    EAssetItemL."Item Allotted" := true;
                    EAssetItemL.Modify();
                end else
                    if EAssetItemL.Get("Asset Type", xRec."Asset Item") then begin
                        EAssetItemL."Item Allotted" := false;
                        EAssetItemL.Modify();
                    end;
                Description := EAssetItemL."Asset Item Description";
                "Serial No." := EAssetItemL."Serial No.";
            end;*/
            trigger OnValidate()
            var
                HrSetup: Record "Human Resources Setup";
                NoSeriesMgt: Codeunit NoSeriesManagement;
            begin
                HrSetup.Get();
                NoSeriesMgt.TestManual(HrSetup."Employee Asset Nos.");
            end;
        }
        field(7; "Issued Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Issued Date';
        }
        field(8; "Serial No."; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Serial No.';
        }
        field(9; Description; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Description';
        }
        field(10; Status; Option)
        {
            DataClassification = ToBeClassified;
            Caption = 'Status';
            OptionMembers = " ","Issued","Collected","Transferred";
            OptionCaption = ' ,Issued,Collected,Transferred';
        }
        field(11; "Asset Price"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Asset Price';
        }
        field(12; Notes; Text[80])
        {
            DataClassification = CustomerContent;
            Caption = 'Notes';
        }
    }
    keys
    {
        key(PK; "Employee No.",/*, "Asset Type",*/ "Asset Item")
        {
            Clustered = true;
        }
    }


    trigger OnInsert()
    var
        HRSetup: Record "Human Resources Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
    begin
        if "Asset Item" = '' then begin
            HRSetup.Get();
            "Asset Item" := NoSeriesMgt.GetNextNo(HRSetup."Employee Asset Nos.", Today, true);
        end;
    end;

    trigger OnModify()
    begin
    end;

    trigger OnDelete()
    var
    //EAssetItemL: Record "Employee Asset Item";
    begin
        /*if ("Asset Item" > '') and (EAssetItemL.Get("Asset Type", "Asset Item")) then begin
            EAssetItemL."Item Allotted" := false;
            EAssetItemL.Modify();
        end;*/
    end;

    trigger OnRename()
    begin
    end;
}
