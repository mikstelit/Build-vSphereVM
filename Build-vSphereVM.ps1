<#

.SYNOPSIS
  This script creates a new vMware virtual machine using the supplied 
  settings in the InputData CSV.  The virtual machine is then started with
  the SCCM boot media in the optical drive.  The script adds the virtual 
  machien to an SCCM collection that should have a task sequence deployed 
  to it that installs an operating system.  The script requires PowerCLI 
  to be installed before running the script and the SCCM PowerShell 
  module needs to be installed.

.PARAMETER vCenter
  The name of the vCenter server.

.PARAMETER SCCMServer
  The name of the SCCM server.

.PARAMETER SiteCode
  The name of your SCCM site code.

.PARAMETER SCCMModuleLocation
  The location of the SCCM PowerShell module.

.PARAMETER BaseSCCMCollection
  This is the name of the limiting collection of the collection in SCCM that has the 
  task sequence deployed to.  This would be something like 'All Systems'.

.PARAMETER InputData
  The script requires a CSV file.  If no CSV file is specified as a parameter, 
  a default value is used.  The CSV file should have the following format:

    VMName,CPUs,RAM,DiskSizeMB,DiskProvisioning,ISO,Cluster,DataStore,GuestID,VLAN

  If the VMName, Cluster, DataStore, GuestID, or VLAN fields are empty in the CSV file, 
  the script will prompt the user for those values.  If any of the following fields 
  do not have values, defaults will be used.

    ,CPUs,RAM,DiskSizeMB,DiskProvisioning,ISO,,,,,
  
.OUTPUTS
  Writes error messages to the screen.

.EXAMPLE
  Build-vSphereVM

#>

Param
( 
    [Parameter(Mandatory=$False,
               Position=0)]
    [string]$vCenter = '',

    [Parameter(Mandatory=$False,
               Position=1)]
    [string]$SCCMServer = '',

    [Parameter(Mandatory=$False,
               Position=2)]
    [string]$SiteCode = '',

    [Parameter(Mandatory=$False,
               Position=3)]
    [string]$SCCMModuleLocation = 'C:\Program Files (x86)\Microsoft Configuration Manager\AdminConsole\bin\ConfigurationManager.psd1',

    [Parameter(Mandatory=$False,
               Position=4)]
    [string]$BaseSCCMCollection = 'All Systems',

    [Parameter(Mandatory=$False,
               Position=4)]
    [string]$InputData = 'Resources\Servers.csv'
)


Try
{
    Add-PSSnapin VMware.VimAutomation.Core -ErrorAction Stop
    Import-Module $SCCMModuleLocation -ErrorAction Stop

    $ServerData = "$PSScriptRoot\$InputData "
    $VMs = Import-Csv $ServerData -ErrorAction Stop
    Get-ChildItem "$PSScriptRoot\Functions" | Where-Object { $_.Name -like '*.ps1' } | Resolve-Path | Foreach { . $_.ProviderPath }

    Connect-VIServer $vCenter -ErrorAction Stop | Out-Null

    $OriginalWorkingDirectory = $PWD
}
Catch
{
    Write-Host $Error[0].Exception.Message
    Exit
}

Try
{
    Get-VMBuildInformation $VMs

    Foreach ($VM in $VMs)
    {
        New-VirtualMachine $VM
    }

    Set-Location "$($SiteCode):"

    Foreach ($VM in $VMs)
    {
        Add-SystemToSCCM $VM $BaseSCCMCollection $SiteCode $SCCMServer
    }

    Set-Location $OriginalWorkingDirectory
    Disconnect-VIServer $vCenter -Confirm:$false
}
Catch
{
    Write-Host $Error[0].Exception.Message
}