report 50019 uStoreInventory
{
    ProcessingOnly = true;
    UseRequestPage = false;
    UsageCategory = Tasks;
    Caption = 'H&W uStoreInventory';
    ApplicationArea = All;

    dataset
    {
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
    }

    trigger OnPreReport()
    begin
        MakeExcel
    end;

    var
        // uStoreInventory: Page Page50025;
        P: Record "PVS Sorting Buffer" temporary;
        OK: Integer;
        ERR: Integer;
        ExcelBuffer: Record "Excel Buffer" temporary;
        mail: Codeunit Mail;
        SMTPMail: Codeunit "SMTP Mail";
        OutStr: OutStream;
        InStr: InStream;

    local procedure MakeExcel()
    var
        Mail: Codeunit Mail;
        PVUserSetup: Record "PVS User Setup";
    begin
        // uStoreInventory.BuildBuffer(P, OK, ERR);


        AddT('Item No'); //item no
        AddT('ProductID');  //Prod ID
        AddT('Store');  // store
        AddT('Item Name');  //item name
        AddT('Inventory NAV');
        AddT('On SalesOrder');
        AddT('OVERS');
        AddT('Sum NAV');
        AddT('Qty uStore');
        AddT('Diff');
        AddT('InventoryEnabled');
        AddT('Make To Order');
        AddT('Status');  //Status

        P.RESET;
        P.SETFILTER(Text2, '<>OK');
        if P.FINDSET then
            repeat
                AddExcelLine;
            until P.NEXT = 0;
        ExcelBuffer.CreateNewBook('uStore');
        ExcelBuffer.WriteSheet('-', '-', '-');
        ExcelBuffer.CloseBook;
        ExcelBuffer.SaveToStream(OutStr, true);
        CopyStream(OutStr, InStr);

        if not InStr.EOS then begin
            PVUserSetup.RESET;
            PVUserSetup.SETFILTER("Optional Field 4", 'Yes');
            if PVUserSetup.FINDSET then
                repeat
                    SendMail(PVUserSetup."E-mail");
                //MESSAGE(PVUserSetup."E-mail");
                until PVUserSetup.NEXT = 0;
        end;
    end;

    local procedure AddExcelLine()
    var
        e: Integer;
    begin

        ExcelBuffer.NewRow;
        AddT(P.PK2_Code1); //item no
        AddT(P.Text3);  //Prod ID
        AddT(P.Text4);  // store
        AddT(P.Text1);  //item name
        AddN(P.Decimal1);
        AddN(P.Decimal2);
        AddN(P.Decimal3);
        AddN(P.Decimal4);
        AddN(P.Decimal5);
        AddN(P.Decimal6);
        if P.Boolean1 then AddT('Yes') else AddT('No');
        if P.Boolean2 then AddT('Yes') else AddT('No');
        AddT(P.Text2);  //Status
    end;

    local procedure AddT(txt: Text)
    begin
        ExcelBuffer.AddColumn(txt, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
    end;

    local procedure AddN(dec: Decimal)
    begin
        ExcelBuffer.AddColumn(dec, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
    end;

    local procedure SendMail(MailTo: Text)
    var
        MailToList: List of [Text];
    begin
        MailToList.Add(MailTo);

        SMTPMail.CreateMessage('Support', 'support@hwprinting.com', MailToList, 'uStore inventory', '-');
        SMTPMail.AddAttachmentStream(InStr, 'uStoreInventory.xlsx');
        SMTPMail.Send;
    end;
}

