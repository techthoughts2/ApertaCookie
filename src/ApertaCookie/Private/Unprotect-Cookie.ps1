<#
.SYNOPSIS
    Takes in cookie encrypted byte encrypted_value and returns decrypted cookie value
.DESCRIPTION
    Using the GCMKey decrypt key returns decrypted cookie value from a provided cookie encrypted_value byte value
.EXAMPLE
    Unprotect-Cookie -Cookie $cookies[0].encrypted_value -Verbose

    Decrypts the provided cookie byte
.PARAMETER Cookie
    Encrypted cookie value in byte format
.OUTPUTS
    System.String
.NOTES
    Author: Jake Morrison - @jakemorrison - https://www.techthoughts.info/
    Use GCM decrytpion if ciphertext starts "V10" & GCMKey exists, else try ProtectedData.unprotect
    Requires Get-CookieDecryptKey to have already been run to load $Script:GCMKey
    Some of this code was inspired from Read-Chromium by James O'Neill:
        https://www.powershellgallery.com/packages/Read-Chromium/1.0.0/Content/Read-Chromium.ps1
.COMPONENT
    ApertaCookie
#>
function Unprotect-Cookie {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true,
            HelpMessage = 'Encrypted cookie value in byte format')]
        [System.Object]
        $Cookie
    )

    Write-Verbose -Message 'Decrypting cookie...'

    try {
        if ($Script:GCMKey -and [string]::new($Cookie[0..2]) -match "v1\d") {
            Write-Verbose -Message 'AesGcm decrypt'
            #Ciphertext bytes run 0-2="V10"; 3-14=12_byte_IV; 15 to len-17=payload; final-16=16_byte_auth_tag
            $output = [System.Byte[]]::new($Cookie.length - 31) # same length as payload.

            #_____________________________________________________________________________________________
            # https://docs.microsoft.com/en-us/dotnet/api/system.security.cryptography.aesgcm?view=net-5.0
            $Script:GCMKey.Decrypt(
                $Cookie[3..14],
                $Cookie[15..($Cookie.Length - 17)],
                $Cookie[-16..-1],
                $output,
                $null)
            [string]::new($output)
            #_____________________________________________________________________________________________

        }
        else {
            Write-Verbose -Message 'Attempting CurrentUser decryption method'
            [string]::new([ProtectedData]::Unprotect($Cookie, $null, 'CurrentUser'))
        }
    }
    catch {
        Write-Warning $_
    }
} #Unprotect-Cookie
