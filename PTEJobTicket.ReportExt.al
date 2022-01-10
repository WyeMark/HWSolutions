reportextension 50101 "PTE Job Ticket Ext" extends "H&W Job Ticket"
{
    dataset
    {
        add(OrderRec)
        {
            column(CaseDescription; "Case Description")
            { }
        }
    }

}