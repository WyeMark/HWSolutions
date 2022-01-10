codeunit 50130 "PTE XMPie Mgt"
{

    var
        GlobalWebFrontendSetup: Record "PVS Web2PVS Frontend Setup";
        GlobalWebHeaderRec: Record "PVS Web2PVS Header";
        GlobalWebLineRec: Record "PVS Web2PVS Line";
        PVSXMLDomMgt: Codeunit "PVS XML DOM Mgt.";
        NSMgr: XmlNamespaceManager;
        NameSpacePrefix: Text;
        Error001: label 'No XML file to process';
        Error003: label 'Error in XML File. Order head not found';
        Error004: label 'Login is missing, please create the login (Login: %1)';
        Error005: label 'Error in XML File. XmPie2PrintVis not found. Please check so the template for printvis is loaded in XmPie.';
        Error006: label 'Missing Status Code setup for external status %1, please set up from Frontend Setup page - Data Conversion.';

    procedure This_FrontendID() Frontend: Code[20]
    var
        Web2PVSFrontendSetup: Record "PVS Web2PVS Frontend Setup";
    begin
        Web2PVSFrontendSetup.Reset();
        Web2PVSFrontendSetup.SetRange("Web Shop System", Web2PVSFrontendSetup."web shop system"::XMPie);
        if Web2PVSFrontendSetup.FindFirst() then
            exit(Web2PVSFrontendSetup."Frontend ID");
    end;

    procedure METHOD_Process_placeOrder(var in_LogRec: Record "PVS Web2PVS Inbound Event Log") ErrorText: Text
    var
        Web2PVSBackend: Codeunit "PVS Web2PVS Backend WEB";
        OrderDetailsList, SubOrderDetailsList : XmlNodeList;
        OrderHeadNode: XmlNode;
        RootNode: XmlNode;
        XMLDoc: XmlDocument;
        XNode: XmlNode;
        XMLNode2, SubXMLNode, SubXMLNode2 : XmlNode;
        InStream: InStream;
        XMLLine: Text;
        XMLtxt: Text;
        i, is : Integer;
    begin

        GlobalWebFrontendSetup.Get('USTORE');
        // --- Decode XML ---
        in_LogRec.CalcFields("Frontend XML");
        if not in_LogRec."Frontend XML".Hasvalue() then
            Error(Error001);

        in_LogRec."Frontend XML".CreateInstream(InStream);

        InStream.ReadText(XMLtxt);
        while not InStream.eos() do begin
            InStream.ReadText(XMLLine);
            XMLtxt += XMLLine;
        end;

        //uStore sends as UTF-16 but the encoding is actually UTF-8
        XMLtxt := ReplaceString(XMLtxt, '<?xml version="1.0" encoding="utf-16"?>', '<?xml version="1.0" encoding="utf-8"?>');

        XMLtxt := removeNameSpace(XMLtxt);
        XmlDocument.ReadFrom(XMLtxt, XmlDoc);

        PVSXMLDomMgt.GetRootNode(XmlDoc, RootNode);

        // OrderHead
        if not xml_FindNode(RootNode, 'XmPie2PrintVis', OrderHeadNode) then
            Error(Error005);

        if not XMLFindNode(OrderHeadNode, 'OrderXml', OrderHeadNode) then
            Error(Error003);

        if not XMLFindNode(OrderHeadNode, 'Order', OrderHeadNode) then
            Error(Error003);

        InsertHeader(OrderHeadNode, in_LogRec);

        // ---- Order Details: Create as Job Items (Components) ----
        if XMLFindNode(OrderHeadNode, 'OrderProducts', XNode) then begin
            OrderDetailsList := XNode.AsXmlElement().GetChildNodes();
            for i := 0 to (OrderDetailsList.Count() - 1) do begin
                OrderDetailsList.Get(i + 1, XMLNode2);
                //HW ->
                if XMLFindNode(XMLNode2, 'SubOrderProducts', SubXMLNode) then begin
                    SubOrderDetailsList := SubXMLNode.AsXmlElement().GetChildNodes();
                    for is := 0 TO (SubOrderDetailsList.Count - 1) do begin
                        SubOrderDetailsList.Get(is + 1, SubXMLNode2);
                        InsertLine(SubXMLNode2);
                    end;
                end else //<-HW
                    InsertLine(XMLNode2);
            end;
        end;
        if GlobalWebHeaderRec.Modify() then;
        Web2PVSBackend.Order_Calculate_PlaceOrder(GlobalWebHeaderRec."No.");
        in_LogRec.Get(in_LogRec."Entry No.");

        InsertShipments();

        //<004>
        HW_ShippingSalesLine(in_LogRec);
        //</004>

        //<002>
        HW_Discount(in_LogRec);
        //</002>

        //<001>
        HW_UpdateEmailChargeLogic(GlobalWebHeaderRec);
        //</001>

        //<003>
        HW_UpdateJobName(GlobalWebHeaderRec);
        //</003>
    end;

    local procedure InsertHeader(var xmlNode: XmlNode; var in_LogRec: Record "PVS Web2PVS Inbound Event Log")
    var
        AccountRec: Record "PVS Web2PVS Frontend Account";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        Web2PVS_API: Codeunit "PVS Web2PVS API";
        DeliveryNode, PricesNode, ClearingNode : XmlNode;
        ElementNode, UserNode : XmlNode;
        ElementNodes: XmlNodeList;
        ShippingAddressNode: XmlNode;
        ShippingAgentNode: XmlNode;
        StoreNode: XmlNode;
        ShippingAgentTxt, txtFirstName, txtLastName, txtClearing : Text;
        ShippingAgent: Code[20];
        i: Integer;
        decCoupon, decShip : Decimal;
    begin
        Clear(GlobalWebHeaderRec);
        GlobalWebHeaderRec.Init();
        GlobalWebFrontendSetup.TestField(GlobalWebFrontendSetup."Web Shop Order Nos.");
        NoSeriesMgt.InitSeries(GlobalWebFrontendSetup."Web Shop Order Nos.", '', 0D, GlobalWebHeaderRec."No.", GlobalWebFrontendSetup."Web Shop Order Nos.");
        GlobalWebHeaderRec."Web Shop Status" := GlobalWebHeaderRec."web shop status"::New;
        GlobalWebHeaderRec."Frontend ID" := GlobalWebFrontendSetup."Frontend ID";
        GlobalWebHeaderRec."Inbound Log Entry No." := in_LogRec."Entry No.";
        GlobalWebHeaderRec."Document Date" := Today();
        if in_LogRec.Method = in_LogRec.Method::PlaceOrder then
            GlobalWebHeaderRec."Request Type" := GlobalWebHeaderRec."request type"::PlaceOrder;

        GlobalWebHeaderRec.Insert(true);
        GlobalWebHeaderRec."Status Code" := GlobalWebFrontendSetup."Status Code";

        in_LogRec."Header No." := GlobalWebHeaderRec."No.";

        GlobalWebHeaderRec."Web Shop Status" := GlobalWebHeaderRec."web shop status"::Submitted;

        // HW ->
        IF xml_FindNode(xmlNode, 'Prices', PricesNode) THEN BEGIN
            GetFld_Dec(PricesNode, 'CouponDiscount', decCoupon);
            IF decCoupon <> 0 THEN
                GlobalWebHeaderRec."Custom Field Decimal2" := decCoupon;
            GetFld_Text(PricesNode, 'CouponCode', GlobalWebHeaderRec."Custom Field Text1");
        END;

        IF xml_FindNode(xmlNode, 'Prices', PricesNode) THEN BEGIN
            GetFld_Dec(PricesNode, 'ShippingPrice', decShip);
            IF decShip <> 0 THEN
                GlobalWebHeaderRec."Custom Field Decimal1" := decShip;
        END;

        xml_FindNode(xmlNode, 'User', UserNode);
        GetFld_Text(UserNode, 'Email', GlobalWebHeaderRec."Web Contact E-Mail");
        GetFld_Text(UserNode, 'FirstName', txtFirstName);
        GetFld_Text(UserNode, 'LastName', txtLastName);
        GlobalWebHeaderRec."Optional Field 10" := STRSUBSTNO('%1 %2', txtFirstName, txtLastName);

        xml_FindNode(xmlNode, 'Clearing', ClearingNode);
        GlobalWebHeaderRec."Optional Field 9" := XMLGetAttribute('type', ClearingNode);
        GetFld_Text(ClearingNode, 'Value', txtClearing);
        IF STRLEN(txtClearing) < 50 THEN
            GlobalWebHeaderRec."Optional Field 8" := txtClearing
        ELSE
            GlobalWebHeaderRec."Optional Field 8" := COPYSTR(txtClearing, STRLEN(txtClearing) - 45);
        // <- HW


        if XMLFindNode(xmlNode, 'Store', StoreNode) then begin
            in_LogRec."Frontend Account" := XMLGetAttribute('Id', StoreNode);
        end;

        in_LogRec."Web Order No." := XMLGetAttribute('DisplayOrderId', xmlNode);
        GlobalWebHeaderRec."Web Order No." := in_LogRec."Web Order No.";

        //HW ->
        GlobalWebHeaderRec."External Document No." := in_LogRec."Web Order No."; //2018-02-13

        // Sets the Your Reference Field to the Clearing Value (PO, Invoice, transaction ID) or the web order id
        if GlobalWebHeaderRec."Optional Field 8" = 'Purchase Order' then
            GlobalWebHeaderRec."Your Reference" := GlobalWebHeaderRec."Optional Field 8"
        else
            GlobalWebHeaderRec."Your Reference" := in_LogRec."Web Order No.";
        //HW <-

        // Find Account
        if in_LogRec."Frontend Account" <> '' then begin
            AccountRec.SetRange("Frontend ID", This_FrontendID());
            AccountRec.SetRange("Frontend Login ID", in_LogRec."Frontend Account");
            if AccountRec.FindFirst() then begin
                in_LogRec."Contact No." := AccountRec."Contact Person No.";
                GlobalWebHeaderRec."Sell-To No." := AccountRec."Customer No.";
                in_LogRec."Customer No." := GlobalWebHeaderRec."Sell-To No.";
            end else
                Error(Error004, in_LogRec."Frontend Account");
        end;

        if Evaluate(GlobalWebHeaderRec."External Order ID", XMLGetAttribute('OrderId', xmlNode)) then;

        // Billing
        if XMLFindNode(xmlNode, 'BillingAddress', ElementNode) then begin
            GetFld_Text(ElementNode, 'Company', GlobalWebHeaderRec."Bill-To Name");
            if GlobalWebHeaderRec."Bill-To Name" = '' then
                GetFld_Text(ElementNode, 'Name', GlobalWebHeaderRec."Bill-To Name 2")
            else
                GetFld_Text(ElementNode, 'Name', GlobalWebHeaderRec."Bill-To Name");
            GetFld_Text(ElementNode, 'Address1', GlobalWebHeaderRec."Bill-To Address");
            GetFld_Text(ElementNode, 'Address2', GlobalWebHeaderRec."Bill-To Address 2");
            GetFld_Text(ElementNode, 'City', GlobalWebHeaderRec."Bill-To City");
            GetFld_Text(ElementNode, 'State', GlobalWebHeaderRec."Bill-To County");
            GetFld_Code(ElementNode, 'ZipCode', GlobalWebHeaderRec."Bill-To Post Code");
            GetFld_Code(ElementNode, 'Country', GlobalWebHeaderRec."Bill-To Country/Region Code");

        end;

        in_LogRec.Modify();

        // Shipment
        if XMLFindNode(xmlNode, 'Deliveries', ElementNode) then begin
            ElementNodes := ElementNode.AsXmlElement().GetChildNodes();
            for i := 0 to (ElementNodes.Count() - 1) do begin
                ElementNodes.Get(i + 1, DeliveryNode);
                if XMLFindNode(DeliveryNode, 'DeliveryProvider', ShippingAgentNode) then begin
                    GetFldAttr_Text(ShippingAgentNode, 'id', ShippingAgentTxt);
                    ShippingAgent := ShippingAgentTxt;
                    Web2PVS_API.ConvertFieldData(GlobalWebHeaderRec."Frontend ID", 291, true, ShippingAgent, ShippingAgent);
                    GlobalWebHeaderRec."Shipping Agent Code" := ShippingAgent;
                end;
                if XMLFindNode(DeliveryNode, 'DeliveryService', ShippingAgentNode) then begin
                    GetFldAttr_Text(ShippingAgentNode, 'id', ShippingAgentTxt);
                    ShippingAgent := ShippingAgentTxt;
                    Web2PVS_API.ConvertFieldData(GlobalWebHeaderRec."Frontend ID", 5790, true, ShippingAgent, ShippingAgent);
                    GlobalWebHeaderRec."Shipping Agent Service Code" := ShippingAgent;
                end;
                XMLFindNode(DeliveryNode, 'ShippingAddress', ShippingAddressNode);

                //HW ->
                //GetFld_Text(ShippingAddressNode, 'Company', GlobalWebHeaderRec."Ship-To Name");
                //GetFld_Text(ShippingAddressNode, 'Name', GlobalWebHeaderRec."Ship-to Name 2");
                GetFld_Text(ShippingAddressNode, 'Name', GlobalWebHeaderRec."Ship-to Name");
                GetFld_Text(ShippingAddressNode, 'Company', GlobalWebHeaderRec."Ship-to Name 2");
                //<- HW
                GetFld_Text(ShippingAddressNode, 'Address1', GlobalWebHeaderRec."Ship-To Address");
                GetFld_Text(ShippingAddressNode, 'Address2', GlobalWebHeaderRec."Ship-To Address 2");
                GetFld_Code(ShippingAddressNode, 'ZipCode', GlobalWebHeaderRec."Ship-To Post Code");
                GetFld_Text(ShippingAddressNode, 'City', GlobalWebHeaderRec."Ship-To City");
                GetFld_Text(ShippingAddressNode, 'State', GlobalWebHeaderRec."Ship-To County");
                GetFld_Code(ShippingAddressNode, 'Country', GlobalWebHeaderRec."Ship-To Country/Region Code");
                GetFld_Text(ShippingAddressNode, 'Name', GlobalWebHeaderRec."Ship-To Contact");
                GetFld_Text(ShippingAddressNode, 'Phone', GlobalWebHeaderRec."Web Contact Phone");
                IF GlobalWebHeaderRec."Ship-to Name" <> '' THEN BEGIN
                    GlobalWebHeaderRec.MODIFY;
                    EXIT;
                END;
            end;
        end;

        GlobalWebHeaderRec.Modify();
    end;

    local procedure InsertLine(var xmlNode: XmlNode)
    var
        CatalogIndexItems: Record "PVS Web2PVS Cat. Index Items";
        Web2PVSPart: Record "PVS Web2PVS Part";
        LogRec: Record "PVS Web2PVS Outbound Event Log";
        Web2PVS_API: Codeunit "PVS Web2PVS API";
        ComponentNode: XmlNode;
        ComponentNodes: XmlNodeList;
        ComponentsNode: XmlNode;
        Node2: XmlNode;
        Node3: XmlNode;
        PropertyNode: XmlNode;
        ValueNode: XmlNode;
        PaperInXML: Code[250];
        PaperItemNo: Code[100];
        i: Integer;
        NextLineNo: Integer;
        itemsAmountTxt: Text;
        itemsAmountDec: Decimal;
    begin
        GlobalWebLineRec.Reset();
        GlobalWebLineRec.SetRange(GlobalWebLineRec."Header No.", GlobalWebHeaderRec."No.");

        if NextLineNo = 0 then
            if GlobalWebLineRec.FindLast() then
                NextLineNo := GlobalWebLineRec."Line No." + 10000
            else
                NextLineNo := 10000;

        GlobalWebLineRec.Reset();
        Clear(GlobalWebLineRec);
        GlobalWebLineRec.Init();
        GlobalWebLineRec."Header No." := GlobalWebHeaderRec."No.";
        GlobalWebLineRec."Line No." := NextLineNo;
        GlobalWebLineRec.Insert(true);

        if Evaluate(GlobalWebLineRec."External Line ID", XMLGetAttribute('id', xmlNode)) then;
        GlobalWebLineRec."Description 2" := XMLGetAttribute('Nickname', xmlNode); //HW

        //Read product node
        xml_FindNode(xmlNode, 'Product', Node2);
        GlobalWebLineRec."No." := XMLGetAttribute('externalId', Node2);
        if xml_FindNode(Node2, 'Name', Node3) then
            GlobalWebLineRec.Description := CopyStr(Node3.AsXmlElement().InnerText(), 1, MaxStrLen(GlobalWebLineRec.Description));

        //Read quantity node
        xml_FindNode(xmlNode, 'Quantities', Node2);
        GetFld_Dec(Node2, 'TotalUnits', GlobalWebLineRec.Quantity);

        //Read pack HW
        IF xml_FindNode(xmlNode, 'ProductUnit', Node2) THEN BEGIN
            itemsAmountTxt := XMLGetAttribute('itemsAmount', Node2);
            IF EVALUATE(itemsAmountDec, itemsAmountTxt) THEN
                GlobalWebLineRec.Quantity := GlobalWebLineRec.Quantity * itemsAmountDec;
        END;
        //<- HW

        //Read prices node
        xml_FindNode(xmlNode, 'Prices', Node2);
        GetFld_Dec(Node2, 'PricePerUnit', GlobalWebLineRec."Unit Price");
        GlobalWebLineRec.Amount := GlobalWebLineRec.Quantity * GlobalWebLineRec."Unit Price";

        // Find Catalog Item, or trow error if not exist
        CatalogIndexItems.Reset();
        CatalogIndexItems.SetRange("Item No.", GlobalWebLineRec."No.");
        CatalogIndexItems.FindFirst();

        GlobalWebLineRec."Catalog Code" := CatalogIndexItems."Catalog Code";
        GlobalWebLineRec."Catalog Entry No." := CatalogIndexItems."Catalog Entry No.";
        GlobalWebLineRec."Catalog Index" := CatalogIndexItems."Catalog Index";

        if GlobalWebLineRec."No." <> '' then begin
            GlobalWebLineRec.Type := GlobalWebLineRec.Type::Item;
            if CatalogIndexItems."Item Production Type" <> CatalogIndexItems."item production type"::"Call from Stock" then
                GlobalWebLineRec."Production Order" := true;
        end;

        GlobalWebLineRec.Modify(true);

        xml_FindNode(xmlNode, 'PropertyValues', ComponentNode);
        ComponentNodes := ComponentNode.AsXmlElement().GetChildNodes();

        for i := 0 to (ComponentNodes.Count() - 1) do begin
            ComponentNodes.Get(i + 1, ComponentsNode);
            xml_FindNode(ComponentsNode, 'Property', PropertyNode);
            if PropertyNode.AsXmlElement().InnerText() = 'Paper Type' then begin
                xml_FindNode(ComponentsNode, 'Value', ValueNode);
                Web2PVSPart.Init();
                Web2PVSPart."Header No." := GlobalWebLineRec."Header No.";
                Web2PVSPart."Line No." := GlobalWebLineRec."Line No.";
                Web2PVSPart."Job Part Selected" := true;
                Web2PVSPart."Job Part No." := 1;
                PaperInXML := ValueNode.AsXmlElement().InnerText();
                PaperItemNo := PaperInXML;
                Web2PVS_API.ConvertFieldData(GlobalWebHeaderRec."Frontend ID", 27, true, PaperItemNo, PaperInXML);
                Web2PVSPart."Paper Item No." := PaperItemNo;
                Web2PVSPart.Insert();
            end;
        end;

        LogRec.Init();
        LogRec."Frontend ID" := This_FrontendID();
        LogRec.Method := 'UPDATEINVENTORY';
        LogRec."External ID 1" := GlobalWebLineRec."No.";
        LogRec.Insert(true);
    end;

    local procedure UpdateInventoryInXMPie(ItemNo: Code[50]; Inventory: Decimal)
    var
        i: Integer;
        IntArr: array[1000] of Integer;
        IntInventory: Integer;
    begin
        IntInventory := ROUND(Inventory);
        GetProductIDsByExternalID(ItemNo, IntArr);
        for i := 1 to 1000 do begin
            if IntArr[i] = 0 then
                exit;
            ProductInventoryUpdate(IntArr[i], IntInventory);
        end;
    end;

    local procedure GetAllProductionStatusFromXMPie()
    var
        SalesHeaderRec: Record "Sales Header";
        Web2PVSHeaderRec: Record "PVS Web2PVS Header";
        Web2PVSLinerec: Record "PVS Web2PVS Line";
        NewExternalLineId: Integer;
    begin
        //Loop all active order for XMPie
        SalesHeaderRec.Reset();
        SalesHeaderRec.SetRange("PVS Web Frontend Code", This_FrontendID());
        SalesHeaderRec.SetRange("Completely Shipped", false);
        if SalesHeaderRec.FindSet() then
            repeat
                if Web2PVSHeaderRec.Get(SalesHeaderRec."PVS Web Header Code") then begin
                    Web2PVSLinerec.Reset();
                    Web2PVSLinerec.SetRange("Header No.", Web2PVSHeaderRec."No.");
                    Web2PVSLinerec.SetFilter("External Line Status", '<>%1', '3');
                    Web2PVSLinerec.SetFilter("External Line ID", '<>%1', 0);
                    if Web2PVSLinerec.FindSet(true, false) then
                        repeat
                            NewExternalLineId := GetProductionStatus(Web2PVSLinerec."External Line ID");
                            if Web2PVSLinerec."External Line Status" <> Format(NewExternalLineId) then begin
                                Web2PVSLinerec."External Line Status" := Format(NewExternalLineId);
                                Web2PVSLinerec.Modify();
                            end;
                        until Web2PVSLinerec.Next() = 0;
                end;
            until SalesHeaderRec.Next() = 0;
    end;

    local procedure GetProductionStatusAndUpdateStatus(OrderProductID: Integer; ErrorTxt: Text)
    var
        CaseRec: Record "PVS Case";
        Web2PVSLineRec: Record "PVS Web2PVS Line";
        Web2PVSDataConversionRec: Record "PVS Web2PVS Data Conversion";
        LogRec: Record "PVS Web2PVS Outbound Event Log";
        NewStatus: Text;
    begin
        NewStatus := Format(GetProductionStatus(OrderProductID));
        Web2PVSLineRec.Reset();
        Web2PVSLineRec.SetRange("External Line ID", OrderProductID);
        if not Web2PVSLineRec.FindFirst() then
            exit;

        if Web2PVSLineRec."External Line Status" = NewStatus then begin
            LogRec.Reset();
            LogRec.SetRange("Frontend ID", This_FrontendID());
            LogRec.SetRange(Method, 'GETPRODUCTIONSTATUS');
            LogRec.SetRange("External ID 1", Format(OrderProductID));
            if LogRec.Count() < 20 then begin
                // one more request
                LogRec.Init();
                LogRec."Frontend ID" := This_FrontendID();
                LogRec.Method := 'GETPRODUCTIONSTATUS';
                LogRec."External ID 1" := Format(OrderProductID);
                LogRec.Insert(true);
                exit;
            end;
        end;

        Web2PVSLineRec."External Line Status" := NewStatus;
        Web2PVSLineRec.Modify();
        if Web2PVSLineRec."External Line Status" = '3' then //Completed
            if CaseRec.Get(Web2PVSLineRec."Case ID") then begin
                //Change status
                Web2PVSDataConversionRec.Reset();
                Web2PVSDataConversionRec.SetRange("Frontend ID", This_FrontendID());
                Web2PVSDataConversionRec.SetRange(Type, Web2PVSDataConversionRec.Type::"Status Code");
                Web2PVSDataConversionRec.SetRange("Frontend Value", Web2PVSLineRec."External Line Status");
                if Web2PVSDataConversionRec.FindFirst() then begin
                    CaseRec.Validate("Status Code", Web2PVSDataConversionRec.Code);
                    CaseRec.Modify(true);
                end else
                    ErrorTxt := StrSubstNo(Error006, Web2PVSLineRec."External Line Status");
                //Do not create a new request
                exit;
            end;

        if Web2PVSLineRec."External Line Status" in ['4', '5', '6', '8'] then begin
            //ERROR stop polling status, Job should be moved back to ORDER to send a new sendtoproduction.
            ErrorTxt := '';
        end else begin
            LogRec.Reset();
            LogRec.SetRange("Frontend ID", This_FrontendID());
            LogRec.SetRange(Method, 'GETPRODUCTIONSTATUS');
            LogRec.SetRange("External ID 1", Format(OrderProductID));
            if LogRec.Count() < 20 then begin
                LogRec.Init();
                LogRec."Frontend ID" := This_FrontendID();
                LogRec.Method := 'GETPRODUCTIONSTATUS';
                LogRec."External ID 1" := Format(OrderProductID);
                LogRec.Insert(true);
            end;
        end;
    end;

    local procedure InsertShipments()
    var
        JobRec: Record "PVS Job";
        JobShipmentRec: Record "PVS Job Shipment";
    begin
        GlobalWebLineRec.Reset();
        GlobalWebLineRec.SetFilter(GlobalWebLineRec."Header No.", GlobalWebHeaderRec."No.");
        if GlobalWebLineRec.FindSet() then
            repeat
                JobShipmentRec.Reset();
                JobShipmentRec.SetRange(ID, GlobalWebLineRec."Case ID");
                JobShipmentRec.SetRange(Job, GlobalWebLineRec."Job ID");
                if not JobShipmentRec.IsEmpty() then
                    JobShipmentRec.DeleteAll();
                JobShipmentRec.Init();
                if JobRec.Get(GlobalWebLineRec."Case ID", GlobalWebLineRec."Job ID") then begin
                    JobRec.Create_First_Shipment();
                end;
            until GlobalWebLineRec.Next() = 0;
    end;


    // HW ->
    LOCAL PROCEDURE HW_UpdateEmailChargeLogic(inHeader: Record 6010938)
    VAR
        SalesHeader: Record "Sales Header";
    //TODO SalesEMailAddress: Record 37028808;
    BEGIN
        SalesHeader.RESET;
        SalesHeader.SETRANGE("PVS Web Header Code", inHeader."No.");
        IF NOT SalesHeader.FINDLAST THEN
            EXIT;

        //TODO  ->       
        // SalesEMailAddress.RESET;
        // SalesEMailAddress.SETRANGE("Document Type", SalesHeader."Document Type");
        // SalesEMailAddress.SETRANGE("Document No.", SalesHeader."No.");
        // SalesEMailAddress.SETRANGE("Link to Table", SalesEMailAddress."Link to Table"::Customer);
        // IF SalesEMailAddress.FINDFIRST THEN BEGIN
        //     SalesEMailAddress.Name := inHeader."Optional Field 10";
        //     SalesEMailAddress."E-Mail" := inHeader."Web Contact Email";
        //     IF SalesEMailAddress.MODIFY THEN;
        // END;
        //TODO <-

        SalesHeader."Clearing Type" := inHeader."Optional Field 9";
        SalesHeader."Clearing Value" := inHeader."Optional Field 8";
        IF SalesHeader.MODIFY THEN;
    END;

    LOCAL PROCEDURE HW_Discount(VAR in_InboundEventLog: Record "PVS Web2PVS Inbound Event Log");
    VAR
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        Web2PVHeader: Record "PVS Web2PVS Header";
        Discount: Decimal;
        isReleased: Boolean;
        ReleaseSalesDocument: Codeunit "Release Sales Document";
    BEGIN
        //<002>
        IF NOT Web2PVHeader.GET(in_InboundEventLog."Header No.") THEN
            EXIT;
        IF NOT SalesHeader.GET(SalesHeader."Document Type"::Order, in_InboundEventLog."Sales Order No.") THEN
            EXIT;

        //todo SalesHeader.Coupon := Web2PVHeader."Custom Field Text1"; // <004>
        //Todo SalesHeader."Coupon Value" := Web2PVHeader."Custom Field Decimal2"; //<004>
        SalesHeader.MODIFY;


        Discount := Web2PVHeader."Custom Field Decimal2";

        IF Discount = 0 THEN
            EXIT;

        SalesLine.SETRANGE("Document No.", SalesHeader."No.");
        SalesLine.SETRANGE("Document Type", SalesHeader."Document Type");
        IF SalesLine.FINDSET THEN
            REPEAT
                IF SalesLine.Amount > 0 THEN BEGIN //first line takes all
                    IF SalesLine.Amount > Discount THEN BEGIN
                        SalesLine.VALIDATE("Line Discount Amount", Discount);
                        SalesLine.MODIFY(TRUE);
                        Discount := Discount - SalesLine."Line Discount Amount";
                    END;
                    IF SalesLine.Amount <= Discount THEN BEGIN
                        SalesLine.VALIDATE("Line Discount Amount", SalesLine.Amount);
                        SalesLine.MODIFY(TRUE);
                        Discount := Discount - SalesLine."Line Discount Amount";
                    END;
                END;

                IF Discount = 0 THEN
                    EXIT;

            UNTIL SalesLine.NEXT = 0;
    END;

    LOCAL PROCEDURE HW_UpdateJobName(inHeader: Record "PVS Web2PVS Header");
    VAR
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        JobRec: Record "PVS Job";
        CaseRec: Record "PVS Case";
    BEGIN

        SalesHeader.RESET;
        SalesHeader.SETRANGE("PVS Web Header Code", inHeader."No.");
        IF NOT SalesHeader.FINDLAST THEN
            EXIT;

        SalesLine.RESET;
        SalesLine.SETRANGE("Document No.", SalesHeader."No.");
        SalesLine.SETRANGE("Document Type", SalesHeader."Document Type");
        SalesLine.SETFILTER("PVS ID", '<>%1', 0);
        SalesLine.SETFILTER("Description 2", '<>%1', '');
        IF SalesLine.FINDSET THEN
            REPEAT
                IF CaseRec.GET(SalesLine."PVS ID") THEN BEGIN
                    CaseRec."Job Name" := SalesLine.Description + ' ' + SalesLine."Description 2";
                    IF CaseRec.MODIFY THEN;
                END;
                JobRec.SETRANGE(ID, SalesLine."PVS ID");
                JobRec.SETRANGE(Job, SalesLine."PVS Job");
                IF JobRec.FINDFIRST THEN BEGIN
                    JobRec."Job Name" := SalesLine.Description + ' ' + SalesLine."Description 2";
                    JobRec.MODIFY;
                END
            UNTIL SalesLine.NEXT = 0;

    END;

    LOCAL PROCEDURE HW_ShippingSalesLine(VAR in_InboundEventLog: Record "PVS Web2PVS Inbound Event Log");
    VAR
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        Web2PVHeader: Record "PVS Web2PVS Header";
        //TODO HWSettings : Record 50003;
        ShipmentPrice: Decimal;
        LineNo: Integer;
    BEGIN
        //<002>
        IF NOT Web2PVHeader.GET(in_InboundEventLog."Header No.") THEN
            EXIT;
        IF NOT SalesHeader.GET(SalesHeader."Document Type"::Order, in_InboundEventLog."Sales Order No.") THEN
            EXIT;

        ShipmentPrice := Web2PVHeader."Custom Field Decimal1";

        IF ShipmentPrice = 0 THEN
            EXIT;

        //TODO IF NOT HWSettings.GET THEN
        //TODO EXIT;

        //TODO IF HWSettings."Add Shipping Line" = HWSettings."Add Shipping Line"::None THEN
        //TODO             EXIT;

        SalesLine.SETRANGE("Document No.", SalesHeader."No.");
        SalesLine.SETRANGE("Document Type", SalesHeader."Document Type");
        IF SalesLine.FINDLAST THEN
            LineNo := SalesLine."Line No.";

        SalesLine.INIT;
        SalesLine."Document No." := SalesHeader."No.";
        SalesLine."Document Type" := SalesHeader."Document Type";
        SalesLine."Line No." := LineNo + 10000;
        SalesLine.INSERT(TRUE);
        //TODO  ->
        // IF HWSettings."Add Shipping Line" = HWSettings."Add Shipping Line"::Item THEN BEGIN
        //     SalesLine.Type := SalesLine.Type::Item;
        //     SalesLine.VALIDATE("No.", HWSettings."uStore Shipping Item");
        // END;
        // IF HWSettings."Add Shipping Line" = HWSettings."Add Shipping Line"::Resource THEN BEGIN
        SalesLine.Type := SalesLine.Type::Resource;
        SalesLine.VALIDATE("No.", 'SHIPPING');
        // END;
        //<- TODO 
        SalesLine.VALIDATE(Quantity, 1);
        SalesLine.VALIDATE("Unit Price", ShipmentPrice);
        SalesLine.MODIFY(TRUE);
    END;






    local procedure "----Response----"()
    begin
    end;

    procedure GetProductionStatus(OrderProductID: Integer): Integer
    var
        FrontendRec: Record "PVS Web2PVS Frontend Setup";
        ResponseTxt: Text;
        StatusTxt: Text;
        URL: Text;
        StatusInt: Integer;
    begin
        FrontendRec.Get('USTORE');

        URL := StrSubstNo('%1/ProductionWS.asmx/GetProductionStatus?username=%2&password=%3&orderProductId=%4', FrontendRec."Response URL", FrontendRec."Response Login", FrontendRec."Response Password", OrderProductID);
        ResponseTxt := SendWebReuest(URL);

        if ResponseTxt = '' then
            exit(0);
        if StrPos(ResponseTxt, '<Status>') > 0 then begin
            StatusTxt := CopyStr(ResponseTxt, StrPos(ResponseTxt, '<Status>') + 8);
            StatusTxt := CopyStr(StatusTxt, 1, StrPos(StatusTxt, '<') - 1);
            if Evaluate(StatusInt, StatusTxt) then
                exit(StatusInt);
        end;
        exit(0);

        //1 waiting
        //2 inprogress
        //3 Completed
        //4 > failed
    end;

    local procedure SendToProduction(OrderProductID: Integer): Boolean
    var
        FrontendRec: Record "PVS Web2PVS Frontend Setup";
        ResponseTxt: Text;
        URL: Text;
    begin
        FrontendRec.Get('USTORE');
        URL := StrSubstNo('%1/ProductionWS.asmx/SendToProduction?username=%2&password=%3&orderProductId=%4', FrontendRec."Response URL", FrontendRec."Response Login", FrontendRec."Response Password", OrderProductID);
        ResponseTxt := SendWebReuest(URL);
        //No response from XMPie for this request
    end;

    local procedure SendToProductionOneCopy(OrderProductID: Integer): Boolean
    var
        FrontendRec: Record "PVS Web2PVS Frontend Setup";
        ResponseTxt: Text;
        URL: Text;
    begin
        FrontendRec.Get('USTORE');
        URL := StrSubstNo('%1/ProductionWS.asmx/SendToProductionOneCopy?username=%2&password=%3&orderProductId=%4', FrontendRec."Response URL", FrontendRec."Response Login", FrontendRec."Response Password", OrderProductID);
        ResponseTxt := SendWebReuest(URL);
        //No response from XMPie for this request
    end;

    local procedure MoveToQueue(OrderProductID: Integer; QueueID: Text): Boolean
    var
        FrontendRec: Record "PVS Web2PVS Frontend Setup";
        ResponseTxt: Text;
        URL: Text;
    begin
        FrontendRec.Get('USTORE');
        URL := StrSubstNo('%1/OrderProductWS.asmx/MoveToQueue?username=%2&password=%3&orderProductId=%4&queueId=%5', FrontendRec."Response URL", FrontendRec."Response Login", FrontendRec."Response Password", OrderProductID, QueueID);
        ResponseTxt := SendWebReuest(URL);
        //No response from XMPie for this request
    end;

    local procedure GetProductIDsByExternalID(ExternalProductID: Text; var outIntArr: array[1000] of Integer): Boolean
    var
        FrontendRec: Record "PVS Web2PVS Frontend Setup";
        RootNode: XmlNode;
        XMLDoc: XmlDocument;
        XNode: XmlNode;
        XNodeList: XmlNodeList;
        ResponseTxt: Text;
        URL: Text;
        i: Integer;
        IntProductID: Integer;
    begin
        FrontendRec.Get('USTORE');
        URL := StrSubstNo('%1/ProductWS.asmx/GetProductIDsByExternalID?username=%2&password=%3&externalProductID=%4', FrontendRec."Response URL", FrontendRec."Response Login", FrontendRec."Response Password", ExternalProductID);
        ResponseTxt := SendWebReuest(URL);

        if ResponseTxt = '' then
            exit;

        i := 0;

        XMLDocument.ReadFrom(ResponseTxt, XMLDoc);
        PVSXMLDomMgt.GetRootNode(XmlDoc, RootNode);

        XNodeList := RootNode.AsXmlElement().GetChildNodes();
        for i := 0 to (XNodeList.Count() - 1) do begin
            XNodeList.Get(i, XNode);
            if Evaluate(IntProductID, XNode.AsXmlElement().InnerText()) then begin
                outIntArr[i + 1] := IntProductID;
            end;
        end;
        //No response from XMPie for this request
    end;

    local procedure ProductInventoryUpdate(ProductID: Integer; InventoryAmount: Integer): Boolean
    var
        FrontendRec: Record "PVS Web2PVS Frontend Setup";
        ResponseTxt: Text;
        URL: Text;
    begin
        FrontendRec.Get('USTORE');
        URL := StrSubstNo('%1/ProductInventoryWS.asmx/Update?username=%2&password=%3&productID=%4&inventoryAmount=%5', FrontendRec."Response URL", FrontendRec."Response Login", FrontendRec."Response Password", ProductID, InventoryAmount);
        ResponseTxt := SendWebReuest(URL);
        //No response from XMPie for this request
    end;

    local procedure CreateDeliveryWithDetailsByOrderProducts(DocumentNo: Code[50]; LineNoTxt: Text)
    var
        SalesShipmentHeader: Record "Sales Shipment Header";
        SalesShipmentLine: Record "Sales Shipment Line";
        FrontendRec: Record "PVS Web2PVS Frontend Setup";
        PVSWeb2PVSHeader: Record "PVS Web2PVS Header";
        PVSWeb2PVSLine: Record "PVS Web2PVS Line";
        Web2PVSAPI: Codeunit "PVS Web2PVS API";
        DeliveryDateTxt: Text;
        DeliveryPrice: Text;
        DeliveryServiceId: Text;
        DeliveryTrackingNo: Text;
        OrderProductID: Text;
        ResponseTxt: Text;
        URL: Text;
        ShippingAgent: Code[20];
        LineNo: Integer;
    begin
        if Evaluate(LineNo, LineNoTxt) then;

        if not SalesShipmentLine.Get(DocumentNo, LineNo) then
            exit;

        if SalesShipmentLine.Quantity = 0 then
            exit;

        PVSWeb2PVSHeader.Reset();
        PVSWeb2PVSHeader.SetRange("Sales Order No.", SalesShipmentLine."Order No.");
        if PVSWeb2PVSHeader.FindFirst() then;

        PVSWeb2PVSLine.Reset();
        PVSWeb2PVSLine.SetRange("Header No.", PVSWeb2PVSHeader."No.");
        PVSWeb2PVSLine.SetRange("Line No.", SalesShipmentLine."Order Line No.");
        if PVSWeb2PVSLine.FindFirst() then;

        OrderProductID := Format(PVSWeb2PVSLine."External Line ID");
        DeliveryDateTxt := Format(SalesShipmentLine."Shipment Date", 9);
        DeliveryTrackingNo := 'DUMMY_NO';
        if SalesShipmentHeader.Get(SalesShipmentLine."Document No.") then;
        ShippingAgent := SalesShipmentHeader."Shipping Agent Service Code";
        Web2PVSAPI.ConvertFieldData(This_FrontendID(), 5790, false, ShippingAgent, ShippingAgent);
        DeliveryServiceId := ShippingAgent;
        DeliveryPrice := '0';

        DeliveryDateTxt := Format(SalesShipmentLine."Shipment Date", 0, '<Month,2>/<Day,2>/<Year>');

        FrontendRec.Get('USTORE');
        URL :=
          StrSubstNo('%1/actualdeliveryWS.asmx/CreateDeliveryWithDetailsByOrderProducts?username=%2&password=%3&orderProductIds=%4&deliveryDatetime=%5&trackingNumber=%6&deliveryPrice=%7&deliveryServiceID=%8',
            FrontendRec."Response URL", FrontendRec."Response Login", FrontendRec."Response Password", OrderProductID, DeliveryDateTxt, DeliveryTrackingNo, DeliveryPrice, DeliveryServiceId);

        ResponseTxt := SendWebReuest(URL);
    end;

    local procedure SendWebReuest(URL: Text): Text
    var
        RequestMessage: HttpRequestMessage;
        ResponseMessage: HttpResponseMessage;
        Headers: HttpHeaders;
        Content: HttpContent;
        InStr: InStream;
        MyHTTPClient: HttpClient;
        ContentTxt: Text;
        ContentLineTxt: Text;
        ErrText01: Label '%1 , %2', Locked = true;
    begin
        RequestMessage.SetRequestUri(URL);
        RequestMessage.Method('GET');
        Headers.Remove('Content-Type');
        Headers.Add('Content-Type', 'text/xml; charset=utf-8');
        RequestMessage.Content := Content;
        if MyHTTPClient.send(RequestMessage, ResponseMessage) then;
        if not ResponseMessage.IsSuccessStatusCode then
            error(ErrText01, ResponseMessage.HttpStatusCode, ResponseMessage.ReasonPhrase);
        if ResponseMessage.IsSuccessStatusCode then begin
            ResponseMessage.Content.ReadAs(InStr);
            while not InStr.EOS do begin
                InStr.ReadText(ContentLineTxt);
                ContentTxt := ContentTxt + ContentLineTxt;
            end;
            exit(ContentTxt);
        end;


    end;

    local procedure "----Functions----"()
    begin
    end;

    local procedure GetFld_Text(var XMLNode: XmlNode; Tag: Text; var Out_Field: Text) Result: Boolean
    begin
        Out_Field := CopyStr(XMLFindNodeTextNS(XMLNode, Tag), 1, MaxStrLen(Out_Field));
    end;

    local procedure GetFld_Code(var XMLNode: XmlNode; Tag: Text; var Out_Field: Code[1024])
    begin
        Out_Field := CopyStr(XMLFindNodeTextNS(XMLNode, Tag), 1, MaxStrLen(Out_Field));
    end;

    local procedure GetFld_Date(var XMLNode: XmlNode; Tag: Text; var Out_Field: Date) Result: Boolean
    var
        Txt: Text;
    begin
        Txt := XMLFindNodeTextNS(XMLNode, Tag);
        Out_Field := Text2Date(Txt);
    end;

    local procedure GetFld_Int(var XMLNode: XmlNode; Tag: Text; var Out_Field: Integer) Result: Boolean
    var
        Txt: Text;
    begin
        Out_Field := 0;
        Txt := XMLFindNodeTextNS(XMLNode, Tag);
        Out_Field := Text2Int(Txt);
    end;

    local procedure GetFld_Dec(var XMLNode: XmlNode; Tag: Text; var Out_Field: Decimal) Result: Boolean
    var
        Txt: Text;
    begin
        Txt := XMLFindNodeTextNS(XMLNode, Tag);
        Out_Field := Text2Dec(Txt);
    end;

    local procedure GetFldAttr_Text(var XMLNode: XmlNode; Tag: Text; var Out_Field: Text) Result: Boolean
    var
        Txt: Text;
    begin
        Txt := XMLGetAttribute(Tag, XMLNode);
        //Out_Field := COPYSTR(XMLFindNodeTextNS(XMLNode,Tag),1,MAXSTRLEN(Txt));
        Out_Field := CopyStr(Txt, 1, MaxStrLen(Out_Field));
    end;

    procedure GetFldAttr_Code(var XMLNode: XmlNode; Tag: Text; var Out_Field: Code[100]) Result: Boolean
    var
        Txt: Text;
    begin
        Txt := XMLGetAttribute(Tag, XMLNode);
        Out_Field := CopyStr(XMLFindNodeTextNS(XMLNode, Tag), 1, MaxStrLen(Txt));
    end;

    procedure GetFldAttr_Int(var XMLNode: XmlNode; Tag: Text; var Out_Field: Integer) Result: Boolean
    var
        Txt: Text;
    begin
        Txt := XMLGetAttribute(Tag, XMLNode);
        Out_Field := Text2Int(Txt);
    end;

    procedure GetFldAttr_Dec(var XMLNode: XmlNode; Tag: Text; var Out_Field: Decimal) Result: Boolean
    var
        Txt: Text;
    begin
        Txt := XMLGetAttribute(Tag, XMLNode);
        Out_Field := Text2Dec(Txt);
    end;

    local procedure xmlSetTxt(var XMLNode: XmlNode; NodePath: Text[1024]; var ToField: Text[1024]) Result: Boolean
    var
        FoundNode: XmlNode;
    begin
        if not xml_FindNode(XMLNode, NodePath, FoundNode) then
            exit(false);

        SetTxt(ToField, FoundNode.AsXmlElement().InnerText);
        exit(true);
    end;

    local procedure xmlSetCde(var XMLNode: XmlNode; NodePath: Text[1024]; var ToField: Code[1024]) Result: Boolean
    var
        FoundNode: XmlNode;
    begin
        if not xml_FindNode(XMLNode, NodePath, FoundNode) then
            exit(false);

        SetCde(ToField, FoundNode.AsXmlElement().InnerText);
        exit(true);
    end;

    local procedure xmlSetDat(var XMLNode: XmlNode; NodePath: Text[1024]; var ToField: Date) Result: Boolean
    var
        FoundNode: XmlNode;
    begin
        if not xml_FindNode(XMLNode, NodePath, FoundNode) then
            exit(false);

        SetDat(ToField, FoundNode.AsXmlElement().InnerText);
        exit(true);
    end;

    local procedure xmlSetDec(var XMLNode: XmlNode; NodePath: Text[1024]; var ToField: Decimal) Result: Boolean
    var
        FoundNode: XmlNode;
    begin
        if not xml_FindNode(XMLNode, NodePath, FoundNode) then
            exit(false);

        SetDec(ToField, FoundNode.AsXmlElement().InnerText);
        exit(true);
    end;

    local procedure xmlSetInt(var XMLNode: XmlNode; NodePath: Text[1024]; var ToField: Integer) Result: Boolean
    var
        FoundNode: XmlNode;
    begin
        if not xml_FindNode(XMLNode, NodePath, FoundNode) then
            exit(false);

        SetInt(ToField, FoundNode.AsXmlElement().InnerText);
        exit(true);
    end;

    local procedure XMLFindNode(var InNode: XmlNode; Tag: Text; var OutNode: XmlNode): Boolean
    begin
        exit(PVSXMLDomMgt.FindNode(InNode, tag, OutNode));
    end;

    local procedure XMLFindNodeTextNS(var RootNode: XmlNode; Tag: Text): Text
    begin
        exit(PVSXMLDomMgt.FindNodeTextNs(RootNode, NameSpacePrefix + Tag, NSMgr));
    end;

    local procedure XMLGetAttribute(inAttributeName: Text[1024]; var inNode: XmlNode): Text
    begin
        exit(PVSXMLDomMgt.GetAttributeValue(inNode, inAttributeName));
    end;


    procedure Text2Int(inText: Text) retInt: Integer
    begin
        if Evaluate(retInt, inText) then;
    end;

    local procedure Text2Dec(inText: Text) retDec: Decimal
    begin
        if StrPos(Format(1 / 2), '.') > 0 then begin
            if Evaluate(retDec, ConvertStr(inText, ',', '.')) then;
        end else begin
            if Evaluate(retDec, ConvertStr(inText, '.', ',')) then;
        end;
    end;

    local procedure Text2Date(inText: Text): Date
    var
        Web2PVSXMLGateway: Codeunit "PVS Web2PVS XML Gateway";
    begin
        exit(Web2PVSXMLGateway.Text2Date(inText));
    end;

    local procedure xml_FindNode(XMLRootNode: XmlNode; NodePath: Text[250]; var FoundXMLNode: XmlNode): Boolean
    begin
        exit(PVSXMLDomMgt.FindNode(XMLRootNode, NodePath, FoundXMLNode));
    end;

    local procedure SetTxt(var in_To: Text[1024]; in_From: Text[1024])
    begin
        in_To := CopyStr(in_From, 1, MaxStrLen(in_To));
    end;

    local procedure SetCde(var in_To: Code[1024]; in_From: Text[1024])
    begin
        in_To := CopyStr(in_From, 1, MaxStrLen(in_To));
    end;

    local procedure SetDat(var in_To: Date; in_From: Text[1024])
    begin
        if in_From = '' then
            in_To := 0D;
    end;

    local procedure SetDec(var in_To: Decimal; in_From: Text[1024])
    begin
        if in_From = '' then
            in_To := 0;

        if Evaluate(in_To, in_From) then;
    end;

    local procedure SetInt(var in_To: Integer; in_From: Text[1024])
    begin
        if in_From = '' then
            in_To := 0;

        if Evaluate(in_To, in_From) then;
    end;

    procedure ReplaceString(in_String: Text; in_FindWhat: Text; in_ReplaceWith: Text): Text
    begin
        while StrPos(in_String, in_FindWhat) > 0 do
            in_String := DelStr(in_String, StrPos(in_String, in_FindWhat)) + in_ReplaceWith + CopyStr(in_String, StrPos(in_String, in_FindWhat) + StrLen(in_FindWhat));
        exit(in_String);
    end;

    local procedure "---Events---"()
    begin
    end;

    procedure removeNameSpace(XMLtxt: text) outXMLtxt: text
    var
        XMLDomMGt: Codeunit "XML DOM Management";
    begin
        exit(XMLDomMGt.RemoveNamespaces(XMLtxt));
    end;
}



