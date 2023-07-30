function Get-SystemHardware {
    return Get-CimInstance Win32_ComputerSystem
}

function Get-OperatingSystem {
    return Get-CimInstance Win32_OperatingSystem
}

function Get-Processor {
    return Get-CimInstance Win32_Processor
}

function Get-Memory {
    return Get-CimInstance Win32_PhysicalMemory
}

function Get-DiskDrives {
    $diskdrives = Get-CimInstance CIM_DiskDrive
    $diskInfo = @()

    foreach ($disk in $diskdrives) {
        $partitions = $disk | Get-CimAssociatedInstance -ResultClassName CIM_DiskPartition
        foreach ($partition in $partitions) {
            $logicaldisks = $partition | Get-CimAssociatedInstance -ResultClassName CIM_LogicalDisk
            foreach ($logicaldisk in $logicaldisks) {
                $diskInfo += New-Object -TypeName PSObject -Property @{
                    Manufacturer = $disk.Manufacturer
                    Location = $partition.DeviceID
                    Drive = $logicaldisk.DeviceID
                    "Size(GB)" = [math]::Round($logicaldisk.Size / 1GB, 2)
                    "Free Space(GB)" = [math]::Round($logicaldisk.FreeSpace / 1GB, 2)
                    "Free Space(%)" = [math]::Round(($logicaldisk.FreeSpace / $logicaldisk.Size) * 100, 2)
                }
            }
        }
    }

    return $diskInfo
}

function Get-NetworkAdapterConfiguration {
    $networkAdapters = Get-CimInstance Win32_NetworkAdapterConfiguration | Where-Object { $_.IPEnabled -eq $true }
    $adapterInfo = @()

    foreach ($adapter in $networkAdapters) {
        $ipAddresses = $adapter.IPAddress -join ', '
        $subnetMasks = $adapter.IPSubnet -join ', '
        $dnsServers = $adapter.DNSServerSearchOrder -join ', '

        $adapterInfo += New-Object PSObject -Property @{
            'Adapter Description' = $adapter.Description
            'Index' = $adapter.Index
            'IP Address(es)' = $ipAddresses
            'Subnet Mask(s)' = $subnetMasks
            'DNS Domain Name' = $adapter.DNSDomain
            'DNS Server' = $dnsServers
        }
    }

    return $adapterInfo
}

function Get-VideoController {
    return Get-CimInstance Win32_VideoController
}

# Main script starts here

# System Hardware Section
$systemHardware = Get-SystemHardware

Write-Output "--- System Hardware ---"
Write-Output "Manufacturer: $($systemHardware.Manufacturer)"
Write-Output "Model: $($systemHardware.Model)"
Write-Output "Total Physical Memory: $([math]::Round($systemHardware.TotalPhysicalMemory / 1GB, 2)) GB"
Write-Output ""

# Operating System Section
$operatingSystem = Get-OperatingSystem

Write-Output "--- Operating System ---"
Write-Output "Name: $($operatingSystem.Caption)"
Write-Output "Version: $($operatingSystem.Version)"
Write-Output ""

# Processor Section
$processor = Get-Processor

Write-Output "--- Processor ---"
Write-Output "Description: $($processor.Name)"
Write-Output "Speed: $($processor.MaxClockSpeed) MHz"
Write-Output "Number of Cores: $($processor.NumberOfCores)"
Write-Output "L1 Cache: $($processor.L2CacheSize) KB"
Write-Output "L2 Cache: $($processor.L2CacheSize) KB"
Write-Output "L3 Cache: $($processor.L3CacheSize) KB"
Write-Output ""

# Memory Section
$memory = Get-Memory

Write-Output "--- Memory ---"
$memory | Format-Table -Property Vendor, PartNumber, Capacity, DeviceLocator
$totalRAM = ($memory | Measure-Object Capacity -Sum).Sum
Write-Output "Total Installed RAM: $([math]::Round($totalRAM / 1GB, 2)) GB"
Write-Output ""

# Disk Drives Section
$diskDrives = Get-DiskDrives

Write-Output "--- Disk Drives ---"
$diskDrives | Format-Table -AutoSize
Write-Output ""

# Network Adapter Configuration Section
$networkAdapters = Get-NetworkAdapterConfiguration

Write-Output "--- Network Adapter Configuration ---"
$networkAdapters | Format-Table -AutoSize
Write-Output ""

# Video Controller Section
$videoController = Get-VideoController

Write-Output "--- Video Controller ---"
Write-Output "Vendor: $($videoController.Manufacturer)"
Write-Output "Description: $($videoController.Caption)"
Write-Output "Current Screen Resolution: $($videoController.CurrentHorizontalResolution) x $($videoController.CurrentVerticalResolution)"
Write-Output ""