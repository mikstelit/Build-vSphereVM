# Build-vSphereVM

## Overview

Build-vSphereVM builds a virtual machine in vSphere, adds the virtual machine to SCCM, and starts the virtual machine with the SCCM boot media in the optical drive.  When the virtual machine is added to SCCM, the virtual machine is placed in a collection that should have a task sequence deployed to it that will install the operating system.

## System Requirements

Successfully running the script requires PowerShell version 3 or higher, vMware's PowerCLI, Microsoft's Configuration Management module, and a CSV file with specifications of the virtual machine(s) to be built.  The installer for vMware's PowerCLI (version 6.3) can be found in the Resources folder of the project.  Microsoft's Configuration Management module is installed when the Configuration Manager console is installed, but the module's installer can also be found in the Resources folder of the project.  The first row of the CSV should look like this:

	VMName,CPUs,RAM,DiskSizeMB,DiskProvisioning,ISO,Cluster,DataStore,GuestID,VLAN

A new line for each virtual machine should be added to the CSV with specifications for that virtual machine.  If a column is left blank, the script will prompt the user for that information.  Here are the contents of an example CSV file:

	VMName,CPUs,RAM,DiskSizeMB,DiskProvisioning,ISO,Cluster,DataStore,GuestID,VLAN
	Server1,4,16384,81920,Thin,,,,,,
	Server2,2,8192,256000,Thick,,,,,,

This example CSV file would create two virtual machines.  The first virtual machine would be named Server1 and it would have 4 CPUs, 16 GB of RAM, an 80 GB thin provisioned disk.  The second virtual machine would be named Server2 and it would have 2 CPUs, 8 GB of RAM, a 256 GB thick provisioned disk.  The script would prompt the user for what cluster to add the virtual machines to based on available clusters.  The script would then prompt the user for what datastore and VLAN to add the virtual machines to based on datastores and VLANs available in that cluster.  The ISO inserted into the virtual machines would be based on the cluster selected.  The GuestID determines the operating system to be installed on the virtual machines and the user would be prompted for that information as well.

## Permission Requirements

The user running the script should have permissions to create new virtual machines and add devices to SCCM

## Usage

To use the script, copy the project's folder to a workstation that can connect to vSphere and SCCM.  The script can be run simply by typing .\Build-vSphereVM.ps1 from PowerShell when in the project's folder with no parameters.  There are optional parameters available to the script.  Documentation about those parameters can be found in the script.  After the script completes, you may need to access the console of the virtual machine and select the appropriate SCCM task sequence if the virtual machine has multiple task sequences available or if the task sequence is not set to automatically start.

## Issues

**ISO hard coded in function:** The ISO information is hard coded into the New-VirtualMachine function located in .\Functions\New-VirtualMachine.ps1.  I am working on extracting that information from the script and either allowing the user to specify the value or create logic to set the value.

**SCCM collections hard coded in function:** The collection names that have the SCCM task sequence deployed to them are currently hard coded in the Add-SystemToSCCM function located in .\Functions\Add-SystemToSCCM.ps1.  I am working on extracting that information from the script and either allowing the user to specify the value or create logic to set the value.

**Default values:** Default values for CPUs, RAM, DiskSizeMB, and DiskProvisioning can be found in the Get-VMBuildInformation function located in .\Functions\Get-VMBuildInformation.ps1.  I am working on extracting that information from the script and either allowing the user to specify the value or create logic to set the value.

**Network adapter type hard codded in function:** The network adapter type of Vmxnet3 is hard coded in the New-VirtualMachine function located in .\Functions\New-VirtualMachine.ps1.  I am working on extracting that information from the script and either allowing the user to specify the value or create logic to set the value.

**Operating system support:** The script currently supports install Windows Server 2008 or Windows Server 2012 on the virtual machine.  The values that determine this can be found in the Select-OS function located in .\Functions\Select-OS.ps1.