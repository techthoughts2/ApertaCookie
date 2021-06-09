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
    Describe 'Copy-CookieDBToTemp' -Tag Unit {
        BeforeAll {
            $WarningPreference = 'SilentlyContinue'
            $ErrorActionPreference = 'SilentlyContinue'
            $sqlitePath = 'pathto\cookies.sqlite'
        } #beforeAll
        Context 'Error' {
            It 'should return false if the temp dir can not be created' {
                Mock -CommandName Test-Path -MockWith {
                    $false
                } #endMock
                Mock -CommandName New-Item -MockWith {
                    throw 'Fake Error'
                } #endMock
                Copy-CookieDBToTemp -SQLitePath $sqlitePath | Should -BeExactly $false
            } #it
            It 'should return false if the sqlite db can not be copied' {
                Mock -CommandName Test-Path -MockWith {
                    $false
                } #endMock
                Mock -CommandName New-Item -MockWith {
                    $null
                } #endMock
                Mock -CommandName Copy-Item -MockWith {
                    throw 'Fake Error'
                } #endMock
                Copy-CookieDBToTemp -SQLitePath $sqlitePath | Should -BeExactly $false
            } #it
        } #context_Error
        Context 'Success' {
            BeforeEach {
                Mock -CommandName Test-Path -MockWith {
                    $true
                } #endMock
                Mock -CommandName New-Item -MockWith {
                    $null
                } #endMock
                Mock -CommandName Copy-Item -MockWith {
                    [PSCustomObject]@{
                        PSPath              = 'Microsoft.PowerShell.Core\FileSystem::C:\test\copytest\b\cookies.sqlite'
                        PSParentPath        = 'Microsoft.PowerShell.Core\FileSystem::C:\test\copytest\b'
                        PSChildName         = 'zeddb.txt'
                        PSDrive             = 'C'
                        PSProvider          = 'Microsoft.PowerShell.Core\FileSystem'
                        PSIsContainer       = 'False'
                        Mode                = '-a---'
                        ModeWithoutHardLink = '-a---'
                        BaseName            = 'cookies'
                        DirectoryName       = 'C:\test\copytest\b'
                        Directory           = 'C:\test\copytest\b'
                        IsReadOnly          = 'False'
                        FullName            = 'C:\test\copytest\b\cookies.sqlite'
                        Extension           = '.txt'
                        Name                = 'cookies.sqlite'
                        Exists              = 'True'
                        CreationTime        = '06/08/21 17:46:15'
                        CreationTimeUtc     = '06/09/21 00:46:15'
                        LastAccessTime      = '06/08/21 17:46:15'
                        LastAccessTimeUtc   = '06/09/21 00:46:15'
                        LastWriteTime       = '06/08/21 17:44:13'
                        LastWriteTimeUtc    = '06/09/21 00:44:13'
                        Attributes          = 'Archive'
                    }
                } #endMock
            } #beforeEach
            It 'should return false if the sqlite db can not be copied' {
                $eval = Copy-CookieDBToTemp -SQLitePath $sqlitePath
                $eval | Should -BeExactly 'C:\test\copytest\b\cookies.sqlite'
            } #it
        } #context_Success
    } #describe_PrivateFunctions
}
