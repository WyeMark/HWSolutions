$containerName = 'hw-bc17'

$credential = New-Object pscredential 'robert', (ConvertTo-SecureString '1234' -AsPlainText -Force)
$auth = 'UserPassword'
$artifactUrl = Get-BcArtifactUrl -type Sandbox -version 17 -country us -select Latest
$licenseFile = 'c:\nav\licenses\BC17.flf'

New-BcContainer `
    -accept_eula `
    -auth $auth `
    -credential $credential `
    -containerName $containerName `
    -artifactUrl $artifactUrl `
    -licenseFile $licenseFile `
    -updateHosts `
    -includeAL `
    -doNotExportObjectsToText `
    -shortcuts Desktop 


$containerName = 'bc14-windows'
Export-ModifiedObjectsAsDeltas `
    -containerName $containerName `
    -filter "Type=Report;ID=50002" `
    -useNewSyntax 
    #-sqlCredential $databaseCredential 
    #-fullObjectsFolder 'c:\programdata\navcontainerhelper\extensions\harbor-bc14\my\harbor' 

Convert-Txt2Al `
    -containerName $containerName `
    -myAlFolder "c:\programdata\bccontainerhelper\extensions\$containerName\txt2al" `
    -myDeltaFolder "C:\ProgramData\bcContainerHelper\Extensions\$containerName\delta-newsyntax" `
    -startId 1