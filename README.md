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

TBD

![ApertaCookie Gif Demo](media/ApertaCookie.gif "ApertaCookie in action")

## Description

TBD

[ApertaCookie](docs/ApertaCookie.md) provides the following functions:

* [Convert-CookieTime](docs/Convert-CookieTime.md)
* [Get-DecryptedCookiesInfo](docs/Get-DecryptedCookiesInfo.md)
* [Get-RawCookiesFromDB](docs/Get-RawCookiesFromDB.md)

## Why

TBD

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
#import the ApertaCookie module
Import-Module -Name "ApertaCookie"
#------------------------------------------------------------------------------------------------
# tbd

#------------------------------------------------------------------------------------------------
```

## Author

[Jake Morrison](https://twitter.com/JakeMorrison) - [https://techthoughts.info/](https://techthoughts.info/)

## Notes

## License

This project is [licensed under the MIT License](LICENSE).

## Changelog

Reference the [Changelog](.github/CHANGELOG.md)
