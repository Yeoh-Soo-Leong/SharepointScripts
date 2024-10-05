$orig = Import-Csv "./FolderData(Original).csv"
$new = Import-Csv "./FolderData.csv"

# flipped the order of new and orig so that the remove changes come first
# need to remove first, otherwise there will be duplicate permissions when add without removing first
$diff = Compare-Object $new $orig -Property Title, PrincipalType, Permission

$folderPath = Get-Content -Path ".\FolderName.txt"

foreach ($change in $diff)
{
    if ($change.SideIndicator -eq "<=")
    {
        # add
        try
        {
            if ($change.PrincipalType -eq "SharePointGroup")
            {
                Write-Output "Adding group $($change.Title) to $($folderPath) folder with $($change.Permission) permissions"
                Set-PnPFolderPermission -List 'Shared Documents' -Identity "Shared Documents/$($folderPath)" -Group $change.Title -AddRole $change.Permission
            }
            elseif ($change.PrincipalType -eq "User")
            {
                Write-Output "Adding user $($change.Title) to $($folderPath) folder with $($change.Permission) permissions"
                Set-PnPFolderPermission -List 'Shared Documents' -Identity "Shared Documents/$($folderPath)" -User $change.Title -AddRole $change.Permission
            }
        }
        catch [System.Management.Automation.PSInvalidOperationException]
        {
            # should not have any new
            Write-Output "detected new $change"
            Write-Output "THIS SHOULD NOT HAPPEN, PLEASE TAKE A SCREENSHOT AND CONTACT THE DEVELOPER"
        }
    }
    elseif ($change.SideIndicator -eq "=>")
    {
        # remove
        if ($change.PrincipalType -eq "SharePointGroup")
        {
            Write-Output "Removing group $($change.Title) to $($folderPath) folder with $($change.Permission) permissions"
            Set-PnPFolderPermission -List 'Shared Documents' -Identity "Shared Documents/$($folderPath)" -Group $change.Title -RemoveRole $change.Permission
        }
        elseif ($change.PrincipalType -eq "User")
        {
            Write-Output "Removing user $($change.Title) to $($folderPath) folder with $($change.Permission) permissions"
            Set-PnPFolderPermission -List 'Shared Documents' -Identity "Shared Documents/$($folderPath)" -User $change.Title -RemoveRole $change.Permission
        }
    }
}
