tableextension 54103 "Human Resources Setup" extends "Human Resources Setup"
{
    fields
    {
        field(60000; "Leave Request Nos."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
            Caption = 'Leave Request Nos.';

        }
        field(60001; "Adhoc Payment Nos."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
            Caption = 'Adhoc Payment Nos.';
        }
        field(60002; "HR Rounding Precision"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'HR Rounding Precision';
            MinValue = 0;
        }
        field(60003; "HR Rounding Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = "Nearest","Up","Down";
            OptionCaption = 'Nearest,Up,Down';
            Caption = 'HR Rounding Type';
        }
        field(60004; "Loan Request Nos."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
            Caption = 'Loan Request Nos.';
        }
        field(60005; "Withhold Salary Nos."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
            Caption = 'Withhold Salary Nos.';
        }
        field(60007; "Salary Computation Nos."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
            Caption = 'Salary Computation Nos.';
        }
        field(60008; "Salary Cut-off Start Date"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Salary Cut-off Start Date';
            MinValue = 0;
            MaxValue = 28;
            BlankZero = true;
            trigger OnValidate()
            begin
                TestField("Salary Cut-off Start Date");
                "Salary Cut-off End Date" := "Salary Cut-off Start Date" - 1;
            end;
        }
        field(60009; "Salary Cut-off End Date"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Salary Cut-off End Date';
            MinValue = 0;
            MaxValue = 31;
            BlankZero = true;
            Editable = false;

        }
        field(60010; "Enable Salary Cut-off"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Enable Salary Cut-off';
            trigger OnValidate()
            begin
                if not "Enable Salary Cut-off" then begin
                    "Salary Cut-off End Date" := 0;
                    "Salary Cut-off Start Date" := 0;
                end else
                    Validate("Salary Cut-off Start Date", Date2DMY(Today(), 1));
            end;
        }
        field(60011; "Leave Encashment No."; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Leave Encashment No.';
            TableRelation = "No. Series";
        }
        field(60012; "Timing Nos."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Timing Nos.';
            TableRelation = "No. Series";
        }
        field(60013; "Gratuity Accrual Days"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Gratuity Accrual Days';
            MinValue = 360;
            MaxValue = 366;
        }
        field(60014; "End of Service Nos."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'End of Service Nos.';
            TableRelation = "No. Series";
        }
        field(60015; "Bank Account"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Bank Account';
            TableRelation = "Employee Bank Account Master";
            trigger OnValidate()
            begin
                CalcFields("Bank Name");
            end;
        }
        field(60016; "Bank Name"; Text[100])
        {
            Caption = 'Bank Name';
            FieldClass = FlowField;
            CalcFormula = lookup("Employee Bank Account Master"."Bank Name" where(Code = field("Bank Account")));
        }
        field(60017; "Salary Comp. Jnl. Template"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Salary Comp. Jnl. Template';
            TableRelation = "Gen. Journal Template" where(Type = const(General), Recurring = const(false), "Payroll Template" = const(true));
        }
        field(60018; "Accurals Jnl. Template"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Accurals Jnl. Template';
            TableRelation = "Gen. Journal Template" where(Type = const(General), Recurring = const(false));
        }
        field(60019; "EOS Jnl. Template"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'EOS Jnl. Template';
            TableRelation = "Gen. Journal Template" where(Type = const(General), Recurring = const(false));
        }
        field(60020; "Employee Level Posting"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Employee Level Posting';

        }
        field(60021; "Employee Dimension Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Employee Dimension Code';
            TableRelation = Dimension;
        }
        field(60022; "Company ID"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Company ID';
        }
        field(60023; "Air Ticket Request Nos."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Air Ticket Request Nos.';
            TableRelation = "No. Series";
        }
        field(60024; "Salary Increment Nos."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Salary Increment Nos.';
            TableRelation = "No. Series";
        }
        field(60025; "Working Hours"; Duration)
        {
            DataClassification = CustomerContent;
            Caption = 'Working Hours';
        }
        field(60026; "Employee Asset Nos."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Employee Asset Nos.';
            TableRelation = "No. Series";
        }

        field(60027; "Over Time Nos."; Code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Over Time Nos.';
            TableRelation = "No. Series";
        }
        field(60028; "HR Manager"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'HR Manager';
            TableRelation = Employee where(Manager = const(true));

            trigger OnValidate()
            var
                EmployeeL: Record Employee;
            begin
                if EmployeeL.Get(Rec."HR Manager") then
                    Rec."HR Manager Name" := EmployeeL.FullName();

                EmployeeL.Reset();
                EmployeeL.SetFilter("HR Manager", '<>%1', Rec."HR Manager");
                if EmployeeL.FindSet() then
                    repeat
                        EmployeeL."HR Manager" := Rec."HR Manager";
                        EmployeeL."HR Manager Name" := Rec."HR Manager Name";
                        EmployeeL.Modify();
                    until EmployeeL.Next() = 0;
            end;
        }
        field(60029; "HR Manager Name"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'HR Manager Name';
            Editable = false;
        }
        field(60030; "Document Req No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Document Rq No.';
            TableRelation = "No. Series";
        }

    }

    procedure RoundingDirection(): Text[1]
    begin
        CASE "HR Rounding Type" OF
            "HR Rounding Type"::Nearest:
                EXIT('=');
            "HR Rounding Type"::Up:
                EXIT('>');
            "HR Rounding Type"::Down:
                EXIT('<');
        END;
    end;

}