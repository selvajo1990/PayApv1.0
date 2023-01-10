table 50102 "Air Ticket Request"
{
    DataClassification = CustomerContent;
    Caption = 'Air Ticket Request';
    LookupPageId = "Air Ticket Requests";
    DrillDownPageId = "Air Ticket Requests";
    fields
    {
        field(1; "No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'No.';
        }
        field(21; "Employee No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Employee No.';
            TableRelation = Employee;
            trigger OnValidate()
            var
                Employee: Record Employee;
                AirticketRequest: Record "Air Ticket Request";
                AirTicketGroup: Record "Employee Level Air Ticket";
                EmployeeEarningHistroy: Record "Employee Earning History";
                PayPeriodLine: Record "Pay Period Line";
                SalaryComputation: Report "Salary Computation";
                InBetweenDaysErr: Label 'You are allowed to apply after %1 days from your last request';
            begin
                CalcFields("Employee Name");
                if "Employee No." = '' then begin
                    "Requested Date" := 0D;
                    "Approved Date" := 0D;
                    Amount := 0;
                    "No. of Ticket" := 0;
                    Status := Status::Open;
                end else begin
                    Employee.Get("Employee No.");
                    Employee.TestField("Air Ticket Group");
                    AirticketRequest.SetCurrentKey("Employee No.", "Requested Date");
                    AirticketRequest.SetRange("Employee No.", "Employee No.");
                    AirticketRequest.SetFilter(Status, '<>%1', AirticketRequest.Status::Rejected);
                    if AirticketRequest.FindLast() then begin
                        SalaryComputation.GetPayPeriodLine("Requested Date", Employee."No.", PayPeriodLine);
                        EmployeeEarningHistroy.SetRange("Employee No.", Employee."No.");
                        EmployeeEarningHistroy.SetRange("Group Code", Employee."Air Ticket Group");
                        EmployeeEarningHistroy.SetRange("Component Type", EmployeeEarningHistroy."Component Type"::"Air Ticket");
                        EmployeeEarningHistroy.SetFilter("From Date", '<=%1', PayPeriodLine."Period End Date");
                        EmployeeEarningHistroy.SetFilter("To Date", '>=%1', PayPeriodLine."Period End Date");
                        EmployeeEarningHistroy.FindFirst();

                        AirTicketGroup.SetRange("Air Ticket Group Code", EmployeeEarningHistroy."Group Code");
                        AirTicketGroup.SetRange("From Date", EmployeeEarningHistroy."From Date");
                        AirTicketGroup.FindLast();
                        AirTicketGroup.TestField("Days Between");
                        if (Today() - AirticketRequest."Requested Date") < AirTicketGroup."Days Between" then
                            Error(InBetweenDaysErr, AirTicketGroup."Days Between");
                    end;
                end;
            end;
        }
        field(22; "Employee Name"; Text[50])
        {
            Caption = 'Employee Name';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = lookup(Employee."First Name" where("No." = Field("Employee No.")));
        }
        field(23; "Requested Date"; Date)
        {
            Caption = 'Request Date';
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                Employee: Record Employee;
                AirTicketGroup: Record "Employee Level Air Ticket";
                EmployeeEarningHistroy: Record "Employee Earning History";
                PayPeriodLine: Record "Pay Period Line";
                SalaryComputation: Report "Salary Computation";
                DateErr: Label '%1 can''t be earlier than %2';
                MinimumTenureErr: Label 'You can apply for Air Ticket request after %1 days from %2';
            begin
                TestField("Employee No.");
                if "Requested Date" > 0D then begin
                    Employee.Get("Employee No.");
                    Employee.TestField("Air Ticket Accrual Start Date");

                    SalaryComputation.GetPayPeriodLine("Requested Date", Employee."No.", PayPeriodLine);
                    EmployeeEarningHistroy.SetRange("Employee No.", Employee."No.");
                    EmployeeEarningHistroy.SetRange("Group Code", Employee."Air Ticket Group");
                    EmployeeEarningHistroy.SetRange("Component Type", EmployeeEarningHistroy."Component Type"::"Air Ticket");
                    EmployeeEarningHistroy.SetFilter("From Date", '<=%1', PayPeriodLine."Period End Date");
                    EmployeeEarningHistroy.SetFilter("To Date", '>=%1', PayPeriodLine."Period End Date");
                    EmployeeEarningHistroy.FindFirst();

                    AirTicketGroup.SetRange("Air Ticket Group Code", EmployeeEarningHistroy."Group Code");
                    AirTicketGroup.SetRange("From Date", EmployeeEarningHistroy."From Date");
                    AirTicketGroup.FindLast();
                    if ("Requested Date" - Employee."Air Ticket Accrual Start Date") < AirTicketGroup."Minimum Tenure (In days)" then
                        Error(MinimumTenureErr, AirTicketGroup."Minimum Tenure (In days)", Employee.FieldCaption("Air Ticket Accrual Start Date"));

                    if "Requested Date" < Employee."Air Ticket Accrual Start Date" then
                        Error(DateErr, FieldCaption("Requested Date"), Employee.FieldCaption("Air Ticket Accrual Start Date"));
                    if ("Approved Date" < "Requested Date") and ("Approved Date" > 0D) then
                        Error(DateErr, FieldCaption("Approved Date"), FieldCaption("Requested Date"));
                    LoanRequest.IsPayPeriodClosed("Requested Date", "Employee No.", '');
                end;
            end;
        }
        field(24; "Approved Date"; Date)
        {
            Caption = 'Approved Date';
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                DateErr: Label '%1 can''t be earlier than %2';
            begin
                if "Approved Date" > 0D then begin
                    TestField("Requested Date");
                    LoanRequest.IsPayPeriodClosed("Approved Date", "Employee No.", '');

                    if "Approved Date" < "Requested Date" then
                        Error(DateErr, FieldCaption("Approved Date"), FieldCaption("Requested Date"));
                end;
            end;
        }
        field(25; "Air Ticket Type"; Option)
        {
            Caption = 'Air Ticket Type';
            OptionMembers = Amount,Ticket;
            OptionCaption = 'Amount,Ticket';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                "Pay with Salary" := false;
            end;
        }
        field(26; Amount; Decimal)
        {
            Caption = 'Amount';
            DataClassification = CustomerContent;
        }
        field(27; "No. of Ticket"; Integer)
        {
            Caption = 'No. of Ticket';
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                Employee: Record Employee;
                EmployeeEarningHistroy: Record "Employee Earning History";
                PayPeriodLine: Record "Pay Period Line";
                AirTicketGroup: Record "Employee Level Air Ticket";
                SalaryComputation: Report "Salary Computation";
                TicketAllowed: Integer;
                TicketAllowedErr: Label 'You are allowed to apply for total of %1 Air Ticket';
            begin
                if "No. of Ticket" = 0 then
                    exit;
                Employee.Get("Employee No.");
                Employee.TestField("Air Ticket Group");
                SalaryComputation.GetPayPeriodLine("Requested Date", Employee."No.", PayPeriodLine);
                EmployeeEarningHistroy.SetRange("Employee No.", Employee."No.");
                EmployeeEarningHistroy.SetRange("Group Code", Employee."Air Ticket Group");
                EmployeeEarningHistroy.SetRange("Component Type", EmployeeEarningHistroy."Component Type"::"Air Ticket");
                EmployeeEarningHistroy.SetFilter("From Date", '<=%1', PayPeriodLine."Period End Date");
                EmployeeEarningHistroy.SetFilter("To Date", '>=%1', PayPeriodLine."Period End Date");
                EmployeeEarningHistroy.FindFirst();

                AirTicketGroup.SetRange("Air Ticket Group Code", EmployeeEarningHistroy."Group Code");
                AirTicketGroup.SetRange("From Date", EmployeeEarningHistroy."From Date");
                AirTicketGroup.FindLast();
                if AirTicketGroup.Accrual then
                    TicketAllowed := AirTicketGroup."Dependent Allowed" + 1;
                if "No. of Ticket" > TicketAllowed then
                    Error(TicketAllowedErr, TicketAllowed);

            end;
        }
        field(28; "Status"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = Open,Approved,"Pending Approval",Rejected;
            OptionCaption = 'Open,Approved,Pending Approval,Rejected';
            Caption = 'Status';
        }
        field(29; "Pay with Salary"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Pay with Salary';
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
        HrSetupG: Record "Human Resources Setup";
        LoanRequest: Record "Loan Request";
        NoSeriesMgtG: Codeunit NoSeriesManagement;
        NoSeriesG: Code[20];

    trigger OnInsert()
    begin
        if "No." = '' then begin
            HrSetupG.Get();
            HrSetupG.TESTFIELD("Air Ticket Request Nos.");
            NoSeriesMgtG.InitSeries(HrSetupG."Air Ticket Request Nos.", '', 0D, "No.", NoSeriesG);
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

    procedure AssisEdit(): Boolean
    begin
        HrSetupG.Get();
        HrSetupG.TestField("Air Ticket Request Nos.");
        IF NoSeriesMgtG.SelectSeries(HrSetupG."Air Ticket Request Nos.", '', NoSeriesG) then begin
            NoSeriesMgtG.SetSeries(HrSetupG."Air Ticket Request Nos.");
            exit(true);
        end;
    end;

}