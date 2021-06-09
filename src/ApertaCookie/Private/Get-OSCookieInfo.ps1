<#
.SYNOPSIS
    Returns the correct path to the SQLite Cookie database and SQLite Table Name based on OS and Browser
.DESCRIPTION
    Evaluates the provided browser and OS and returns the known location for the SQLite Cookie Database and SQLite Table Name
.EXAMPLE
    Get-OSCookieInfo -Browser 'Chrome'

    Returns SQLite Cookie Database path for OS that function is run on as well as SQLite Table Name
.PARAMETER Browser
    Browser choice
.OUTPUTS
    System.Management.Automation.PSCustomObject
.NOTES
    Author: Jake Morrison - @jakemorrison - https://www.techthoughts.info/
.COMPONENT
    ApertaCookie
#>
function Get-OSCookieInfo {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true,
            HelpMessage = 'Browser choice')]
        [ValidateSet('Edge', 'Chrome', 'FireFox')]
        [string]
        $Browser
    )

    Write-Verbose -Message ('Browser: {0}' -f $Browser)

    if ($IsWindows) {
        Write-Verbose -Message 'Windows Detected'
        switch ($Browser) {
            Edge {
                $sqlPath = "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Cookies"
                $tableName = 'cookies'
            }
            Chrome {
                $sqlPath = "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Cookies"
                $tableName = 'cookies'
            }
            FireFox {
                # TODO: check database lock. you may have to copy the file
                $profilePath = Get-FireFoxProfilePath -Path "$env:APPDATA\Mozilla\Firefox\Profiles"
                if ($profilePath) {
                    $sqlPath = "$profilePath\cookies.sqlite"
                    $tableName = 'moz_cookies'
                }
                else {
                    # TODO: ERROR CONTROL
                }
            }
        }
    } #if_Windows
    elseif ($IsLinux) {
        Write-Verbose -Message 'Linux Detected'
        switch ($Browser) {
            Edge {
                $sqlPath = "$env:HOME/.config/microsoft-edge-beta/Default/Cookies"
                $tableName = 'cookies'
            }
            Chrome {
                $sqlPath = "$env:HOME/.config/google-chrome/Default/Cookies"
                $tableName = 'cookies'
            }
            FireFox {
                $profilePath = Get-FireFoxProfilePath -Path "$env:HOME/.mozilla/firefox"
                if ($profilePath) {
                    $sqlPath = "$profilePath/cookies.sqlite"
                    $tableName = 'moz_cookies'
                }
                else {
                    # TODO: ERROR CONTROL
                }
            }
        }
    } #elseif_Linux
    elseif ($IsMacOS) {
        Write-Verbose -Message 'OSX Detected'
        switch ($Browser) {
            Edge {
                $sqlPath = "$env:HOME/Library/Application Support/Microsoft Edge/Default/Cookies"
                $tableName = 'cookies'
            }
            Chrome {
                $sqlPath = "$env:HOME/Library/Application Support/Google/Chrome/Default/Cookies"
                $tableName = 'cookies'
            }
            FireFox {
                $profilePath = Get-FireFoxProfilePath -Path "$env:HOME/Library/Application Support/Firefox/Profiles"
                if ($profilePath) {
                    $sqlPath = "$profilePath/cookies.sqlite"
                    $tableName = 'moz_cookies'
                }
                else {
                    # TODO: ERROR CONTROL
                }

            }
        }
    } #elseif_OSX

    Write-Verbose -Message ('SQLite Path: {0}' -f $sqlPath)
    Write-Verbose -Message ('Table Name: {0}' -f $tableName)

    $obj = [PSCustomObject]@{
        SQLitePath = $sqlPath
        TableName  = $tableName
    }

    return $obj

} #Get-OSCookieInfo
