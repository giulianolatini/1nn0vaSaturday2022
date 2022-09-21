BeforeAll {
    . $PSCommandPath.Replace('.Tests.ps1', '.ps1')
}

Describe 'Mocked Test' {
    BeforeEach {
        Mock -CommandName Invoke-RestMethod -ParameterFilter { $Uri -eq 'http://api.korg.org/dict/ita' } -MockWith { [PSCustomObject]@{ 
                            StatusCode = 200
                            StatusDescription = 'Ok'
                            Content = [PSCustomObject]@{ 
                                dataset = @('alpha','beta','gamma','delta','epsilon','zeta','eta','theta','iota','kappa','lambda','mu','nu','xi','omicron','pi','rho','sigma','tau','upsilon','phi','chi','psi','omega')
                                metadata = [PSCustomObject]@{
                                    wordnumber = 8674
                                    language = 'ita'
                                    version = '1.0'
                                }
                            }
                         }
                        }
        Mock -CommandName Invoke-RestMethod -ParameterFilter { $Uri -eq 'http://api.korg.org/dict/ima' } -MockWith { [PSCustomObject]@{ 
                            StatusCode = 200
                            StatusDescription = 'Ok'
                            Content = [PSCustomObject]@{ 
                                dataset = @('IMG01.jpg','IMG02.jpg','IMG03.jpg','IMG04.jpg','IMG05.jpg','IMG06.jpg','IMG07.jpg','IMG08.jpg','IMG09.jpg','IMG10.jpg','IMG11.jpg','IMG12.jpg','IMG13.jpg','IMG14.jpg','IMG15.jpg','IMG16.jpg')
                                metadata = [PSCustomObject]@{
                                    albumname = 'Vacanze in Costa Esmeralda'
                                    imagesnumber = 16
                                    date = '18/07/2021'
                                }
                            }
                         }
                        }
        Mock -CommandName Invoke-RestMethod -ParameterFilter { $Uri -eq 'http://api.korg.org/dict/zip' } -MockWith { [PSCustomObject]@{ 
                            StatusCode = 500
                            StatusDescription = 'Internal Server Error'
                            Content = [PSCustomObject]@{
                                dataset = @()
                                metadata = [PSCustomObject]@{
                                    filename = $null
                                    compressformat = $null
                                    date = $null
                                }
                            }
                         }
                        }
    }
    Context 'Get api.korg.org/dict' {
        It '/ita GET should be 200 ad 8674 words' {
            
            $RequestInput = [PSCustomObject]@{
                URL = 'http://api.korg.org/dict/ita'
                key = 'wordnumber'
            }
            $RequestOutput = [PSCustomObject]@{
                HttpStatus = $null
                keyValue = $null
                Message = $null
            }
            Get-ApiKeyValue -ReadIn $RequestInput -WriteOut $RequestOutput
            $RequestOutput.HttpStatus | Should -BeExactly 200
            $RequestOutput.keyValue | Should -BeExactly 8674
        }
        It '/ima GET should be 200 ad "Vacanze in Costa Esmeralda" album' {
            
            $RequestInput = [PSCustomObject]@{
                URL = 'http://api.korg.org/dict/ima'
                key = 'albumname'
            }
            $RequestOutput = [PSCustomObject]@{
                HttpStatus = $null
                keyValue = $null
                Message = $null
            }
            Get-ApiKeyValue -ReadIn $RequestInput -WriteOut $RequestOutput
            $RequestOutput.HttpStatus | Should -BeExactly 200
            $RequestOutput.keyValue | Should -BeExactly "Vacanze in Costa Esmeralda"
        }
        It '/zip GET should be 500 ad NULL' {
            
            $RequestInput = [PSCustomObject]@{
                URL = 'http://api.korg.org/dict/zip'
                key = 'filename'
            }
            $RequestOutput = [PSCustomObject]@{
                HttpStatus = $null
                keyValue = $null
                Message = $null
            }
            Get-ApiKeyValue -ReadIn $RequestInput -WriteOut $RequestOutput
            $RequestOutput.HttpStatus | Should -BeExactly 500
            $RequestOutput.Value | Should -BeExactly $null
        }
    }
}