---
external help file: ApertaCookie-help.xml
Module Name: ApertaCookie
online version:
schema: 2.0.0
---

# Convert-CookieTime

## SYNOPSIS
Converts cookie epoch time to PowerShell dateTime object

## SYNTAX

```
Convert-CookieTime [-CookieTime] <Int64> [-FireFoxTime] [<CommonParameters>]
```

## DESCRIPTION
Cookies store time data in epoch seconds.
This function takes in epoch time and converts to a PowerShell dateTime object.

## EXAMPLES

### EXAMPLE 1
```
Convert-CookieTime -CookieTime 13267233550477440
```

Thursday, June 3, 2021 22:39:10

### EXAMPLE 2
```
Convert-CookieTime -CookieTime 1616989552356002 -FireFoxTime
```

Monday, March 29, 2021 03:45:52

## PARAMETERS

### -CookieTime
Chrome Based Time

```yaml
Type: Int64
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -FireFoxTime
Specify switch if converting from FireFox time

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

### System.DateTime
## NOTES
Author: Jake Morrison - @jakemorrison - https://www.techthoughts.info/
Chrome timestamp is formatted as the number of microseconds since January, 1601
FireFox does its time based on January, 1970
ISO 8601 EPOCH format

## RELATED LINKS
