//Extends the Item Card to make the Desc. 2 and the No. 2 Fields Visible
//MCA - 3/7/2022
pageextension 50128 "PTEItemCard-50128-PageExt" extends "Item Card"
{
    layout
    {
        addafter(Description)
        {
            field("Description 293768"; Rec."Description 2")
            {
                ApplicationArea = All;
            }
        }
        addafter("No.")
        {
            field("No. 277695"; Rec."No. 2")
            {
                ApplicationArea = All;
            }
        }
    }
}
