Function Select-OS()
{
    $OperatingSystems = 'Windows Server 2008 R2', 'Windows Server 2012 R2'
    $OSNumber = 0
    $ValidResponses = @()

    Write-Host ' '
    Write-Host 'Select an Operating System:'

    Foreach ($OperatingSystem in $OperatingSystems)
    {
        $ValidResponses += $OSNumber
        Write-Host "  ($OSNumber): $OperatingSystem"
        $OSNumber++
    }

    Do
    {
        $OSNumber = Read-Host "Enter the OS's number "
        If ($ValidResponses -contains $OSNumber)
        {
            If ($OSNumber -eq 0)
            {
                Return 'windows7Server64Guest'
            }
            Else
            {
                Return 'windows8Server64Guest'
            }
        }
    }
    While ($true)
}