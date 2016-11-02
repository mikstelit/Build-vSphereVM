Function Select-Datastore($vMwareCluster)
{
    $UserPrompt = "Enter the datastore's number "
    $DataStores = Get-UniqueObjects $vMwareCluster 'Datastore'
    $DataStoreNumber = 0
    $ValidResponses = @()

    Write-Host ' '
    Write-Host 'Select a datastore:'

    Foreach ($DataStore in $DataStores)
    {
        $ValidResponses += $DataStoreNumber
        $FormatedSpace = '{0:N0}' -f $DataStore.FreeSpaceGB
        Write-Host "  ($DataStoreNumber): $($DataStore.Name): Free space in GB = $FormatedSpace"
        $DataStoreNumber++
    }

    Get-UserSelection $UserPrompt $ValidResponses $DataStores
}