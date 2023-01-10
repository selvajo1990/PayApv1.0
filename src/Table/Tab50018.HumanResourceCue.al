table 50018 "Human Resource Cue"
{
    DataClassification = CustomerContent;
    fields
    {
        field(1; "Primary Key"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(21; "Active Employees"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count(Employee where(Status = filter(Active)));
            Caption = 'Active Employees';
        }
        field(22; "Total Employees"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count(Employee);
            Caption = 'Total Employees';
        }
        field(23; "Leave Request"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Leave Request" where(Status = filter("Pending Approval")));
            Caption = 'Pending Leave Request';
        }
        field(24; "End of Service"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'End of Service';
        }
        field(25; "Document Expiry"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Document Expiry';
        }
        field(26; "Employee Birthday"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Employee Birthday';
        }
        field(27; "Employee Anniversary"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Employee Anniversary';
        }
        field(28; "New Joiners"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'New Joiners';
        }
        // Start #15 - 12/05/2019 - 103
        // field(28; "Total Applicants"; Integer)
        // {
        //     Caption = 'Total Applicants';
        //     FieldClass = FlowField;
        //     CalcFormula = count(Applicant);
        // }
        // field(29; "Total Candidates"; Integer)
        // {
        //     Caption = 'Total Candidates';
        //     FieldClass = FlowField;
        //     CalcFormula = count("Candidate Header");
        // }
        // field(30; "Interview Candidates"; Integer)
        // {
        //     DataClassification = CustomerContent;
        //     Caption = 'Interview Candidates';
        // }
        // Stop #15 - 12/05/2019 - 103
    }

    keys
    {
        key(PK; "Primary Key")
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
    begin

    end;

    trigger OnRename()
    begin

    end;

}