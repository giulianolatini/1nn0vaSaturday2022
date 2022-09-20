BeforeAll {
    . $PSCommandPath.Replace('.Tests.ps1', '.ps1')
}
Describe 'Test-PathAndService' {
    BeforeEach {
        Mock -CommandName Get-Service -ParameterFilter { $Service -eq 'TestService'} -MockWith { @{'Status' = 'Running'} }
        Mock -CommandName Test-Path -ParameterFilter { $Path -eq 'C:\Abuse\abuse.txt' -and $PathType -eq 'leaf' } -MockWith { $true }
    }
    Context 'When the path exists' {
        It 'Should return true' {
            Test-PathAndService -Path 'C:\Abuse\abuse.txt' -Service 'TestService'| Should -BeTrue
        }
    }
    Context 'When the path does not exist' {
        It 'Should return false' {
            Test-PathAndService -Path 'C:\Windows\NotReal' -Service 'TestService'| Should -BeFalse
        }
    }
}

Describe 'Test-PathAndService Real' {
    
    Context 'When make a real test' {
        It 'Should return true' {
            Test-PathAndService -Path 'C:\Program Files\OpenSSH\sshd.exe' -Service 'sshd'| Should -BeTrue
        }
    }
}

# $script:Path = 'C:\Program Files\WindowsPowerShell\Modules\Demo'
# $script:ServiceName = 'Demo'
# $script:FunctionName = 'Test-PathAndService'
# $script:Function = Get-ChildItem -Path $script:Path -Filter "$script:FunctionName.ps1" -Recurse