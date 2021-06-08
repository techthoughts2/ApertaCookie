using namespace "System.Security.Cryptography"

<#
.SYNOPSIS
    Creates System.Security.Cryptography.AesGcm with provided key byte
.DESCRIPTION
    Creates System.Security.Cryptography.AesGcm with provided key byte from the decrypted Local State
.EXAMPLE
    New-WindowsAesGcm -WinDecrypt $key
.PARAMETER WinDecrypt
    Windows Local State Key
.OUTPUTS
    System.Bool
.NOTES
    Author: Jake Morrison - @jakemorrison - https://www.techthoughts.info/
    This was very hard to make.
    $Script:GCMKey should be used for decrypting cookies
.COMPONENT
    ApertaCookie
#>
function New-WindowsAesGcm {
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    param (
        [Parameter(Mandatory = $true,
            HelpMessage = 'Windows Local State Key')]
        [System.Object]
        $WinDecrypt

    )

    Write-Verbose -Message 'Creating AesGcm...'

    try {
        $Script:GCMKey = [AesGcm]::new($WinDecrypt)
        Write-Verbose -Message 'Decrypt Key loaded into script variable!'
    }
    catch {
        Write-Error $_
        return $false
    }

    return $true
} #New-WindowsAesGcm
