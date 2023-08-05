param (
    [switch]$System,
    [switch]$Disks,
    [switch]$Network
)

if (-not ($System -or $Disks -or $Network)) {
    # If no parameters provided, generate the full report
    Get-CpuInfo
    Get-OSInfo
    Get-RamInfo
    Get-VideoInfo
    Get-DisksInfo
    Get-NetworkInfo
}
else {
    # Generate reports based on provided parameters
    if ($System) {
        Get-CpuInfo
        Get-OSInfo
        Get-RamInfo
        Get-VideoInfo
    }
    if ($Disks) {
        Get-DisksInfo
    }
    if ($Network) {
        Get-NetworkInfo
    }
}