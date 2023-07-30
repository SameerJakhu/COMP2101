# PowerShell script to generate an IP configuration report

# Get a collection of network adapter configuration objects
$networkAdapters = Get-CimInstance Win32_NetworkAdapterConfiguration | Where-Object { $_.IPEnabled -eq $true }

# Initialize an empty array to store the results
$report = @()

# Loop through each network adapter and gather the required information
foreach ($adapter in $networkAdapters) {
    $ipAddresses = $adapter.IPAddress -join ', '
    $subnetMasks = $adapter.IPSubnet -join ', '
    $dnsServers = $adapter.DNSServerSearchOrder -join ', '
    
    $reportEntry = @{
        'Adapter Description' = $adapter.Description
        'Index' = $adapter.Index
        'IP Address(es)' = $ipAddresses
        'Subnet Mask(s)' = $subnetMasks
        'DNS Domain Name' = $adapter.DNSDomain
        'DNS Server' = $dnsServers
    }
    
    # Add the current adapter's information to the report array
    $report += New-Object PSObject -Property $reportEntry
}

# Display the report in a clean and easy-to-read table format
$report | Format-Table -AutoSize

# Optionally, you can export the report to a CSV file for further analysis
$report | Export-Csv -Path "IP_Configuration_Report.csv" -NoTypeInformation
