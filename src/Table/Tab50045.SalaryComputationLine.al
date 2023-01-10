table 50045 "Salary Computation Line"
{
    DataClassification = CustomerContent;
    Caption = 'Salary Computation Line';

    fields
    {
        field(1; "Computation No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Computation No.';
        }
        field(2; "Line No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Line No.';
        }
        field(21; "Employee No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Employee No.';
            TableRelation = Employee;
        }
        field(22; "Employee Name"; Text[50])
        {
            FieldClass = FlowField;
            Caption = 'Employee Name';
            CalcFormula = lookup(Employee."First Name" where("No." = field("Employee No.")));
        }
        field(23; "Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Code';
            //TableRelation = "Earning";
        }
        field(24; Amount; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Amount';
        }
        field(25; Description; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Description';
        }
        field(26; "No. of Working Days"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'No. of Working Days';
        }
        field(27; "No. of UnPaid Leave Days"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'No. of UnPaid Leave Days';
        }
        field(28; "Line Type"; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Line Type';
            OptionMembers = " ","Earning","Absence","Loans","PASI/GOSI";
            OptionCaption = ' ,Earning,Absence,Loans,PASI/GOSI';
        }
        field(29; "Salary Class"; Code[20])
        {
            // Avi : Removed the flowfield coz if am doing leave calculation it might fall in 2 monthns.
            DataClassification = CustomerContent;
            Caption = 'Salary Class';
            TableRelation = "Salary Class";
        }
        field(30; "No. of Paid Leave Days"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'No. of Paid Leave Days';
        }
        field(31; "Pay Period"; Code[30])
        {
            // Avi : Removed the flowfield coz if am doing leave calculation it might fall in 2 monthns.
            DataClassification = CustomerContent;
            Caption = 'Pay Period';
        }
        field(32; "Pay With Salary"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Pay With Salary';
        }
        field(33; Category; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = " ","Earning","Deduction","Absence";// Avi : Added Absence
            OptionCaption = ' ,Earning,Deduction,Absence';
            Caption = 'Category';
        }
        field(34; Type; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = " ","Constant","Adhoc","Employer Contribution";
            OptionCaption = ' ,Constant,Adhoc,Employer Contribution';
            Caption = 'Type';
        }
        field(35; "Show in Payslip"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Show in Payslip';
        }
        field(36; "Affects Salary"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Affects Salary';
        }
        field(37; "No. Of WithHold Days"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'No. Of WithHold Days';
        }
        field(38; Accrual; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Accrual';
        }
        field(39; "Accrual Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = "Leave Accrual","Gratuity Accrual","Air Ticket"," ";
            OptionCaption = 'Leave Accrual,Gratuity Accrual,Air Ticket, ';
        }
        field(40; "Computation Code"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Computation;
            Caption = 'Computation Code';
        }
        field(41; "Total Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Total Amount';
        }
        field(42; "Opening Balance"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Opening Balance';
        }
        field(43; "Accrual Value"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Accrual Value';
        }
        field(44; "Total Accrual Value"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Total Accrual Value';
        }
        field(45; "Comments"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Comments';
        }
        field(46; "Computation Type"; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Computation Type';
            OptionMembers = " ","Working Days","Leave Days";
            OptionCaption = ' ,Working Days,Leave Days';
        }
        field(47; "Posting Category"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = " ","Accruals","Salary","End of Service","Instalment","Encashment","Travel & Expense";
        }
        field(48; "Reference Document No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(49; "Free Text 1"; Text[50])
        {
            DataClassification = CustomerContent;
            Description = 'Only For Development';
        }
        field(50; "Free Text 2"; Text[250])
        {
            DataClassification = CustomerContent;
            Description = 'Only For Development';
        }
    }
    keys
    {
        key(PK; "Computation No.", "Line No.")
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
