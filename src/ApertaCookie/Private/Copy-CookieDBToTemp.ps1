<#
.SYNOPSIS
    Copies specified cookies sqlite database to temp directory
.DESCRIPTION
    Copies specified cookies sqlite database to temp directory to avoid issues related to a browser having a file lock on the original database.
.EXAMPLE
    Copy-CookieDBToTemp -SQLitePath $pathToCookieDB

    Copies browser cookie SQLite DB to temp dir location.
.PARAMETER SQLitePath
    Path of SQLite Cookie DB to copy
.OUTPUTS
    System.String
    -or-
    System.Boolean
.NOTES
    Author: Jake Morrison - @jakemorrison - https://www.techthoughts.info/
    This is a necessary action to prevent issues where the browser has a lock on the orignal databse.
    In testing I noticed that Linux was especially sensitive to this.
    Although I also saw the freeze behavior on Windows when querying FireFox.
    This copy action shifts ApertaCookie to querying the copy instead of the primary database.
.COMPONENT
    ApertaCookie
#>
function Copy-CookieDBToTemp {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true,
            HelpMessage = 'Path of SQLite Cookie DB to copy')]
        [string]
        $SQLitePath
    )

    $tempDir = [System.IO.Path]::GetTempPath()
    $tempPath = $tempDir + 'apertacookie'
    Write-Verbose -Message ('Evaluating temp location: {0}' -f $tempPath)

    if (-not(Test-Path -Path $tempPath)) {
        Write-Verbose -Message 'Creating ApertaCookie directory in temp location...'
        try {
            $newItemSplat = @{
                ItemType    = 'Directory'
                Force       = $true
                Path        = $tempPath
                ErrorAction = 'Stop'
            }
            New-Item @newItemSplat | Out-Null
            Write-Verbose -Message 'Temp directory created.'
        }
        catch {
            Write-Error $_
            return $false
        }

    }
    else {
        Write-Verbose -Message 'Temp path confirmed.'
    }

    Write-Verbose -Message 'Initiating Cookie DB copy...'
    Write-Verbose -Message ('Copying from: {0}' -f $SQLitePath)
    Write-Verbose -Message ('Copying to: {0}' -f $tempPath)

    try {
        $copySplat = @{
            Path        = $SQLitePath
            Destination = $tempPath
            Force       = $true
            Confirm     = $false
            PassThru    = $true
            ErrorAction = 'Stop'
        }
        $results = Copy-Item @copySplat
        $fullName = $results.FullName
    }
    catch {
        Write-Error $_
        return $false
    }

    Write-Verbose -Message ('Returning full copy path: {0}' -f $fullName)

    return $fullName

} #Copy-CookieDBToTemp
