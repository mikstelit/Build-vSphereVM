Function Check-SCCMCollectionMembership($ComputerName, $Collection, $SiteCode, $SCCMServer)
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