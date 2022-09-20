function Test-PathAndService {
    param (
        [string]$Path,
        [string]$Service
    )
    
    $PathResult = Test-Path -Path $Path -PathType leaf -ErrorAction SilentlyContinue
    $ServiceResult = Get-Service -Name $Service -ErrorAction SilentlyContinue
    if ($PathResult -and ($ServiceResult.Status -eq 'Running')) {
        return $true
    } else {
        return $false
    }
}