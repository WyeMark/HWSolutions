pageextension 50121 PageExtension50121 extends "PVS Shipment List"
{
    layout
    {
        //Changes the caption for County to State to match US definitions
        modify(County)
        {
            caption = 'State';
        }
    }
}