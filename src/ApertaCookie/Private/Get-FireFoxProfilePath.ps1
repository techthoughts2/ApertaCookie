
<#
.SYNOPSIS
    Retrieves the FireFox profile that has been written to most recently
.DESCRIPTION
    FireFox can have multiple profiles. This function finds the profile that has been written to most recently. This is likely a good indicator of the active (primary) profile.
.EXAMPLE
    Get-FireFoxProfilePath -Path $pathToFireFoxProfiles

    Returns the FireFox profile path that has been written to most recently.
.PARAMETER Path
    Path to FireFox Profiles
.OUTPUTS
    System.String
    -or
    System.Boolean
.NOTES
    Author: Jake Morrison - @jakemorrison - https://www.techthoughts.info/
    This isn't perfect. Open to better suggestions.
.COMPONENT
    ApertaCookie
#>
function Get-FireFoxProfilePath {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true,
            HelpMessage = 'Path to FireFox Profiles')]
        [string]
        $Path
    )

    Write-Verbose -Message ('Evaluating {0}' -f $Path)

    try {
        $itemSplat = @{
            Path        = $Path
            ErrorAction = 'Stop'
        }
        $recentProfile = Get-ChildItem @itemSplat | Where-Object { $_.PSIsContainer -and $_.Name -match '\.default' } | Sort-Object LastWriteTime -Descending | Select-Object -First 1
        Write-Verbose $recentProfile
    }
    catch {
        Write-Error $_
        return $false
    }

    Write-Verbose -Message ('Most recent FireFox profile: {0}' -f $recentProfile.FullName)

    return $recentProfile.FullName

} #Get-FireFoxProfilePath
