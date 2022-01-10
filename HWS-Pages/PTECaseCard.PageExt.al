pageextension 50133 "PTE Case Card" extends "PVS Case Card"
{
    layout
    {
        addafter(JobName)
        {
            field("Job Description"; Rec."Case Description")
            {
                ApplicationArea = All;
                MultiLine = true;
            }
        }
    }
}