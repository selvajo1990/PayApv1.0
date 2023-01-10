table 50116 "Employee Information"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Document No."; Integer)
        {
            DataClassification = CustomerContent;

        }
        field(2; "Line No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(3; "Type"; Option)
        {
            OptionMembers = "Self","Dependent";
            OptionCaption = 'Self,Dependent';
            Caption = 'Type';
            DataClassification = CustomerContent;
            trigger Onvalidate()
            begin

                if xRec.Type <> Rec.Type then begin
                    Clear("Personal Number");
                    Clear("Employee Name");
                    Clear(Dependent);
                    Clear(Relationship);
                    Clear("From Date");
                    Clear("To Date");
                    Clear(Amount);
                end;
            end;

        }
        field(4; "Employee Name"; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(5; "Personal Number"; Text[30])
        {
            DataClassification = CustomerContent;
            TableRelation = Employee;
            trigger OnValidate()
            begin

                if Type = Type::Dependent then begin
                    EmplInfo.reset();
                    EmplInfo.setrange("Document No.", "Document No.");
                    EmplInfo.setrange(Type, EmplInfo.Type::Self);
                    EmplInfo.SetRange("Personal Number", "Personal Number");
                    if EmplInfo.IsEmpty() then
                        Error('Please select the Employee First ');

                end;


                InsInfo.reset();
                InsInfo.setrange("No.", "Document No.");
                if InsInfo.FindFirst() then begin

                    Amount := InsInfo."Insurance Amount";
                    "To Date" := InsInfo."To Date";
                end;
                Employee.Reset();
                Employee.SetRange(Employee."No.", "Personal Number");
                if Employee.FindFirst() then
                    "Employee Name" := Employee."First Name"
                else begin
                    "Employee Name" := '';
                    "From Date" := 0D;
                    "To Date" := 0D;
                    Amount := 0;

                end;

            end;

        }
        field(6; Dependent; Text[20])
        {
            DataClassification = CustomerContent;

        }
        field(7; "Relationship"; Text[20])
        {
            DataClassification = CustomerContent;
            trigger OnLookup()
            var
                EmployeeInformation: record "Employee Information";

                EmpRelativePage: Page "Employee Relatives";

            begin

                EmpRelative.reset();
                EmpRelative.setrange("Employee No.", "Personal Number");
                clear(EmpRelativePage);
                EmpRelativePage.SetRecord(EmpRelative);
                EmpRelativePage.SetTableView(EmpRelative);
                EmpRelativePage.LookupMode(true);
                if EmpRelativePage.RunModal() = Action::LookupOK then begin
                    EmpRelativePage.GetRecord(EmpRelative);

                    InsInfo.reset();
                    InsInfo.setrange("No.", "Document No.");
                    if InsInfo.FindFirst() then begin

                        EmployeeInformation.reset();
                        EmployeeInformation.setrange("Document No.", "Document No.");
                        EmployeeInformation.SetRange("Personal Number", EmpRelative."Employee No.");
                        EmployeeInformation.setrange(Relationship, EmpRelative."Relative Code");
                        EmployeeInformation.SetRange("From Date", InsInfo."From Date", InsInfo."To Date");
                        if EmployeeInformation.IsEmpty() then begin
                            Dependent := EmpRelative."First Name";
                            Relationship := EmpRelative."Relative Code";
                        end else
                            if not (Confirm('Do you want to Continue?')) then
                                Error('Dependent is already Exist')
                            else begin
                                Dependent := EmpRelative."First Name";
                                Relationship := EmpRelative."Relative Code";
                            end;

                    end;
                end;

            end;
        }
        field(8; "From Date"; Date)
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if Type = Type::Dependent then
                    TestField(Relationship);

                TestField("To Date");

                if "From Date" > "To Date" then
                    Error('From Date should be less than To Date');



                InsInfo.Reset();
                InsInfo.SetRange("No.", "Document No.");
                if InsInfo.FindFirst() then begin
                    Employee.Reset();
                    Employee.SetRange(Employee."No.", "Personal Number");
                    if Employee.FindFirst() then
                        if ("From Date" < Employee."Employment Date") then
                            error('From Date should be greater than Employee DOJ %1', Employee."Employment Date")
                        else
                            if ("From Date" < InsInfo."From Date") or ("From Date" > InsInfo."to Date") then
                                error('From Date should be within the range of %1 to %2.', InsInfo."From Date", InsInfo."To Date")
                            else begin
                                EmplInfo.Reset();
                                EmplInfo.SetRange(Type, Type);
                                EmplInfo.SetRange("Personal Number", "Personal Number");
                                if Relationship <> '' then
                                    EmplInfo.setrange(Relationship, Relationship);
                                EmplInfo.SetFilter("Line No.", '<>%1', "Line No.");
                                if EmplInfo.FindLast() then
                                    if ("From Date" < EmplInfo."From Date") then
                                        "To Date" := EmplInfo."From Date" - 1;

                                EmplInfo.Reset();
                                EmplInfo.SetRange(Type, Type);
                                EmplInfo.SetRange("Personal Number", "Personal Number");
                                if Relationship <> '' then
                                    EmplInfo.setrange(Relationship, Relationship);
                                EmplInfo.SetFilter("Line No.", '<>%1', "Line No.");
                                if EmplInfo.FindFirst() then
                                    repeat
                                        if ("From Date" > EmplInfo."From Date") and ("From Date" < EmplInfo."To Date") then
                                            Error('Date range already exist');
                                    until EmplInfo.Next() = 0;


                            end;

                end;

            end;
        }
        field(9; "To Date"; Date)
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if "To Date" < "From Date" then
                    Error('To Date should be grater than From Date');

                InsInfo.Reset();
                InsInfo.SetRange("No.", "Document No.");
                if InsInfo.FindFirst() then begin
                    Employee.Reset();
                    Employee.SetRange(Employee."No.", "Personal Number");
                    if Employee.FindFirst() then
                        if ("To Date" < Employee."Employment Date") then
                            error('To Date should be greater than Employee DOJ %1', Employee."Employment Date")
                        else
                            if ("To Date" < InsInfo."From Date") or ("To Date" > InsInfo."to Date") then
                                error('To Date should be within the range of %1 to %2.', Employee."Employment Date", InsInfo."To Date")
                            else begin

                                EmplInfo.Reset();
                                EmplInfo.SetRange(Type, Type);
                                EmplInfo.SetRange("Personal Number", "Personal Number");
                                if Relationship <> '' then
                                    EmplInfo.setrange(Relationship, Relationship);
                                EmplInfo.SetFilter("Line No.", '<>%1', "Line No.");
                                if EmplInfo.Findset() then
                                    repeat
                                        if ("To Date" > EmplInfo."From Date") and ("To Date" < EmplInfo."To Date") then
                                            Error('Date range already exist')
                                        else
                                            if ("From Date" < EmplInfo."From Date") and ("To Date" >= EmplInfo."From Date") then
                                                Error('Date range already exist');



                                    until EmplInfo.Next() = 0;
                            end;
                end;
            end;
        }
        field(10; Amount; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(11; "Insurance Card"; code[20])
        {
            DataClassification = CustomerContent;
        }
        field(12; "Card No."; Code[20])
        {
            DataClassification = CustomerContent;
        }


    }

    keys
    {
        key(PK; "Document No.", "Line No.")
        {
            Clustered = true;
        }
    }

    var
        InsInfo: record "Insurance Information";
        Employee: Record Employee;
        EmplInfo: record "Employee Information";
        EmpRelative: record "Employee Relative";

        RestrictLineErr: Label 'You can''t delete the line';

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin
        if (Type = type::Dependent) and ("Line No." = 10000) then
            Error('Select the self first');

    end;

    trigger OnDelete()
    begin
        if ("Line No." = 10000) or (Type = Type::Dependent) then
            Error(RestrictLineErr);
    end;

    trigger OnRename()
    begin

    end;

}