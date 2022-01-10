// Welcome to your new AL extension.
// Remember that object names and IDs should be unique across all extensions.
// AL snippets start with t*, like tpageext - give them a try and happy coding!

pageextension 50120 SalesOrderExt extends "Sales Order"
{
    layout
    {
        addafter("Your Reference")
        {
            field("PVS Web Order No."; REC."PVS Web Order No.")
            {
                ApplicationArea = All;
            }
        }
        addbefore("Shortcut Dimension 1 Code")
        {
            field("Clearing Type"; Rec."Clearing Type")
            {
                ApplicationArea = All;
            }
            field("Clearing Value"; rec."Clearing Value")
            {
                ApplicationArea = All;
            }
        }
    }
}