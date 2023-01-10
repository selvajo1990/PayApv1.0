report 50081 "Travel & Expenses"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    Caption = 'Travel & Expenses Report';
    RDLCLayout = './res/Travel&Expenses.rdl';

    dataset
    {
        dataitem("Travel & Expense Advance"; "Travel & Expense Advance")
        {
            DataItemTableView = sorting("No.");

            column(CompanyInformationG_Name;
            CompanyInformationG.Name)
            {
            }
            column(CompanyInformationG_Picture;
            CompanyInformationG.Picture)
            {
            }
            column(CompanyInformationG_Address;
            CompanyInformationG.Address)
            {
            }
            column(CompanyInformationG_Address2;
            CompanyInformationG."Address 2")
            {
            }
            column(CompanyInformationG_Phone;
            CompanyInformationG."Phone No.")
            {
            }
            column(CompanyInformationG_Email;
            CompanyInformationG."E-Mail")
            {
            }
            column(SI;
            SI)
            {
            }
            column(No_;
            "No.")
            {
            }
            column(AmountFCY;
            "Amount (FCY)")
            {
            }
            column(AmountLCY;
            "Amount (LCY)")
            {
            }
            column(ApprovedDate;
            "Approved Date")
            {
            }
            column(AssignedinClaim;
            "Assigned in Claim")
            {
            }
            column(CurrencyCode;
            "Currency Code")
            {
            }
            column(Destination;
            Destination)
            {
            }
            column(DestinationCode;
            "Destination Code")
            {
            }
            column(DocumentDate;
            "Document Date")
            {
            }
            column(EmployeeName;
            "Employee Name")
            {
            }
            column(EmployeeNo;
            "Employee No.")
            {
            }
            column(ExpenseCategoryCode;
            "Expense Category Code")
            {
            }
            column(ExpenseCategoryDescription;
            "Expense Category Description")
            {
            }
            column(JournalCreated;
            "Journal Created")
            {
            }
            column(PayWithSalary;
            "Pay With Salary")
            {
            }
            column(PurposeofVisit;
            "Purpose of Visit")
            {
            }
            column(PurposeofVisitDescription;
            "Purpose of Visit Description")
            {
            }
            column(Status;
            Status)
            {
            }
            column(Payamount;
            Payamount)
            {
            }
            column(ClaimAmount;
            ClaimAmount)
            {
            }
            column(TravelDescription;
            TravelDescription)
            {
            }
            column(NoofDays;
            NoofDays)
            {
            }
            column(EmpDepartment;
            EmpDepartment)
            {
            }
            column(EmpDesignation; EmpDesignation)
            {
            }
            trigger OnPreDataItem()
            begin
                if EmployeeNoG <> '' then SetRange("Employee No.", EmployeeNoG);
                if (FromDate <> 0D) and (Todate <> 0D) then setrange("Document Date", FromDate, Todate);
            end;

            trigger OnAfterGetRecord()
            begin
                SI += 1;
                Payamount := 0;
                ClaimAmount := 0;
                NoofDays := 0;
                TravelDescription := '';
                EmpDepartment := '';
                EmpDesignation := '';
                EmployeeG.Get("Employee No.");
                DesignationG.Reset();
                DesignationG.SetRange("Employee No.", "Employee No.");
                if DesignationG.FindLast() then begin
                    EmpDesignation := DesignationG.Description;
                    DepartmentG.Get(DesignationG.Department);
                    EmpDepartment := DepartmentG.Description;
                end;
                travelgroup.Get(EmployeeG."Travel & Expense Group");
                TravelDescription := travelgroup.Description;
                TravelExpClaimG.Reset();
                TravelExpClaimG.SetRange("Employee No.", "Employee No.");
                TravelExpClaimG.SetRange("Advance No.", "No.");
                if TravelExpClaimG.FindFirst() then begin
                    NoofDays := TravelExpClaimG."No. of Days";
                    TravelExpClaimLineG.Reset();
                    TravelExpClaimLineG.SetRange("Document No.", TravelExpClaimG."No.");
                    if TravelExpClaimLineG.FindSet() then
                        repeat
                            Payamount += TravelExpClaimLineG."Payable Amount (LCY)";
                            ClaimAmount += TravelExpClaimLineG."Amount (LCY)";
                        until TravelExpClaimLineG.Next() = 0;
                end;
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    field("Employee No."; EmployeeNoG)
                    {
                        ApplicationArea = All;
                        TableRelation = Employee;
                        ToolTip = 'Specifies the value of the EmployeeNoG';

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            EmployeeL: Record Employee;
                            FilterSelectionL: Codeunit SelectionFilterManagement;
                            EmployeeListL: Page "Employee List";
                            RecRefL: RecordRef;
                        begin
                            EmployeeListL.LookupMode := true;
                            EmployeeListL.SetTableView(EmployeeL);
                            if EmployeeListL.RunModal() = Action::LookupOK then begin
                                EmployeeListL.SetSelectionFilter(EmployeeL);
                                RecRefL.GetTable(EmployeeL);
                                Evaluate(EmployeeNoG, FilterSelectionL.GetSelectionFilter(RecRefL, EmployeeL.FieldNo("No.")));
                            end;
                        end;
                    }
                    field(FromDateL; FromDate)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the FromDate';
                    }
                    field(TodateL; Todate)
                    {
                        ApplicationArea = all;
                        ToolTip = 'Specifies the value of the Todate';
                    }
                }
            }
        }
    }
    //     actions
    // {
    //     area(processing)
    //     {
    //         action(ActionName)
    //         {
    //             ApplicationArea = All;
    //         }
    //     }
    // }
    trigger OnPreReport()
    begin
        SI := 0;
        CompanyInformationG.get();
        CompanyInformationG.CalcFields(Picture);
    end;

    var
        CompanyInformationG: record "Company Information";
        TravelExpClaimG: record "Travel Req & Expense Claim";
        TravelExpClaimLineG: record "Travel Req. & Exp. Claim Line";
        travelgroup: record "Travel & Expense Group";
        EmployeeG: record Employee;
        DesignationG: record "Employee Level Designation";
        DepartmentG: record Department;
        SI: Integer;
        Payamount: Decimal;
        ClaimAmount: Decimal;
        NoofDays: Integer;
        FromDate: date;
        Todate: Date;
        EmployeeNoG: Code[30];
        TravelDescription: text;
        EmpDepartment: Text;
        EmpDesignation: text;
}
