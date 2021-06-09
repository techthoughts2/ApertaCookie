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
    Describe 'Convert-CookieTime' -Tag Unit {
        BeforeAll {
            $WarningPreference = 'SilentlyContinue'
            $ErrorActionPreference = 'SilentlyContinue'
        } #beforeAll
        # Context 'Error' {
        # } #context_Error
        Context 'Success' {
            It 'should return expected results' {
                Convert-CookieTime -CookieTime 13267233550477440 | Should -BeOfType System.DateTime
                $eval = Convert-CookieTime -CookieTime 13267233550477440
                $eval.Ticks | Should -BeExactly 637583567504770000
            } #it
            It 'should return expected results' {
                Convert-CookieTime -CookieTime 1616989552356002 -FireFoxTime | Should -BeOfType System.DateTime
                $eval = Convert-CookieTime -CookieTime 1616989552356002 -FireFoxTime
                $eval.Ticks | Should -BeExactly 637525863523560000
            } #it
        } #context_Success
    } #describe_PrivateFunctions
} #in_module
