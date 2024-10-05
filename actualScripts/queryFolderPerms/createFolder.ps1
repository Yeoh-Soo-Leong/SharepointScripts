Param(
    [Parameter(Mandatory, HelpMessage = "Please enter site url eg.https://<domain>.sharepoint.com/sites/<site name>")]
    $siteUrl,
    [Parameter(Mandatory, HelpMessage = "Please enter folder name eg.Public")]
    $filePath,
    [Parameter(Mandatory, HelpMessage = "Please enter owner email eg.user@<domain>.com")]
    $ownerEmail
)

Connect-PnPOnline -Url $siteUrl -Interactive

try
{
    Add-PnPFolder -Name $filePath -Folder "Shared Documents"
    Set-PnPFolderPermission -List "Shared Documents" -Identity "Shared Documents/$($filePath)" -User $ownerEmail -AddRole "Full Control" -ClearExisting
    Write-Output "Added $($filePath) folder with $($ownerEmail) as the owner"
}
catch [System.Management.Automation.PSInvalidOperationException]
{
    # if the folder already exists
    Write-Output "$($filePath) folder already exists"
}
