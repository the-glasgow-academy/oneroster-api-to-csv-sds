# Oneroster API to CSV for MS SDS

This script calls against a Oneroster compliant API to build CSV files compatible with the UK standard CSV required by Microsoft School Data Sync.  

This includes modifiable filters for creating bespoke blacklists for unsuitable or uncompliant content with MS SDS.

## Usage

Requires: PowerShell Core (linux/mac/windows)

```
$VerbosePreference = 'continue'
$env:OR_URL = 'https://my-oneroster-api/ims/oneroster/v1p1'
$env:OR_CI = read-host #api client id
$env:OR_CS = read-host #api client secret

. ./ConvertFrom-K12.ps1
./sds-ms.ps1
```

This will generate 6 csvs under ./csv-sds folder. Upload these to you MS SDS profile.


## Omit entries

You may need to omit results from being added to your MS SDS sync, 
editing the `where-object` options under the `$blacklistUsers` 
and `$blacklistClasses` will allow you to remove entries based on any
available source values.

