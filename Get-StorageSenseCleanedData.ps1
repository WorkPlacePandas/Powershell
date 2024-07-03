<#
.SYNOPSIS
    Script to evalulate Space cleaned by Storage Sense

.DESCRIPTION
    This script will revert data in GB for data that was cleaned for last duration (depends on storage sense setup ,which varies).

.NOTES
    Created:     2024-06-28
	  Author :     Jasbir Rana

    Version history:
    1.0.0 - (2024-06-28) Script created
#>

# Define an array of registry paths and value names you want to retrieve and sum
$path = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy\SpaceHistory"
$registryValues = get-item -Path $path -ErrorAction SilentlyContinue
# Initialize a variable to hold the sum of values
$totalSum = 0
if ($registryValues.Property -ne $null) {
 
	# Loop through each registry value definition
	foreach ($value in $registryValues.Property) {
		try {
			# Get the registry value
			$data = Get-ItemProperty -Path $path | Select-Object -ExpandProperty $value
			# Check if the value is numeric before adding to total sum
			if ($data -as [int]) {
				$totalSum += $data
			} 
		} 
		catch {
			Write-Host "Failed to retrieve value $value from $path. $_"
		}
	}

	$SpaceCleaned = [math]::round(($totalSum * 967) / 1048576, 2)
 
	#Total Cleandup space in last Month using Storage Sense
	Write-Host " $SpaceCleaned : GB (approx) cleaned by Storage Sense"
}
else {
	Write-Host  " 0 : GB cleaned "
}
