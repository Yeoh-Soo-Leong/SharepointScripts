$orig = Import-Csv "./GroupData(Original).csv"
$new = Import-Csv "./GroupData.csv"

$diff = Compare-Object $orig $new -Property GroupTitle, UserTitle, Email

foreach ($change in $diff) 
{
    if ($change.SideIndicator -eq "=>") 
    {
        # add
        try 
        {
            Write-Output "adding $($change.Email) to $($change.GroupTitle)"
            Add-PnPGroupMember -LoginName $change.Email -Group $change.GroupTitle
        }
        catch [System.Management.Automation.PSInvalidOperationException] 
        {
            # if the group does not exist, create a new group
            New-PnPGroup -Title $change.GroupTitle
            Add-PnPGroupMember -LoginName $change.Email -Group $change.GroupTitle
            Write-Output "New group $($change.GroupTitle) created"
        }
    }
    elseif ($change.SideIndicator -eq "<=") 
    {
        # remove
        Write-Output "removing $($change.Email) from $($change.GroupTitle)"
        Remove-PnPGroupMember -LoginName $change.Email -Group $change.GroupTitle
    }
}