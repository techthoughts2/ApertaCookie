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
    Describe 'Get-RawCookiesFromDB' -Tag Unit {
        BeforeAll {
            $WarningPreference = 'SilentlyContinue'
            $ErrorActionPreference = 'SilentlyContinue'
        } #beforeAll
        BeforeEach {
            Mock -CommandName Get-OSCookieInfo -MockWith {
                [PSCustomObject]@{
                    SQLitePath = 'apath'
                    TableName  = 'cookies'
                }
            } #endMock
        } #beforeEach
        Context 'Error' {
            It 'should return null of the cookie path can not be determined' {
                Mock -CommandName Get-OSCookieInfo -MockWith {
                    $null
                } #endMock
                Get-RawCookiesFromDB -Browser 'Edge' | Should -BeNullOrEmpty
            } #it
            It 'should throw if a sqlite connection cannot be established' {
                Mock -CommandName New-SQLiteConnection -MockWith {
                    throw 'Fake Error'
                } #endMock
                { Get-RawCookiesFromDB -Browser 'Edge' } | Should -Throw
            } #it
            It 'should throw if the database encounters an error running the query' {
                Mock -CommandName New-SQLiteConnection -MockWith {
                    $sqlite = [System.Data.SQLite.SQLiteConnection]::new()
                    $sqlite.ConnectionString = 'Data Source=C:\Users\user\AppData\Local\Google\Chrome\UserData\Default\Cookies'
                    $sqlite.ParseViaFramework = $true
                    $sqlite.Flags = 'Default'
                    $sqlite
                } #endMock
                Mock -CommandName Invoke-SqliteQuery -MockWith {
                    throw 'Fake Error'
                } #endMock
                { Get-RawCookiesFromDB -Browser 'FireFox' } | Should -Throw
            } #it
        } #context_Error
        # Context 'Success' {
        # Doesn't seem to be a good way to be able to mock the sqlite connections
        # the close() and dispose() don't work correctly
        # }#context_Success
    }#describe_PrivateFunctions
}
