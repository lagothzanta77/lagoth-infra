# Windows ISO assimilator extension

## Features

This ISO manipulator offers the following features:

  * [Windows server (based on MS installer)](https://www.microsoft.com/en-us/windows-server)
  * [CloudBase-Init installer with config files](https://cloudbase.it/cloudbase-init/)
  * [A cumulative patch for Windows Server](https://www.catalog.update.microsoft.com/home.aspx)
  * [VMware Tools installer](https://docs.vmware.com/en/VMware-Tools/index.html)
  * Assimilator (this is my unique tool to control the whole installation process)
  * [Windows Admin Center installer](https://www.microsoft.com/en-us/windows-server/windows-admin-center)
  * [PSWindowsUpdate](https://github.com/mgajda83/PSWindowsUpdate)

## Requirements

  * Windows Server original `ISO` file
  * Cloudbase init installer `msi` file
  * Windows Admin center `msi` file
  * Uncompressed VMware Tools installer (this can be found on ESXi Host)
  * Cumulative patch `msu` file
  * Credential file in txt format containing the admin password as a PWSH SecureString

## Usage

  * `bash generiso.sh`

**This repo is only a so-called demo version so some folders/files are not available.**
(for example borg_library)
