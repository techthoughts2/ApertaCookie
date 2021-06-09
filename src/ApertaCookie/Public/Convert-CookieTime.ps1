<#
.SYNOPSIS
    Converts cookie epoch time to PowerShell dateTime object
.DESCRIPTION
    Cookies store time data in epoch seconds. This function takes in epoch time and converts to a PowerShell dateTime object.
.EXAMPLE
    Convert-CookieTime -CookieTime 13267233550477440

    Thursday, June 3, 2021 22:39:10
.EXAMPLE
    Convert-CookieTime -CookieTime 1616989552356002 -FireFoxTime

    Monday, March 29, 2021 03:45:52
.PARAMETER CookieTime
    Chrome Based Time
.PARAMETER FireFoxTime
    Specify switch if converting from FireFox time
.OUTPUTS
    System.DateTime
.NOTES
    Author: Jake Morrison - @jakemorrison - https://www.techthoughts.info/
    Chrome timestamp is formatted as the number of microseconds since January, 1601
    FireFox does its time based on January, 1970
    ISO 8601 EPOCH format
.COMPONENT
    ApertaCookie
#>
function Convert-CookieTime {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true,
            HelpMessage = 'Chrome Based Time')]
        [Int64]
        $CookieTime,
        [Parameter(HelpMessage = 'Specify switch if converting from FireFox time')]
        [switch]
        $FireFoxTime
    )

    # 01/01/1601 00:00:00 - Chrome time date to vet against
    # 13267233550477440 - time input to expect

    # 01/01/1970 00:00:00 - firefox time date to vet against
    # 1616989552356002 - firefox time input

    Write-Verbose -Message 'Converting cookie time to dateTime!'

    if ($FireFoxTime) {
        Write-Verbose -Message 'FireFox detected. Taking us back to 1970! Groovy!'
        [datetime]$baseTime = '01/01/1970 00:00:00'
    }
    else {
        Write-Verbose -Message 'Taking us back to 1601!'
        [datetime]$baseTime = '01/01/1601 00:00:00'
    }

    $seconds = $CookieTime / 1000000
    [dateTime]$convertedTime = $baseTime.AddSeconds($seconds)

    return $convertedTime
} #Convert-CookieTime
