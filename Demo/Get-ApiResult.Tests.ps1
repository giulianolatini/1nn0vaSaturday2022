BeforeAll {
    . $PSCommandPath.Replace('.Tests.ps1', '.ps1')
}

Describe 'Mocked Test' {
    BeforeEach {
        Mock -CommandName Invoke-RestMethod -ParameterFilter { $Method -eq 'GET' -and $Uri -eq 'https://www.google.com' } -MockWith { [PSCustomObject]@{ 
                            StatusCode = 200
                            StatusDescription = 'Ok'
                            Content = $null
                         }
                        }
        Mock -CommandName Invoke-RestMethod -ParameterFilter { $Method -eq 'POST' -and $Uri -eq 'http://api.korg.org/test/pino' } -MockWith { [PSCustomObject]@{ 
                            StatusCode = 200
                            StatusDescription = 'Ok'
                            Content = [PSCustomObject]@{ 
                                Name = 'Goofy'
                                LastName = 'McGoof'
                            }
                         }
                        }
        Mock -CommandName Invoke-RestMethod -ParameterFilter { $Method -eq 'GET' -and $Uri -eq 'http://api.korg.org/test/pino' } -MockWith { [PSCustomObject]@{ 
                            StatusCode = 200
                            StatusDescription = 'Ok'
                            Content = $null
                         }
                        }
        Mock -CommandName Invoke-RestMethod -ParameterFilter { $Method -eq 'DELETE' -and $Uri -eq 'http://api.korg.org/test/pino' } -MockWith { [PSCustomObject]@{ 
                            StatusCode = 200
                            StatusDescription = 'Ok'
                            Content = [PSCustomObject]@{ 
                                result = 'Ok'
                            }
                         }
                        }
    }
    Context 'Get www.google.com' {
        It 'Google GET should be false' {
            
            $RequestInput = [PSCustomObject]@{
                URL = 'https://www.google.com'
                Verb = 'GET'
                Payload = $null
            }
            $RequestOutput = [PSCustomObject]@{
                HttpStatus = $null
                Payload = $null
                Message = $null
            }
            Get-ApiResult -ReadIn $RequestInput -WriteOut $RequestOutput | Should -BeFalse
        }
    }
    Context 'Get api.korg.org/test/pino' {
        It 'Korg POST should be true' {
            
            $RequestInput = [PSCustomObject]@{
                URL = 'http://api.korg.org/test/pino'
                Verb = 'POST'
                Payload = [PSCustomObject]@{
                    user = 'pippo'
                    token = 'acde32eeq£@'
                }
            }
            $RequestOutput = [PSCustomObject]@{
                HttpStatus = $null
                Payload = $null
                Message = $null
            }
            Get-ApiResult -ReadIn $RequestInput -WriteOut $RequestOutput | Should -BeTrue
        }
        It 'Korg GET should be false' {
            
            $RequestInput = [PSCustomObject]@{
                URL = 'http://api.korg.org/test/pino'
                Verb = 'GET'
                Payload = [PSCustomObject]@{
                    user = 'pippo'
                    token = 'acde32eeq£@'
                }
            }
            $RequestOutput = [PSCustomObject]@{
                HttpStatus = $null
                Payload = $null
                Message = $null
            }
            Get-ApiResult -ReadIn $RequestInput -WriteOut $RequestOutput | Should -BeFalse
        }
        It 'Korg DELETE should be true' {
            
            $RequestInput = [PSCustomObject]@{
                URL = 'http://api.korg.org/test/pino'
                Verb = 'DELETE'
                Payload = [PSCustomObject]@{
                    user = 'pippo'
                    token = 'acde32eeq£@'
                }
            }
            $RequestOutput = [PSCustomObject]@{
                HttpStatus = $null
                Payload = $null
                Message = $null
            }
            Get-ApiResult -ReadIn $RequestInput -WriteOut $RequestOutput | Should -BeTrue
        }
    }
}