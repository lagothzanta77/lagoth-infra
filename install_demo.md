# VMware ESX(i) Automated install youtube videos with Terrafrom admin workstation and iSCSI target in ~75 minutes and some configuration check and example usage in ~35 minutes

## Automated section (except the adding of the new virtual disk on the iSCSI target)

| title                                                                                                                | startpos (hh:mm)| endpos(hh:mm)| length (min)|
|----------------------------------------------------------------------------------------------------------------------|-----------------|--------------|-------------|
| [Start the script to prepare the Template VM and create the Terraform admin client...](https://youtu.be/1RBBLMw1hkI) | 00:00           | 00:03        | 03          |
| ...Complete the setup of the admin client                                            | 00:07           | 00:14        | 07          |
| Create the iSCSI target VM with disks for datastores...                              | 00:14           | 00:23        | 09          |
| ...Complete the setup of the iSCSI target VM]                                         | 00:28           | 00:33        | 05          |
| Create the BorgESXi...                                                               | 00:33           | 00:46        | 13          |
| ...**install a new virtual disk on iSCSI target** Complete the BorgESXi installation | 01:03           | 01:13        | 10          |

## Configuration section

| title                                                                                                                                       | startpos (hh:mm)| endpos(hh:mm)| length (min)|
|---------------------------------------------------------------------------------------------------------------------------------------------|-----------------|--------------|-------------|
| Define the new installed virtual disk on iSCSI target to expand a datastore | 01:13           | 01:23        | 10          |
| Create the borgVM 01 using Terraform on the BorgESXi                                                        | 01:22           | 01:36        | 14          |
| Complete and check the borgVM 01 and the network topology and shutdown the whole infrastructure after this. | 01:36           | 01:49        | 13          |

