codeunit 50135 "PTE Copy Management"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"PVS Copy Management", 'OnafterCopyCaseHead', '', false, false)]
    local procedure OnafterCopyCaseHead(var CaseRec_To: Record "PVS Case"; var CaseRec_From: Record "PVS Case");
    begin
        CaseRec_To."Case Description" := CaseRec_From."Case Description";
    end;


}