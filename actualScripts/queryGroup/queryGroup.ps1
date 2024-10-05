Param(
    [Parameter(Mandatory, HelpMessage = "Please enter site url eg.https://<domain>.sharepoint.com/sites/<site name>")]
    $siteUrl
    # [string]$CSVPath = ".\GroupData.csv"
)

# Connect to the SharePoint site
Connect-PnPOnline -Url $siteUrl -Interactive

# Initialize an empty array to store group data
$groupData = @()

# Get all groups in the site
$groups = Get-PnPGroup

# Loop through each group
foreach ($group in $groups) {
    # Get the members of the current group
    $groupMembers = Get-PnPGroupMember -Group $group.Title

    # Create a custom object for the group and its members
    $groupData += $groupMembers | Select-Object @{Name="GroupTitle"; Expression={$group.Title}}, @{Name="UserTitle"; Expression={$_.Title}}, @{Name="Email"; Expression={$_.Email}}
}

# Export the group data to a CSV file
$groupData | Export-Csv -Path ".\GroupData(Original).csv" -NoTypeInformation
$groupData | Export-Csv -Path ".\GroupData.csv" -NoTypeInformation

Write-Output "Groups queried"
