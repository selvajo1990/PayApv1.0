report 50082 "Salary Increment Details"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'Salary Increment Details';
    DefaultLayout = RDLC;
    RDLCLayout = './res/SalaryIncrementDetails.rdl';

    dataset
    {
        dataitem("Salary Increment Header"; "Salary Increment Header")
        {
            RequestFilterFields = "Employee No.", "Effective Date";
            column(No_; "No.") { }
            column(Employee_No_; "Employee No.") { }
            column(Employee_Name; "Employee Name") { }
            column(Effective_Date; "Effective Date") { }
        }
        dataitem("Salary Increment Line"; "Salary Increment Line")
        {
            column(Earning_Group_Code; "Earning Group Code") { }
            column(Earning_Code; "Earning Code") { }
            column(Current_Amount; "Current Amount") { }
            column(Value; Value) { }
            column(Value_Percentage; "Value Percentage") { }
            column(New_Amount; "New Amount") { }
            column(Payment_Type; "Payment Type") { }
            column(Base_Code; "Base Code") { }
            column(Temp_EarningCode; TempSalIncLine."Earning Code") { }

            trigger OnAfterGetRecord()
            var

            begin
                recSalIncLine.Reset();
                recSalIncLine.SetRange("Document No.", "Document No.");
                recSalIncLine.SetRange(Inserted, true);
                if recSalIncLine.FindSet() then
                    repeat
                        TempSalIncLine.Init();
                        TempSalIncLine.TransferFields(recSalIncLine);
                        TempSalIncLine.Insert();
                    until recSalIncLine.Next() = 0;
            end;
        }
    }

    /* requestpage
     {
         layout
         {
             area(Content)
             {
                 group(GroupName)
                 {
                     field(Name; SourceExpression)
                     {
                         ApplicationArea = All;

                     }
                 }
             }
         }

         actions
         {
             area(processing)
             {
                 action(ActionName)
                 {
                     ApplicationArea = All;

                 }
             }
         }
     }*/

    /* rendering
     {
         layout(LayoutName)
         {
             Type = RDLC;
             LayoutFile = 'mylayout.rdl';
         }
     }*/

    var
        recEmpLevelEarning: Record "Employee Level Earning";
        recSalIncLine: Record "Salary Increment Line";
        recSalIncHeader: Record "Salary Increment Header";
        TempSalIncLine: Record "Salary Increment Line" temporary;
}