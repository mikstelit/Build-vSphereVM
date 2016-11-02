Function Select-VLAN($vMwareCluster)
{
    $UserPrompt = "Enter the VLAN's number "
    $VLANs = Get-UniqueObjects $vMwareCluster 'VLAN'
    $VLANNumber = 0
    $ValidResponses = @()

    Write-Host ' '
    Write-Host 'Select a VLAN:'

    Foreach ($VLAN in $VLANs)
    {
        $ValidResponses += $VLANNumber
        Write-Host "  ($VLANNumber): $($VLAN.Name)"
        $VLANNumber++
    }

    Get-UserSelection $UserPrompt $ValidResponses $VLANs
}