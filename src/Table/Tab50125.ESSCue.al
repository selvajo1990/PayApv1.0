table 50125 "ESS Cue"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[20])
        {
            DataClassification = CustomerContent;

        }
        field(2; "Requests to Approve"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Approval Entry ATG" where("Approver ID" = field("Employee No. Filter"), Status = filter(Open)));
        }
        field(10; "Leave Request"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Leave Request" where("Employee No." = field("Employee No. Filter")));
        }
        //<< skr
        field(15; "Approved Requests"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Approval Entry ATG" where("Approver ID" = field("Employee No. Filter"), Status = filter(Approved)));
        }
        //>> skr
        field(500; "Employee No. Filter"; Code[20])
        {
            FieldClass = FlowFilter;
        }
    }

    keys
    {
        key(Key1; "Primary Key")
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