Function Get-UserSelection($UserPrompt, $ValidResponses, $Collection)
{
    Do
    {
        $ItemNumber = Read-Host $UserPrompt
        If ($ValidResponses -contains $ItemNumber)
        {
            Return $Collection[$ItemNumber]
        }        
    }
    While ($true)
}