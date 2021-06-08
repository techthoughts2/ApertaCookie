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
Add-Type -AssemblyName System.Security

[Reflection.Assembly]::LoadWithPartialName("System.Security")
$rijndael = New-Object System.Security.Cryptography.RijndaelManaged
$rijndael.GenerateKey()
$cookiesKeyEncBaseSixtyFour = ([Convert]::ToBase64String($rijndael.Key))
$rijndael.Dispose()

$json = @"
{
    "os_crypt": {
        "encrypted_key": "$cookiesKeyEncBaseSixtyFour"
    }
}
"@

InModuleScope $ModuleName {
    Describe 'Get-WindowsCookieDecryptKey' -Tag Unit {
        BeforeAll {
            $WarningPreference = 'SilentlyContinue'
            $ErrorActionPreference = 'SilentlyContinue'
        } #beforeAll
        Context 'Error' {
            It 'should return false if an error is encountered getting file content' {
                Mock -CommandName Get-Content -MockWith {
                    throw 'Fake Error'
                } #endMock
                Get-WindowsCookieDecryptKey -Browser 'Edge' | Should -BeExactly $false
            } #it
        } #context_Error
        Context 'Success' {
            It 'should return null if FireFox is specified' {
                Get-WindowsCookieDecryptKey -Browser 'FireFox' | Should -BeNullOrEmpty
            } #it
            # It 'should return expected results if no issues are encountered {
            # !there doesn't seem to be a way to mock the .NET Cryptography calls
            # } #it
        } #context_Success
    } #describe_PrivateFunctions
} #in_module
