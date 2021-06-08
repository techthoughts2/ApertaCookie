<#
.SYNOPSIS
    Retrieves raw cookies from the specified SQLite database
.DESCRIPTION
    Uses PSSQLite to run a query against the specified SQLite database to retrieve cookies. The database queried is discovered based on the specified browser. If a domain is specified a query is run to return cookies that match that domain name.
.EXAMPLE
    Get-RawCookiesFromDB -Browser Edge

    Returns all cookies in the Edge SQLLite database
.EXAMPLE
    Get-RawCookiesFromDB -Browser Edge -Domain 'twitter'

    Returns all cookies in the Edge SQLLite database that are like domain twitter
.PARAMETER Browser
    Browser choice
.PARAMETER DomainName
    Domain to search for in Cookie Database
.OUTPUTS
    System.Management.Automation.PSCustomObject
.NOTES
    Author: Jake Morrison - @jakemorrison - https://www.techthoughts.info/
    Cookies that are returned are ENCRYPTED. You will need to decrypt them.
    Except FireFox. FireFox cookies are not encrypted.
.COMPONENT
    ApertaCookie
#>
function Get-RawCookiesFromDB {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true,
            HelpMessage = 'Browser choice')]
        [ValidateSet('Edge', 'Chrome', 'FireFox')]
        [string]
        $Browser,
        [Parameter(Mandatory = $false,
            HelpMessage = 'Domain to search for in Cookie Database')]
        [string]
        $DomainName
    )

    $cookies = $null

    $osCookieInfo = Get-OSCookieInfo -Browser $Browser
    if ($null -eq $osCookieInfo) {
        Write-Warning 'OS Cookie information was not located'
        return
    }

    $sqlPath = $osCookieInfo.SQLitePath
    $tableName = $osCookieInfo.TableName

    if ($DomainName) {
        switch ($Browser) {
            FireFox {
                $query = "SELECT `"_rowid_`",* FROM `"main`".`"$tableName`" WHERE `"host`" LIKE '%$DomainName%' ESCAPE '\' LIMIT 0, 49999;"
            }
            Default {
                $query = "SELECT `"_rowid_`",* FROM `"main`".`"$tableName`" WHERE `"host_key`" LIKE '%$DomainName%' ESCAPE '\' LIMIT 0, 49999;"
            }
        }

    }
    else {
        $query = "SELECT `"_rowid_`",* FROM `"main`".`"$tableName`" '\' LIMIT 0, 49999;"
    }

    Write-Verbose -Message ('Establishing SQLite connection to: {0}' -f $sqlPath)
    try {
        $cookiesSQL = New-SQLiteConnection -DataSource $sqlPath -ErrorAction 'Stop'
    }
    catch {
        throw $_
    }

    # examples of things that can be done with the connection:
    # $cookiesSQL.GetSchema()
    # $cookiesSQL.GetSchema("Tables")

    Write-Verbose -Message ('Running query {0} against {1}' -f $query, $sqlPath)
    try {
        $dataSource = $cookiesSQL.FileName
        $sqlSplat = @{
            Query       = $query
            DataSource  = $dataSource
            ErrorAction = 'Stop'
        }
        $cookies = Invoke-SqliteQuery @sqlSplat
    }
    catch {
        throw $_
    }
    finally {
        $cookiesSQL.Close()
        $cookiesSQL.Dispose()
    }

    Write-Verbose -Message 'Cookies retrieved from SQLite'

    return $cookies

} #Get-RawCookiesFromDB
