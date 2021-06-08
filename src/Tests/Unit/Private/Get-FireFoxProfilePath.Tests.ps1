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
    Describe 'Get-FireFoxProfilePath' -Tag Unit {
        BeforeAll {
            $WarningPreference = 'SilentlyContinue'
            $ErrorActionPreference = 'SilentlyContinue'
        } #beforeAll
        Context 'Error' {
            It 'should return false if an error is encountered getting file info' {

                Mock -CommandName Get-ChildItem -MockWith {
                    throw 'Fake Error'
                } #endMock
                Get-FireFoxProfilePath -Path "$env:APPDATA\Mozilla\Firefox\Profiles" | Should -BeExactly $false
            } #it
        } #context_Error
        Context 'Success' {
            BeforeEach {
                $ffProfileInfo = @(
                    [PSCustomObject]@{
                        PSPath              = 'Microsoft.PowerShell.Core\FileSystem::C:\Users\user\AppData\Roaming\Mozilla\Firefox\Profiles\xxxxxxxxxx.default'
                        PSParentPath        = 'Microsoft.PowerShell.Core\FileSystem::C:\Users\user\AppData\Roaming\Mozilla\Firefox\Profiles'
                        PSChildName         = 'xxxxxxxxxx.default'
                        PSDrive             = 'C'
                        PSProvider          = 'Microsoft.PowerShell.Core\FileSystem'
                        PSIsContainer       = $true
                        Mode                = 'd----'
                        ModeWithoutHardLink = 'd----'
                        BaseName            = 'xxxxxxxxxx.default'
                        Target              = ''
                        LinkType            = ''
                        Parent              = 'C:\Users\user\AppData\Roaming\Mozilla\Firefox\Profiles'
                        Root                = 'C:\'
                        FullName            = 'C:\Users\user\AppData\Roaming\Mozilla\Firefox\Profiles\xxxxxxxxxx.default'
                        Extension           = '.default'
                        Name                = 'xxxxxxxxxx.default'
                        Exists              = 'True'
                        CreationTime        = '03 / 25 / 17 23:44:25'
                        CreationTimeUtc     = '03 / 26 / 17 06:44:25'
                        LastAccessTime      = '06 / 06 / 21 22:32:13'
                        LastAccessTimeUtc   = '06 / 07 / 21 05:32:13'
                        LastWriteTime       = '06 / 06 / 21 22:32:13'
                        LastWriteTimeUtc    = '06 / 07 / 21 05:32:13'
                        Attributes          = 'Directory'
                    }
                    [PSCustomObject]@{
                        PSPath              = 'Microsoft.PowerShell.Core\FileSystem::C:\Users\user\AppData\Roaming\Mozilla\Firefox\Profiles\yyyyyyyyy.default-release'
                        PSParentPath        = 'Microsoft.PowerShell.Core\FileSystem::C:\Users\user\AppData\Roaming\Mozilla\Firefox\Profiles'
                        PSChildName         = 'yyyyyyyyy.default-release'
                        PSIsContainer       = $true
                        Mode                = 'd----'
                        ModeWithoutHardLink = 'd----'
                        BaseName            = 'yyyyyyyyy.default-release'
                        Target              = ''
                        LinkType            = ''
                        Parent              = 'C:\Users\user\AppData\Roaming\Mozilla\Firefox\Profiles'
                        Root                = 'C:\'
                        FullName            = 'C:\Users\user\AppData\Roaming\Mozilla\Firefox\Profiles\yyyyyyyyy.default-release'
                        Extension           = '.default-release'
                        Name                = 'yyyyyyyyy.default-release'
                        Exists              = 'True'
                        CreationTime        = '06 / 04 / 19 20:21:43'
                        CreationTimeUtc     = '06 / 05 / 19 03:21:43'
                        LastAccessTime      = '06 / 05 / 21 00:25:34'
                        LastAccessTimeUtc   = '06 / 05 / 21 07:25:34'
                        LastWriteTime       = '05 / 11 / 21 18:44:39'
                        LastWriteTimeUtc    = '05 / 12 / 21 01:44:39'
                        Attributes          = 'Directory'
                    }
                )
                Mock -CommandName Get-ChildItem -MockWith {
                    $ffProfileInfo
                } #endMock
            } #beforeEach
            It 'should return expected results if successful' {
                Get-FireFoxProfilePath -Path "$env:APPDATA\Mozilla\Firefox\Profiles" | Should -BeExactly 'C:\Users\user\AppData\Roaming\Mozilla\Firefox\Profiles\xxxxxxxxxx.default'
            } #it
        } #context_Success
    } #describe_PrivateFunctions
} #in_module
