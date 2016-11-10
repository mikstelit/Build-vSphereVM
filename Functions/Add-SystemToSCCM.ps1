Function Add-SystemToSCCM($VM, $BaseSCCMCollection, $SiteCode, $SCCMServer)
{
    Try
    {
        $NIC = Get-NetworkAdapter -VM $VM.VMName -ErrorAction Stop
        $MACAddress = $NIC.MacAddress
        $HostName = $VM.VMName
        If ($VM.GuestId -eq 'windows7Server64Guest')
        {
            $CollectionName = 'Deploy - Server 2008'
        }
        Else
        {
            $CollectionName = 'Deploy - Server 2012'
        }
        
        Import-CMComputerInformation -CollectionName $CollectionName -ComputerName $HostName -MacAddress $MACAddress

        Check-SCCMCollectionMembership $VM.VMName $CollectionName $SiteCode $SCCMServer
    }
    Catch
    {
        Write-Host $Error[0].Exception.Message
    }
}