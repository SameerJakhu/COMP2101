function Get-CpuInfo {
    $cpuInfo = Get-WmiObject Win32_Processor
    "CPU Information:"
    "  Manufacturer: $($cpuInfo.Manufacturer)"
    "  Model: $($cpuInfo.Name)"
    "  Cores: $($cpuInfo.NumberOfCores)"
    "  Threads: $($cpuInfo.NumberOfLogicalProcessors)"
}

function Get-OSInfo {
    $osInfo = Get-WmiObject Win32_OperatingSystem
    "Operating System Information:"
    "  Caption: $($osInfo.Caption)"
    "  Version: $($osInfo.Version)"
    "  Architecture: $($osInfo.OSArchitecture)"
    "  Install Date: $($osInfo.InstallDate)"
}

function Get-RamInfo {
    $ramInfo = Get-WmiObject Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum
    $ramCapacityGB = $ramInfo.Sum / 1GB
    "RAM Information:"
    "  Total Capacity: $([math]::Round($ramCapacityGB, 2)) GB"
}

function Get-VideoInfo {
    $videoInfo = Get-WmiObject Win32_VideoController
    "Video Information:"
    "  Adapter Name: $($videoInfo.Name)"
    "  Driver Version: $($videoInfo.DriverVersion)"
}

function Get-DisksInfo {
    $disksInfo = Get-WmiObject Win32_LogicalDisk | Where-Object { $_.DriveType -eq 3 }
    "Disks Information:"
    foreach ($disk in $disksInfo) {
        "  Drive $($disk.DeviceID):"
        "    Volume Name: $($disk.VolumeName)"
        "    File System: $($disk.FileSystem)"
        "    Total Size: $($disk.Size / 1GB) GB"
        "    Free Space: $($disk.FreeSpace / 1GB) GB"
    }
}

function Get-NetworkInfo {
    $networkInfo = Get-WmiObject Win32_NetworkAdapterConfiguration | Where-Object { $_.IPEnabled }
    "Network Information:"
    foreach ($network in $networkInfo) {
        "  Adapter: $($network.Description)"
        "    IP Address: $($network.IPAddress -join ', ')"
        "    MAC Address: $($network.MACAddress)"
    }
}