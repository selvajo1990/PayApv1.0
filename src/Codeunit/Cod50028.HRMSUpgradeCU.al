codeunit 50028 "HRMS Upgrade CU"
{
    Subtype = Upgrade;
    trigger OnUpgradePerDatabase()
    begin
        DataUpgradeMgtG.SetTableSyncSetup(Database::"Salary Computation Line", 0, TableUpgradeMode::Force);
    end;

    trigger OnUpgradePerCompany()
    begin
        DataUpgradeMgtG.SetTableSyncSetup(Database::"Salary Computation Line", 0, TableUpgradeMode::Force);
    end;

    trigger OnCheckPreconditionsPerDatabase()
    begin
        DataUpgradeMgtG.SetTableSyncSetup(Database::"Salary Computation Line", 0, TableUpgradeMode::Force);
    end;

    trigger OnCheckPreconditionsPerCompany()
    begin
        DataUpgradeMgtG.SetTableSyncSetup(Database::"Salary Computation Line", 0, TableUpgradeMode::Force);
    end;

    procedure OnNavAppUpgradePerDatabase()
    begin
        NavApp.RestoreArchiveData(Database::"Salary Computation Line");
    end;


    var
        DataUpgradeMgtG: Codeunit "Data Upgrade Mgt.";
        TableUpgradeMode: Option Check,Copy,Move,Force;

}