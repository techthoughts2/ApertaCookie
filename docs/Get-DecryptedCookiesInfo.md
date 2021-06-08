---
external help file: ApertaCookie-help.xml
Module Name: ApertaCookie
online version:
schema: 2.0.0
---

# Get-DecryptedCookiesInfo

## SYNOPSIS
Retrieves cookies from SQLite database of specified browser and decrypts encrypted cookie values.
Returns web session if specified.

## SYNTAX

```
Get-DecryptedCookiesInfo [-Browser] <String> [[-DomainName] <String>] [-WebSession] [<CommonParameters>]
```

## DESCRIPTION
Queries SQLite cookies database for browser specified and retrieves all cookies.
If domain is specified, retrieves only cookies that match domain.
If cookies have encrypted contents, they are decrypted.

## EXAMPLES

### EXAMPLE 1
```
Get-DecryptedCookiesInfo -Browser Edge
```

Returns all cookie information from Edge - cookies are decrypted.

### EXAMPLE 2
```
Get-DecryptedCookiesInfo -Browser FireFox
```

Returns all cookie information from Firefox.
Note: no decryption takes place as FireFox cookies are not encrypted.

### EXAMPLE 3
```
$session = Get-DecryptedCookiesInfo -Browser Chrome -WebSession -Domain twitter
```

Cookies found in the Chrome cookie database that match twitter are loaded into a WebSession and returned for use.

### EXAMPLE 4
```
$session = Get-DecryptedCookiesInfo -Browser FireFox -WebSession -Domain facebook
$response = Invoke-WebRequest -Uri "https://m.facebook.com/119812241410296" -WebSession $session
```

Cookies found in the FireFox cookie database that match facebook are loaded into a WebSession and that websession is used to visit the Facebook PowerShell page.

## PARAMETERS

### -Browser
Browser choice

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DomainName
Domain to search for in Cookie Database

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WebSession
If specified cookies are loaded into a Microsoft.PowerShell.Commands.WebRequestSession and returned for session use.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.Management.Automation.PSCustomObject
### -or-
### Microsoft.PowerShell.Commands.WebRequestSession
## NOTES
Author: Jake Morrison - @jakemorrison - https://www.techthoughts.info/
It took a lot longer to make this than I thought it would.
Only up to 300 cookies can be loaded into a WebSession.
Cookie decryption is currently only supported on Windows.
Visit https://github.com/techthoughts2/ApertaCookie to see how you can contribute to Linux and MacOS cookie decryption.

## RELATED LINKS
