//Extends the Item List to make the Desc. 2 and the No. 2 Fields Visible
//MCA - 3/7/2022
pageextension 50129 "PTEItemLis-50129-PageExt" extends "Item List"
{
    layout
    {
        addafter("No.")
        {
            field("No. 220874"; Rec."No. 2")
            {
                ApplicationArea = All;
            }
        }
        addafter(Description)
        {
            field("Description 203004"; Rec."Description 2")
            {
                ApplicationArea = All;
            }
        }
        addbefore("Substitutes Exist")
        {
            field("Qty. on Assembly Order"; Rec."Qty. on Assembly Order")
            {
                ApplicationArea = All;
            }
            field("Qty. On Asm Component";Rec."Qty. on Asm. Component")
            {
                ApplicationArea = All;
            }
        }
    }
}
