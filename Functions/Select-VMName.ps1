Function Select-VMName($VM)
{
    Do
    {
        If ($VM.VMName -eq '') 
        {
            $VM.VMName = Read-Host 'Enter the name of the VM (must be less than 15 characters): '
        }
        
        If ($VM.VMName.Length -lt 16)
        {
            Break
        }
    }
    While($true)
}