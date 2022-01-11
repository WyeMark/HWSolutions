// Adds Web Order No. to the Sales order list
pageextension 50126 SalesOrderListExt extends "Sales Order List"
{
    layout
    {
        addafter("Sell-to Customer Name")
        {
            field("PVS Web Order No."; REC."PVS Web Order No.")
            {
                ApplicationArea = All;
            }
        }
    }
}