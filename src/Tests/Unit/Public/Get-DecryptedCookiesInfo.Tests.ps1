#-------------------------------------------------------------------------
Set-Location -Path $PSScriptRoot
#-------------------------------------------------------------------------
$ModuleName = 'ApertaCookie'
$PathToManifest = [System.IO.Path]::Combine('..', '..', '..', $ModuleName, "$ModuleName.psd1")
#-------------------------------------------------------------------------
if (Get-Module -Name $ModuleName -ErrorAction 'SilentlyContinue') {
    #if the module is already in memory, remove it
    Remove-Module -Name $ModuleName -Force
}
Import-Module $PathToManifest -Force
#-------------------------------------------------------------------------

InModuleScope $ModuleName {
    Describe 'Get-DecryptedCookiesInfo' -Tag Unit {
        BeforeAll {
            $WarningPreference = 'SilentlyContinue'
            $ErrorActionPreference = 'SilentlyContinue'
        } #beforeAll
        BeforeEach {
            # Mock -CommandName Get-OSCookieInfo -MockWith {
            #     [PSCustomObject]@{
            #         SQLitePath = 'apath'
            #         TableName  = 'cookies'
            #     }
            # } #endMock
        } #beforeEach
        Context 'Error' {
            BeforeEach {
                Mock -CommandName Get-RawCookiesFromDB -MockWith {
                    [PSCustomObject]@{
                        rowid           = '6'
                        creation_utc    = '13156314751422811'
                        host_key        = '.twitter.com'
                        name            = '_ga'
                        value           = ''
                        path            = '/'
                        expires_utc     = '13223699120000000'
                        is_secure       = '0'
                        is_httponly     = '0'
                        last_access_utc = '13220514656017963'
                        has_expires     = '1'
                        is_persistent   = '1'
                        priority        = '1'
                        encrypted_value = '{118, 49, 48, 28…}'
                        samesite        = '-1'
                        source_scheme   = '0'
                        source_port     = '-1'
                        is_same_party   = '0'
                    }
                } #end_Mock
            }
            It 'should throw if an error is encountered getting raw cookies from database' {
                Mock -CommandName Get-RawCookiesFromDB -MockWith {
                    throw 'Fake Error'
                } #endMock
                { Get-DecryptedCookiesInfo -Browser 'Edge' } | Should -Throw
            } #it
            It 'should throw if websession is provided and cookie count is greater than 300' {
                Mock -CommandName Get-RawCookiesFromDB -MockWith {
                    $lotsOfCookies = @(0) * 301
                    $lotsOfCookies
                } #endMock
                { Get-DecryptedCookiesInfo -Browser 'FireFox' -WebSession } | Should -Throw
            } #it
            Context 'Windows' -Skip:(!$IsWindows) {
                It 'should throw if the Windows decryption key can not be retrieved' {
                    Mock -CommandName Get-WindowsCookieDecryptKey -MockWith {
                        $false
                    } #endMock
                    { Get-DecryptedCookiesInfo -Browser 'Chrome' -WebSession } | Should -Throw
                } #it
                It 'should throw if websession is provided and cookie count is greater than 300' {
                    Mock -CommandName Get-WindowsCookieDecryptKey -MockWith {
                        $true
                    } #endMock
                    Mock -CommandName New-WindowsAesGcm -MockWith {
                        $true
                    } #endMock
                    Mock -CommandName Unprotect-Cookie -MockWith {
                        'GA1.2.111111111.11111111'
                    } #end_Mock
                    Mock -CommandName Get-RawCookiesFromDB -MockWith {
                        $lotsOfCookies = @(
                            [PSCustomObject]@{
                                Name            = 'Name'
                                encrypted_value = 'encrypt'
                            }
                        ) * 301
                        $lotsOfCookies
                    } #endMock
                    { Get-DecryptedCookiesInfo -Browser 'Chrome' -WebSession } | Should -Throw
                } #it
                It 'should throw if the Windows decryption key AesGcm can not be created' {
                    Mock -CommandName Get-WindowsCookieDecryptKey -MockWith {
                        $true
                    } #endMock
                    Mock -CommandName New-WindowsAesGcm -MockWith {
                        $false
                    } #endMock
                    { Get-DecryptedCookiesInfo -Browser 'Chrome' -WebSession } | Should -Throw
                } #it
            }
        } #context_Error
        Context 'Success' {
            BeforeEach {
                Mock -CommandName Get-RawCookiesFromDB -MockWith {
                    [PSCustomObject]@{
                        rowid           = '6'
                        creation_utc    = '13156314751422811'
                        host_key        = '.twitter.com'
                        name            = '_ga'
                        value           = ''
                        path            = '/'
                        expires_utc     = '13223699120000000'
                        is_secure       = '0'
                        is_httponly     = '0'
                        last_access_utc = '13220514656017963'
                        has_expires     = '1'
                        is_persistent   = '1'
                        priority        = '1'
                        encrypted_value = '{118, 49, 48, 28…}'
                        samesite        = '-1'
                        source_scheme   = '0'
                        source_port     = '-1'
                        is_same_party   = '0'
                    }
                } #end_Mock
                Mock -CommandName Get-WindowsCookieDecryptKey -MockWith {
                    $true
                } #endMock
                Mock -CommandName New-WindowsAesGcm -MockWith {
                    $true
                } #endMock
                Mock -CommandName Unprotect-Cookie -MockWith {
                    'GA1.2.111111111.11111111'
                } #end_Mock
            }
            It 'should return null if no raw cookies are returned from database' {
                Mock -CommandName Get-RawCookiesFromDB -MockWith {
                    $null
                } #endMock
                Get-DecryptedCookiesInfo -Browser 'FireFox' | Should -BeNullOrEmpty
            } #it
            It 'should return expected results for FireFox' {
                Mock -CommandName Get-RawCookiesFromDB -MockWith {
                    [PSCustomObject]@{
                        rowid           = '6'
                        creation_utc    = '13156314751422811'
                        host            = '.twitter.com'
                        name            = '_ga'
                        value           = 'GA1.2.111111111.11111111'
                        path            = '/'
                        expires_utc     = '13223699120000000'
                        is_secure       = '0'
                        is_httponly     = '0'
                        last_access_utc = '13220514656017963'
                        has_expires     = '1'
                        is_persistent   = '1'
                        priority        = '1'
                        encrypted_value = '{118, 49, 48, 28…}'
                        samesite        = '-1'
                        source_scheme   = '0'
                        source_port     = '-1'
                        is_same_party   = '0'
                    }
                } #end_Mock
                $eval = Get-DecryptedCookiesInfo -Browser 'FireFox'
                $eval.value | Should -BeExactly 'GA1.2.111111111.11111111'
            } #it
            It 'should return expected results for FireFox when websession is specified' {
                Mock -CommandName Get-RawCookiesFromDB -MockWith {
                    [PSCustomObject]@{
                        rowid           = '6'
                        creation_utc    = '13156314751422811'
                        host            = '.twitter.com'
                        name            = '_ga'
                        value           = 'GA1.2.111111111.11111111'
                        path            = '/'
                        expires_utc     = '13223699120000000'
                        is_secure       = '0'
                        is_httponly     = '0'
                        last_access_utc = '13220514656017963'
                        has_expires     = '1'
                        is_persistent   = '1'
                        priority        = '1'
                        encrypted_value = '{118, 49, 48, 28…}'
                        samesite        = '-1'
                        source_scheme   = '0'
                        source_port     = '-1'
                        is_same_party   = '0'
                    }
                } #end_Mock
                $session = Get-DecryptedCookiesInfo -Browser 'FireFox' -WebSession
                $session.Cookies.Count | Should -BeExactly 1
            } #it
            Context 'Windows' -Skip:(!$IsWindows) {
                It 'should return expected values if non-firefox is provided on Windows' {
                    $eval = Get-DecryptedCookiesInfo -Browser 'Edge'
                    $eval.decrypted_value | Should -BeExactly 'GA1.2.111111111.11111111'
                } #it
                It 'should return expected values if non-firefox is provided on Windows and domain is specified' {
                    $eval = Get-DecryptedCookiesInfo -Browser 'Edge' -DomainName twitter
                    $eval.decrypted_value | Should -BeExactly 'GA1.2.111111111.11111111'
                } #it
                It 'should return expected values if non-firefox is provided on Windows and websession is specified' {
                    $session = Get-DecryptedCookiesInfo -Browser 'Chrome' -WebSession
                    $session.Cookies.Count | Should -BeExactly 1
                } #it
            }
            Context 'Linux' -Skip:(!$IsLinux) {
                It 'should return null if non-firefox is provided on Linux' {
                    Get-DecryptedCookiesInfo -Browser 'Chrome' | Should -BeNullOrEmpty
                } #it
            }
            Context 'MacOS' -Skip:(!$IsMacOS) {
                It 'should return null if non-firefox is provided on MacOs' {
                    Get-DecryptedCookiesInfo -Browser 'Chrome' | Should -BeNullOrEmpty
                } #it
            }
        } #context_Success
    } #describe_PrivateFunctions
}
