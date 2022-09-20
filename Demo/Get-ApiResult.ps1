function Get-ApiResult {
    param ( 
        [PSCustomObject] $ReadIn, 
        [PSCustomObject] $WriteOut
    )
    
    $result = Invoke-RestMethod -Uri $ReadIn.URL -Method $ReadIn.Verb -Body $ReadIn.Payload -ErrorAction Stop
    $WriteOut.HttpStatus = $result.StatusCode
    $WriteOut.Payload = $result.Content
    $WriteOut.Message = $result.StatusDescription
    
    if ($null -ne $WriteOut.Payload) {
        return $true
    } else {
        return $false
    }
}