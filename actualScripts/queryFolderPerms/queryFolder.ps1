Param(
    [Parameter(Mandatory, HelpMessage = "Please enter site url eg.https://<domain>.sharepoint.com/sites/<site name>")]
    $siteUrl,
    [Parameter(Mandatory, HelpMessage = "Please enter relative path to folder eg.Public/Users")]
    $folderPath
)

Connect-PnPOnline -Url $siteUrl -Interactive

$file = Get-PnPFolder -Url "Shared Documents/$($folderPath)" -Includes ListItemAllFields.RoleAssignments, ListItemAllFields.HasUniqueRoleAssignments

$FolderData = @()

if($file.ListItemAllFields.HasUniqueRoleAssignments -eq $True) 
{
    foreach($roleAssignments in $file.ListItemAllFields.RoleAssignments)
    {
        Get-PnPProperty -ClientObject $roleAssignments -Property RoleDefinitionBindings, Member
        $FolderData += $roleAssignments | Select-Object @{Name="Title"; Expression={$_.Member.Title}}, @{Name="PrincipalType"; Expression={$_.Member.PrincipalType.ToString()}}, @{Name="Permission"; Expression={$_.RoleDefinitionBindings.Name}}
    }
}

$FolderData | Export-Csv -Path ".\FolderData.csv" -NoTypeInformation
$FolderData | Export-Csv -Path ".\FolderData(Original).csv" -NoTypeInformation
$folderPath | Out-File -FilePath ".\FolderName.txt"

Write-Output "Permissions for $folderPath queried"
