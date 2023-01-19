page 50061 "Loan Request List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Loan Request";
    Caption = 'Loan & Advance Requests';
    Editable = false;
    CardPageId = "Loan Request Card";
    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Loan Request No."; Rec."Loan Request No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Loan Request No.';
                }
                field("Loan Description"; Rec."Loan Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Loan Description';
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Employee No.';
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Employee Name';
                }
                field("Loan Type"; Rec."Loan Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Loan Type';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Amount';
                }
                field("Outstanding Amount"; "Outstanding Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Outstanding Amount';
                }
            }
        }
        area(Factboxes)
        {

        }
    }
    actions
    {
        area(Processing)
        {
            action("ESS Loan Request") //SKR 18-01-2023
            {
                ApplicationArea = All;
                Caption = 'ESS Loan Request';
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Visible = EssUser;
                Image = SendApprovalRequest;
                RunObject = page "Employee Loan Request";
            }
        }
    }
    var
        GetEmpNoG: Codeunit "Single Instance";
        UserSetupG: Record "User Setup";
        EmpNoG: Code[20];
        EssUser: Boolean;

    trigger OnOpenPage() //SKR 17-01-2023
    var
        GetEmpNo: Codeunit "Single Instance";
    begin
        Clear(EssUser);
        if UserSetupG.Get(UserId) and UserSetupG."Is ESS User" then begin
            EssUser := true;
            Clear(EmpNoG);
            EmpNoG := GetEmpNo.GetEmpNo();
            Rec.SetRange("Employee No.", EmpNoG);
        end else
            EssUser := false;
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        if UserSetupG.Get(UserId) and UserSetupG."Is ESS User" then
            Rec.Delete(false);
    end;
}