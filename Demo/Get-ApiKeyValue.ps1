function Get-ApiKeyValue {
    param ( 
        [PSCustomObject] $ReadIn, 
        [PSCustomObject] $WriteOut
    )

    function ConvertPSObjectToHashtable
    {
        param (
            [Parameter(ValueFromPipeline)]
            $InputObject
        )
    
        process
        {
            if ($null -eq $InputObject) { return $null }
    
            if ($InputObject -is [System.Collections.IEnumerable] -and $InputObject -isnot [string])
            {
                $collection = @(
                    foreach ($object in $InputObject) { ConvertPSObjectToHashtable $object }
                )
    
                Write-Output -NoEnumerate $collection
            }
            elseif ($InputObject -is [psobject])
            {
                $hash = @{}
    
                foreach ($property in $InputObject.PSObject.Properties)
                {
                    $hash[$property.Name] = ConvertPSObjectToHashtable $property.Value
                }
    
                $hash
            }
            else
            {
                $InputObject
            }
        }
    }

    $result = Invoke-RestMethod -Uri $ReadIn.URL -ErrorAction Stop

    $WriteOut.HttpStatus = $result.StatusCode

    $hashresult = ConvertPSObjectToHashtable $result.Content.metadata
    $WriteOut.keyValue  = $hashresult[$ReadIn.key]

    $WriteOut.Message = $result.StatusDescription

}