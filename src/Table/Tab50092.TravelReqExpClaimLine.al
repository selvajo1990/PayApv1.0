table 50092 "Travel Req. & Exp. Claim Line"
{
    DataClassification = ToBeClassified;
    Caption = 'Travel Requisition & Expense Claim Line';
    fields
    {
        field(1; "Document No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Document No.';
        }
        field(2; "Line No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Line No.';
        }
        field(22; "Travel & Expense Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Travel & Expense Code';
            TableRelation = "Travel & Expense Configuration" where("Travel & Expense Group Code" = field("Travel & Expense Group Code"));
            trigger OnValidate()
            var
                TravelExpenseSetup: Record "Travel & Expense Configuration";
            begin
                if (TravelExpenseSetup.Get("Travel & Expense Code")) then;
                Validate("Document Date", Today());
                Destination := TravelExpenseSetup.Destination;
                "Destination Type Description" := TravelExpenseSetup."Destination Type Description";
                "Expense Description" := TravelExpenseSetup."Expense Description";
                "Travel Payment Type" := TravelExpenseSetup."Travel Payment Type";
                "Currency Code" := TravelExpenseSetup.Currency;
                "Attachment Required" := TravelExpenseSetup."Attachment Required";
                "Expense Code" := TravelExpenseSetup."Expense Code";
                "Amount (FCY)" := 0;
                "Amount (LCY)" := 0;
                "Payable Amount (LCY)" := 0;
                if "Travel & Expense Code" = '' then begin
                    DocumentAttachment.SetRange("Table ID", Database::"Travel Req. & Exp. Claim Line");
                    DocumentAttachment.SetRange("No.", "Document No.");
                    DocumentAttachment.SetRange("Line No.", "Line No.");
                    DocumentAttachment.DeleteAll(true);
                end;
            end;
        }
        field(21; "Document Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Document Date';
            trigger OnValidate()
            begin
                if ("Currency Code" > '') and ("Amount (FCY)" > 0) and ("Document Date" > 0D) then
                    "Amount (LCY)" := GetConvertedCurrencyAmount("Amount (FCY)", "Currency Code", "Document Date");
            end;
        }
        field(23; "Destination"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Destination';
            Editable = false;
        }
        field(24; "Destination Type Description"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Destination Type Description';
            Editable = false;
        }
        field(26; "Expense Description"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Expense Description';
            Editable = false;
        }
        field(27; "Travel Payment Type"; Option)
        {
            OptionMembers = "Per Day","Hourly","Fixed Amount","Actuals/ As per Bill","Per Kilometer";
            OptionCaption = 'Per Day,Hourly,Fixed Amount,Actuals/ As per Bill,Per Kilometer';
            DataClassification = CustomerContent;
            Caption = 'Travel Payment Type';
            Editable = false;
        }
        field(28; "Amount (FCY)"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Value';
            trigger OnValidate()
            var
                ClaimHeader: Record "Travel Req & Expense Claim";
                TravelExpenseSetup: Record "Travel & Expense Configuration";
                HRSetup: Record "Human Resources Setup";
            begin

                CalcFields("Has Attachment");
                if ("Attachment Required") and (not "Has Attachment") then
                    Error(AttachmentRequiredErr);
                "Amount (LCY)" := 0;
                "Payable Amount (LCY)" := 0;
                if "Amount (FCY)" > 0 then begin
                    TestField("Currency Code");
                    TestField("Document Date");
                    "Amount (LCY)" := GetConvertedCurrencyAmount("Amount (FCY)", "Currency Code", "Document Date");

                    ClaimHeader.Get("Document No.");
                    ClaimHeader.TestField("No. of Days");
                    //ClaimHeader.TestField("Advance No.");
                    TravelExpenseSetup.Get("Travel & Expense Code");
                    HRSetup.Get();
                    case "Travel Payment Type" of
                        "Travel Payment Type"::"Actuals/ As per Bill":
                            "Payable Amount (LCY)" := "Amount (LCY)";
                        "Travel Payment Type"::"Fixed Amount":
                            begin
                                if TravelExpenseSetup."Max Amount" = 0 then
                                    TravelExpenseSetup."Max Amount" := "Amount (LCY)";

                                if "Amount (LCY)" < TravelExpenseSetup."Max Amount" then
                                    TravelExpenseSetup."Max Amount" := "Amount (LCY)";

                                "Payable Amount (LCY)" := Round(TravelExpenseSetup."Max Amount", HRSetup."HR Rounding Precision", HRSetup.RoundingDirection());
                            end;
                        "Travel Payment Type"::Hourly:
                            begin
                                "Payable Amount (LCY)" := Round("Amount (FCY)" * TravelExpenseSetup."Max Amount", HRSetup."HR Rounding Precision", HRSetup.RoundingDirection());
                                "Amount (LCY)" := 0;
                            end;
                        "Travel Payment Type"::"Per Day":

                            "Payable Amount (LCY)" := Round(ClaimHeader."No. of Days" * TravelExpenseSetup."Max Amount", HRSetup."HR Rounding Precision", HRSetup.RoundingDirection());
                        "Travel Payment Type"::"Per Kilometer":
                            begin
                                "Payable Amount (LCY)" := Round("Amount (FCY)" * TravelExpenseSetup."Max Amount", HRSetup."HR Rounding Precision", HRSetup.RoundingDirection());
                                "Amount (LCY)" := 0;
                            end;
                    end;
                end;
            end;
        }
        field(29; "Currency Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Currency Code';
            TableRelation = Currency;
            Editable = false;
            trigger OnValidate()
            begin
                if ("Currency Code" > '') and ("Amount (FCY)" > 0) then begin
                    TestField("Document Date");
                    "Amount (LCY)" := GetConvertedCurrencyAmount("Amount (FCY)", "Currency Code", "Document Date");
                end;
            end;
        }
        field(30; "Payable Amount (LCY)"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Payable Amount (LCY)';
            Editable = false;
        }
        field(31; "Attachment Required"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Attachment Required';
            Editable = false;
        }
        field(32; "Has Attachment"; Boolean)
        {
            FieldClass = FlowField;
            Caption = 'Has Attachment';
            CalcFormula = exist("Document Attachment" where("No." = field("Document No."), "Line No." = field("Line No.")));
            Editable = false;
        }
        field(33; "Amount (LCY)"; Decimal)
        {
            Caption = 'Amount Claimed (LCY)';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(34; "Expense Code"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(35; "Travel & Expense Group Code"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Travel & Expense Group";
        }
    }

    keys
    {
        key(PK; "Document No.", "Travel & Expense Group Code", "Line No.")
        {
            Clustered = true;
            SumIndexFields = "Amount (FCY)", "Payable Amount (LCY)";
        }
    }

    var
        DocumentAttachment: Record "Document Attachment";
        ClaimHdr: Record "Travel Req & Expense Claim";
        AttachmentRequiredErr: Label 'You have to attach the required document to proceed';

    trigger OnInsert()
    begin
    end;

    trigger OnModify()
    begin
        ClaimHdr.Get("Document No.");
        ClaimHdr.TestField(Status, ClaimHdr.Status::Open);
    end;

    trigger OnDelete()
    begin
        ClaimHdr.Get("Document No.");
        ClaimHdr.TestField(Status, ClaimHdr.Status::Open);

        DocumentAttachment.SetRange("Table ID", Database::"Travel Req. & Exp. Claim Line");
        DocumentAttachment.SetRange("No.", "Document No.");
        DocumentAttachment.SetRange("Line No.", "Line No.");
        DocumentAttachment.DeleteAll(true);
    end;

    trigger OnRename()
    begin

    end;

    procedure GetConvertedCurrencyAmount(Amount: Decimal; FromCurrency: Code[10]; Date: Date): Decimal
    var
        ExchangeRate: Record "Currency Exchange Rate";
        GeneralLedgerSetup: Record "General Ledger Setup";
        Currency: Record Currency;
    begin
        GeneralLedgerSetup.Get();
        GeneralLedgerSetup.TestField("LCY Code");
        Currency.get(GeneralLedgerSetup."LCY Code");
        exit(Round(ExchangeRate.ExchangeAmount(Amount, FromCurrency, GeneralLedgerSetup."LCY Code", Date), Currency."Amount Rounding Precision"));
    end;
}