table 50103 "Salary Increment Header"
{
    DataClassification = CustomerContent;
    Caption = 'Salary Increment Header';

    fields
    {
        field(1; "No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'No.';

            trigger OnValidate()
            begin
                if "No." <> xRec."No." then begin
                    HumanResSetup.Get();
                    NoSeriesMgt.TestManual(HumanResSetup."Salary Increment Nos.");
                end;

                "Document Date" := Today; // Added by suganya-m
            end;
        }
        field(21; "Document Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Document Date';
            trigger OnValidate()
            begin
                /* if "Document Date" > 0D then
                     Validate("Effective Date");*/

            end;
        }
        field(22; "Effective Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Effective Date';
            trigger OnValidate()
            begin
                if "Effective Date" > 0D then begin
                    TestField("Document Date");
                    if "Effective Date" < "Document Date" then
                        Error(DateErr, FieldCaption("Effective Date"), FieldCaption("Document Date"));
                end;
            end;
        }
        field(23; "Status"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = Open,Approved,"Pending Approval",Rejected;
            OptionCaption = 'Open,Approved,Pending Approval,Rejected';
            Caption = 'Status';
            trigger OnValidate()
            var
                IncrementLine: Record "Salary Increment Line";
                Employee: Record Employee;
                EmployeeLevelEarning: Record "Employee Level Earning";
                EmployeeLevelEarning2: Record "Employee Level Earning";
                xEmployeeNo: Code[20];
                FromDateValidationErr: Label '%1 should not be earlier than %2: %3';
                SalIncrLineL: Record "Salary Increment Line";
                EmployeeL: Record Employee;
                recEmployeeLevelEarning: Record "Employee Level Earning";
            // added by suganya-m
            begin
                if Status = Status::Approved then begin
                    TestField("Effective Date");
                    //TestField("Approved Date"); // commented by suganya-m
                    IncrementLine.SetCurrentKey("Document No.", "Employee No.", "Line No."); // added by suganya-m
                    IncrementLine.SetRange("Document No.", Rec."No.");
                    if IncrementLine.FindSet() then
                        repeat
                            if xEmployeeNo <> IncrementLine."Employee No." then begin
                                Employee.Get(IncrementLine."Employee No.");
                                if "Effective Date" < Employee."Employment Date" then
                                    Error(FromDateValidationErr, EmployeeLevelEarning.FieldCaption("From Date"), Employee.FieldCaption("Employment Date"), Employee."Employment Date");
                                IncrementLine.TestField(Value);
                                Employee.GetDocumentNo("No."); // added a coding suganya-m
                                Employee.CreateUpdateEarningGroupLines("Effective Date");
                            end;

                            if EmployeeLevelEarning.Get(IncrementLine."Employee No.", IncrementLine."Earning Group Code", "Effective Date", IncrementLine."Earning Code") then; // added if and then by suganya-m

                            if IncrementLine."New Amount" <> 0 then begin // Suganya-m added a coding
                                case true of
                                    IncrementLine."Payment Type" = IncrementLine."Payment Type"::Amount:
                                        EmployeeLevelEarning.Validate("Pay Amount", IncrementLine."New Amount");
                                    IncrementLine."Payment Type" = IncrementLine."Payment Type"::Percentage:
                                        EmployeeLevelEarning.Validate("Pay Percentage", IncrementLine.Value + EmployeeLevelEarning."Pay Percentage");
                                end;
                            end;// Suganya-m added a coding

                            if IncrementLine."New Amount" = 0 then begin
                                case true of
                                    IncrementLine."Payment Type" = IncrementLine."Payment Type"::Amount:
                                        EmployeeLevelEarning.Validate("Pay Amount", IncrementLine."Current Amount");
                                    IncrementLine."Payment Type" = IncrementLine."Payment Type"::Percentage:
                                        EmployeeLevelEarning.Validate("Pay Percentage", IncrementLine."Current Amount");
                                end;
                            end;
                            // Suganya-m added a coding
                            EmployeeLevelEarning.Modify(true);

                            // Suganya-m added a coding
                            if not EmployeeLevelEarning.Get(IncrementLine."Employee No.", IncrementLine."Earning Group Code", "Effective Date", IncrementLine."Earning Code") then begin
                                recEmployeeLevelEarning.Init();
                                recEmployeeLevelEarning."Employee No." := IncrementLine."Employee No.";
                                recEmployeeLevelEarning."Group Code" := IncrementLine."Earning Group Code";
                                recEmployeeLevelEarning."From Date" := "Effective Date";
                                recEmployeeLevelEarning."Earning Code" := IncrementLine."Earning Code";
                                recEmployeeLevelEarning.Validate("Earning Code");
                                if IncrementLine."New Amount" <> 0 then begin // Suganya-m added a coding
                                    case true of
                                        IncrementLine."Payment Type" = IncrementLine."Payment Type"::Amount:
                                            recEmployeeLevelEarning.Validate("Pay Amount", IncrementLine."New Amount");
                                        IncrementLine."Payment Type" = IncrementLine."Payment Type"::Percentage:
                                            recEmployeeLevelEarning.Validate("Pay Percentage", IncrementLine.Value + EmployeeLevelEarning."Pay Percentage");
                                    end;
                                end;// Suganya-m added a coding

                                if IncrementLine."New Amount" = 0 then begin
                                    case true of
                                        IncrementLine."Payment Type" = IncrementLine."Payment Type"::Amount:
                                            recEmployeeLevelEarning.Validate("Pay Amount", IncrementLine."Current Amount");
                                        IncrementLine."Payment Type" = IncrementLine."Payment Type"::Percentage:
                                            recEmployeeLevelEarning.Validate("Pay Percentage", IncrementLine."Current Amount");
                                    end;
                                end;
                                // Suganya-m added a coding
                                recEmployeeLevelEarning.Insert();
                            end;
                            // suganya-m added a coding
                            if xEmployeeNo <> IncrementLine."Employee No." then begin
                                EmployeeLevelEarning2.SetRange("Employee No.", Employee."No.");
                                EmployeeLevelEarning2.SetRange("Group Code", IncrementLine."Earning Group Code");
                                EmployeeLevelEarning2.SetRange("From Date", "Effective Date");
                                if EmployeeLevelEarning2.FindSet() then
                                    repeat
                                        EmployeeLevelEarning.SetRange("Employee No.", Employee."No.");
                                        EmployeeLevelEarning.SetRange("Group Code", EmployeeLevelEarning2."Group Code");
                                        EmployeeLevelEarning.SetRange("Earning Code", EmployeeLevelEarning2."Earning Code");
                                        EmployeeLevelEarning.SetRange("To Date", "Effective Date" - 1);
                                        if EmployeeLevelEarning.IsEmpty() then
                                            EmployeeLevelEarning2.Delete(true);
                                    until EmployeeLevelEarning2.Next() = 0;
                            end;
                            xEmployeeNo := IncrementLine."Employee No.";
                        until IncrementLine.Next() = 0;

                    if SalIncrLineL.FindSet() then
                        repeat begin
                            EmployeeL.Reset();
                            EmployeeL.SetRange("No.", SalIncrLineL."Employee No.");
                            if EmployeeL.FindFirst() then
                                EmployeeL."Last Salary Increment Date" := Rec."Effective Date";
                            EmployeeL.Modify();
                        end;
                        // Suganya-m added a coding start
                        SalIncrLineL.TestField("Earning Group Code");
                        EmployeeL.TestField("Employment Date");
                        until SalIncrLineL.Next() = 0;
                end;

                "Approved Date" := Today;
                "Approver Name" := UserId;
                // Suganya-m added a coding end
            end;
        }
        field(24; "Approved Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Approved Date';
            Editable = false;
            trigger OnValidate()
            begin
                if "Approved Date" > 0D then begin
                    TestField("Document Date");
                    TestField("Effective Date");
                    if "Approved Date" < "Document Date" then
                        Error(DateErr, FieldCaption("Approved Date"), FieldCaption("Document Date"));
                end;
            end;
        }

        field(25; "Employee No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Employee No.';
            TableRelation = Employee;
            trigger OnValidate()
            var
                Employee: Record Employee;
                recSalaryIncrementLine: Record "Salary Increment Line";
            begin
                // Suganya-m added
                recSalaryIncrementLine.Reset();
                recSalaryIncrementLine.SetRange("Document No.", "No.");
                recSalaryIncrementLine.SetRange(Inserted, true);
                if recSalaryIncrementLine.FindFirst() then
                    Error('Earning Code are updated for this %1, you cannot change the Employee No.', xRec."Employee No.");

                if Employee.Get("Employee No.") then
                    "Employee Name" := Employee."First Name";

                UpdateEmployeeEarning();
            end;
        }
        field(26; "Employee Name"; Text[50])
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Employee."First Name" where("No." = field("Employee No.")));
            Editable = false;
            Caption = 'Employee Name';
        }  // suganya-m added

        field(27; "Approver Name"; Text[100])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }
    var
        HumanResSetup: Record "Human Resources Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        NoSeriesG: Code[20];
        DateErr: Label '%1 can''t be earlier than %2';

    trigger OnInsert()
    begin
        HumanResSetup.Get();
        if "No." = '' then begin
            HumanResSetup.TestField("Salary Increment Nos.");
            NoSeriesMgt.InitSeries(HumanResSetup."Salary Increment Nos.", '', 0D, "No.", NoSeriesG);

            "Document Date" := Today;


        end;
    end;

    trigger OnModify()
    begin
        if xRec.Status <> xRec.Status::Open then
            TestField(Status, Status::Open);
    end;

    trigger OnDelete()
    begin
        TestField(Status, Status::Open);
    end;

    trigger OnRename()
    begin

    end;

    procedure AssistEdit(): Boolean
    begin
        HumanResSetup.Get();
        HumanResSetup.TestField("Salary Increment Nos.");
        if NoSeriesMgt.SelectSeries(HumanResSetup."Salary Increment Nos.", '', NoSeriesG) then begin
            NoSeriesMgt.SetSeries("No.");

            "Document Date" := Today;
            exit(true);
        end;
    end;
    // Suganya-m added a coding
    procedure UpdateEmployeeEarning()
    var
        EmployeeEarningLevel: Record "Employee Level Earning";
        EmployeeGroupHistory: Record "Employee Earning History";
        EmployeeSalaryIncLine: Record "Salary Increment Line";
        EmployeeGroupLine: Record "Earning Group Line";
    begin
        EmployeeGroupHistory.Reset();
        EmployeeGroupHistory.SetRange("Employee No.", rec."Employee No.");
        EmployeeGroupHistory.SetRange("Component Type", EmployeeGroupHistory."Component Type"::Earning);
        if EmployeeGroupHistory.FindLast() then begin
            EmployeeEarningLevel.Reset();
            EmployeeEarningLevel.SetRange("Employee No.", Rec."Employee No.");
            EmployeeEarningLevel.SetRange("Group Code", EmployeeGroupHistory."Group Code");
            EmployeeEarningLevel.SetRange("From Date", EmployeeGroupHistory."From Date");
            EmployeeEarningLevel.SetRange("To Date", EmployeeGroupHistory."To Date");
            if EmployeeEarningLevel.FindSet() then
                repeat
                    EmployeeGroupLine.Reset();
                    EmployeeGroupLine.SetRange("Group Code", EmployeeEarningLevel."Group Code");
                    EmployeeGroupLine.SetRange("Earning Code", EmployeeEarningLevel."Earning Code");
                    if EmployeeGroupLine.FindFirst() then begin
                        EmployeeSalaryIncLine.Init();
                        EmployeeSalaryIncLine."Document No." := Rec."No.";
                        EmployeeSalaryIncLine."Line No." := EmployeeGroupLine."Line No.";
                        EmployeeSalaryIncLine."Employee No." := Rec."Employee No.";
                        EmployeeSalaryIncLine."Employee Name" := Rec."Employee Name";
                        EmployeeSalaryIncLine."Earning Group Code" := EmployeeEarningLevel."Group Code";
                        EmployeeSalaryIncLine."Earning Code" := EmployeeEarningLevel."Earning Code";
                        EmployeeSalaryIncLine."Base Code" := EmployeeEarningLevel."Base Code";
                        EmployeeSalaryIncLine."Payment Type" := EmployeeEarningLevel."Payment Type";
                        EmployeeSalaryIncLine."Value Percentage" := EmployeeEarningLevel."Pay Percentage";
                        if EmployeeEarningLevel."Payment Type" = EmployeeEarningLevel."Payment Type"::Amount then
                            EmployeeSalaryIncLine."Current Amount" := EmployeeEarningLevel."Pay Amount";

                        if EmployeeEarningLevel."Payment Type" = EmployeeEarningLevel."Payment Type"::Percentage then
                            EmployeeSalaryIncLine."Current Amount" := EmployeeEarningLevel."Pay Percentage";

                        EmployeeSalaryIncLine.Inserted := true;
                        EmployeeSalaryIncLine.Insert();
                    end;
                until EmployeeEarningLevel.Next() = 0;
        end;
    end;
    // Suganya-m added a coding
}