report 50001 "PrintVis Sales Invoice"
{
    // Date     Order Chg   Init Text
    // ------------------------------------
    // 07-08-15 78040 Chg01 TN   Fix dateformat to mm/dd/yy for PrintVis Inc
    // 14-10-15 78459       TN   Field BillToCust_VATRegistrationNo added dataset
    // 
    // 20-10-15             KT   US Format of amounts
    // 
    // 18-09-17 82097       PT   Add Coordinator from PV Case
    RDLCLayout = './src/reports/PrintVis Sales Invoice.rdlc';
    WordLayout = './src/reports/PrintVis Sales Invoice.docx';

    DefaultLayout = Word;
    Permissions = TableData "Sales Shipment Buffer" = rimd;
    PreviewMode = PrintLayout;
    WordMergeDataItem = Document;
    Caption = 'H&W PrintVis Sales Invoice';

    dataset
    {
        dataitem(Document; "Sales Invoice Header")
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.", "Sell-to Customer No.", "No. Printed";
            RequestFilterHeading = 'Posted Sales Invoice';
            dataitem(Labels; "Integer")
            {
                MaxIteration = 1;
                column(Labels_AppliesToDocNo; Document.FieldCaption("Applies-to Doc. No."))
                {
                }
                column(Labels_Amount; PriceLbl)
                {
                }
                column(Labels_AmountInclTax; Document.FieldCaption("Amount Including VAT"))
                {
                }
                column(Labels_BillTo; BillToLbl)
                {
                }
                column(Labels_BillToCustomerNo; CustomerNoLbl)
                {
                }
                column(Labels_CompanyBankAccountNo; CompanyInfo.FieldCaption("Bank Account No."))
                {
                }
                column(Labels_CompanyBankBranch; CompanyInfo.FieldCaption("Bank Branch No."))
                {
                }
                column(Labels_CompanyBankName; CompanyInfo.FieldCaption("Bank Name"))
                {
                }
                column(Labels_CompanyGiroNo; CompanyInfo.FieldCaption("Giro No."))
                {
                }
                column(Labels_CompanyCustomGiroNo; CompanyInfo.GetCustomGiroLbl)
                {
                }
                column(Labels_CompanyIBAN; CompanyInfo.FieldCaption(IBAN))
                {
                }
                column(Labels_CompanyLegalOffice; CompanyInfo.GetLegalOfficeLbl)
                {
                }
                column(Labels_CompanyPhoneNo; CompanyInfo.FieldCaption("Phone No."))
                {
                }
                column(Labels_CompanySWIFT; CompanyInfo.FieldCaption("SWIFT Code"))
                {
                }
                column(Labels_CompanyRegNo; CompanyInfo.GetRegistrationNumberLbl)
                {
                }
                column(Labels_CompanyTaxRegNo; CompanyInfo.GetVATRegistrationNumberLbl)
                {
                }
                column(Labels_CustomerPostalBarCode; FormatAddr.PostalBarCode(1))
                {
                }
                column(Labels_CustomerTaxRegNo; VATnoLabel)
                {
                }
                column(Labels_Description; Lines.FieldCaption(Description))
                {
                }
                column(Labels_DiscountAmt; DiscountLabel)
                {
                }
                column(Labels_DiscountPct; Lines.FieldCaption("Line Discount %"))
                {
                }
                column(Labels_DocumentNo; Lines.FieldCaption("Document No."))
                {
                }
                column(Labels_DocumentDate; Document.FieldCaption("Document Date"))
                {
                }
                column(Labels_DueDate; Document.FieldCaption("Due Date"))
                {
                }
                column(Labels_Email; CompanyInfo.FieldCaption("E-Mail"))
                {
                }
                column(Labels_HomePage; CompanyInfo.FieldCaption("Home Page"))
                {
                }
                column(Labels_InvoiceDiscount; Lines.FieldCaption("Inv. Discount Amount"))
                {
                }
                column(Labels_InvoiceDiscountBase; TaxAmountLines.FieldCaption("Inv. Disc. Base Amount"))
                {
                }
                column(Labels_LegalEntityType; Cust.GetLegalEntityTypeLbl)
                {
                }
                column(Labels_LocalCurrency; Document.FieldCaption("Currency Code"))
                {
                }
                column(Labels_LineAmount; AmountLbl)
                {
                }
                column(Labels_OrderNo; OrderNoLbl)
                {
                }
                column(Labels_No; Lines.FieldCaption("No."))
                {
                }
                column(Labels_PaymentTerms; PaymentTermsLabel)
                {
                }
                column(Labels_PaymentMethod; PaymentMethodLabel)
                {
                }
                column(Labels_PostingDate; Document.FieldCaption("Posting Date"))
                {
                }
                column(Labels_Quantity; Lines.FieldCaption(Quantity))
                {
                }
                column(Labels_Salesperson; SalespersonLbl)
                {
                }
                column(Labels_SellToCustomerNo; Document.FieldCaption("Sell-to Customer No."))
                {
                }
                column(Labels_ShipmentDate; Document.FieldCaption("Shipment Date"))
                {
                }
                column(Labels_ShipmentMethod; ShipmentMethodLabel)
                {
                }
                column(Labels_ShipmentNo; Lines.FieldCaption("Shipment No."))
                {
                }
                column(Labels_ShipmentQty; QtyShippedToPrint)
                {
                }
                column(Labels_ShipTo; ShipToLabel)
                {
                }
                column(Labels_Subtotal; SubtotalLbl)
                {
                }
                column(Labels_UnitPrice; Lines.FieldCaption("Unit Price"))
                {
                }
                column(Labels_UnitOfMeasure; Lines.FieldCaption("Unit of Measure Code"))
                {
                }
                column(Labels_Total; TotalLabel)
                {
                }
                column(Labels_TotalExcludingTax; TotalExclVATLabel)
                {
                }
                column(Labels_TotalIncludingTax; TotalInclVATLabel)
                {
                }
                column(Labels_TaxAmount; TaxAmountLabel)
                {
                }
                column(Labels_TaxAmountSpec; VATAmountSpecLbl)
                {
                }
                column(Labels_TaxBase; TaxAmountLines.FieldCaption("VAT Base"))
                {
                }
                column(Labels_TaxClause; TaxAmountLines.FieldCaption("VAT Clause Code"))
                {
                }
                column(Labels_TaxIdentifier; TaxAmountLines.FieldCaption("VAT Identifier"))
                {
                }
                column(Labels_TaxInvDiscBase; TaxAmountLines.FieldCaption("Inv. Disc. Base Amount"))
                {
                }
                column(Labels_TaxPct; TaxAmountLines.FieldCaption("VAT %"))
                {
                }
                column(Labels_TaxRegistrationNo; Cust.FieldCaption("VAT Registration No."))
                {
                }
                column(Labels_YourReference; Document.FieldCaption("Your Reference"))
                {
                }
                column(Labels_HWCoordinatorName; HW_PVCase.FIELDCAPTION("Coordinator Name"))
                {
                }
                column(Labels_HWCoordinator; HW_PVCase.FIELDCAPTION(Coordinator))
                {
                }
            }
            dataitem(Company; "Integer")
            {
                DataItemTableView = SORTING(Number);
                MaxIteration = 1;
                column(Company_Address1; CompanyAddr[1])
                {
                }
                column(Company_Address2; CompanyAddr[2])
                {
                }
                column(Company_Address3; CompanyAddr[3])
                {
                }
                column(Company_Address4; CompanyAddr[4])
                {
                }
                column(Company_Address5; CompanyAddr[5])
                {
                }
                column(Company_Address6; CompanyAddr[6])
                {
                }
                column(Company_Address7; CompanyAddr[7])
                {
                }
                column(Company_Address8; CompanyAddr[8])
                {
                }
                column(Company_HomePage; CompanyInfo."Home Page")
                {
                }
                column(Company_Email; CompanyInfo."E-Mail")
                {
                }
                column(Company_PhoneNo; CompanyInfo."Phone No.")
                {
                }
                column(Company_GiroNo; CompanyInfo."Giro No.")
                {
                }
                column(Company_BankName; CompanyInfo."Bank Name")
                {
                }
                column(Company_BankBranchNo; CompanyInfo."Bank Branch No.")
                {
                }
                column(Company_BankAccountNo; CompanyInfo."Bank Account No.")
                {
                }
                column(Company_IBAN; CompanyInfo.IBAN)
                {
                }
                column(Company_SWIFT; CompanyInfo."SWIFT Code")
                {
                }
                column(Company_RegistrationNo; CompanyInfo.GetRegistrationNumber)
                {
                }
                column(Company_TaxRegNo; CompanyInfo.GetVATRegistrationNumber)
                {
                }
                column(Company_LegalOffice; CompanyInfo.GetLegalOffice)
                {
                }
                column(Company_CustomGiro; CompanyInfo.GetCustomGiro)
                {
                }
                column(Company_Logo; CompanyInfo.Picture)
                {
                }
            }
            dataitem(Customer; "Integer")
            {
                DataItemTableView = SORTING(Number);
                MaxIteration = 1;
                column(Customer_Address1; CustAddr[1])
                {
                }
                column(Customer_Address2; CustAddr[2])
                {
                }
                column(Customer_Address3; CustAddr[3])
                {
                }
                column(Customer_Address4; CustAddr[4])
                {
                }
                column(Customer_Address5; CustAddr[5])
                {
                }
                column(Customer_Address6; CustAddr[6])
                {
                }
                column(Customer_Address7; CustAddr[7])
                {
                }
                column(Customer_Address8; CustAddr[8])
                {
                }
                column(Customer_LegalEntityType; Cust.GetLegalEntityType)
                {
                }
                column(Customer_CustomerPostalBarCode; FormatAddr.PostalBarCode(1))
                {
                }
            }
            dataitem(Shipment; "Integer")
            {
                DataItemTableView = SORTING(Number);
                column(Shipment_Address1; ShipToAddr[1])
                {
                }
                column(Shipment_Address2; ShipToAddr[2])
                {
                }
                column(Shipment_Address3; ShipToAddr[3])
                {
                }
                column(Shipment_Address4; ShipToAddr[4])
                {
                }
                column(Shipment_Address5; ShipToAddr[5])
                {
                }
                column(Shipment_Address6; ShipToAddr[6])
                {
                }
                column(Shipment_Address7; ShipToAddr[7])
                {
                }
                column(Shipment_Address8; ShipToAddr[8])
                {
                }
                column(Shipment_ShipmentMethod; ShipmentMethod.Description)
                {
                }

                trigger OnAfterGetRecord()
                var
                    SkipTable: Boolean;
                begin
                    if Number = 1 then begin
                        if not HW_SortingBuffer.FINDFIRST then
                            SkipTable := true;
                    end else begin
                        HW_SortingBuffer.NEXT;
                    end;
                    if not SkipTable then begin
                        ShipToAddr[1] := HW_SortingBuffer.Text1;
                        ShipToAddr[2] := HW_SortingBuffer.Text2;
                        ShipToAddr[3] := HW_SortingBuffer.Text3;
                        ShipToAddr[4] := HW_SortingBuffer.Text4;
                        ShipToAddr[5] := HW_SortingBuffer.Text5;
                        ShipToAddr[6] := HW_SortingBuffer.Text6;
                        ShipToAddr[7] := HW_SortingBuffer.Text7;
                        ShipToAddr[8] := HW_SortingBuffer.Text8;
                    end;
                    CompressArray(ShipToAddr);
                    ShipToAddr[1] := StrSubstNo('%1 %2 %3 %4 %5 %6 %7 %8', ShipToAddr[1], ShipToAddr[2], ShipToAddr[3], ShipToAddr[4], ShipToAddr[5], ShipToAddr[6], ShipToAddr[7], ShipToAddr[8]);
                end;

                trigger OnPreDataItem()
                var
                    C: Integer;
                begin
                    HW_SortingBuffer.RESET;
                    C := HW_SortingBuffer.COUNT;
                    if C > 0 then
                        Shipment.SetRange(Number, 1, C)
                    else
                        Shipment.SetRange(Number, 1);
                end;
            }
            dataitem(Header; "Integer")
            {
                DataItemTableView = SORTING(Number);
                MaxIteration = 1;
                column(Header_AppliesToDocNo; AppliesToTextToPrint)
                {
                }
                column(Header_BillToCustomerNo; Document."Bill-to Customer No.")
                {
                }
                column(Header_CurrencyCode; Document."Currency Code")
                {
                }
                column(Header_DocumentDate; DocumentDateTxt)
                {
                }
                column(Header_DocumentType; DocumentTypetoPrint)
                {
                }
                column(Header_DocumentNo; Document."No.")
                {
                }
                column(Header_DueDate; DueDateTxt)
                {
                }
                column(Header_ExchangeRate; ExchangeRateText)
                {
                }
                column(Header_GlobalLocationNumber; Document.GetCustomerGlobalLocationNumber)
                {
                }
                column(Header_PaymentTerms; PaymentTerms.Description)
                {
                }
                column(Header_PaymentMethod; PaymentMethod.Description)
                {
                }
                column(Header_LegalEntityType; Cust.GetLegalEntityType)
                {
                }
                column(Header_OrderNo; OrderNoToPrint)
                {
                }
                column(Header_PostingDate; PostingDateTxt)
                {
                }
                column(Header_QuoteNo; QuoteNoToPrint)
                {
                }
                column(Header_Salesperson; SalespersonPurchaser.Name)
                {
                }
                column(Header_SelltoCustomerNo; Document."Sell-to Customer No.")
                {
                }
                column(Header_CustomerName; CustomerName)
                {
                }
                column(Header_YourReference; Document."Your Reference")
                {
                }
                column(Header_TaxRegistrationNo; Document.GetCustomerVATRegistrationNumber)
                {
                }
                column(BillToCust_VATRegNo; Cust."VAT Registration No.")
                {
                }
                column(Header_CurrencyIBAN; CurrencyIBAN)
                {
                }
                column(Header_CurrencyAccountNo; CurrencyAccountNo)
                {
                }
                column(HeaderSWIFT; CompanyInfo."SWIFT Code")
                {
                }
                column(Header_HWCoordinator; HW_PVCase.Coordinator)
                {
                }
                column(Header_HWCoordinatorName; HW_PVCase."Coordinator Name")
                {
                }
            }
            dataitem(Lines; "Sales Invoice Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemLinkReference = Document;
                DataItemTableView = SORTING("Document No.", "Line No.");
                column(Lines_Type; Format(Type))
                {
                }
                column(Lines_No; "No.")
                {
                }
                column(Lines_VariantCode; "Variant Code")
                {
                }
                column(Lines_Description; Description)
                {
                }
                column(Lines_Quantity; QtyToPrint)
                {
                }
                column(Lines_UnitOfMeasure; GetUOMText("Unit of Measure Code"))
                {
                }
                column(Lines_UnitPrice; UnitPriceToPrint)
                {
                }
                column(Lines_Amount; LineAmountToPrint)
                {
                    AutoFormatExpression = GetCurrencyCode;
                    AutoFormatType = 1;
                }
                column(Lines_TaxIdentifier; "VAT Identifier")
                {
                }
                column(Lines_Tax; LineTaxAmtToPrint)
                {
                }
                column(Lines_AmountIncludingTax; "Amount Including VAT")
                {
                    AutoFormatExpression = GetCurrencyCode;
                    AutoFormatType = 1;
                }
                column(Lines_DiscountAmt; LineDiscAmtToPrint)
                {
                }
                column(Lines_DiscountPct; LineDiscPctToPrint)
                {
                }
                column(Lines_QuantityShipped; QtyShippedToPrint)
                {
                }
                column(Lines_ReturnReceiptNo; ReturnReceiptToPrint)
                {
                }
                column(Lines_ReturnReasonCode; ReturnReasonToPrint)
                {
                }
                column(Lines_ShipmentDate; Format("Shipment Date"))
                {
                }
                column(Lines_ShipmentNo; ShipmentNoToPrint)
                {
                }
                column(Lines_OrderNoLine; OrderNoLineToPrint)
                {
                }

                trigger OnAfterGetRecord()
                var
                    PVCase: Record "PVS Case";
                begin
                    PostedShipmentDate := 0D;
                    if Quantity <> 0 then
                        PostedShipmentDate := FindPostedShipmentDate;

                    if Type = Type::"G/L Account" then
                        "No." := '';

                    if "Line Discount %" = 0 then
                        LineDiscountPctText := ''
                    else
                        LineDiscountPctText := StrSubstNo('%1%', -Round("Line Discount %", 0.1));

                    TaxAmountLines.Init;
                    TaxAmountLines."VAT Identifier" := "VAT Identifier";
                    TaxAmountLines."VAT Calculation Type" := "VAT Calculation Type";
                    TaxAmountLines."Tax Group Code" := "Tax Group Code";
                    TaxAmountLines."VAT %" := "VAT %";
                    TaxAmountLines."VAT Base" := Amount;
                    TaxAmountLines."Amount Including VAT" := "Amount Including VAT";
                    TaxAmountLines."Line Amount" := "Line Amount";
                    if "Allow Invoice Disc." then
                        TaxAmountLines."Inv. Disc. Base Amount" := "Line Amount";
                    TaxAmountLines."Invoice Discount Amount" := "Inv. Discount Amount";
                    TaxAmountLines."VAT Clause Code" := "VAT Clause Code";
                    if ("VAT %" <> 0) or ("VAT Clause Code" <> '') or (Amount <> "Amount Including VAT") then
                        TaxAmountLines.InsertLine;

                    TransHeaderAmount += PrevLineAmount;
                    PrevLineAmount := "Line Amount";
                    TotalSubTotal += "Line Amount";
                    TotalInvDiscAmount -= "Inv. Discount Amount";
                    TotalAmount += Amount;
                    TotalAmountVAT += "Amount Including VAT" - Amount;
                    TotalAmountInclVAT += "Amount Including VAT";
                    TotalPaymentDiscOnVAT += -("Line Amount" - "Inv. Discount Amount" - "Amount Including VAT");

                    FormatLineAmountsToPrint(Lines);

                    OrderNoLineToPrint := '';
                    if Lines."PVS ID 1" <> 0 then
                        if PVCase.GET(Lines."PVS ID 1") then
                            OrderNoLineToPrint := PVCase."Order No.";

                    // if Lines."Hiden Group Line" then  //Group
                    //   CurrReport.Skip;                //Group
                end;

                trigger OnPreDataItem()
                begin
                    TaxAmountLines.DeleteAll;
                    ShipmentLines.Reset;
                    ShipmentLines.DeleteAll;

                    MoreLines := Find('+');
                    while MoreLines and (Description = '') and ("No." = '') and (Quantity = 0) and (Amount = 0) do
                        MoreLines := Next(-1) <> 0;
                    if not MoreLines then
                        CurrReport.Break;
                    SetRange("Line No.", 0, "Line No.");
                    TransHeaderAmount := 0;
                    PrevLineAmount := 0;
                end;
            }
            dataitem(TaxAmountLines; "VAT Amount Line")
            {
                DataItemTableView = SORTING("VAT Identifier", "VAT Calculation Type", "Tax Group Code", "Use Tax", Positive);
                UseTemporary = true;
                column(TaxAmountLines_DiscountAmount; "Invoice Discount Amount")
                {
                    AutoFormatExpression = Document."Currency Code";
                    AutoFormatType = 1;
                }
                column(TaxAmountLines_DiscountBase; "Inv. Disc. Base Amount")
                {
                    AutoFormatExpression = Document."Currency Code";
                    AutoFormatType = 1;
                }
                column(TaxAmountLines_Amount; "Line Amount")
                {
                    AutoFormatExpression = Document."Currency Code";
                    AutoFormatType = 1;
                }
                column(TaxAmountLines_TaxAmount; "VAT Amount")
                {
                    AutoFormatExpression = Document."Currency Code";
                    AutoFormatType = 1;
                }
                column(TaxAmountLines_TaxBase; "VAT Base")
                {
                    AutoFormatExpression = GetCurrencyCode;
                    AutoFormatType = 1;
                }
                column(TaxAmountLines_TaxIdentifier; "VAT Identifier")
                {
                }
                column(TaxAmountLines_TaxPct; VATPctToPrint)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    VATBaseLCY :=
                      GetBaseLCY(
                        Document."Posting Date", Document."Currency Code",
                        Document."Currency Factor");
                    VATAmountLCY :=
                      GetAmountLCY(
                        Document."Posting Date", Document."Currency Code",
                        Document."Currency Factor");

                    TotalVATBaseLCY += VATBaseLCY;
                    TotalVATAmountLCY += VATAmountLCY;

                    FormatVATAmountsToPrint(TaxAmountLines);
                end;

                trigger OnPreDataItem()
                begin
                    TotalVATBaseLCY := 0;
                    TotalVATAmountLCY := 0;
                end;
            }
            dataitem(ReportTotals; "Integer")
            {
                DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                column(ReportTotals_Subtotal; FormatTotals(TotalSubTotal))
                {
                    AutoFormatExpression = Document."Currency Code";
                    AutoFormatType = 1;
                }
                column(ReportTotals_InvoiceDiscount; FormatTotals(TotalInvDiscAmount))
                {
                    AutoFormatExpression = Document."Currency Code";
                    AutoFormatType = 1;
                }
                column(ReportTotals_SubtotalLessDiscount; FormatTotals(TotalSubTotal + TotalInvDiscAmount))
                {
                }
                column(ReportTotals_TotalExcludingTax; FormatTotals(TotalAmount))
                {
                }
                column(ReportTotals_Tax; FormatTotals(TotalAmountVAT))
                {
                    AutoFormatExpression = Document."Currency Code";
                    AutoFormatType = 1;
                }
                column(ReportTotals_PaymentDiscOnTax; FormatTotals(TotalPaymentDiscOnVAT))
                {
                }
                column(ReportTotals_TotalIncludingTax; FormatTotals(TotalAmountInclVAT))
                {
                }
            }

            trigger OnAfterGetRecord()
            var
                CurrencyExchangeRate: Record "Currency Exchange Rate";
                LocalLine: Record "Sales Invoice Line";
            begin
                // <Chg01>
                //PostingDateTxt  := FORMAT(Document."Posting Date");
                //DueDateTxt      := FORMAT(Document."Due Date");
                //DocumentDateTxt := FORMAT(Document."Document Date");

                //IF COMPANYNAME = 'PrintVis Inc.' THEN BEGIN
                PostingDateTxt := Format(Document."Posting Date", 0, '<Month,2>/<Day,2>/<Year4>');
                DueDateTxt := Format(Document."Due Date", 0, '<Month,2>/<Day,2>/<Year4>');
                DocumentDateTxt := Format(Document."Document Date", 0, '<Month,2>/<Day,2>/<Year4>');
                //END;
                // </Chg01>

                // <82097>
                Clear(HW_PVCase);
                if Document."PVS Order ID" <> 0 then begin
                    HW_PVCase.GET(Document."PVS Order ID");
                    HW_PVCase.CalcFields("Coordinator Name")
                end;
                // </82097>

                if not CurrReport.Preview then
                    CODEUNIT.Run(CODEUNIT::"Sales Inv.-Printed", Document);

                CurrReport.Language := Language.GetLanguageID("Language Code");
                if RespCenter.Get("Responsibility Center") then begin
                    FormatAddr.RespCenter(CompanyAddr, RespCenter);
                    CompanyInfo."Phone No." := RespCenter."Phone No.";
                    CompanyInfo."Fax No." := RespCenter."Fax No.";
                end else
                    FormatAddr.Company(CompanyAddr, CompanyInfo);

                if "Salesperson Code" = '' then begin
                    SalespersonPurchaser.Init;
                    SalesPersonText := '';
                end else begin
                    SalespersonPurchaser.Get("Salesperson Code");
                    SalesPersonText := SalespersonLbl;
                end;

                if "Currency Code" = '' then begin
                    GLSetup.TestField("LCY Code");
                    ExchangeRateText := '';
                    CurrencyInfoText := '';
                end else begin
                    CurrencyExchangeRate.FindCurrency("Posting Date", "Currency Code", 1);
                    CalculatedExchRate :=
                      Round(1 / "Currency Factor" * CurrencyExchangeRate."Exchange Rate Amount", 0.000001);
                    ExchangeRateText := GetTableCaption(DATABASE::"Currency Exchange Rate") + ': %1/%2';
                    ExchangeRateText := StrSubstNo(ExchangeRateText, CalculatedExchRate, CurrencyExchangeRate."Exchange Rate Amount");
                end;

                if Currency.Get("Currency Code") then begin
                    CurrencyIBAN := ''; //Currency.IBAN;
                    CurrencyAccountNo := ''; // Currency."Account No.";
                end else begin
                    CurrencyIBAN := ''; //CompanyInfo.IBAN;
                    CurrencyAccountNo := CompanyInfo."Bank Account No.";
                end;




                //<H&W-02102017> #OnSite1 Address contact person
                //FormatAddr.SalesInvBillTo(CustAddr,Document);
                if "Bill-to Customer No." = "Sell-to Customer No." then
                    FormatAddr.SalesInvSellTo(CustAddr, Document)
                else
                    FormatAddr.SalesInvBillTo(CustAddr, Document);
                //</H&W-02102017>

                if not Cust.Get("Bill-to Customer No.") then
                    Clear(Cust);

                if "Payment Terms Code" = '' then
                    PaymentTerms.Init
                else begin
                    PaymentTerms.Get("Payment Terms Code");
                    PaymentTerms.TranslateDescription(PaymentTerms, "Language Code");
                end;

                if "Payment Method Code" = '' then
                    PaymentMethod.Init
                else
                    PaymentMethod.Get("Payment Method Code");

                if "Shipment Method Code" = '' then
                    ShipmentMethod.Init
                else begin
                    ShipmentMethod.Get("Shipment Method Code");
                    ShipmentMethod.TranslateDescription(ShipmentMethod, "Language Code");
                end;
                FormatAddr.SalesInvShipTo(ShipToAddr, CustAddr, Document);
                ShowShippingAddr := "Sell-to Customer No." <> "Bill-to Customer No.";
                for i := 1 to ArrayLen(ShipToAddr) do
                    if ShipToAddr[i] <> CustAddr[i] then
                        ShowShippingAddr := true;

                if LogInteraction and not CurrReport.Preview then begin
                    if "Bill-to Contact No." <> '' then
                        SegManagement.LogDocument(
                          4, "No.", 0, 0, DATABASE::Contact, "Bill-to Contact No.", "Salesperson Code",
                          "Campaign No.", "Posting Description", '')
                    else
                        SegManagement.LogDocument(
                          4, "No.", 0, 0, DATABASE::Customer, "Bill-to Customer No.", "Salesperson Code",
                          "Campaign No.", "Posting Description", '');
                end;

                TotalSubTotal := 0;
                TotalInvDiscAmount := 0;
                TotalAmount := 0;
                TotalAmountVAT := 0;
                TotalAmountInclVAT := 0;
                TotalPaymentDiscOnVAT := 0;

                FormatDocumentElementsToPrint();

                // NVS ->
                if "Sell-to Customer No." = "Bill-to Customer No." then
                    CustomerName := ''
                else
                    CustomerName := "Sell-to Customer Name";

                LocalLine.SetRange("Document No.", "No.");
                LocalLine.SetFilter("Line Discount Amount", '<>0');
                if LocalLine.IsEmpty then
                    DiscountLabel := ''
                else
                    DiscountLabel := DiscountLbl;

                if Document.GetCustomerVATRegistrationNumber <> '' then
                    VATnoLabel := Document.GetCustomerVATRegistrationNumberLbl
                else
                    VATnoLabel := '';

                GetShipments; //HW
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(LogInteraction; LogInteraction)
                    {
                        Caption = 'Log Interaction';
                        Enabled = LogInteractionEnable;
                        ApplicationArea = All;
                    }
                    field(DisplayAsmInformation; DisplayAssemblyInformation)
                    {
                        Caption = 'Show Assembly Components';
                        Visible = false;
                        ApplicationArea = All;
                    }
                    field(DisplayShipmentInformation; DisplayShipmentInformation)
                    {
                        Caption = 'Show Shipments';
                        Visible = false;
                        ApplicationArea = All;
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnInit()
        begin
            LogInteractionEnable := true;
        end;

        trigger OnOpenPage()
        begin
            InitLogInteraction;
            LogInteractionEnable := LogInteraction;
        end;
    }

    labels
    {
    }

    trigger OnInitReport()
    begin
        GLSetup.Get;
        CompanyInfo.Get;
        SalesSetup.Get;
        CompanyInfo.VerifyAndSetPaymentInfo;
        CompanyInfo.CalcFields(Picture);
    end;

    trigger OnPreReport()
    begin
        if not CurrReport.UseRequestPage then
            InitLogInteraction;

        CompanyLogoPosition := SalesSetup."Logo Position on Documents";
    end;

    var
        GLSetup: Record "General Ledger Setup";
        ShipmentMethod: Record "Shipment Method";
        PaymentTerms: Record "Payment Terms";
        PaymentMethod: Record "Payment Method";
        SalespersonPurchaser: Record "Salesperson/Purchaser";
        CompanyInfo: Record "Company Information";
        SalesSetup: Record "Sales & Receivables Setup";
        Cust: Record Customer;
        RespCenter: Record "Responsibility Center";
        Language: Codeunit Language;
        VATAmountLine: Record "VAT Amount Line" temporary;
        VATClause: Record "VAT Clause";
        AsmHeader: Record "Assembly Header";
        ShipmentLines: Record "Sales Shipment Buffer" temporary;
        VATClauseLine: Record "VAT Amount Line" temporary;
        Currency: Record Currency;
        FormatAddr: Codeunit "Format Address";
        SegManagement: Codeunit SegManagement;
        PostedShipmentDate: Date;
        CustAddr: array[8] of Text[50];
        ShipToAddr: array[8] of Text;
        CompanyAddr: array[8] of Text[50];
        SalesPersonText: Text[30];
        TotalText: Text[50];
        TotalExclVATText: Text[50];
        TotalInclVATText: Text[50];
        LineDiscountPctText: Text;
        MoreLines: Boolean;
        CopyText: Text[30];
        ShowShippingAddr: Boolean;
        i: Integer;
        NextEntryNo: Integer;
        FirstValueEntryNo: Integer;
        LogInteraction: Boolean;
        TotalSubTotal: Decimal;
        TotalAmount: Decimal;
        TotalAmountInclVAT: Decimal;
        TotalAmountVAT: Decimal;
        TotalInvDiscAmount: Decimal;
        TotalPaymentDiscOnVAT: Decimal;
        TransHeaderAmount: Decimal;
        [InDataSet]
        LogInteractionEnable: Boolean;
        DisplayAssemblyInformation: Boolean;
        AsmInfoExistsForLine: Boolean;
        DisplayShipmentInformation: Boolean;
        ArchiveDocument: Boolean;
        CompanyLogoPosition: Integer;
        CalculatedExchRate: Decimal;
        ExchangeRateText: Text;
        VATBaseLCY: Decimal;
        VATAmountLCY: Decimal;
        TotalVATBaseLCY: Decimal;
        TotalVATAmountLCY: Decimal;
        PrevLineAmount: Decimal;
        QtyToPrint: Text[30];
        UnitPriceToPrint: Text[30];
        LineAmountToPrint: Text[30];
        LineDiscAmtToPrint: Text[30];
        LineDiscPctToPrint: Text[30];
        LineTaxAmtToPrint: Text[30];
        CurrencyInfoText: Text[30];
        AppliesToTextToPrint: Text[80];
        DocumentTypetoPrint: Text[30];
        QuoteNoToPrint: Text[30];
        OrderNoToPrint: Text[30];
        OrderNoLineToPrint: Text[30];
        PaymentMethodLabel: Text[30];
        PaymentTermsLabel: Text[30];
        QtyShippedToPrint: Text[30];
        SalespersonLabel: Text[30];
        ReturnReceiptToPrint: Text[30];
        ReturnReasonToPrint: Text[30];
        ShipmentMethodLabel: Text[30];
        ShipmentNoToPrint: Text[30];
        ShipToLabel: Text[30];
        TaxAmountLabel: Text[80];
        TotalLabel: Text[80];
        TotalInclVATLabel: Text[80];
        TotalExclVATLabel: Text[80];
        SalespersonLbl: Label 'Salesperson';
        BillToLbl: Label 'Bill To';
        SubtotalLbl: Label 'Subtotal';
        TotalLbl: Label 'Total';
        TotalExclVATLbl: Label 'Total Excl. Tax';
        TotalInclVATLbl: Label 'Total';
        VATAmountSpecLbl: Label 'Tax Amount Spec.';
        VATPctToPrint: Text[30];
        "** NVS **": Integer;
        CustomerName: Text;
        DiscountLabel: Text;
        CustomerNoLbl: Label 'Customer No';
        PriceLbl: Label 'Amount';
        DiscountLbl: Label 'Discount';
        AmountLbl: Label 'Line Amount';
        TaxAmountLbl: Label 'Tax Amount';
        VATnoLabel: Text;
        TotalTaxAmtToPrint: Text[30];
        "<Chg01>": Boolean;
        PostingDateTxt: Text;
        DueDateTxt: Text;
        DocumentDateTxt: Text;
        "</Chg01>": Boolean;
        CurrencyIBAN: Text;
        CurrencyAccountNo: Text;
        OrderNoLbl: Label 'Order No.';
        "** HW **": Integer;
        HW_PVCase: Record "PVS Case";
        HW_SortingBuffer: Record "PVS Sorting Buffer" temporary;
        PV_InterceptMisc: Codeunit "PVS Intercept Misc.";

    procedure InitLogInteraction()
    begin
        LogInteraction := SegManagement.FindInteractTmplCode(4) <> '';
    end;

    local procedure FindPostedShipmentDate(): Date
    var
        SalesShipmentHeader: Record "Sales Shipment Header";
        SalesShipmentBuffer2: Record "Sales Shipment Buffer";
    begin
        if Lines."Shipment No." <> '' then
            if SalesShipmentHeader.Get(Lines."Shipment No.") then
                exit(SalesShipmentHeader."Posting Date");

        if Lines.Type = Lines.Type::" " then
            exit(0D);

        ShipmentLines.GetLinesForSalesInvoiceLine(Lines, Document);

        ShipmentLines.Reset;
        ShipmentLines.SetRange("Line No.", Lines."Line No.");
        if ShipmentLines.Find('-') then begin
            SalesShipmentBuffer2 := ShipmentLines;
            if not DisplayShipmentInformation then
                if ShipmentLines.Next = 0 then begin
                    ShipmentLines.Get(
                      SalesShipmentBuffer2."Document No.", SalesShipmentBuffer2."Line No.", SalesShipmentBuffer2."Entry No.");
                    ShipmentLines.Delete;
                    exit(SalesShipmentBuffer2."Posting Date");
                end;
            ShipmentLines.CalcSums(Quantity);
            if ShipmentLines.Quantity <> Lines.Quantity then begin
                ShipmentLines.DeleteAll;
                exit(Document."Posting Date");
            end;
        end;
        exit(Document."Posting Date");
    end;

    procedure InitializeRequest(NewLogInteraction: Boolean; DisplayAsmInfo: Boolean)
    begin
        LogInteraction := NewLogInteraction;
        DisplayAssemblyInformation := DisplayAsmInfo;
    end;

    procedure GetUOMText(UOMCode: Code[10]): Text[10]
    var
        UnitOfMeasure: Record "Unit of Measure";
    begin
        if not UnitOfMeasure.Get(UOMCode) then
            exit(UOMCode);
        exit(UnitOfMeasure.Description);
    end;

    local procedure FormatDocumentElementsToPrint()
    var
        TableRef: RecordRef;
        TableName: Text[30];
        FieldRef: FieldRef;
        SalesInvHeader: Record "Sales Invoice Header";
        SalesHeader: Record "Sales Header";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        CurrencyCode: Code[10];
    begin
        // This allows a standardized XML format to be used across document types, allowing users to create a single document and then copy/paste/edit for other formats.

        QuoteNoToPrint := '';
        OrderNoToPrint := '';
        AppliesToTextToPrint := '';
        TableRef.GetTable(Document);

        case TableRef.Number of
            DATABASE::"Sales Header":
                begin
                    TableRef.SetTable(SalesHeader);
                    DocumentTypetoPrint := Format(SalesHeader."Document Type");
                    QuoteNoToPrint := SalesHeader."Quote No.";

                    if SalesHeader."Currency Code" = '' then begin
                        GLSetup.TestField("LCY Code");
                        CurrencyCode := GLSetup."LCY Code";
                    end else
                        CurrencyCode := SalesHeader."Currency Code";
                end;
            DATABASE::"Sales Invoice Header":
                begin
                    TableRef.SetTable(SalesInvHeader);
                    DocumentTypetoPrint := Format(SalesHeader."Document Type"::Invoice);
                    OrderNoToPrint := SalesInvHeader."Order No.";
                    QuoteNoToPrint := SalesInvHeader."Quote No.";

                    if SalesInvHeader."Currency Code" = '' then begin
                        GLSetup.TestField("LCY Code");
                        CurrencyCode := GLSetup."LCY Code";
                    end else
                        CurrencyCode := SalesInvHeader."Currency Code";
                end;
            DATABASE::"Sales Cr.Memo Header":
                begin
                    TableRef.SetTable(SalesCrMemoHeader);
                    if SalesCrMemoHeader."Prepayment Credit Memo" then
                        DocumentTypetoPrint := SalesCrMemoHeader.FieldCaption("Prepayment Credit Memo")
                    else
                        DocumentTypetoPrint := Format(SalesHeader."Document Type"::"Credit Memo");

                    if SalesCrMemoHeader."Applies-to Doc. No." = '' then
                        AppliesToTextToPrint := ''
                    else
                        AppliesToTextToPrint := StrSubstNo('%1 %2', SalesCrMemoHeader."Applies-to Doc. Type", SalesCrMemoHeader."Applies-to Doc. No.");


                    if SalesCrMemoHeader."Currency Code" = '' then begin
                        GLSetup.TestField("LCY Code");
                        CurrencyCode := GLSetup."LCY Code";
                    end else
                        CurrencyCode := SalesCrMemoHeader."Currency Code";
                end;
        end;

        TotalLabel := StrSubstNo(TotalLbl + ' (%1)', CurrencyCode);
        TotalInclVATLabel := StrSubstNo('Total Incl. Tax (%1)', CurrencyCode);
        TotalExclVATLabel := StrSubstNo('Total Excl. Tax (%1)', CurrencyCode);
        TaxAmountLabel := StrSubstNo('Tax Amount (%1)', CurrencyCode);

        PaymentMethodLabel := GetTableCaption(DATABASE::"Payment Method");
        PaymentTermsLabel := GetTableCaption(DATABASE::"Payment Terms");
        ShipmentMethodLabel := GetTableCaption(DATABASE::"Shipment Method");
        ShipToLabel := GetTableCaption(DATABASE::"Ship-to Address");
    end;

    local procedure GetTableCaption(TableNo: Integer): Text[30]
    var
        TableRef: RecordRef;
    begin
        TableRef.Open(TableNo);
        exit(TableRef.Caption);
    end;

    local procedure FormatLineAmountsToPrint(Lines: Record "Sales Invoice Line")
    var
        SalesLine: Record "Sales Line";
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
        AutoFormatExpr: Text[80];
        AutoFormatType: Option ,Amount,UnitAmount,Other;
        TaxAmount: Decimal;
        TableRef: RecordRef;
    begin
        with Lines do begin

            QtyToPrint := '';
            UnitPriceToPrint := '';
            LineAmountToPrint := '';
            LineDiscAmtToPrint := '';
            LineDiscPctToPrint := '';
            QtyShippedToPrint := '';
            ShipmentNoToPrint := '';
            ReturnReceiptToPrint := '';
            ReturnReasonToPrint := '';

            AutoFormatExpr := GetCurrencyCode();
            if Quantity <> 0 then begin
                QtyToPrint := Format(Quantity, 0);
                UnitPriceToPrint := FormatAmt("Unit Price", AutoFormatExpr, AutoFormatType::UnitAmount);
                LineAmountToPrint := FormatAmt(Amount + "Inv. Discount Amount", AutoFormatExpr, AutoFormatType::Amount);
            end;

            TaxAmount := "Amount Including VAT" - Amount;
            if TaxAmount <> 0 then
                LineTaxAmtToPrint := FormatAmt(TaxAmount, AutoFormatExpr, AutoFormatType::Amount);

            if "Line Discount Amount" <> 0 then begin
                LineDiscAmtToPrint := Format("Line Discount Amount", 0);
                LineDiscPctToPrint := StrSubstNo('%1%', Round("Line Discount %", 0.1));
            end;
        end;

        TableRef.GetTable(Lines);

        case TableRef.Number of
            DATABASE::"Sales Line":
                begin
                    TableRef.SetTable(SalesLine);
                    if SalesLine."Quantity Shipped" <> 0 then begin
                        QtyShippedToPrint := Format(SalesLine."Quantity Shipped", 0);
                        ShipmentNoToPrint := SalesLine."Shipment No.";
                    end;
                end;
            DATABASE::"Sales Cr.Memo Line":
                begin
                    TableRef.SetTable(SalesCrMemoLine);
                    ReturnReceiptToPrint := SalesCrMemoLine."Return Receipt No.";
                    ReturnReasonToPrint := SalesCrMemoLine."Return Reason Code";
                end;
        end;

        // NVS
        TotalTaxAmtToPrint := '';

        if TotalAmountVAT <> 0 then
            //   TotalTaxAmtToPrint := FORMAT(TotalAmountVAT,0);
            TotalTaxAmtToPrint := FormatAmt(TotalAmountVAT, GetCurrencyCode, AutoFormatType::Amount);
    end;

    local procedure FormatVATAmountsToPrint(VATAmountLine: Record "VAT Amount Line")
    begin
        with VATAmountLine do begin
            VATPctToPrint := StrSubstNo('%1%', Round("VAT %", 0.1));

        end;
    end;

    local procedure FormatAmt(Amount: Decimal; AutoFormatExpr: Text[80]; AutoFormatType: Option ,Amount,UnitAmount,Other) AmountTxt: Text[80]
    var
        ApplicationMgt: Codeunit "Auto Format";
        FormatStr: Text[80];
        txt: Text[80];
    begin
        FormatStr := ApplicationMgt.ResolveAutoFormat(AutoFormatType, AutoFormatExpr);

        AmountTxt := Format(Amount, 0, FormatStr);

        if UpperCase(CopyStr(CompanyName, 1, 8)) = 'PRINTVIS' then begin
            // Are we in Europe
            txt := Format(1.23);
            if CopyStr(txt, 2, 1) = ',' then begin
                // Switch comma/dot
                AmountTxt := ConvertStr(AmountTxt, ',', '#');
                AmountTxt := ConvertStr(AmountTxt, '.', ',');
                AmountTxt := ConvertStr(AmountTxt, '#', '.');
            end;
        end;

        //EXIT(FORMAT(Amount,0,FormatStr));
    end;

    local procedure GetCurrencyCode(): Code[10]
    begin
        exit(Document."Currency Code");
    end;

    local procedure FormatTotals(Amount: Decimal): Text[80]
    begin
        exit(FormatAmt(Amount, GetCurrencyCode, 1));
    end;

    local procedure GetShipments()
    var
        HW_SalesLine: Record "Sales Invoice Line";
        PVJob: Record "PVS Job";
        PVJobShipment: Record "PVS Job Shipment";
        EntryNo: Integer;
    begin
        HW_SortingBuffer.DELETEALL;

        EntryNo := 0;

        HW_SalesLine.Reset;
        //HW_SalesLine.SETRANGE("Document Type",Document."Document Type");
        HW_SalesLine.SetRange("Document No.", Document."No.");
        HW_SalesLine.SetFilter("PVS ID 1", '<>%1', 0);
        if HW_SalesLine.FindSet then
            repeat
                PVJob.RESET;
                PVJob.SETRANGE(ID, HW_SalesLine."PVS ID 1");
                PVJob.SETRANGE(Status, PVJob.Status::"Production Order");
                PVJob.SETRANGE(Active, true);
                if PVJob.FINDSET then
                    repeat
                        PVJobShipment.RESET;
                        PVJobShipment.SETRANGE(ID, PVJob.ID);
                        PVJobShipment.SETRANGE(Job, PVJob.Job);
                        PVJobShipment.SETCURRENTKEY(Name);
                        if PVJobShipment.FINDSET then
                            repeat
                                EntryNo += 1;
                                HW_SortingBuffer.INIT;
                                HW_SortingBuffer.PK1_Integer1 := PVJobShipment.ID;
                                HW_SortingBuffer.PK1_Integer2 := PVJobShipment.Job;
                                HW_SortingBuffer.PK1_Integer3 := PVJobShipment.Shipment;
                                HW_SortingBuffer.Text1 := PVJobShipment.Name;
                                HW_SortingBuffer.Text2 := PVJobShipment."Name 2";
                                HW_SortingBuffer.Text3 := PVJobShipment."Contact Name";
                                HW_SortingBuffer.Text4 := PVJobShipment.Address;
                                HW_SortingBuffer.Text5 := PVJobShipment."Address 2";
                                HW_SortingBuffer.Text6 := PVJobShipment."Post Code";
                                HW_SortingBuffer.Text7 := PVJobShipment.City;
                                HW_SortingBuffer.Text8 := PVJobShipment.County;
                                //HW_SortingBuffer.Text9 := PVJobShipment."Country/Region Code";
                                if HW_SortingBuffer.INSERT then;
                            until PVJobShipment.NEXT = 0;
                    until PVJob.NEXT = 0;
            until HW_SalesLine.Next = 0;
    end;
}

