// Adds Web Order No. to the Sales order list
//Also adds Order Date to the list
//MCA - 3/7/2022
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
        addafter("Assigned User ID")
        {
            field("Order Date28480"; Rec."Order Date")
            {
                ApplicationArea = All;
            }
        }
    }
}