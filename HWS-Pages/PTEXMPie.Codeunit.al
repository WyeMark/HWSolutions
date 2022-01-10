codeunit 50131 "PTE XMPie"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"PVS Web2PVS Frontend XMPie", 'OnBeforeMETHODProcessplaceOrder', '', false, false)]
    local procedure OnBeforeMETHODProcessplaceOrder(var in_LogRec: Record "PVS Web2PVS Inbound Event Log"; var ErrorText: Text; var IsHandled: Boolean);
    var
        PTEXMPieMgt: Codeunit "PTE XMPie Mgt";
    begin
        ErrorText := PTEXMPieMgt.METHOD_Process_placeOrder(in_LogRec);
        IsHandled := true;
    end;

}
