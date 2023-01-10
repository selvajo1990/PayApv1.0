table 50044 "Salary Computation Header"
{
    DataClassification = CustomerContent;
    Caption = 'Salary Computation Header';
    LookupPageId = "Salary Computation List";
    fields
    {
        field(1; "Computation No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Computation No.';
            trigger OnValidate()
            begin
                IF "Computation No." = '' THEN BEGIN
                    HrSetupG.Get();
                    HrSetupG.TESTFIELD("Salary Computation Nos.");
                    NoSeriesMgtG.InitSeries(HrSetupG."Salary Computation Nos.", '', 0D, "Computation No.", NoSeriesG);
                END;
            end;
        }
        field(21; "Employee No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Employee No.';
            TableRelation = Employee;
        }
        field(22; "Salary Class"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Salary Class';
            TableRelation = "Salary Class";
        }
        field(23; "No. of Employee"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'No. of Employee';
        }
        field(24; "Total Net Pay"; Decimal)
        {
            FieldClass = FlowField;
            Caption = 'Total Net Pay';
            CalcFormula = sum("Salary Computation Line".Amount where("Computation No." = field("Computation No."), "Affects Salary" = filter(true)));
        }
        field(25; "Pay Period"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Pay Period';
        }
        field(26; "From Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'From Date';
        }
        field(27; "To Date"; date)
        {
            DataClassification = CustomerContent;
            Caption = 'To Date';
        }
        field(28; Status; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Sal. Comp. Posting Status';
            OptionMembers = "Open","Journal Created","Posted";
        }
        field(29; "Created DateTime"; DateTime)
        {
            DataClassification = CustomerContent;
            Caption = 'Created DateTime';
        }
        field(30; "Employee Name"; Text[50])
        {
            FieldClass = FlowField;
            Caption = 'Employee Name';
            CalcFormula = lookup(Employee."First Name" where("No." = field("Employee No.")));
        }
        field(31; "Document Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = "Salary Computation","EOS Computation";
            OptionCaption = 'Salary Computation,EOS Computation';
            Caption = 'Document Type';
        }
        field(32; "Accrual Posting Status"; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Accrual Posting Status';
            OptionMembers = "Open","Journal Created","Posted";
        }
    }

    keys
    {
        key(PK; "Computation No.")
        {
            Clustered = true;
        }
    }

    var
        HrSetupG: Record "Human Resources Setup";
        SalaryComputationLineG: Record "Salary Computation Line";
        NoSeriesMgtG: Codeunit NoSeriesManagement;
        NoSeriesG: Code[20];

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin
        SalaryComputationLineG.SetRange("Computation No.", "Computation No.");
        SalaryComputationLineG.DeleteAll();
    end;

    trigger OnRename()
    begin

    end;

}