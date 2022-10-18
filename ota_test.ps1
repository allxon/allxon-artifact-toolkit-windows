param (
    [string]$otaPath = $( Read-Host "Allxon OTA payload file name" )
)

$scriptPath = Resolve-Path -Path $MyInvocation.MyCommand.Source
$workingDir = Split-Path -Path $scriptPath
Set-Location $workingDir

Write-Host $otaPath
if(-NOT (Test-Path -Path "$otaPath")) 
{
    Write-Host
    Write-Host -ForegroundColor red "OTA payload not found"
    Write-Host

    PAUSE
    exit -1
}

If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{   
    $processOptions = @{
        FilePath = "powershell.exe"
        ArgumentList = @("-executionpolicy", "AllSigned", "-File", $scriptPath.Path, "-otaPath", $otaPath)
        Verb = "RunAs"
        workingDirectory = $workingDir
        Wait = $true
    }
    Start-Process @processOptions
    exit
}

Write-Host "Using Allxon OTA paylaod : $otaPath"

$currentEpoch = [int][double]::Parse((Get-Date (get-date).touniversaltime() -UFormat %s))

$otaDest = "$env:TEMP\appies_ota\$currentEpoch"

Write-Host "Extarcting Allxon OTA payload : $otaPath"

Expand-Archive -Path $otaPath -DestinationPath $otaDest -Verbose

if(-NOT (Test-Path -Path "$otaDest\ota_deploy.bat")) 
{
    Write-Host
    Write-Host -ForegroundColor red "ota_deploy.bat not found"
    Write-Host

    PAUSE
    exit -1
}

$processOptions = @{
    FilePath = "cmd.exe"
    ArgumentList = @("/c", "ota_deploy.bat")
    Verb = "RunAs"
    workingDirectory = $otaDest
    Wait = $true
    WindowStyle  = "Hidden"
}

Write-Host "Runing ota_deploy.bat in Allxon OTA payload ..."
Start-Process @processOptions
Write-Host "Running install is finished. Check the result."

PAUSE