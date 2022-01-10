report 50000 "H&W Formula Report"
{
    Caption = 'H&W PV Sample Formula Report';
    ProcessingOnly = true;
    ShowPrintStatus = false;
    UseRequestPage = false;
    UsageCategory = Tasks;
    ApplicationArea = All;

    dataset
    {
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    var
        f: Integer;
        i: Integer;
        j: Integer;
    begin
        SingleInstance.Get_Current_CalcUnitDetailRec(CalcUnitDetailRec); // Get the Current Calc. Detail record

        // only use this if needed - this can take performance if formula is called many times
        // SingleInstance.Get_CalcUnitDetailsRecTmp(CalcUnitDetailRecTMP); // Maybe get all the Calc. Detail records if needed
        //SingleInstance.Get_SheetRecTmp(SheetRecTMP); // Use this if you need information from the sheet
        //SingleInstance.Get_ProcessRecTmp(ProcessRecTMP); // Use this if you need information from the process
        ////SingleInstance.Get_JobItemRecTmp(JobItemRecTMP);

        CalcUnitDetailRec."Qty. Calculated" := 0; // Clear the field to be calculated

        // If the same report if used for multible formulas:

        case CalcUnitDetailRec."Formula Code" of
            1282:
                Formula_1282;
            1700:
                Formula_1700;
            1840:
                Formula_1840;
            1845:
                Formula_1845;
            1850:
                Formula_1850;
            1855:
                Formula_1855;
            1860:
                Formula_1860;
            1865:
                Formula_1865;
            1870:
                Formula_1870;
            1875:
                Formula_1875;
            1880:
                Formula_1880;
            1885:
                Formula_1885;
            1890:
                Formula_1890;
            1970:
                Formula_1970;
            2650:
                Formula_2650; // 81260
            2651:
                Formula_2651; // 81260
        end;

        SingleInstance.Set_Current_CalcUnitDetailRec(CalcUnitDetailRec); // Push back the result
    end;

    var
        SingleInstance: Codeunit "PVS SingleInstance";
        CalcUnitDetailRec: Record "PVS Job Calculation Detail";
        CalcUnitDetailRecTMP: Record "PVS Calc. Unit Setup Detail" temporary;
        SheetRecTMP: Record "PVS Job Sheet" temporary;
        ProcessRecTMP: Record "PVS Job Process" temporary;
        CacheMgt: Codeunit "PVS Cache Management";
        JobItemRec: Record "PVS Job Item";

    procedure Formula_1282()
    var
        PaperItemRec: Record Item;
    begin
        SingleInstance.Get_SheetRecTmp(SheetRecTMP); // Use this if you need information from the sheet
        LoadJobItem;
        if not SheetRecTMP.GET(CalcUnitDetailRec."Sheet ID") then
            exit;

        if not PaperItemRec.Get(SheetRecTMP."Paper Item No.") then
            exit;

        if PaperItemRec."PVS Thickness" = 0 then
            exit;

        CalcUnitDetailRec."Qty. Calculated" := PaperItemRec."PVS Thickness"; // Assign value
    end;

    procedure Formula_1700()
    var
        PaperItemRec: Record Item;
    begin
        SingleInstance.Get_SheetRecTmp(SheetRecTMP); // Use this if you need information from the sheet
        ////SingleInstance.Get_JobItemRecTmp(JobItemRecTMP);
        if not SheetRecTMP.GET(CalcUnitDetailRec."Sheet ID") then
            exit;

        if not PaperItemRec.Get(SheetRecTMP."Paper Item No.") then
            exit;

        CalcUnitDetailRec."Qty. Calculated" := 1;

        if PaperItemRec."PVS Grade" = PaperItemRec."PVS Grade"::"Uncoated - white paper" then
            CalcUnitDetailRec."Qty. Calculated" := 1.6;

        if PaperItemRec."PVS Grade" = PaperItemRec."PVS Grade"::"Uncoated - yellowish paper" then
            CalcUnitDetailRec."Qty. Calculated" := 1.6;
    end;

    procedure Formula_1970()
    var
        JobRec: Record "PVS Job";
        PaperItemRec: Record Item;
        DecValue: Decimal;
        DecQuantity: Decimal;
        DecLengthFinalFormat: Decimal;
        DecGutterFromJobItem: Decimal;
        DecWidthFinalFormat: Decimal;
    begin


        SingleInstance.Get_SheetRecTmp(SheetRecTMP); // Use this if you need information from the sheet
        ////SingleInstance.Get_JobItemRecTmp(JobItemRecTMP);
        LoadJobItem;

        // Quantity x ( Length Sheet Format * Width Sheet Format / "Print width/ReelWidth(Field25")/144 (=SqInch to Sqft)

        if not SheetRecTMP.GET(CalcUnitDetailRec."Sheet ID") then
            exit;

        if not PaperItemRec.Get(SheetRecTMP."Paper Item No.") then
            exit;

        if JobRec.GET(CalcUnitDetailRec.ID, CalcUnitDetailRec.Job, CalcUnitDetailRec.Version) then
            //  DecQuantity := JobRec.Quantity; // Assign value
            DecQuantity := SheetRecTMP."Gross Printed Sheets"; // Assign value

        //NVS-Dak, Sept. 12 2017 ... change to find size of final format instead
        DecLengthFinalFormat := PaperItemRec."PVS Format 1";
        //DecLengthFinalFormat := JobItemRec.UnCutDepth();

        DecWidthFinalFormat := PaperItemRec."PVS Format 2";
        //DecWidthFinalFormat := JobItemRec.Width;
        // End (Sept. 12 2017)

        DecValue := DecQuantity * (DecLengthFinalFormat * DecWidthFinalFormat / SheetRecTMP."Print Sheet") / 144;

        CalcUnitDetailRec."Qty. Calculated" := DecValue;
        CalcUnitDetailRec."Item No." := PaperItemRec."No.";
    end;

    procedure Formula_1000()
    var
        JobRec: Record "PVS Job";
    begin
        // Find the job quantity (same result as formula 1)

        if JobRec.GET(CalcUnitDetailRec.ID, CalcUnitDetailRec.Job, CalcUnitDetailRec.Version) then
            CalcUnitDetailRec."Qty. Calculated" := JobRec.Quantity; // Assign value
    end;

    procedure Formula_1001()
    begin
        // Find the sum of quantity of all calculationlines with 'PV' in "Formula Class"
        // (could be done by setup of af formula of the type "Lookup")

        CalcUnitDetailRecTMP.SETFILTER("Formula Class", 'XX');
        if CalcUnitDetailRecTMP.FINDSET then
            repeat
                CalcUnitDetailRec."Qty. Calculated" := CalcUnitDetailRec."Qty. Calculated" + CalcUnitDetailRecTMP.Quantity;
            until CalcUnitDetailRecTMP.NEXT = 0;
    end;

    procedure Formula_1002()
    var
        UnitConversion: Codeunit "PVS Unit Conversion";
        CalcMgt: Codeunit "PVS Formula Management";
        Local_JobRec: Record "PVS Job";
        Dummy_PriceUnit: Record "PVS Job Calculation Unit";
        PaperItemRec: Record Item;
        Quantity_Result: Decimal;
        Factor: Decimal;
    begin
        // This formula will work as a combination of formula 14, 240, 250 and 260
        // The item no. on the calc. line will be changed to the paper no. from the sheet
        // depending on the price unit on the paper, the quantity will be calculated in either pcs, weight etc.
        // The example also shows how the value of a standard formula to be retrieved

        if not SheetRecTMP.GET(CalcUnitDetailRec."Sheet ID") then
            exit;

        if not PaperItemRec.Get(SheetRecTMP."Paper Item No.") then
            exit;

        if not ProcessRecTMP.GET(SheetRecTMP."First Process ID") then
            exit;

        // This will change the item no. on the calc. line
        CalcUnitDetailRec."Item No." := PaperItemRec."No.";

        // This will get the result of formula 16 (amount of paper - same as formula 14 but without changing the item no.)
        if not CalcMgt.Standard_Formula_Rutine(16, CalcUnitDetailRec, Dummy_PriceUnit, Local_JobRec, SheetRecTMP, ProcessRecTMP, false) then
            exit;

        Quantity_Result := CalcUnitDetailRec."Qty. Calculated";

        // Now the amount is transformed into weight, area or lenght

        case PaperItemRec."PVS Price Unit" of
            2:
                begin
                    // Weight of paper with scrap
                    // Calculate Area
                    Quantity_Result := SheetRecTMP."Full Sheet Format 1" * SheetRecTMP."Full Sheet Format 2" * Quantity_Result;

                    // Transform from area to weight
                    Factor :=
                      UnitConversion.Weight2SqFormat(SheetRecTMP.Weight, SheetRecTMP."Weight Unit", SheetRecTMP."Full Sheet Format 1", SheetRecTMP."Full Sheet Format 2");
                    if Factor = 0 then
                        Quantity_Result := 0
                    else
                        Quantity_Result := Quantity_Result / Factor;
                end;

            3:
                // Area of paper with scrap
                // Calculate Area
                Quantity_Result := SheetRecTMP."Full Sheet Format 1" * SheetRecTMP."Full Sheet Format 2" * Quantity_Result;
            4:
                // Lenght of paper with scrap
                Quantity_Result := SheetRecTMP."Print Sheet" * SheetRecTMP."Full Sheet Depth" / UnitConversion.Lenght2Format * Quantity_Result;
        end;

        CalcUnitDetailRec."Qty. Calculated" := Quantity_Result;

        // This will change the unit on the calc. line IF the unit on the user formula is set to "Custom"
        CalcUnitDetailRec.Unit := PaperItemRec."PVS Price Unit";
    end;

    local procedure Formula_1840()
    begin
        SingleInstance.Get_SheetRecTmp(SheetRecTMP); // Use this if you need information from the sheet
        ////SingleInstance.Get_JobItemRecTmp(JobItemRecTMP);
        CalcUnitDetailRec."Qty. Calculated" := 0;

        LoadJobItem;
        if JobItemRec.FINDSET then
            repeat
                if ((GetDepth(JobItemRec.Width, JobItemRec.UnCutDepth()) > 36) or (GetWidth(JobItemRec.Width, JobItemRec.UnCutDepth()) > 24)) then
                    CalcUnitDetailRec."Qty. Calculated" += Round(GetCaliper / 4, 1, '>');
            until JobItemRec.NEXT = 0;
    end;

    local procedure Formula_1845()
    begin
        SingleInstance.Get_SheetRecTmp(SheetRecTMP); // Use this if you need information from the sheet
        ////SingleInstance.Get_JobItemRecTmp(JobItemRecTMP);
        CalcUnitDetailRec."Qty. Calculated" := 0;

        LoadJobItem;
        if JobItemRec.FINDSET then
            repeat
                if ((GetDepth(JobItemRec.Width, JobItemRec.UnCutDepth()) > 30) and (GetWidth(JobItemRec.Width, JobItemRec.UnCutDepth()) <= 24)) and
                   ((GetDepth(JobItemRec.Width, JobItemRec.UnCutDepth()) <= 36) and (GetWidth(JobItemRec.Width, JobItemRec.UnCutDepth()) <= 24)) then
                    CalcUnitDetailRec."Qty. Calculated" += Round(GetCaliper / 4, 1, '>');
            until JobItemRec.NEXT = 0;
    end;

    local procedure Formula_1850()
    begin
        SingleInstance.Get_SheetRecTmp(SheetRecTMP); // Use this if you need information from the sheet
        //SingleInstance.Get_JobItemRecTmp(JobItemRecTMP);
        CalcUnitDetailRec."Qty. Calculated" := 0;

        LoadJobItem;
        if JobItemRec.FINDSET then
            repeat
                if ((GetDepth(JobItemRec.Width, JobItemRec.UnCutDepth()) > 24) and (GetWidth(JobItemRec.Width, JobItemRec.UnCutDepth()) <= 24)) and
                   ((GetDepth(JobItemRec.Width, JobItemRec.UnCutDepth()) <= 30) and (GetWidth(JobItemRec.Width, JobItemRec.UnCutDepth()) <= 24)) then
                    CalcUnitDetailRec."Qty. Calculated" := Round(GetCaliper / 4, 1, '>');
            until JobItemRec.NEXT = 0
    end;

    local procedure Formula_1855()
    begin
        SingleInstance.Get_SheetRecTmp(SheetRecTMP); // Use this if you need information from the sheet
        //SingleInstance.Get_JobItemRecTmp(JobItemRecTMP);
        CalcUnitDetailRec."Qty. Calculated" := 0;

        LoadJobItem;
        if JobItemRec.FINDSET then
            repeat
                if ((GetDepth(JobItemRec.Width, JobItemRec.UnCutDepth()) > 17.25) and (GetWidth(JobItemRec.Width, JobItemRec.UnCutDepth()) > 11.25)) and
                   ((GetDepth(JobItemRec.Width, JobItemRec.UnCutDepth()) <= 24) and (GetWidth(JobItemRec.Width, JobItemRec.UnCutDepth()) <= 24)) then
                    CalcUnitDetailRec."Qty. Calculated" := Round(GetCaliper / 4, 1, '>');
            until JobItemRec.NEXT = 0
    end;

    local procedure Formula_1860()
    begin
        SingleInstance.Get_SheetRecTmp(SheetRecTMP); // Use this if you need information from the sheet
        //SingleInstance.Get_JobItemRecTmp(JobItemRecTMP);
        CalcUnitDetailRec."Qty. Calculated" := 0;

        LoadJobItem;
        if JobItemRec.FINDSET then
            repeat
                if ((GetDepth(JobItemRec.Width, JobItemRec.UnCutDepth()) > 12) and (GetWidth(JobItemRec.Width, JobItemRec.UnCutDepth()) <= 11.25)) and
                   ((GetDepth(JobItemRec.Width, JobItemRec.UnCutDepth()) <= 17.25) and (GetWidth(JobItemRec.Width, JobItemRec.UnCutDepth()) <= 11.25)) then
                    CalcUnitDetailRec."Qty. Calculated" := Round(GetCaliper / 10, 1, '>');
            until JobItemRec.NEXT = 0
    end;

    local procedure Formula_1865()
    begin
        SingleInstance.Get_SheetRecTmp(SheetRecTMP); // Use this if you need information from the sheet
        //SingleInstance.Get_JobItemRecTmp(JobItemRecTMP);
        CalcUnitDetailRec."Qty. Calculated" := 0;

        LoadJobItem;
        if JobItemRec.FINDSET then
            repeat
                if ((GetDepth(JobItemRec.Width, JobItemRec.UnCutDepth()) > 9.25) and (GetWidth(JobItemRec.Width, JobItemRec.UnCutDepth()) > 9.25)) and
                   ((GetDepth(JobItemRec.Width, JobItemRec.UnCutDepth()) <= 12) and (GetWidth(JobItemRec.Width, JobItemRec.UnCutDepth()) <= 12)) then
                    CalcUnitDetailRec."Qty. Calculated" := Round(GetCaliper / 10, 1, '>');
            until JobItemRec.NEXT = 0
    end;

    local procedure Formula_1870()
    begin
        SingleInstance.Get_SheetRecTmp(SheetRecTMP); // Use this if you need information from the sheet
        //SingleInstance.Get_JobItemRecTmp(JobItemRecTMP);
        CalcUnitDetailRec."Qty. Calculated" := 0;

        LoadJobItem;
        if JobItemRec.FINDSET then
            repeat
                if ((GetDepth(JobItemRec.Width, JobItemRec.UnCutDepth()) <= 12.25) and (GetWidth(JobItemRec.Width, JobItemRec.UnCutDepth()) > 8.75)) and
                   ((GetDepth(JobItemRec.Width, JobItemRec.UnCutDepth()) <= 12.25) and (GetWidth(JobItemRec.Width, JobItemRec.UnCutDepth()) <= 9.25)) then
                    CalcUnitDetailRec."Qty. Calculated" := Round(GetCaliper / 12, 1, '>');
            until JobItemRec.NEXT = 0
    end;

    local procedure Formula_1875()
    begin
        SingleInstance.Get_SheetRecTmp(SheetRecTMP); // Use this if you need information from the sheet
        //SingleInstance.Get_JobItemRecTmp(JobItemRecTMP);
        CalcUnitDetailRec."Qty. Calculated" := 0;

        LoadJobItem;
        if JobItemRec.FINDSET then
            repeat
                if ((GetDepth(JobItemRec.Width, JobItemRec.UnCutDepth()) <= 11.25) and (GetWidth(JobItemRec.Width, JobItemRec.UnCutDepth()) <= 8.75)) then
                    if (JobItemRec.UnCutDepth() * JobItemRec.Width) <> 0 then
                        if Round(GetCaliper / (93.5 / (JobItemRec.UnCutDepth() * JobItemRec.Width)), 1, '<') <= 2.75 then
                            CalcUnitDetailRec."Qty. Calculated" := 1;
            until JobItemRec.NEXT = 0
    end;

    local procedure Formula_1880()
    begin
        SingleInstance.Get_SheetRecTmp(SheetRecTMP); // Use this if you need information from the sheet
        //SingleInstance.Get_JobItemRecTmp(JobItemRecTMP);
        CalcUnitDetailRec."Qty. Calculated" := 0;

        LoadJobItem;
        if JobItemRec.FINDSET then
            repeat
                if ((GetDepth(JobItemRec.Width, JobItemRec.UnCutDepth()) <= 11.25) and (GetWidth(JobItemRec.Width, JobItemRec.UnCutDepth()) <= 8.75)) then
                    if (JobItemRec.UnCutDepth() * JobItemRec.Width) <> 0 then
                        if (Round(GetCaliper / (93.5 / (JobItemRec.UnCutDepth() * JobItemRec.Width)), 1, '<') > 2.75) and (Round(GetCaliper / (93.5 / (JobItemRec.UnCutDepth() * JobItemRec.Width)), 1, '<') <= 4) then
                            CalcUnitDetailRec."Qty. Calculated" := 1;
            until JobItemRec.NEXT = 0
    end;

    local procedure Formula_1885()
    begin
        SingleInstance.Get_SheetRecTmp(SheetRecTMP); // Use this if you need information from the sheet
        //SingleInstance.Get_JobItemRecTmp(JobItemRecTMP);
        CalcUnitDetailRec."Qty. Calculated" := 0;

        LoadJobItem;
        if JobItemRec.FINDSET then
            repeat
                if ((GetDepth(JobItemRec.Width, JobItemRec.UnCutDepth()) <= 11.25) and (GetWidth(JobItemRec.Width, JobItemRec.UnCutDepth()) <= 8.75)) then
                    if (JobItemRec.UnCutDepth() * JobItemRec.Width) <> 0 then
                        if (Round(GetCaliper / (93.5 / (JobItemRec.UnCutDepth() * JobItemRec.Width)), 1, '<') > 4) and (Round(GetCaliper / (93.5 / (JobItemRec.UnCutDepth() * JobItemRec.Width)), 1, '<') <= 6) then
                            CalcUnitDetailRec."Qty. Calculated" := 1;
            until JobItemRec.NEXT = 0
    end;

    local procedure Formula_1890()
    begin
        SingleInstance.Get_SheetRecTmp(SheetRecTMP); // Use this if you need information from the sheet
        //SingleInstance.Get_JobItemRecTmp(JobItemRecTMP);
        CalcUnitDetailRec."Qty. Calculated" := 0;

        LoadJobItem;
        if JobItemRec.FINDSET then
            repeat
                if ((GetDepth(JobItemRec.Width, JobItemRec.UnCutDepth()) <= 11.25) and (GetWidth(JobItemRec.Width, JobItemRec.UnCutDepth()) <= 8.75)) then
                    if (JobItemRec.UnCutDepth() * JobItemRec.Width) <> 0 then
                        if (Round(GetCaliper / (93.5 / (JobItemRec.UnCutDepth() * JobItemRec.Width)), 1, '<') > 6) then
                            CalcUnitDetailRec."Qty. Calculated" := Round(GetCaliper / 10, 1, '>');
            until JobItemRec.NEXT = 0;
    end;

    local procedure Formula_2650()
    var
        Item: Record Item;
    begin
        // 81260
        SingleInstance.Get_SheetRecTmp(SheetRecTMP); // Use this if you need information from the sheet
        CalcUnitDetailRec."Qty. Calculated" := 0;

        if SheetRecTMP."Paper Item No." = '' then
            exit;

        Item.Get(SheetRecTMP."Paper Item No.");
        case Item."PVS Item Quality Code" of
            'APPWHT':
                CalcUnitDetailRec."Qty. Calculated" := 1;
            'APPCOL':
                CalcUnitDetailRec."Qty. Calculated" := 2;
        end;
    end;

    local procedure Formula_2651()
    var
        Item: Record Item;
    begin
        // 81260
        SingleInstance.Get_SheetRecTmp(SheetRecTMP); // Use this if you need information from the sheet
        CalcUnitDetailRec."Qty. Calculated" := 0;

        if SheetRecTMP."Paper Item No." = '' then
            exit;

        Item.Get(SheetRecTMP."Paper Item No.");
        if Item."PVS Item Quality Code" in ['NYLON', 'MESH'] then
            CalcUnitDetailRec."Qty. Calculated" := 1;
    end;

    local procedure GetCaliper() outDec: Decimal
    var
        JobRec: Record "PVS Job";
        DecQuantity: Decimal;
    begin

        if JobRec.GET(CalcUnitDetailRec.ID, CalcUnitDetailRec.Job, CalcUnitDetailRec.Version) then
            DecQuantity := JobRec.Quantity; // Assign value

        outDec := DecQuantity * JobItemRec."No. of leaves" * JobItemRec."Qty. in block" * (SheetRecTMP.Thickness * 1.02);
        exit(outDec);
    end;

    local procedure GetDepth(Width: Decimal; Depth: Decimal): Decimal
    begin
        if Width > Depth then //Width is higher
            exit(Width)
        else
            exit(Depth);
    end;

    local procedure GetWidth(Width: Decimal; Depth: Decimal): Decimal
    begin
        if Width < Depth then //Width is smallest
            exit(Width)
        else
            exit(Depth);
    end;

    local procedure LoadJobItem()
    begin
        JobItemRec.RESET;
        JobItemRec.SETRANGE(ID, CalcUnitDetailRec.ID);
        JobItemRec.SETRANGE(Job, CalcUnitDetailRec.Job);
        JobItemRec.SETRANGE(Version, CalcUnitDetailRec.Version);
        if JobItemRec.FINDSET(false, false) then;
    end;
}

