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
    Describe 'Get-OSCookieInfo' -Tag Unit {
        BeforeAll {
            $WarningPreference = 'SilentlyContinue'
            $ErrorActionPreference = 'SilentlyContinue'
        } #beforeAll
        Context 'Success' {
            Context 'Windows' -Skip:(!$IsWindows) {
                It 'should return expected results for Chrome' {
                    $eval = Get-OSCookieInfo -Browser 'Chrome'
                    $eval.SQLitePath | Should -BeExactly "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Cookies"
                    $eval.TableName | Should -BeExactly 'cookies'
                } #it
                It 'should return expected results for Firefox' {
                    Mock -CommandName Get-FireFoxProfilePath -MockWith {
                        'C:\Users\user\AppData\Roaming\Mozilla\Firefox\Profiles\xxxxxxx.default'
                    } #endMock
                    $eval = Get-OSCookieInfo -Browser 'FireFox'
                    $eval.SQLitePath | Should -BeExactly 'C:\Users\user\AppData\Roaming\Mozilla\Firefox\Profiles\xxxxxxx.default\cookies.sqlite'
                    $eval.TableName | Should -BeExactly 'moz_cookies'
                } #it
                It 'should return expected results for Edge' {
                    $eval = Get-OSCookieInfo -Browser 'Edge'
                    $eval.SQLitePath | Should -BeExactly "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Cookies"
                    $eval.TableName | Should -BeExactly 'cookies'
                } #it
            } #context_windows
            Context 'Linux' -Skip:(!$IsLinux) {
                It 'should return expected results for Chrome' {
                    $eval = Get-OSCookieInfo -Browser 'Chrome'
                    $eval.SQLitePath | Should -BeExactly "$env:HOME/.config/google-chrome/Default/Cookies"
                    $eval.TableName | Should -BeExactly 'cookies'
                } #it
                It 'should return expected results for Edge' {
                    $eval = Get-OSCookieInfo -Browser 'Edge' -Verbose
                    $eval.SQLitePath | Should -BeExactly "$env:HOME/.config/microsoft-edge-beta/Default/Cookies"
                    $eval.TableName | Should -BeExactly 'cookies'
                } #it
                It 'should return expected results for FireFox' {
                    Mock -CommandName Get-FireFoxProfilePath -MockWith {
                        '/home/jake/.mozilla/firefox/xxxxxxxx.default-release'
                    } #endMock
                    $eval = Get-OSCookieInfo -Browser 'FireFox' -Verbose
                    $eval.SQLitePath | Should -BeExactly '/home/jake/.mozilla/firefox/xxxxxxxx.default-release/cookies.sqlite'
                    $eval.TableName | Should -BeExactly 'moz_cookies'
                } #it
            } #context_windows
            Context 'MacOS' -Skip:(!$IsMacOS) {
                It 'should return expected results for Chrome' {
                    $eval = Get-OSCookieInfo -Browser 'Chrome'
                    $eval.SQLitePath | Should -BeExactly "$env:HOME/Library/Application Support/Google/Chrome/Default/Cookies"
                    $eval.TableName | Should -BeExactly 'cookies'
                } #it
                It 'should return expected results for Edge' {
                    $eval = Get-OSCookieInfo -Browser 'Edge' -Verbose
                    $eval.SQLitePath | Should -BeExactly "$env:HOME/Library/Application Support/Microsoft Edge/Default/Cookies"
                    $eval.TableName | Should -BeExactly 'cookies'
                } #it
                It 'should return expected results for FireFox' {
                    Mock -CommandName Get-FireFoxProfilePath -MockWith {
                        'home/Library/Application Support/Firefox/Profiles/'
                    } #endMock
                    $eval = Get-OSCookieInfo -Browser 'FireFox' -Verbose
                    $eval.SQLitePath | Should -BeExactly 'home/Library/Application Support/Firefox/Profiles/cookies.sqlite'
                    $eval.TableName | Should -BeExactly 'moz_cookies'
                } #it
            } #context_windows
        }#context_Success
    }#describe_PrivateFunctions
}


