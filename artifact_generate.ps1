$scriptPath = Resolve-Path -Path $MyInvocation.MyCommand.Source
$workingDir = Split-Path -Path $scriptPath

if(-NOT (Test-Path -Path $workingDir\ota_content)) 
{
    Write-Host
    Write-Host -ForegroundColor red "ota_content not found"
    Write-Host

    PAUSE
    exit -1
}

If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{   
    $processOptions = @{
        FilePath = "powershell.exe"
        ArgumentList = @("-executionpolicy", "AllSigned", "-File", $scriptPath.Path)
        Verb = "RunAs"
        workingDirectory = $workingDir
        Wait = $true
    }
    Start-Process @processOptions
    exit
}

Write-Host "Creating Allxon OTA Payload ..."

$file = "Allxon_OTA_Artifact-W-x86_64.zip"
$currentEpoch = [int][double]::Parse((Get-Date (get-date).touniversaltime() -UFormat %s))

echo "DateTime: $currentEpoch" > $workingDir\ota_content\.host_info

Get-ComputerInfo -Property CsProcessors, WindowsBuildLabEx, OsName, OsVersion, OsArchitecture | Format-List >> $workingDir\ota_content\.host_info

Get-ChildItem -Path $workingDir\ota_content -Recurse >> $workingDir\ota_content\.host_info

if(Test-Path -Path $file) {
    Remove-Item -Path $file -Force
}

Write-Host "Packing all files in ota_content..."
Compress-Archive -Verbose -DestinationPath "$workingDir\$file" -Path "$workingDir\ota_content\*"

$fileMD5 = Get-FileHash -Path "$workingDir\$file" -Algorithm MD5 | Select-Object -Property Hash

$fileOriName = $fileMD5.Hash.ToString().ToLower() + "-" + $file

Write-Host "fileOriName " $fileOriName

$stringAsStream = [System.IO.MemoryStream]::new()
$writer = [System.IO.StreamWriter]::new($stringAsStream)
$writer.write($fileOriName)
$writer.Flush()
$stringAsStream.Position = 0
$fileNameHash = Get-FileHash -InputStream $stringAsStream -Algorithm MD5 | Select-Object Hash

$fileNewName = $fileNameHash.Hash.ToString().ToLower() + "-" + $file

Rename-Item -NewName "$fileNewName" -Path $workingDir\$file

Write-Host
Write-Host
Write-Host "Allxon OTA Artifact Created : " -NoNewline
Write-Host "$fileNewName" -ForegroundColor red -BackgroundColor white
Write-Host
Write-Host
PAUSE
