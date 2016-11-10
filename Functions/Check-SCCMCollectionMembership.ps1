Function Check-SCCMCollectionMembership($ComputerName, $Collection, $SiteCode, $SCCMServer)
{
    Try
    {
        While($True)
        {
            $CollectionObject = Get-WmiObject -Namespace "Root\SMS\Site_$SiteCode" -Class SMS_Collection -Filter "Name = '$Collection'" -ComputerName $SCCMServer
            $CollectionObject.RequestRefresh() | Out-Null

            Start-Sleep 15

            $CollectionMembers = Get-CMCollectionMember -CollectionName $Collection -ErrorAction Stop | foreach { $_.Name } | Sort-Object

            If($CollectionMembers -and $CollectionMembers.Contains($ComputerName))
            {
                Break
            }
        }
    }
    Catch
    {
        # Sometimes Get-CMCollectionMember throws an error when updating the All Systems collection.
        # I have not found a solution for this, but am returning the function if the error occurs.
        Return
    }
}