# Oneroster API to CSV for MS SDS

This script calls against a Oneroster compliant API to build CSV files compatible with the UK standard CSV required by Microsoft School Data Sync.  

This includes modifiable functions for creating bespoke blacklists for unsuitable or uncompliant content with MS SDS.

## Dependancies

This script relies on:  
* 'ConvertFrom-K12' function from [ad-user-provisioning](https://github.com/the-glasgow-academy/ad-user-provisioning)
* [pwsh-module-api-wrapper](https://github.com/the-glasgow-academy/pwsh-module-api-wrapper)
