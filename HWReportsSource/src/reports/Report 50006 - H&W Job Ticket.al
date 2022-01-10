report 50006 "H&W Job Ticket"
{
    // <LOG>
    //   Version   Date        User  Case  Chg   Description
    //   HW001     02.05.2017  PT    81087       Additions for JobTicket
    //   H&W2      XX.10.2017  RH    x           Changes on site. Shipment area changed. Project name in top
    //   H&W3      2018-07-31  TN    83275 Chg03 Several minor changes to layout:
    //                                           1: Remove "1" in orderno-job in header
    //                                           1b:Add Estimator. Const added. 2 fields added to dataset. Also added to layout
    //                                           2: Erase "FORM..." (Seems to be the JobItem description)
    //                                           3: Make "Flat Size..." Bigger/Bold.
    //                                           4: Erase area "2.00 SheetID 1,2"
    //                                           5: Sheet # should come from JobItem...
    //                                           6: Erase area "405.00 Sheet ID..."
    //                                           7: Qty ("1500") should be moved to left + bigger/bolder
    //                                              In layout: LineType 80: Dec1 fontsize increased. Field moved to the left. Set to bold.
    //                                           8: Modify addressline:
    //                                           9: Add COD
    //                                           10: NOT included!
    //                                           11: Add word to read: "Printed Sheet Format"
    //                                           12: add word to read: "No. of parent sheets"
    //   H&W4      2018-08-16  TN    83275 Chg04 Minor changes:
    //                                            - Removed dev code on COD.
    //                                            - Reuse of var Addr destryoed the Addr info in the header! Now fixed.
    //                                            - Seems shipment addr can hold a space. Code added to identify that.
    //   H&W5      2018-08-22  TN    83275 Chg05 Missing clearing of AddrStr fixed!
    //   H&W6      2018-12-10  RH    Marietta Chg06 - Make delivery date mandatory
    // 
    // 
    // </LOG>
    // 
    // LineType:
    //   1 : Delimiter Line
    //   2 : Header (Department Name etc.)
    //   3 : Comment Text (Full Width)
    //   4 : Side by Side: Comment Text (Half Width) + UserFields
    //   5 : UserFields
    //   6 : Side by Side: Comment Text (Half Width) + UserFields  (Same as 4)
    //   7 : UserFields                                            (Same as 5)
    //  20 : Calc. Unit Details
    //  50 : Press - Process Head
    //  51 : Press - Process Subject Body
    //  52 : Press - Process Body
    //  55 : Press - Plate Change Head
    //  57 : Press - Plate Change Body
    //  60 : Postpress - Process Head
    //  61 : Postpress - Process Subject Body
    //  62 : Postpress - Process Body
    //  70 : Press Continuous - Process Head
    //  71 : Press Continuous - Process Subject Body
    //  72 : Press Continuous - Process Body
    // 
    //  80 : Shipments
    //  99 : Not in Use
    DefaultLayout = RDLC;
    RDLCLayout = './src/reports/H&W Job Ticket.rdlc';

    Caption = 'H&W Job Ticket';
    PreviewMode = PrintLayout;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem(OrderRec; "PVS Case")
        {
            RequestFilterFields = ID, "Order No.";

            column(OrderRec_ID; ID)
            {
            }
            column(PicturePage_Show; PicturePresent)
            {
            }
            column(PH_CaseDescription; "Case Description")
            {

            }
            dataitem(JOB_LOOP; "Integer")
            {
                DataItemTableView = SORTING(Number) WHERE(Number = FILTER(1 ..));
                dataitem(COPY_LOOP; "Integer")
                {
                    DataItemTableView = SORTING(Number);
                    MaxIteration = 5;
                    dataitem(VERSION_LOOP; "Integer")
                    {
                        DataItemTableView = SORTING(Number) WHERE(Number = FILTER(1 ..));
                        PrintOnlyIfDetail = true;
                        dataitem(PAGE_LOOP; "Integer")
                        {
                            DataItemTableView = SORTING(Number);
                            MaxIteration = 1;
                            PrintOnlyIfDetail = true;
                            column(PH_CompanyName; CompanyNameText)
                            {
                            }
                            column(PH_HeaderTxt; HEADERTXT)
                            {
                            }
                            column(PH_Today; Format(Today, 0, 4))
                            {
                            }
                            column(PH_HeaderTxt2; PageLoopHeaderText)
                            {
                            }
                            column(PH_Address1; Addr[1])
                            {
                            }
                            column(PH_Address2; Addr[2])
                            {
                            }
                            column(PH_Address3; Addr[3])
                            {
                            }
                            column(PH_Address4; Addr[4])
                            {
                            }
                            column(PH_SellToNo; OrderRec."Sell-To No.")
                            {
                                IncludeCaption = true;
                            }
                            column(PH_SellToContact; OrderRec."Sell-To Contact")
                            {
                                AutoCalcField = true;
                                IncludeCaption = true;
                            }
                            column(PH_YourReference; OrderRec."Your Reference")
                            {
                                IncludeCaption = true;
                            }
                            column(PH_Coordinator; OrderRec.Coordinator)
                            {
                                AutoCalcField = true;
                                IncludeCaption = true;
                            }
                            column(PH_Estimator; OrderRec.Estimator)
                            {
                            }
                            column(PH_Salesperson; OrderRec.Salesperson)
                            {
                                AutoCalcField = true;
                                IncludeCaption = true;
                            }
                            column(PH_PhoneCaption; OrderRec."Sell-To Phone")
                            {
                                AutoCalcField = true;
                                IncludeCaption = true;
                            }
                            column(PH_FaxCaption; OrderRec."Sell-To Fax")
                            {
                                AutoCalcField = true;
                                IncludeCaption = true;
                            }
                            column(PH_BelongsToProject; HW_BelongsToProject)
                            {
                            }
                            column(PH_BelongsToProjectlbl; HW_BelongsToProjectLbl)
                            {
                            }
                            column(PH_JobDescription; JobRecTemp."Job Name")
                            {
                            }

                            column(PH_JobFormatCode; JobRecTemp."Format Code")
                            {
                            }
                            column(PH_CopyFromOrderNo; OrderRec."Copy from Order No.")
                            {
                                IncludeCaption = true;
                            }
                            column(PH_QuoteNo; OrderRec."Quote No.")
                            {
                                IncludeCaption = true;
                            }
                            column(PH_EcoLabelCode; OrderRec."ECO Label Code")
                            {
                                IncludeCaption = true;
                            }
                            column(PH_EcoLabelPicture; EcoLabel_PictureRec.Picture)
                            {
                            }
                            column(PH_PhoneData; TXT_PHONE)
                            {
                            }
                            column(PH_FaxData; TXT_FAX)
                            {
                            }
                            column(PH_MailData; TXT_MAIL)
                            {
                            }
                            column(PH_ShippingDateData; Shipping_DateTxt)
                            {
                            }
                            column(PH_HeaderFieldLabel1; HeaderFieldName[1])
                            {
                            }
                            column(PH_HeaderFieldLabel2; HeaderFieldName[2])
                            {
                            }
                            column(PH_HeaderFieldLabel3; HeaderFieldName[3])
                            {
                            }
                            column(PH_HeaderFieldLabel4; HeaderFieldName[4])
                            {
                            }
                            column(PH_HeaderFieldLabel5; HeaderFieldName[5])
                            {
                            }
                            column(PH_HeaderFieldLabel6; HeaderFieldName[6])
                            {
                            }
                            column(PH_HeaderFieldTxt1; HeaderFieldNameTxt[1])
                            {
                            }
                            column(PH_HeaderFieldTxt2; HeaderFieldNameTxt[2])
                            {
                            }
                            column(PH_HeaderFieldTxt3; HeaderFieldNameTxt[3])
                            {
                            }
                            column(PH_HeaderFieldTxt4; HeaderFieldNameTxt[4])
                            {
                            }
                            column(PH_HeaderFieldTxt5; HeaderFieldNameTxt[5])
                            {
                            }
                            column(PH_HeaderFieldTxt6; HeaderFieldNameTxt[6])
                            {
                            }
                            column(PH_JobQuantity; NV.Format_Decimal(JobRecTemp.Quantity, 0))
                            {
                            }
                            column(PH_Number; Number)
                            {
                            }
                            column(PH_CaptionCustomer; CaptionCustomer)
                            {
                            }
                            column(PH_CaptionSellToContact; CaptionSellToContact)
                            {
                            }
                            column(PH_CaptionQuantity; CaptionQuantity)
                            {
                            }
                            column(PH_CaptionYourReference; CaptionYourReference)
                            {
                            }
                            column(PH_CaptionFormatCode; CaptionFormatCode)
                            {
                            }
                            column(PH_CaptionShipmentDate; CaptionShipmentDate)
                            {
                            }
                            column(PH_CaptionSellToNo; CaptionSellToNo)
                            {
                            }
                            column(PH_CaptionSellToPhone; CaptionSellToPhone)
                            {
                            }
                            column(PH_CaptionSellToFax; CaptionSellToFax)
                            {
                            }
                            column(PH_CaptionEmail; CaptionEmail)
                            {
                            }
                            column(PH_CaptionSalesPerson; CaptionSalesPerson)
                            {
                            }
                            column(PH_CaptionCoordinator; CaptionCoordinator)
                            {
                            }
                            column(PH_CaptionEstimator; CaptionEstimator)
                            {
                            }
                            column(PH_CaptionQuoteNo; CaptionQuoteNo)
                            {
                            }
                            column(PH_CaptionCopyFromOrder; CaptionCopyFromOrder)
                            {
                            }
                            dataitem(LINE_DETAILS; "Integer")
                            {
                                DataItemTableView = SORTING(Number);
                                column(Details_Number; Number)
                                {
                                }
                                column(Details_Section; TempSortingBufferRec."Report Section")
                                {
                                }
                                column(Details_CellBackColor; TempSortingBufferRec."Report Cell Background Color")
                                {
                                }
                                column(Details_FontSize; TempSortingBufferRec."Report Font Size (Points)")
                                {
                                }
                                column(Details_Txt1; TempSortingBufferRec.Text1)
                                {
                                }
                                column(Details_Txt2; TempSortingBufferRec.Text2)
                                {
                                }
                                column(Details_Txt3; TempSortingBufferRec.Text3)
                                {
                                }
                                column(Details_Txt4; TempSortingBufferRec.Text4)
                                {
                                }
                                column(Details_Txt5; TempSortingBufferRec.Text5)
                                {
                                }
                                column(Details_Txt6; TempSortingBufferRec.Text6)
                                {
                                }
                                column(Details_Txt7; TempSortingBufferRec.Text7)
                                {
                                }
                                column(Details_Txt8; TempSortingBufferRec.Text8)
                                {
                                }
                                column(Details_Txt9; TempSortingBufferRec.Text9)
                                {
                                }
                                column(Details_Txt10; TempSortingBufferRec.Text10)
                                {
                                }
                                column(Details_Txt11; TempSortingBufferRec.Text11)
                                {
                                }
                                column(Details_Txt12; TempSortingBufferRec.Text12)
                                {
                                }
                                column(Details_Txt13; TempSortingBufferRec.Text13)
                                {
                                }
                                column(Details_Txt14; TempSortingBufferRec.Text14)
                                {
                                }
                                column(Details_Txt15; TempSortingBufferRec.Text15)
                                {
                                }
                                column(Details_Txt1Bold; TempSortingBufferRec."Report Text1_Bold")
                                {
                                }
                                column(Details_Txt2Bold; TempSortingBufferRec."Report Text2_Bold")
                                {
                                }
                                column(Details_Txt3Bold; TempSortingBufferRec."Report Text3_Bold")
                                {
                                }
                                column(Details_Txt4Bold; TempSortingBufferRec."Report Text4_Bold")
                                {
                                }
                                column(Details_Txt5Bold; TempSortingBufferRec."Report Text5_Bold")
                                {
                                }
                                column(Details_Txt6Bold; TempSortingBufferRec."Report Text6_Bold")
                                {
                                }
                                column(Details_Txt7Bold; TempSortingBufferRec."Report Text7_Bold")
                                {
                                }
                                column(Details_Txt8Bold; TempSortingBufferRec."Report Text8_Bold")
                                {
                                }
                                column(Details_Txt9Bold; TempSortingBufferRec."Report Text9_Bold")
                                {
                                }
                                column(Details_Txt10Bold; TempSortingBufferRec."Report Text10_Bold")
                                {
                                }
                                column(Details_Txt11Bold; TempSortingBufferRec."Report Text11_Bold")
                                {
                                }
                                column(Details_Txt12Bold; TempSortingBufferRec."Report Text12_Bold")
                                {
                                }
                                column(Details_Txt13Bold; TempSortingBufferRec."Report Text13_Bold")
                                {
                                }
                                column(Details_Txt14Bold; TempSortingBufferRec."Report Text14_Bold")
                                {
                                }
                                column(Details_Txt15Bold; TempSortingBufferRec."Report Text15_Bold")
                                {
                                }
                                column(Details_Dec1; TempSortingBufferRec.Decimal1)
                                {
                                }
                                column(Details_Dec2; TempSortingBufferRec.Decimal2)
                                {
                                }
                                column(Details_Dec3; TempSortingBufferRec.Decimal3)
                                {
                                }
                                column(Details_Dec4; TempSortingBufferRec.Decimal4)
                                {
                                }
                                column(Details_Dec5; TempSortingBufferRec.Decimal5)
                                {
                                }
                                column(Details_Dec6; TempSortingBufferRec.Decimal6)
                                {
                                }
                                column(Details_Dec7; TempSortingBufferRec.Decimal7)
                                {
                                }
                                column(Details_Dec8; TempSortingBufferRec.Decimal8)
                                {
                                }
                                column(Details_Dec9; TempSortingBufferRec.Decimal9)
                                {
                                }
                                column(Details_Dec10; TempSortingBufferRec.Decimal10)
                                {
                                }
                                column(Details_Dec11; TempSortingBufferRec.Decimal11)
                                {
                                }
                                column(Details_Dec12; TempSortingBufferRec.Decimal12)
                                {
                                }
                                column(Details_Dec1Bold; TempSortingBufferRec."Report Decimal1_Bold")
                                {
                                }
                                column(Details_Dec2Bold; TempSortingBufferRec."Report Decimal2_Bold")
                                {
                                }
                                column(Details_Dec3Bold; TempSortingBufferRec."Report Decimal3_Bold")
                                {
                                }
                                column(Details_Dec4Bold; TempSortingBufferRec."Report Decimal4_Bold")
                                {
                                }
                                column(Details_Dec5Bold; TempSortingBufferRec."Report Decimal5_Bold")
                                {
                                }
                                column(Details_Dec6Bold; TempSortingBufferRec."Report Decimal6_Bold")
                                {
                                }
                                column(Details_Dec7Bold; TempSortingBufferRec."Report Decimal7_Bold")
                                {
                                }
                                column(Details_Dec8Bold; TempSortingBufferRec."Report Decimal8_Bold")
                                {
                                }
                                column(Details_Dec9Bold; TempSortingBufferRec."Report Decimal9_Bold")
                                {
                                }
                                column(Details_Dec10Bold; TempSortingBufferRec."Report Decimal10_Bold")
                                {
                                }
                                column(HW_Imposition1; TempSortingBufferRec."Picture 1")
                                {
                                }
                                column(HW_Imposition2; TempSortingBufferRec."Picture 2")
                                {
                                }
                                column(HW_Imposition3; TempSortingBufferRec."Picture 3")
                                {
                                }
                                column(HW_SheetNo1; TempSortingBufferRec.Text5)
                                {
                                }
                                column(HW_SheetNo2; TempSortingBufferRec.Text6)
                                {
                                }
                                column(HW_SheetNo3; TempSortingBufferRec.Text7)
                                {
                                }
                                column(HW_NoUps1; TempSortingBufferRec.Integer1)
                                {
                                }
                                column(HW_NoUps2; TempSortingBufferRec.Integer2)
                                {
                                }
                                column(HW_NoUps3; TempSortingBufferRec.Integer3)
                                {
                                }
                                column(Long_Txt5; HW_TxtInt_String(TempSortingBufferRec.Text5))
                                {
                                }
                                column(Long_Txt6; HW_TxtInt_String(TempSortingBufferRec.Text6))
                                {
                                }
                                column(Long_Txt7; HW_TxtInt_String(TempSortingBufferRec.Text7))
                                {
                                }

                                trigger OnAfterGetRecord()
                                begin
                                    Line := Number;
                                    if Number = 1 then
                                        TempSortingBufferRec.FINDFIRST
                                    else begin
                                        TempSortingBufferRec.NEXT;
                                        TempSortingBufferRec.CALCFIELDS("Picture 1", "Picture 2", "Picture 3");
                                        if EcoLabel_PictureRec.Picture.HasValue then
                                            Clear(EcoLabel_PictureRec); // Avoid unnessecary repetition of Blob-Data
                                    end;
                                end;

                                trigger OnPreDataItem()
                                begin
                                    SetRange(Number, 1, LineMax);
                                    TempSortingBufferRec.RESET;
                                end;
                            }

                            trigger OnAfterGetRecord()
                            begin
                                PAGE_COUNTER := 0;
                            end;
                        }

                        trigger OnAfterGetRecord()
                        var
                        begin
                            JOBTICKET.JOBTICKET_Get_Report_Buffer(JobRecTemp, VERSION_LOOP.Number, TempSortingBufferRec, HeaderFieldName, HeaderFieldNameTxt);
                            if TempSortingBufferRec.COUNT = 0 then
                                CurrReport.Break;

                            LineMax := 0;
                            if TempSortingBufferRec.FINDLAST then
                                LineMax := TempSortingBufferRec.PK1_Integer1;

                            // <81087>
                            // if HW_DebugMode then begin
                            //     Clear(Page50099);
                            //     Page50099.SetCaption('Buffer BEFORE Modify');
                            //     Page50099.SetRecords(TempSortingBufferRec);
                            //     Page50099.RUN;
                            // end;

                            HW_ModifyBuffer;

                            // if HW_DebugMode then begin
                            //     Clear(Page50099);
                            //     Page50099.SetCaption('Buffer AFTER Modify');
                            //     Page50099.SetRecords(TempSortingBufferRec);
                            //     Page50099.RUN;
                            // end;
                            // </81087>
                        end;

                        trigger OnPreDataItem()
                        begin
                            SetRange(Number, 1, VERSION_LOOP_MAX);
                        end;
                    }

                    trigger OnAfterGetRecord()
                    begin
                        if COPIES > 1 then
                            COPY_TXT := '  (' + Format(Number) + ' - ' + Format(COPIES) + ')'
                        else
                            COPY_TXT := '';

                        // Chg03.1 HEADERTXT := OrderRec.FIELDCAPTION("Order No.") + '  ' + OrderRec."Order No." + '-' + FORMAT(JobRecTemp.Job) + COPY_TXT;
                        // <Chg03.1>
                        HEADERTXT := OrderRec.FIELDCAPTION("Order No.") + '  ' + OrderRec."Order No." + COPY_TXT;
                        // </Chg03.1>
                    end;

                    trigger OnPreDataItem()
                    begin
                        COPY_LOOP_COUNTER := Abs(COPIES);
                        if COPY_LOOP_COUNTER <= 0 then
                            COPY_LOOP_COUNTER := 1;

                        SetRange(Number, 1, COPY_LOOP_COUNTER);
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    case Number of
                        1:
                            JobRecTemp.FINDSET;
                        else
                            if JobRecTemp.NEXT = 0 then
                                CurrReport.Break;
                    end;

                    // <CHG06>
                    if JobRecTemp."Requested Delivery Date" = 0D then
                        Error('Requested Delivery Date is mandatory.');
                    // </CHG06>

                    Set_Custom_Variables_Job;
                end;
            }

            trigger OnAfterGetRecord()
            var
                CaseRec2: Record "PVS Case";
            begin
                if not JOBTICKET.JOBTICKET_Get_Jobs(OrderRec, JobRecTemp, VERSION_LOOP_MAX) then
                    CurrReport.Skip;

                FormMgt.Case_Get_EcoLabel_Picture(OrderRec, false, EcoLabel_PictureRec);

                HW_BelongsToProject := '';
                if OrderRec."Belongs to Project ID" <> 0 then
                    if CaseRec2.GET(OrderRec."Belongs to Project ID") then
                        HW_BelongsToProject := CaseRec2."Job Name";
            end;

            trigger OnPostDataItem()
            begin
                PrintMgt.MarkReportAsPrinted(OrderRec.ID, 3, CurrReport.Preview);
            end;

            trigger OnPreDataItem()
            begin
                // TN ->
                // IF OrderRec.GETFILTERS = '' THEN
                // OrderRec.SETRANGE(ID,3338);
                // TN <-
                SetupRec.FINDFIRST;
                PicturePresent := false;
                if SetupRec."Job Ticket Bitmap Page" <> '' then
                    if Page_PictureRec.GET(SetupRec."Job Ticket Bitmap Page") then
                        if not SingleInstance.JPG_Use then
                            if Page_PictureRec.Picture.HasValue then
                                PicturePresent := true;

                Clear(Page_PictureRec);
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
        Caption_x = 'x';
        Caption_Customer = 'Customer:';
        Caption_EcoLabel = 'Eco-label';
        Caption_Quantity = 'Quantity:';
        Caption_Mail = 'E-mail:';
        Caption_ShippingDate = 'Shipment:';
    }

    trigger OnInitReport()
    begin
        // </81087>
        HW_DebugMode := false;
        if UserId = 'HWPRINTING\NVS2' then
            HW_DebugMode := true;
        // </81087>

        SetupRec.FINDFIRST;
        COPIES := SetupRec."Job Ticket copies";
        if COPIES = 0 then
            COPIES := 1;

        PageLoopHeaderText := StrSubstNo(Text004, UserId, Format(Time));
        //
        // MESSAGE('R50010 in LIVE');
        //
    end;

    var
        NV: Codeunit "PVS Global";
        SingleInstance: Codeunit "PVS SingleInstance";
        DTM: Codeunit "PVS DateTime Management";
        JOBTICKET: Codeunit "PVS JobTicket Management";
        FormMgt: Codeunit "PVS Page Management";
        PrintMgt: Codeunit "PVS Print Management";
        GAPS: Codeunit "PVS Global";
        SetupRec: Record "PVS General Setup";
        CompanyRec: Record "Company Information";
        UserRec: Record "PVS User Setup";
        ContactRec: Record Contact;
        CustomerRec: Record Customer;
        JobRecTemp: Record "PVS Job" temporary;
        EcoLabel_PictureRec: Record "PVS Embedded File Storage";
        Page_PictureRec: Record "PVS Embedded File Storage";
        TempSortingBufferRec: Record "PVS Sorting Buffer" temporary;
        COPIES: Integer;
        COPY_TXT: Text[30];
        COPY_LOOP_COUNTER: Integer;
        VERSION_LOOP_MAX: Integer;
        PAGE_COUNTER: Integer;
        HEADERTXT: Text[250];
        HeaderFieldName: array[100] of Text[250];
        HeaderFieldNameTxt: array[100] of Text[250];
        LineMax: Integer;
        Line: Integer;
        ok: Boolean;
        Addr: array[10] of Text[50];
        TXT_PHONE: Text[250];
        TXT_FAX: Text[250];
        TXT_MAIL: Text[250];
        Shipping_DateTxt: Text[1024];
        PageLoopHeaderText: Text[250];
        Text004: Label '%1 %2 Page ';
        CompanyNameText: Text[250];
        [InDataSet]
        PicturePresent: Boolean;
        CaptionCustomer: Label 'Customer:';
        CaptionSellToContact: Label 'Contact:';
        CaptionQuantity: Label 'Quantity:';
        CaptionYourReference: Label 'Reference:';
        CaptionFormatCode: Label 'Format:';
        CaptionShipmentDate: Label 'Shipment:';
        CaptionSellToNo: Label 'Cust. No.:';
        CaptionSellToPhone: Label 'Phone No.:';
        CaptionSellToFax: Label 'Fax No.:';
        CaptionEmail: Label 'E-mail:';
        CaptionSalesPerson: Label 'Salesperson:';
        CaptionCoordinator: Label 'Coordinator:';
        CaptionQuoteNo: Label 'Quote No.:';
        CaptionCopyFromOrder: Label 'Copied from:';
        isPreview: Boolean;
        "--HW-SECTION--": Integer;
        // HW_Api: Codeunit Codeunit50000;
        HW_ScopeBuffer: Record "PVS Sorting Buffer" temporary;
        HW_Finishing: Text;
        HW_HeaderFieldName: array[100] of Text[250];
        HW_HeaderFieldNameTxt: array[100] of Text[250];
        HW_CaptionScope: Label 'Scope';
        HW_CaptionFinishing: Label 'Finishing';
        HW_DebugMode: Boolean;
        HW_CaptionQty: Label 'Quantity';
        HW_BelongsToProject: Text;
        HW_BelongsToProjectLbl: Label 'Project:';
        CaptionEstimator: Label 'Estimator:';
        TempSortingBufferRec2: Record "PVS Sorting Buffer" temporary;
        ShipmentRec: Record "PVS Job Shipment";
        T: Integer;
        I: Integer;
        AddrStr: Text;
        Res: Boolean;
        Addr2: array[10] of Text[50];

    procedure Set_Custom_Variables_Job()
    var
        HW_HeaderFieldElementCount: Integer;
    begin
        CompanyRec.FindFirst;
        CompanyNameText := CompanyRec.Name;

        ok := UserRec.GET(SingleInstance.Get_Current_Logical_Login_User);

        Addr[1] := OrderRec."Sell-To Name";
        Addr[2] := OrderRec."Sell-To Name 2";
        Addr[3] := OrderRec."Sell-To Address";
        Addr[4] := OrderRec."Sell-To Address 2";
        Addr[5] := OrderRec."Sell-To Postal Code" + ' ' + OrderRec."Sell-To City";
        CompressArray(Addr);

        OrderRec.CALCFIELDS("Salesperson Name", "Coordinator Name");

        Clear(CustomerRec);
        if CustomerRec.Get(OrderRec."Sell-To No.") then;

        TXT_PHONE := OrderRec."Sell-To Phone";
        TXT_FAX := OrderRec."Sell-To Fax";
        TXT_MAIL := CustomerRec."E-Mail";

        Clear(ContactRec);

        if OrderRec."Sell-To Contact No." <> '' then
            if ContactRec.Get(OrderRec."Sell-To Contact No.") then begin
                if ContactRec."Phone No." <> '' then
                    TXT_PHONE := ContactRec."Phone No.";
                if ContactRec."Fax No." <> '' then
                    TXT_FAX := ContactRec."Fax No.";
                if ContactRec."E-Mail" <> '' then
                    TXT_MAIL := ContactRec."E-Mail";
            end;

        case JobRecTemp."Date Method" of
            0:
                Shipping_DateTxt := DTM.DATETIME_Format(JobRecTemp."Requested Delivery DateTime", 1); // Time
            1:
                Shipping_DateTxt := DTM.DATETIME_Format(JobRecTemp."Requested Delivery DateTime", 5); // Day
            2:
                Shipping_DateTxt := DTM.DATETIME_Format(JobRecTemp."Requested Delivery DateTime", 6); // Week
        end;

        if JobRecTemp."Unchanged Rerun" then
            Shipping_DateTxt := StrSubstNo('%1 (%2)', Shipping_DateTxt, JobRecTemp.FIELDCAPTION("Unchanged Rerun"));

        // <82097>
        Clear(HW_HeaderFieldName);
        Clear(HW_HeaderFieldNameTxt);
        HW_HeaderFieldElementCount := 1;
        HW_HeaderFieldName[HW_HeaderFieldElementCount] := HW_CaptionQty;
        HW_HeaderFieldNameTxt[HW_HeaderFieldElementCount] := Format(JobRecTemp.Quantity);
        // </82097>

        // <81087>
        // HW_Api.Build_Scope(JobRecTemp, HW_ScopeBuffer);
        // HW_Finishing := HW_Api.Build_FinishingTextLine(JobRecTemp);

        if HW_ScopeBuffer.FINDSET then
            repeat
                HW_HeaderFieldElementCount += 1;
                if HW_HeaderFieldElementCount = 2 then
                    HW_HeaderFieldName[HW_HeaderFieldElementCount] := HW_CaptionScope;
                HW_HeaderFieldNameTxt[HW_HeaderFieldElementCount] := HW_ScopeBuffer.Text1;
            until HW_ScopeBuffer.NEXT = 0;
        if HW_Finishing <> '' then begin
            HW_HeaderFieldElementCount += 1;
            HW_HeaderFieldName[HW_HeaderFieldElementCount] := HW_CaptionFinishing;
            HW_HeaderFieldNameTxt[HW_HeaderFieldElementCount] := HW_Finishing;
        end;

        // </81087>
    end;

    local procedure HW_ModifyBuffer()
    var
        HW_HeaderTextLoop: Integer;
        HW_JobCalculationUnit: Record "PVS Job Calculation Unit";
        HW_JobCalculationDetail: Record "PVS Job Calculation Detail";
        HW_JobSheet: Record "PVS Job Sheet";
        HW_JobProcess: Record "PVS Job Process";
        HW_JobItem: Record "PVS Job Item";
        HW_JobSheetImposition: Record "PVS Job Sheet Imposition";
        TempLocalBufferRec: Record "PVS Sorting Buffer" temporary;
        LastUsedSequence: Integer;
        XamlDummy: BigText;
        ImpCount: Integer;
        SecSequence: Integer;
    begin
        // <81087>
        Clear(HeaderFieldName);
        Clear(HeaderFieldNameTxt);
        for HW_HeaderTextLoop := 1 to ArrayLen(HW_HeaderFieldNameTxt) do begin
            HeaderFieldName[HW_HeaderTextLoop] := HW_HeaderFieldName[HW_HeaderTextLoop];
            HeaderFieldNameTxt[HW_HeaderTextLoop] := HW_HeaderFieldNameTxt[HW_HeaderTextLoop];
        end;

        // Insert Bitmap(s)
        TempLocalBufferRec.RESET;
        TempLocalBufferRec.DELETEALL;
        TempSortingBufferRec.SETRANGE("Report Department Code", '100');
        if TempSortingBufferRec.FINDLAST then
            LastUsedSequence := TempSortingBufferRec.PK1_Integer1;
        TempSortingBufferRec.SETRANGE("Report Department Code");
        HW_JobSheet.SETCURRENTKEY(ID, Job, Version);
        HW_JobSheet.SETRANGE(ID, JobRecTemp.ID);
        HW_JobSheet.SETRANGE(Job, JobRecTemp.Job);
        HW_JobSheet.SETRANGE(Version, JobRecTemp.Version);
        if HW_JobSheet.FINDSET then begin
            TempSortingBufferRec.INIT;
            TempSortingBufferRec.PK1_Integer1 := LastUsedSequence;
            TempSortingBufferRec.PK1_Integer2 += 1;
            TempSortingBufferRec."Report Section" := 2;
            TempSortingBufferRec."Report Cell Background Color" := 'LightSteelBlue';
            TempSortingBufferRec."Report Font Size (Points)" := 12;
            TempSortingBufferRec."Report Text1_Bold" := true;
            TempSortingBufferRec.Text1 := 'Imposition';
            TempSortingBufferRec.INSERT;
            repeat
                HW_JobItem.SETRANGE(ID, JobRecTemp.ID);
                HW_JobItem.SETRANGE(Job, JobRecTemp.Job);
                HW_JobItem.SETRANGE(Version, JobRecTemp.Version);
                HW_JobItem.SETRANGE("Sheet ID", HW_JobSheet."Sheet ID");
                if not HW_JobItem.FINDFIRST then
                    HW_JobItem.INIT;
                if ImpCount = 0 then begin
                    TempSortingBufferRec.PK1_Integer2 += 1;
                    TempSortingBufferRec."Report Section" := 100;
                    TempSortingBufferRec."Report Cell Background Color" := '';
                    TempSortingBufferRec."Report Font Size (Points)" := 9;
                    TempSortingBufferRec."Report Text1_Bold" := false;
                    Clear(TempSortingBufferRec."Picture 1");
                    Clear(TempSortingBufferRec."Picture 2");
                    Clear(TempSortingBufferRec."Picture 3");
                end;
                ImpCount += 1;
                HW_JobSheetImposition.RESET;  //rjb
                HW_JobSheetImposition.SETRANGE("Sheet ID", HW_JobSheet."Sheet ID");
                IF HW_JobSheetImposition.FindFirst() then;
                // HW_JobSheetImposition.Get_Imposition_Picture(XamlDummy, true, 700, 500);
                case ImpCount of
                    1:
                        begin
                            if HW_JobSheetImposition.Picture.HasValue then
                                TempSortingBufferRec."Picture 1" := HW_JobSheetImposition.Picture;
                            TempSortingBufferRec.Text1 := HW_JobItem.Description;
                            //            TempSortingBufferRec.Code1 := GAPS.OnFormat_Sheet_No(JobRecTemp.ID,JobRecTemp.Job,
                            //                                                                 JobRecTemp.Version,HW_JobSheet."Sheet ID");
                            //TempSortingBufferRec.Text5 := HW_Int_String(HW_JobSheet."No. of Sheet Sets");
                            TempSortingBufferRec.Text5 := Format(HW_JobSheet."No. of Sheet Sets");
                            TempSortingBufferRec.Text10 := '';
                            repeat
                                if TempSortingBufferRec.Text11 <> '' then
                                    TempSortingBufferRec.Text11 += '+';
                                //TempSortingBufferRec.Text11 += FORMAT(HW_JobItem.Signatures);
                                //TempSortingBufferRec.Text11 += FORMAT(HW_JobItem."Pages with Print");
                                TempSortingBufferRec.Text11 += Format(HW_JobItem."Pages in Sheet");
                            until HW_JobItem.NEXT = 0;
                        end;
                    2:
                        begin
                            if HW_JobSheetImposition.Picture.HasValue then
                                TempSortingBufferRec."Picture 2" := HW_JobSheetImposition.Picture;
                            TempSortingBufferRec.Text2 := HW_JobItem.Description;
                            //            TempSortingBufferRec.Code2 := GAPS.OnFormat_Sheet_No(JobRecTemp.ID,JobRecTemp.Job,
                            //                                                                 JobRecTemp.Version,HW_JobSheet."Sheet ID");
                            //TempSortingBufferRec.Text6 := HW_Int_String(HW_JobSheet."No. of Sheet Sets");
                            TempSortingBufferRec.Text6 := Format(HW_JobSheet."No. of Sheet Sets");
                            repeat
                                if TempSortingBufferRec.Text12 <> '' then
                                    TempSortingBufferRec.Text12 += '+';
                                //TempSortingBufferRec.Text12 += FORMAT(HW_JobItem.Signatures);
                                //TempSortingBufferRec.Text12 += FORMAT(HW_JobItem."Pages with Print");
                                TempSortingBufferRec.Text12 += Format(HW_JobItem."Pages in Sheet");
                            until HW_JobItem.NEXT = 0;
                        end;
                    3:
                        begin
                            if HW_JobSheetImposition.Picture.HasValue then
                                TempSortingBufferRec."Picture 3" := HW_JobSheetImposition.Picture;
                            TempSortingBufferRec.Text3 := HW_JobItem.Description;
                            //            TempSortingBufferRec.Code3 := GAPS.OnFormat_Sheet_No(JobRecTemp.ID,JobRecTemp.Job,
                            //                                                                 JobRecTemp.Version,HW_JobSheet."Sheet ID");
                            //TempSortingBufferRec.Text7 := HW_Int_String(HW_JobSheet."No. of Sheet Sets");
                            TempSortingBufferRec.Text7 := Format(HW_JobSheet."No. of Sheet Sets");
                            repeat
                                if TempSortingBufferRec.Text13 <> '' then
                                    TempSortingBufferRec.Text13 += '+';
                                //TempSortingBufferRec.Text13 += FORMAT(HW_JobItem.Signatures);
                                //TempSortingBufferRec.Text13 += FORMAT(HW_JobItem."Pages with Print");
                                TempSortingBufferRec.Text13 += Format(HW_JobItem."Pages in Sheet");
                            until HW_JobItem.NEXT = 0;
                            TempSortingBufferRec.INSERT;
                            TempLocalBufferRec := TempSortingBufferRec;
                            TempLocalBufferRec.PK1_Integer3 := 1;
                            TempLocalBufferRec."Report Section" := 101;
                            Clear(TempLocalBufferRec."Picture 1");
                            Clear(TempLocalBufferRec."Picture 2");
                            Clear(TempLocalBufferRec."Picture 3");
                            TempLocalBufferRec.INSERT;
                            ImpCount := 0;
                        end;
                end;
            until HW_JobSheet.NEXT = 0;
            if (ImpCount > 0) and (ImpCount < 3) then begin
                TempSortingBufferRec.INSERT;
                TempLocalBufferRec := TempSortingBufferRec;
                TempLocalBufferRec.PK1_Integer3 := 1;
                TempLocalBufferRec."Report Section" := 101;
                Clear(TempLocalBufferRec."Picture 1");
                Clear(TempLocalBufferRec."Picture 2");
                Clear(TempLocalBufferRec."Picture 3");
                TempLocalBufferRec.INSERT;
            end;
            if TempLocalBufferRec.FINDSET then
                repeat
                    TempSortingBufferRec := TempLocalBufferRec;
                    TempSortingBufferRec.INSERT;
                until TempLocalBufferRec.NEXT = 0;
        end;
        HW_JobSheet.RESET;

        // Calculation Details
        // TempSortingBufferRec.SETRANGE("Report Section",20);
        // IF TempSortingBufferRec.FINDSET THEN
        //  REPEAT
        //    HW_JobCalculationUnit.GET(JobRecTemp.ID,JobRecTemp.Job,JobRecTemp.Version,TempSortingBufferRec."Report TableID1");
        //    TempSortingBufferRec.Text1 := HW_JobCalculationUnit.Text;
        //    TempSortingBufferRec.Code1 := HW_JobCalculationUnit.Unit;
        //    TempSortingBufferRec.MODIFY;
        //  UNTIL TempSortingBufferRec.NEXT = 0;
        //
        // TempLocalBufferRec.RESET;
        // TempLocalBufferRec.DELETEALL;
        // IF TempSortingBufferRec.FINDSET THEN BEGIN
        //  REPEAT
        //    TempLocalBufferRec.SETRANGE("Report Department Code",TempSortingBufferRec."Report Department Code");
        //    TempLocalBufferRec.SETRANGE(Code1,TempSortingBufferRec.Code1);
        //    IF NOT TempLocalBufferRec.FINDFIRST THEN BEGIN
        //      TempLocalBufferRec := TempSortingBufferRec;
        //      TempLocalBufferRec.INSERT;
        //    END ELSE BEGIN
        //      TempLocalBufferRec.Decimal1 += TempSortingBufferRec.Decimal1;
        //      TempLocalBufferRec.Decimal2 += TempSortingBufferRec.Decimal2;
        //      IF TempSortingBufferRec.Text4 <> '' THEN
        //        TempLocalBufferRec.Text4 := DELCHR(TempLocalBufferRec.Text4,'>') + ', ' + COPYSTR(TempSortingBufferRec.Text4,STRPOS(TempSortingBufferRec.Text4,' ')+1);
        //      TempLocalBufferRec.MODIFY;
        //    END;
        //  UNTIL TempSortingBufferRec.NEXT = 0;
        //  TempSortingBufferRec.DELETEALL;
        //  TempLocalBufferRec.RESET;
        //  IF TempLocalBufferRec.FINDSET THEN
        //    REPEAT
        //      TempSortingBufferRec := TempLocalBufferRec;
        //      TempSortingBufferRec.INSERT;
        //    UNTIL TempLocalBufferRec.NEXT = 0;
        // END;

        // Printing Header
        TempSortingBufferRec.SETRANGE("Report Section", 50);
        if TempSortingBufferRec.FINDFIRST then begin
            TempSortingBufferRec.Text1 := 'Press';
            TempSortingBufferRec.Text2 := 'Forms';
            TempSortingBufferRec.Text8 := 'Grs';
            // <Chg03.11>
            TempSortingBufferRec.Text5 := 'Printed sheet';
            TempSortingBufferRec.Text12 := '# parent';
            // </Chg03.11>

            TempSortingBufferRec."Report Font Size (Points)" := 8;
            TempSortingBufferRec.MODIFY;
        end;

        // Job Item Info
        TempSortingBufferRec.SETRANGE("Report Section", 51);
        if TempSortingBufferRec.FINDSET then
            repeat
                HW_JobItem.SETRANGE(ID, JobRecTemp.ID);
                HW_JobItem.SETRANGE(Job, JobRecTemp.Job);
                HW_JobItem.SETRANGE(Version, JobRecTemp.Version);
                HW_JobItem.SETRANGE("Job Item No.", TempSortingBufferRec."Report TableID1");
                if HW_JobItem.FINDFIRST then begin
                    // TempSortingBufferRec.Text1 := CopyStr(HW_Api.Build_JobItemColors(HW_JobItem), 1, MaxStrLen(TempSortingBufferRec.Text1));
                    TempSortingBufferRec.MODIFY;
                end;
            until TempSortingBufferRec.NEXT = 0;

        // Printing Details
        TempSortingBufferRec.SETRANGE("Report Section", 52);
        if TempSortingBufferRec.FINDSET then
            repeat
                if TempSortingBufferRec."Report TableID1" <> 0 then begin
                    HW_JobProcess.GET(TempSortingBufferRec."Report TableID1");
                    if not HW_JobSheet.GET(HW_JobProcess."Sheet ID") then
                        HW_JobSheet.INIT;
                    TempSortingBufferRec.Decimal4 := HW_JobSheet."End Qty.";
                    // if Evaluate(TempSortingBufferRec.Decimal9, GAPS.OnFormat_Sheet_No(JobRecTemp.ID,
                    //                      JobRecTemp.Job, JobRecTemp.Version, HW_JobProcess."Sheet ID")) then
                    //     ;
                    TempSortingBufferRec.Decimal9 := HW_JobProcess."Sheet ID";
                    HW_JobProcess.CALCFIELDS("Scrap Add. qty. processes");
                    TempSortingBufferRec.Decimal10 := HW_JobProcess."Total Scrap this process" + HW_JobProcess."Scrap Add. qty. processes";
                    TempSortingBufferRec.Decimal11 := HW_JobProcess.Plates + HW_JobProcess."Change Plates";
                    TempSortingBufferRec."Report Font Size (Points)" := 8;
                    TempSortingBufferRec.MODIFY;
                end;
            until TempSortingBufferRec.NEXT = 0;

        // remove print method on Digital
        TempSortingBufferRec.SETFILTER("Report Section", '52|72');
        if TempSortingBufferRec.FINDSET then
            repeat
                if TempSortingBufferRec."Report TableID1" <> 0 then begin
                    HW_JobProcess.GET(TempSortingBufferRec."Report TableID1");
                    if not HW_JobSheet.GET(HW_JobProcess."Sheet ID") then
                        HW_JobSheet.INIT;
                end;
                if (HW_JobProcess."Process Type" = HW_JobProcess."Process Type"::"Finishing sheet") or
                   (HW_JobProcess."Process Type" = HW_JobProcess."Process Type"::"Imposition Proofer") then begin
                    TempSortingBufferRec.Text2 := '';
                    TempSortingBufferRec.Decimal11 := 0;
                end;
                TempSortingBufferRec.MODIFY;
            until TempSortingBufferRec.NEXT = 0;

        // Shipments Block
        TempSortingBufferRec.SETRANGE("Report Section", 2);
        TempSortingBufferRec.SETRANGE("Report Department Code", '980');
        TempSortingBufferRec.DELETEALL;

        TempLocalBufferRec.RESET;
        TempLocalBufferRec.DELETEALL;
        TempSortingBufferRec.SETRANGE("Report Section");
        TempSortingBufferRec.SETRANGE("Report Department Code", '980');
        if TempSortingBufferRec.FINDSET then
            repeat
                TempLocalBufferRec := TempSortingBufferRec;
                TempLocalBufferRec.INSERT;
                TempSortingBufferRec.DELETE;
            until TempSortingBufferRec.NEXT = 0;

        TempSortingBufferRec.SETRANGE("Report Section", 80);
        TempSortingBufferRec.SETRANGE("Report Department Code");
        if TempSortingBufferRec.FINDFIRST then begin
            LastUsedSequence := TempSortingBufferRec.PK1_Integer1 - 1;

            SecSequence := 0;
            if TempLocalBufferRec.FINDSET then
                repeat
                    TempSortingBufferRec := TempLocalBufferRec;
                    SecSequence += 1;
                    TempSortingBufferRec.PK1_Integer1 := LastUsedSequence;
                    TempSortingBufferRec.PK1_Integer2 := SecSequence;
                    TempSortingBufferRec.INSERT;
                until TempLocalBufferRec.NEXT = 0;

            // <Chg03.8>
            T := 0;
            TempSortingBufferRec2.COPY(TempSortingBufferRec, true);
            TempSortingBufferRec2.RESET;
            TempSortingBufferRec2.SETRANGE("Report Section", 80);
            if TempSortingBufferRec2.FINDSET then
                repeat
                    ShipmentRec.RESET;
                    ShipmentRec.SETRANGE(ID, OrderRec.ID);
                    ShipmentRec.SETRANGE(Job, JobRecTemp.Job);
                    T += 1;
                    if T = 1 then
                        Res := ShipmentRec.FINDSET
                    else
                        Res := ShipmentRec.NEXT = 1;
                    // Chg04 - Addr changed to Addr2 in next 15 lines, to not mix up ordinary addr info!
                    if Res then begin
                        Clear(Addr2);
                        Addr2[1] := ShipmentRec.Name;
                        Addr2[2] := ShipmentRec.Address;
                        Addr2[3] := ShipmentRec."Address 2";
                        Addr2[4] := ShipmentRec.City;
                        Addr2[5] := ShipmentRec.County;
                        Addr2[6] := ShipmentRec."Post Code";
                        Addr2[7] := ShipmentRec.Contact;

                        CompressArray(Addr2);
                        AddrStr := ''; // Chg05
                        for I := 1 to 7 do
                            if Addr2[I] <> ' ' then // Chg04
                                if Addr2[I] <> '' then begin
                                    if AddrStr <> '' then
                                        AddrStr += ', ';
                                    AddrStr += Addr2[I];
                                end;
                        TempSortingBufferRec2.Text2 := AddrStr;
                        TempSortingBufferRec2."Report Decimal1_Bold" := true; // Chg03.7
                        TempSortingBufferRec2.MODIFY;
                    end;

                until TempSortingBufferRec2.NEXT = 0;
            // </Chg03.8>

            // Limit No. Of Shipments
            SecSequence := TempSortingBufferRec.COUNT;
            if SecSequence > 3 then begin
                TempSortingBufferRec.FINDFIRST;
                TempLocalBufferRec.RESET;
                TempLocalBufferRec.DELETEALL;
                TempLocalBufferRec := TempSortingBufferRec;
                TempSortingBufferRec.DELETEALL;
                TempSortingBufferRec := TempLocalBufferRec;
                TempSortingBufferRec.Text1 := 'Shipments:';
                TempSortingBufferRec.Decimal1 := SecSequence;
                TempSortingBufferRec.Text2 := 'Please see Distribution List';
                TempSortingBufferRec."Report Text2_Bold" := true;
                TempSortingBufferRec.INSERT;
            end;
        end;

        // <82097>
        // Added Flat Size
        TempSortingBufferRec.RESET;
        TempSortingBufferRec.SETRANGE("Report Section", 3);
        if TempSortingBufferRec.FINDFIRST then begin
            HW_JobItem.RESET;
            HW_JobItem.SETRANGE(ID, JobRecTemp.ID);
            HW_JobItem.SETRANGE(Job, JobRecTemp.Job);
            HW_JobItem.SETRANGE(Version, JobRecTemp.Version);
            if HW_JobItem.FINDFIRST then begin
                TempSortingBufferRec.PK1_Integer2 += 1;
                // Chg03.2 TempSortingBufferRec.Text1 := 'Flat Size: ' + HW_JobItem.Description + ', ' + FORMAT(HW_JobItem.Width * HW_JobItem."Imposition Factor Width") + 'x' +
                // <Chg03.2>
                TempSortingBufferRec.Text1 := 'Flat Size: ' + Format(HW_JobItem.Width * HW_JobItem."Imposition Factor Width") + 'x' +
                                              // </Chg03.2>
                                              Format(HW_JobItem.Length * HW_JobItem."Imposition Factor Length");
                // <Chg03.3>
                TempSortingBufferRec."Report Font Size (Points)" := 18;
                TempSortingBufferRec."Report Text1_Bold" := true;
                // </Chg03.3>
                TempSortingBufferRec.INSERT;
            end;
        end;
        // </82097>

        // <Chg03.4 + Chg03.6>
        TempSortingBufferRec.RESET;
        TempSortingBufferRec.SETRANGE("Report Section", 20);
        if TempSortingBufferRec.FINDSET then
            repeat
                // TempSortingBufferRec.Decimal2 := 0.0;
                // TempSortingBufferRec.Text4 := '';
                TempSortingBufferRec.MODIFY;
            until TempSortingBufferRec.NEXT = 0;
        // </Chg03.4 + Chg03.6>

        // <Chg03.5>
        TempSortingBufferRec.RESET;

        TempSortingBufferRec2.SETRANGE("Report Section", 101);
        if TempSortingBufferRec2.FINDFIRST then begin
            TempSortingBufferRec.RESET;
            TempSortingBufferRec.SETRANGE("Report Section", 52);
            if TempSortingBufferRec.FINDSET then begin
                TempSortingBufferRec2.Text5 := Format(TempSortingBufferRec.Decimal9);
                if TempSortingBufferRec.NEXT = 1 then begin
                    TempSortingBufferRec2.Text6 := Format(TempSortingBufferRec.Decimal9);
                    if TempSortingBufferRec.NEXT = 1 then
                        TempSortingBufferRec2.Text7 := Format(TempSortingBufferRec.Decimal9);
                end;
                TempSortingBufferRec2.MODIFY;
            end;
        end;
        // </Chg03.5>

        // <Chg03.9>
        // Chg04 IF OrderRec."Payment Terms" = 'NET 30' THEN BEGIN // Was used for test...
        if OrderRec."Payment Terms Code" = 'COD' then begin // Chg04
            TempSortingBufferRec.RESET;
            TempSortingBufferRec.SETRANGE("Report Section", 5);
            TempSortingBufferRec.SETRANGE("Report Department Code", '980');
            if TempSortingBufferRec.FINDFIRST then begin
                TempSortingBufferRec.Text2 := 'COD ' + TempSortingBufferRec.Text2;
                TempSortingBufferRec.MODIFY;
            end;
        end;
        // </Chg03.9>

        TempSortingBufferRec.RESET;
        LineMax := TempSortingBufferRec.COUNT;
        // </81087>
    end;

    local procedure HW_Int_String(inInt: Integer) OutTxt: Text
    var
        x: Integer;
    begin

        if inInt > 0 then
            for x := 1 to inInt do begin
                if OutTxt <> '' then
                    OutTxt += ',';
                OutTxt += Format(x);
            end;
    end;

    local procedure HW_TxtInt_String(inTxtInt: Text) OutTxt: Text
    var
        InInt: Integer;
        x: Integer;
    begin
        if not Evaluate(InInt, inTxtInt) then
            exit;
        if InInt > 0 then
            for x := 1 to InInt do begin
                if OutTxt <> '' then
                    OutTxt += ',';
                OutTxt += Format(x);
            end;
        //  IF STRLEN(OutTxt) > 200 THEN BEGIN
        //    OutTxt := COPYSTR(OutTxt,1,200);
        //    OutTxt += STRSUBSTNO('... (Total %1 Forms)',inInt);
        //  END;
    end;
}

