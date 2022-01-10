tableextension 50133 "PTE SalesHeader" extends "Sales Header"
{
    fields
    {
        field(50010; "Clearing Type"; Text[50]) { DataClassification = ToBeClassified; }
        field(50011; "Clearing Value"; Text[50]) { DataClassification = ToBeClassified; }

    }



}