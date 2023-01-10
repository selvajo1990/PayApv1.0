table 50107 "Approval Entry ATG"
{
    DataClassification = CustomerContent;
    Caption = 'Approval Entry ATG';
    LookupPageId = 50137;
    DrillDownPageId = 50137;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Entry No.';
            AutoIncrement = true;
        }
        field(21; "Table ID"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Table ID';
        }
        field(22; "Document Type"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Document Type';
        }
        field(23; "Document No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Document No.';
        }
        field(24; "Sequence No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Sequence No.';
        }
        field(25; "Approval Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Approval Code';
            TableRelation = "Approval Setup ATG";
        }
        field(26; "Sender ID"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Sender ID';
            TableRelation = Employee;
        }
        field(27; "Approver ID"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Approver ID';
            TableRelation = Employee;
        }
        field(28; Status; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Status';
            OptionMembers = Created,Open,Canceled,Rejected,Approved;
            OptionCaption = 'Created,Open,Canceled,Rejected,Approved';
        }
        field(29; "Date-Time Sent for Approval"; DateTime)
        {
            DataClassification = CustomerContent;
            Caption = 'Date-Time Sent for Approval';
        }
        field(30; "Last Date-Time Modified"; DateTime)
        {
            DataClassification = CustomerContent;
            Caption = 'Last Date-Time Modified';
        }
        field(31; "Last Modified By User ID"; Code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Last Modified By User ID';
        }
        field(32; Comment; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Comment';
        }
        field(33; "Approval Value"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Approval Value';
        }
        field(34; "Approval Type"; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Approval Type';
            OptionMembers = Approver,"Workflow User Group";
            OptionCaption = 'Approver,Workflow User Group';
        }
        field(35; "Pending Approvals"; Integer)
        {
            Caption = 'Pending Approvals';
            FieldClass = FlowField;
            CalcFormula = Count("Approval Entry ATG" where("Record ID to Approve" = field("Record ID to Approve"), Status = filter(Created | Open)));
        }
        field(36; "Record ID to Approve"; RecordId)
        {
            DataClassification = CustomerContent;
            Caption = 'Record ID to Approve';
        }
        field(37; "Limit Type"; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Limit Type';
            OptionMembers = "Approval Limits","Credit Limits","Request Limits","No Limits";
            OptionCaption = 'Approval Limits,Credit Limits,Request Limits,No Limits';
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin
        "Last Date-Time Modified" := CreateDateTime(Today(), Time());
        "Last Modified By User ID" := CopyStr(UserId(), 1, 50);
    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

    procedure RecordCaption(): Text
    var
        AllObjWithCaption: Record "AllObjWithCaption";
        RecRef: RecordRef;
        PageNo: Integer;
    begin
        if not RecRef.GET("Record ID to Approve") then
            exit;
        PageNo := PageManagement.GetPageID(RecRef);
        if PageNo = 0 then
            exit;
        AllObjWithCaption.Get(AllObjWithCaption."Object Type"::Page, PageNo);
        exit(StrSubstNo('%1 %2', AllObjWithCaption."Object Caption", "Document No."));
    end;

    var
        PageManagement: Codeunit "Page Management";
}