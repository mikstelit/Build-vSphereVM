Function Select-Cluster()
{
    $UserPrompt = "Enter the cluster's number "
    $Clusters = Get-Cluster | Sort-Object -Property Name
    $ClusterNumber = 0
    $ValidResponses = @()

    Write-Host ' '
    Write-Host 'Select a cluster:'
    
    Foreach ($Cluster in $Clusters)
    {
        $ValidResponses += $ClusterNumber
        Write-Host "  ($ClusterNumber): $($Cluster.Name)  "
        $ClusterNumber++
    }

    Get-UserSelection $UserPrompt $ValidResponses $Clusters
}