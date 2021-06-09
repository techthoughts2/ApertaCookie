<#
.SYNOPSIS
    Retrievs the primary cookie decryption key for Edge or Chrome cookies
.DESCRIPTION
    Queries the Local State and uses the currentuser context to decrypt the cookies key which can be used to decrypt cookies. This decrypt context can then be loaded into an AesGcm in the context of $Script:GCMKey
.EXAMPLE
    Get-WindowsCookieDecryptKey -Browser Edge

    Retrieves the cookie decryption key using the currentuser context for Edge
.PARAMETER Browser
    Browser choice
.OUTPUTS
    System.Byte
.NOTES
    Author: Jake Morrison - @jakemorrison - https://www.techthoughts.info/
    This was very hard to make.
    $Script:GCMKey should be used for decrypting cookies
.COMPONENT
    ApertaCookie
#>
function Get-WindowsCookieDecryptKey {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true,
            HelpMessage = 'Browser choice')]
        [ValidateSet('Edge', 'Chrome', 'FireFox')]
        [string]
        $Browser
    )

    Write-Verbose -Message ('Browser: {0}' -f $Browser)

    switch ($Browser) {
        Edge {
            $statePath = "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Local State"
        }
        Chrome {
            $statePath = "$env:LOCALAPPDATA\Google\Chrome\User Data\Local State"
        }
        FireFox {
            Write-Verbose -Message 'No state decryption needed for FireFox. Skipping'
            return
        }
    }

    Write-Verbose -Message ('Retrieving content from {0}' -f $statePath)
    try {
        $contentSplat = @{
            Path        = $statePath
            ErrorAction = 'Stop'
        }
        $cookiesKeyEncBaseSixtyFourRaw = Get-Content @contentSplat
    }
    catch {
        Write-Error $_
        return $false
    }

    Write-Verbose -Message 'Converting from JSON...'
    $cookiesKeyEncBaseSixtyFour = ($cookiesKeyEncBaseSixtyFourRaw | ConvertFrom-Json -AsHashtable).'os_crypt'.'encrypted_key'
    Write-Verbose -Message 'Converting from Base64...'
    $cookiesKeyEnc = [System.Convert]::FromBase64String($cookiesKeyEncBaseSixtyFour) | Select-Object -Skip 5  # Magic number 5

    Write-Verbose -Message 'Running Unprotect...'
    try {
        $cookiesKey = [System.Security.Cryptography.ProtectedData]::Unprotect($cookiesKeyEnc, $null, [System.Security.Cryptography.DataProtectionScope]::CurrentUser)
    }
    catch {
        Write-Error $_
        return $false
    }

    return $cookiesKey

} #Get-WindowsCookieDecryptKey
