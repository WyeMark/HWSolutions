pageextension 50127 "PTE Web2PV OB LOG" extends "PVS Web2PVS Outbound Event Log"
{
    layout
    {
        addafter(FrontendSubmissionErrorText)
        {
            field("External ID 1"; Rec."External ID 1")
            {
                ApplicationArea = All;
            }
            field("External ID 2"; Rec."External ID 2")
            {
                ApplicationArea = All;

            }
            field("External ID 3"; Rec."External ID 3")
            {
                ApplicationArea = ALL;
            }
        }
    }
}