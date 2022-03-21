/* Working to add the Case Description field to the Estimating Report
reportextension 50120 "PTE Estimating Report" extends 6010300
{
    dataset
    {
        add(PVS_Case_ID)
        {
            column("Case Description"; "Case Description")
            { }
        }
    }
} */
