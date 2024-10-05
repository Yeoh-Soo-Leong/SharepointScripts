Param(
    $groupsToDelete
)

if ($groupsToDelete.Count -eq 0)
{
    Get-PnPGroup | Select-Object title
}
else
{
    foreach ($group in $groupsToDelete) 
    {
        try
        {
            Write-Output "Removing $($group) group"
            Remove-PnPGroup -Identity $group
        }
        catch [System.Management.Automation.PSInvalidOperationException]
        {
            Write-Output "The group does not exist"
        }
    }
}
