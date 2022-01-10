reportextension 50121 "PTE PickList Extension" extends "Picking List by Order"
{
    dataset
    {
        add("Sales Header")
        {
            column(PVS_Web_Order_No_; "PVS Web Order No.")
            { }
            column(Your_Reference; "Your Reference")
            { }
        }
    }
}