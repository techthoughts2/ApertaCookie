---
external help file: ApertaCookie-help.xml
Module Name: ApertaCookie
online version:
schema: 2.0.0
---

# Get-RawCookiesFromDB

## SYNOPSIS
Retrieves raw cookies from the specified SQLite database

## SYNTAX

```
Get-RawCookiesFromDB [-Browser] <String> [[-DomainName] <String>] [<CommonParameters>]
```

## DESCRIPTION
Uses PSSQLite to run a query against the specified SQLite database to retrieve cookies.
The database queried is discovered based on the specified browser.
If a domain is specified a query is run to return cookies that match that domain name.

## EXAMPLES

### EXAMPLE 1
```
Get-RawCookiesFromDB -Browser Edge
```

Returns all cookies in the Edge SQLLite database

### EXAMPLE 2
```
Get-RawCookiesFromDB -Browser Edge -Domain 'twitter'
```

Returns all cookies in the Edge SQLLite database that are like domain twitter

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.Management.Automation.PSCustomObject
## NOTES
Author: Jake Morrison - @jakemorrison - https://www.techthoughts.info/
Cookies that are returned are ENCRYPTED.
You will need to decrypt them.
Except FireFox.
FireFox cookies are not encrypted.

## RELATED LINKS
