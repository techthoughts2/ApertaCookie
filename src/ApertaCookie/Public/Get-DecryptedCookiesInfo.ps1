<#
.SYNOPSIS
    Retrieves cookies from SQLite database of specified browser and decrypts encrypted cookie values. Returns web session if specified.
.DESCRIPTION
    Queries SQLite cookies database for browser specified and retrieves all cookies. If domain is specified, retrieves only cookies that match domain. If cookies have encrypted contents, they are decrypted.
.EXAMPLE
    Get-DecryptedCookiesInfo -Browser Edge

    Returns all cookie information from Edge - cookies are decrypted.
.EXAMPLE
    Get-DecryptedCookiesInfo -Browser FireFox

    Returns all cookie information from Firefox. Note: no decryption takes place as FireFox cookies are not encrypted.
.EXAMPLE
    $session = Get-DecryptedCookiesInfo -Browser Chrome -WebSession -Domain twitter

    Cookies found in the Chrome cookie database that match twitter are loaded into a WebSession and returned for use.
.EXAMPLE
    $session = Get-DecryptedCookiesInfo -Browser FireFox -WebSession -Domain facebook
    $response = Invoke-WebRequest -Uri "https://m.facebook.com/119812241410296" -WebSession $session

    Cookies found in the FireFox cookie database that match facebook are loaded into a WebSession and that websession is used to visit the Facebook PowerShell page.
.PARAMETER Browser
    Browser choice
.PARAMETER DomainName
    Domain to search for in Cookie Database
.PARAMETER WebSession
    If specified cookies are loaded into a Microsoft.PowerShell.Commands.WebRequestSession and returned for session use.
.OUTPUTS
    System.Management.Automation.PSCustomObject
    -or-
    Microsoft.PowerShell.Commands.WebRequestSession
.NOTES
    Author: Jake Morrison - @jakemorrison - https://www.techthoughts.info/
    It took a lot longer to make this than I thought it would.
    Only up to 300 cookies can be loaded into a WebSession.
    Cookie decryption is currently only supported on Windows.
    Visit https://github.com/techthoughts2/ApertaCookie to see how you can contribute to Linux and MacOS cookie decryption.
.COMPONENT
    ApertaCookie
#>
function Get-DecryptedCookiesInfo {
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
        $DomainName,
        [Parameter(HelpMessage = 'If specified cookies are loaded into a Microsoft.PowerShell.Commands.WebRequestSession and returned for session use.')]
        [switch]
        $WebSession
    )

    Write-Verbose -Message 'Retrieving raw cookies from SQLite database...'
    try {
        if ($DomainName) {
            $cookies = Get-RawCookiesFromDB -Browser $Browser -DomainName $DomainName -ErrorAction 'Stop'
        }
        else {
            $cookies = Get-RawCookiesFromDB -Browser $Browser -ErrorAction 'Stop'
        }
    }
    catch {
        throw $_
    }

    if ($null -eq $cookies) {
        Write-Warning -Message 'No cookies were returned from the SQLite database!'
        return
    }

    if ($Browser -eq 'FireFox') {
        Write-Verbose -Message 'FireFox specified. No cookie decryption is necessary.'
        if ($WebSession) {
            Write-Verbose -Message ('Cookie Count: {0}' -f $cookies.Count)
            if ($cookies.Count -gt 300) {
                throw 'Only up to 300 cookies can be loaded into a WebSession.'
            }

            Write-Verbose -Message 'WebSession specified. Loading cookies into WebSession.'
            $session = New-Object Microsoft.PowerShell.Commands.WebRequestSession

            foreach ($cookie in $cookies) {
                $newCookie = New-Object System.Net.Cookie

                $newCookie.Name = $cookie.name
                $newCookie.Value = $cookie.value
                $newCookie.Domain = $cookie.host

                try {
                    $session.Cookies.Add($newCookie)
                }
                catch {
                    Write-Warning -Message "$($cookie.name) could not be loaded into the session. Skipping."
                }

            } #foreach_cookies

            return $session

        } #if_websession
        else {

            return $cookies

        } #else_websession
    } #if_FireFox

    Write-Verbose -Message 'Getting Cookie decryption key...'

    if ($IsWindows) {
        Write-Verbose -Message 'Windows detected...'
        $cookiesKey = Get-WindowsCookieDecryptKey -Browser $Browser
        if ($cookiesKey -eq $false) {
            throw 'Cookie decryption key not retrieved successfully'
        }
        #sets the script level decryption key
        $decryptEval = New-WindowsAesGcm -WinDecrypt $cookiesKey
        if ($decryptEval -ne $true) {
            throw 'AesGcm Cookie decryption key not created successfully'
        }
    }
    elseif ($IsLinux) {
        Write-Verbose -Message 'Linux detected...'
        #TODO: Add Linux cookie decrypt support
        Write-Warning -Message 'Linux cookie decryption is not currently supported'
        return
    }
    elseif ($IsMacOS) {
        Write-Verbose -Message 'MacOS detected...'
        #TODO: Add MacOS support
        Write-Warning -Message 'MacOS cookie decryption is not currently supported'
        return
    }
    else {
        throw 'Unsupported OS. Windows / Linux / OSX'
    }

    Write-Verbose -Message 'Decrypting cookies...'
    foreach ($cookie in $cookies) {
        $temp = $null
        $temp = Unprotect-Cookie -Cookie $cookie.encrypted_value
        $cookie | Add-Member -NotePropertyName decrypted_value -NotePropertyValue $temp
    }
    Write-Verbose -Message 'Cookies decryption completed.'

    if ($WebSession) {
        Write-Verbose -Message ('Cookie Count: {0}' -f $cookies.Count)
        if ($cookies.Count -gt 300) {
            throw 'Only up to 300 cookies can be loaded into a WebSession.'
        }

        Write-Verbose -Message 'WebSession specified. Loading cookies into WebSession.'
        $session = New-Object Microsoft.PowerShell.Commands.WebRequestSession

        foreach ($cookie in $cookies) {
            $newCookie = New-Object System.Net.Cookie

            $newCookie.Name = $cookie.name
            $newCookie.Value = $cookie.decrypted_value
            $newCookie.Domain = $cookie.host_key

            try {
                $session.Cookies.Add($newCookie)
            }
            catch {
                Write-Warning -Message "$($cookie.name) could not be loaded into the session. Skipping."
            }

        } #foreach_cookies

        return $session

    } #if_websession
    else {
        return $cookies
    } #else_websession

} #Get-DecryptedCookiesInfo
