page 60158 "Salary Increment Subpage"
{

    PageType = Listpart;
    SourceTable = "Salary Increment Line";
    Caption = 'Salary Increment Subpage';
    // AutoSplitKey = true;
    DelayedInsert = true;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Employee No."; Rec."Employee No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Employee No.';
                    Editable = false;
                    Visible = false;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Employee Name';
                    Visible = false;

                }
                field("Earning Group Code"; Rec."Earning Group Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Earning Group Code';
                    //Editable = pEdit;
                    trigger OnValidate()
                    var
                        SalaryIncsubpage: Record "Salary Increment Line";
                        EarningErrorCode: Label 'Please select Earning Group Code of %1';
                    begin
                        SalaryIncsubpage.Reset();
                        SalaryIncsubpage.SetRange("Document No.", rec."Document No.");
                        SalaryIncsubpage.SetRange("Employee No.", rec."Employee No.");
                        //SalaryIncsubpage.SetRange("Earning Group Code", rec."Earning Group Code");
                        if SalaryIncsubpage.FindFirst() then begin
                            if SalaryIncsubpage."Earning Group Code" <> Rec."Earning Group Code" then
                                Error(EarningErrorCode);
                        end;

                    end;

                }
                field("Earning Code"; Rec."Earning Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Earning Code';
                }
                field("Base Code"; Rec."Base Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Base Code';
                }
                field("Payment Type"; Rec."Payment Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Payment Type';
                }
                field(Value; Rec.Value)
                {
                    ApplicationArea = All;
                    Editable = Rec."Payment Type" = Rec."Payment Type"::Amount;
                    ToolTip = 'Specifies the value of the Value';

                }
                field("Value Percentage"; rec."Value Percentage")
                {
                    ApplicationArea = All;
                    Editable = Rec."Payment Type" = Rec."Payment Type"::Percentage;
                    ToolTip = 'Specifies the value of the Value Percentage';
                }
                field("Current Amount"; Rec."Current Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Current Amount';
                }
                field("New Amount"; Rec."New Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the New Amount';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Employee Earning Histroy")
            {
                Caption = 'Employee Earning Histroy';
                ApplicationArea = All;
                Image = History;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Promoted = true;
                ShortcutKey = 'Shift + Ctrl + H';
                RunObject = page "Employee Group History";
                RunPageLink = "Employee No." = field("Employee No."), "Component Type" = filter(Earning);
                ToolTip = 'Executes the Employee Earning Histroy action.';
            }

            /* action(Confirm) // Created and commented by suganya-m
             {
                 Caption = 'Confirm';
                 ApplicationArea = all;
                 Image = UpdateDescription;
                 Promoted = true;
                 PromotedCategory = Process;
                 PromotedIsBig = true;

                 trigger OnAction()
                 var
                     recEmployeeEarning: Record "Employee Level Earning";
                     recSalaryIncHeader: Record "Salary Increment Header";
                     recSalaryIncLine: Record "Salary Increment Line";
                     recEarning: Record Earning;
                 begin
                     if recSalaryIncHeader.Get(rec."Document No.") then begin
                         recSalaryIncLine.Reset();
                         recSalaryIncLine.SetRange("Document No.", Rec."Document No.");
                         recSalaryIncLine.SetRange(Inserted, false);
                         if recSalaryIncLine.FindSet() then
                             repeat
                                 recEmployeeEarning.Init();
                                 recEmployeeEarning."Employee No." := recSalaryIncLine."Employee No.";
                                 recEmployeeEarning."Group Code" := recSalaryIncLine."Earning Group Code";
                                 recEmployeeEarning."From Date" := recSalaryIncHeader."Document Date";
                                 recEmployeeEarning."Earning Code" := recSalaryIncLine."Earning Code";
                                 if recEarning.Get(recSalaryIncLine."Earning Code") then
                                     recEmployeeEarning."Base Code" := recEarning."Base Code";
                                 recEmployeeEarning.Validate("Earning Code");
                                 recEmployeeEarning."Payment Type" := recSalaryIncLine."Payment Type";
                                 recEmployeeEarning."Pay Percentage" := recSalaryIncLine."Value Percentage";
                                 recEmployeeEarning."Pay Amount" := recSalaryIncLine."New Amount";
                                 recEmployeeEarning.Insert();
                             until recSalaryIncLine.Next() = 0;
                     end;
                 end;
             }*/ // Created and commented by suganya-m
        }
    }
    var
        pEdit: Boolean;
        recSalaryIncLine: Record "Salary Increment Line";

    trigger OnOpenPage()
    begin
        /* recSalaryIncLine.Reset();
         recSalaryIncLine.SetRange("Document No.", rec."Document No.");
         recSalaryIncLine.SetRange("Line No.", Rec."Line No.");
         recSalaryIncLine.SetRange("Payment Type", recSalaryIncLine."Payment Type"::Percentage);
         if recSalaryIncLine.FindFirst() then
             pEdit := false
         else
             pEdit := true;*/
    end;

    trigger OnAfterGetRecord()
    begin
        /*recSalaryIncLine.Reset();
        recSalaryIncLine.SetRange("Document No.", rec."Document No.");
        recSalaryIncLine.SetRange("Line No.", Rec."Line No.");
        recSalaryIncLine.SetRange("Payment Type", recSalaryIncLine."Payment Type"::Percentage);
        if recSalaryIncLine.FindFirst() then
            pEdit := false
        else
            pEdit := true;*/
    end;


    trigger OnAfterGetCurrRecord()
    begin
        /*recSalaryIncLine.Reset();
        recSalaryIncLine.SetRange("Document No.", rec."Document No.");
        recSalaryIncLine.SetRange("Line No.", Rec."Line No.");
        recSalaryIncLine.SetRange(Inserted, true);
        if recSalaryIncLine.FindFirst() then
            pEdit := false
        else
            pEdit := true;*/
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        /* recSalaryIncLine.Reset();
         recSalaryIncLine.SetRange("Document No.", rec."Document No.");
         recSalaryIncLine.SetRange("Line No.", Rec."Line No.");
         recSalaryIncLine.SetRange(Inserted, true);
         if recSalaryIncLine.FindFirst() then
             pEdit := false
         else
             pEdit := true;*/
    end;
}
