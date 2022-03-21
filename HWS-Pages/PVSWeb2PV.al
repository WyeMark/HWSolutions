pageextension 50110 RemoveErrors extends "PVS Web2PVS Outbound Event Log"
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
    actions
    {
        addlast(processing)
        {
            action(Remove)
            {
                ApplicationArea = all;
                Image = Delete;
                trigger OnAction()
                begin
                    Rec.Delete();
                end;
            }
        }
    }


}