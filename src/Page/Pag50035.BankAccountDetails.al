page 50035 "Bank Account Details"
{
    PageType = List;
    SourceTable = "Employee Bank Account Detail";
    Caption = 'Bank Account Details';
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Account Identification"; Rec."Account Identification")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Account Identification';
                }
                field("Bank Name"; Rec."Bank Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Bank Name';
                }
                field("Swift Code"; Rec."Swift Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Swift Code';
                }
                field("Branch Name"; Rec."Branch Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Branch Name';
                }
                field("Branch Address"; Rec."Branch Address")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Branch Address';
                }
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Account No.';
                }
                field("IBAN No."; Rec."IBAN No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the IBAN No.';
                }
                field(Primary; Rec.Primary)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Primary';
                }
            }
        }
    }
    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        BankAccountDetailsL: Record "Employee Bank Account Detail";
        PrimaryErr: Label 'You must select one bank as primary';
    begin
        BankAccountDetailsL.SetRange("Employee No.", Rec."Employee No.");
        if not BankAccountDetailsL.IsEmpty() then begin
            BankAccountDetailsL.SetRange(Primary, true);
            if BankAccountDetailsL.IsEmpty() then
                Error(PrimaryErr);
        end
    end;
}