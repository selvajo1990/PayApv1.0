table 50024 "Employee Bank Account Detail"
{
    DataClassification = CustomerContent;
    Caption = 'Employee Bank Account Details';
    LookupPageId = "Bank Account Details";
    fields
    {
        field(1; "Employee No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Employee No.';
        }
        field(2; "Account Identification"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Account Identification';
            TableRelation = "Employee Bank Account Master";
            trigger OnValidate()
            var
                BankAccountMasterL: Record "Employee Bank Account Master";
            begin
                if BankAccountMasterL.Get("Account Identification") then;
                "Bank Name" := BankAccountMasterL."Bank Name";
                "Swift Code" := BankAccountMasterL."Swift Code";
                "Branch Name" := BankAccountMasterL."Branch Name";
                "Branch Address" := BankAccountMasterL."Branch Address";
            end;
        }
        field(3; "Bank Name"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Bank Name';
        }
        field(4; "Swift Code"; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Swift Code';
        }
        field(5; "Branch Name"; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Branch Name';
        }
        field(6; "Branch Address"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Branch Address';
        }
        field(8; "Account No."; Code[25])
        {
            DataClassification = CustomerContent;
            Caption = 'Account No.';
        }
        field(9; "IBAN No."; Text[25])
        {
            DataClassification = CustomerContent;
            Caption = 'IBAN No.';
        }
        field(10; Primary; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Primary';
            trigger OnValidate()
            var
                BankDetailsL: Record "Employee Bank Account Detail";
                EmployeeL: Record Employee;
            begin
                EmployeeL.Get("Employee No.");
                if Primary then begin
                    BankDetailsL.SetFilter("Account Identification", '<>%1', "Account Identification");
                    BankDetailsL.SetRange("Employee No.", Rec."Employee No.");
                    BankDetailsL.ModifyAll(Primary, false);
                    EmployeeL."Bank Account No." := "Account No.";
                    EmployeeL."SWIFT Code" := "Swift Code";
                    EmployeeL.IBAN := "IBAN No.";
                    EmployeeL.Modify();
                end else begin
                    EmployeeL."Bank Account No." := '';
                    EmployeeL.IBAN := '';
                    EmployeeL."SWIFT Code" := '';
                    EmployeeL.Modify();
                end;
            end;
        }
    }

    keys
    {
        key(PK; "Employee No.", "Account Identification")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    var
        EmployeeL: Record Employee;
    begin
        if Primary then begin
            EmployeeL.Get("Employee No.");
            EmployeeL."Bank Account No." := '';
            EmployeeL.IBAN := '';
            EmployeeL."SWIFT Code" := '';
            EmployeeL.Modify();
        end;
    end;

    trigger OnRename()
    begin

    end;

}