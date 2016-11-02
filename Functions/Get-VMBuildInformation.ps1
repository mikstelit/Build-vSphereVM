Function Get-VMBuildInformation($VMs)
{
    $DefaultCPUCount = '2'
    $DefaultRAM = '2048'
    $DefaultDiskSize = '81920'
    $DefaultDiskProvisioning = 'Thin'
    
    Foreach ($VM in $VMs)
    {
        Try
        {
            Write-Host "Collecting information for VM named $($VM.VMName)"

            Select-VMName $VM

            If ($VM.Cluster -eq '') 
            { 
                $VM.Cluster = Select-Cluster 
            }

            If ($VM.DataStore -eq '') 
            { 
                $VM.DataStore = Select-Datastore $VM.Cluster 
            }

            If ($VM.CPUs -eq '') 
            { 
                $VM.CPUs = $DefaultCPUCount 
            }

            If ($VM.RAM -eq '') 
            { 
                $VM.RAM = $DefaultRAM 
            }

            If ($VM.DiskSizeMB -eq '') 
            { 
                $VM.DiskSizeMB = $DefaultDiskSize 
            }

            If ($VM.DiskProvisioning -eq '') 
            { 
                $VM.DiskProvisioning = $DefaultDiskProvisioning 
            }

            If ($VM.GuestID -eq '') 
            { 
                $VM.GuestID = Select-OS 
            }

            If ($VM.VLAN -eq '') 
            { 
                $VM.VLAN = Select-VLAN $VM.Cluster
            }
            
            Write-Host "Finished gathering information for $($VM.VMName)"
            Write-Host '*******************************************************'
        }
        Catch
        {
            Write-Host 'Unable to gather all information for VM.'
            Write-Host $Error[0].Exception.Message
            Exit
        }
    }
}