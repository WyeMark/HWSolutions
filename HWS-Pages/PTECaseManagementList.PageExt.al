pageextension 50134 "PTE Case Management list" extends "PVS Case Management"
{
    layout
    {
        addafter(JobName)
        {
            field("Job Description"; Rec."Case Description")
            {
                ApplicationArea = All;
            }
        }
        addafter(SellToName)
        {
            field("Quoted Price"; Rec.Quoted_SalesPrice)
            {
                ApplicationArea = All;
            }
            field("Quantity"; Rec.Current_Job_Quantity)
            {
                ApplicationArea = All;
            }
        }

    }
}