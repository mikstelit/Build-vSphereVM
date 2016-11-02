Function New-VirtualMachine($VM)
{
    Try
    {
        Write-Verbose ' '
        Write-Verbose "Creating virtual machine $($VM.VMName)"
        New-VM -Name $VM.VMName `
               -ResourcePool $VM.Cluster `
               -Datastore $VM.DataStore `
               -NumCpu $VM.CPUs `
               -MemoryMB $VM.RAM `
               -DiskMB $VM.DiskSizeMB `
               -DiskStorageFormat $VM.DiskProvisioning `
               -GuestId $VM.GuestID `
               -ErrorAction Stop | Out-Null

        $NICToRemove = Get-NetworkAdapter -VM $VM.VMName -ErrorAction Stop
        Remove-NetworkAdapter $NICToRemove -Confirm:$false

        New-NetworkAdapter -NetworkName $VM.VLAN -StartConnected -Type 'Vmxnet3' -VM $VM.VMName | Out-Null
    
        Write-Verbose "Adding ISO to CD drive on $($VM.VMName)"
        If ($VM.Datastore.Name -like '*VMWSQLC1*')
        {
            $BootMediaDataStore = 'VMWSQLC1 Datastore 01'
        }
        Else
        {
            $BootMediaDataStore = 'Store 401 - VMWC4'
        }
        New-CDDrive -VM $VM.VMName `
                    -ISOPath "[$BootMediaDataStore] MEDIA/SCCM_Boot_Media.iso" `
                    -StartConnected `
                    -ErrorAction Stop | Out-Null

        Write-Verbose "Starting virtual machine $($VM.VMName)"
        Start-VM -VM $VM.VMName -ErrorAction Stop | Out-Null
        Write-Verbose "Virtual machine $($VM.VMName) successfully created and started."
    }
    Catch
    {
        Write-Host 'Unable to create or start VM.'
        Write-Host $Error[0].Exception.Message
        Exit
    }
}