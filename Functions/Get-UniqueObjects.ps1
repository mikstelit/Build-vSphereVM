Function Get-UniqueObjects($vMwareCluster, $ObjectType)
{
    <# This is a helper fuction that returns either 
    a array of datastores on the cluster or a 
    collection of VLANs on a cluster.  The $ObjectType 
    variable passed to the script should either be 
    Datastore or VLAN.

    #>
    $VMHosts = Get-VMHost -Location $vMwareCluster
    $Objects = @()

    Foreach ($VMHost in $VMHosts)
    {
        If ($ObjectType -eq 'Datastore')
        {
            $HostObjects = Get-Datastore -VMHost $VMHost
        }
        ElseIf($ObjectType -eq 'VLAN')
        {
            $HostObjects = Get-VirtualPortGroup -VMHost $VMHost
        }
        Else
        {
            Write-Host 'Invalid object type specified.  Should be Datastore or VLAN.'
            Exit
        }

        Foreach ($HostObject in $HostObjects)
        {
            If ($Objects -notcontains $HostObject)
            {
                $Objects += $HostObject
            }
        }
    }

    Return $($Objects | Sort-Object -Property Name)
}