Param(
    [Parameter(Mandatory, HelpMessage = "Please enter site url eg.https://<domain>.sharepoint.com/sites/<site name>")]
    $siteUrl,
    [string]$CSVPath = ".\AllFolderData.csv"
)

Connect-PnPOnline -Url $siteUrl -Interactive

$allFolders = Get-PnPFolderInFolder -FolderSiteRelativeUrl "Shared Documents"

$FolderData = @()

foreach($folder in $allFolders)
{
    $folderPath = "Shared Documents/" + $folder.Name
    $file = Get-PnPFolder -Url $folderPath -Includes ListItemAllFields.RoleAssignments, ListItemAllFields.HasUniqueRoleAssignments

    # to get the permissions of folders that do not inherit permissions from a parent folder 
    if($file.ListItemAllFields.HasUniqueRoleAssignments -eq $True) 
    {
        foreach($roleAssignments in $file.ListItemAllFields.RoleAssignments)
        {
            Get-PnPProperty -ClientObject $roleAssignments -Property RoleDefinitionBindings, Member
            $FolderData += $roleAssignments | Select-Object @{Name="Folder"; Expression={$folder.Name}}, @{Name="Name"; Expression={$_.Member.Title}}, @{Name="PrincipalType"; Expression={$_.Member.PrincipalType.ToString()}}, @{Name="Permission"; Expression={$_.RoleDefinitionBindings.Name}}
        }
    }    
}

$FolderData | Export-Csv -Path $CSVPath -NoTypeInformation

Write-Output "All Folder permissions queried"
