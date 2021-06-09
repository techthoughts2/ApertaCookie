# ApertaCookie

[![Minimum Supported PowerShell Version](https://img.shields.io/badge/PowerShell-7.0+-black.svg)](https://github.com/PowerShell/PowerShell) [![PowerShell Gallery][psgallery-img]][psgallery-site] ![Cross Platform](https://img.shields.io/badge/platform-windows%20%7C%20macos%20%7C%20linux-orange) [![License][license-badge]](LICENSE)

[psgallery-img]:   https://img.shields.io/powershellgallery/dt/ApertaCookie?label=Powershell%20Gallery&logo=powershell
[psgallery-site]:  https://www.powershellgallery.com/packages/ApertaCookie
[license-badge]:   https://img.shields.io/github/license/techthoughts2/ApertaCookie

Branch | Windows | Linux | MacOS
--- | --- | --- | --- |
main | [![ApertaCookie-Windows-pwsh-Build-main](https://github.com/techthoughts2/ApertaCookie/actions/workflows/wf_Windows_Core.yml/badge.svg?branch=main)](https://github.com/techthoughts2/ApertaCookie/actions/workflows/wf_Windows_Core.yml) | [![ApertaCookie-Linux-Build-main](https://github.com/techthoughts2/ApertaCookie/actions/workflows/wf_Linux.yml/badge.svg?branch=main)](https://github.com/techthoughts2/ApertaCookie/actions/workflows/wf_Linux.yml) | [![ApertaCookie-MacOS-Build-main](https://github.com/techthoughts2/ApertaCookie/actions/workflows/wf_MacOS.yml/badge.svg?branch=main)](https://github.com/techthoughts2/ApertaCookie/actions/workflows/wf_MacOS.yml)
Enhancements | [![ApertaCookie-Windows-pwsh-Build-Enhancements](https://github.com/techthoughts2/ApertaCookie/actions/workflows/wf_Windows_Core.yml/badge.svg?branch=Enhancements)](https://github.com/techthoughts2/ApertaCookie/actions/workflows/wf_Windows_Core.yml) | [![ApertaCookie-Linux-Build-Enhancements](https://github.com/techthoughts2/ApertaCookie/actions/workflows/wf_Linux.yml/badge.svg?branch=Enhancements)](https://github.com/techthoughts2/ApertaCookie/actions/workflows/wf_Linux.yml) | [![ApertaCookie-MacOS-Build-Enhancements](https://github.com/techthoughts2/ApertaCookie/actions/workflows/wf_MacOS.yml/badge.svg?branch=Enhancements)](https://github.com/techthoughts2/ApertaCookie/actions/workflows/wf_MacOS.yml)

## Synopsis

ApertaCookie is a PowerShell module that can extract and decrypt cookie data from the SQLite files of several popular browsers.

## Description

ApertaCookie enables you to quickly extract the cookies from a browser's SQLite database using PowerShell.

Edge, Chrome, and Firefox are currently supported across Windows, Linux, and MacOS for retrieving raw cookie information. With the exception of Firefox, cookie values are encrypted. Cookie value decryption is currently supported on Windows OS.

[ApertaCookie](docs/ApertaCookie.md) provides the following functions:

* [Convert-CookieTime](docs/Convert-CookieTime.md)
* [Get-DecryptedCookiesInfo](docs/Get-DecryptedCookiesInfo.md)
* [Get-RawCookiesFromDB](docs/Get-RawCookiesFromDB.md)

### Cross-platform Cookie Decryption Support

ApertaCookie aims to be a fully cross-platform module. For Firefox, it currently is. Unfortunately, while you can still pull raw cookie information on Linux and MacOS, cookie value decryption is not currently possible. See the issues tab if you have experience with PBKDF2 and .NET Core ```System.Security.Cryptography``` to see how you can improve ApertaCookie!

OS | Edge | Chrome | Firefox
:------------ | :-------------| :-------------| :-------------
Windows | :white_check_mark: |  :white_check_mark: | :heavy_check_mark: *no decrypt  required*
Linux | :x: |  :x: | :heavy_check_mark: *no decrypt  required*
MacOS | :x: |  :x: | :heavy_check_mark: *no decrypt  required*



## Why

Using PowerShell you can now quickly query the cookies database of several browsers. You can also quickly load desired cookies into a websession for a variety of use cases.

## Installation

### Prerequisites

* [PowerShell 7.0.0](https://github.com/PowerShell/PowerShell) *(or higher version)*

### Installing ApertaCookie via PowerShell Gallery

```powershell
#from a 7.0.0+ PowerShell session
Install-Module -Name "ApertaCookie" -Scope CurrentUser
```

## Quick start

```powershell
#------------------------------------------------------------------------------------------------
# import the ApertaCookie module
Import-Module -Name "ApertaCookie"
#------------------------------------------------------------------------------------------------
# get raw cookie information from chrome - cookie values are encrypted
$allChromeCookies = Get-RawCookiesFromDB -Browser Chrome
#------------------------------------------------------------------------------------------------
# get decrypted cookie information from edge
$edgeCookies = Get-DecryptedCookiesInfo -Browser Edge
#------------------------------------------------------------------------------------------------
# get decrypted cookie information from edge for a specific domain
$edgeCookies = Get-DecryptedCookiesInfo -Browser Edge -Domain facebook
#------------------------------------------------------------------------------------------------
# get decrypted cookie infromation from firefox for the twitter domain and load into a web session
$session = Get-DecryptedCookiesInfo -Browser Firefox -DomainName twitter -WebSession
#------------------------------------------------------------------------------------------------
# get information about various cookie time values
Convert-CookieTime -CookieTime 13267233550477440
# for firefox cookies specify the firefox switch
Convert-CookieTime -CookieTime 1616989552356002 -FirefoxTime
```

## Author

[Jake Morrison](https://twitter.com/JakeMorrison) - [https://www.techthoughts.info/](https://www.techthoughts.info/)

## Notes

## License

This project is [licensed under the MIT License](LICENSE).

## Changelog

Reference the [Changelog](.github/CHANGELOG.md)
