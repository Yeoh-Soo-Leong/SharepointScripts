Param(
    [Parameter(Mandatory, HelpMessage = "Please enter admin site url eg.https://<domain>-admin.sharepoint.com")]
    $adminSiteUrl,
    [string]$CSVPath = ".\SitesData.csv",
    [string]$siteUrl
)

#Connect to Tenant Admin Site
Connect-PnPOnline -Url $adminSiteURL -Interactive

#Get All Site collections data and export to CSV file
If ($siteUrl)
{
    Get-PnPTenantSite -Detailed -Identity $siteUrl | Select * | Export-Csv -path $CSVPath -NoTypeInformation
} Else {
    Get-PnPTenantSite -Detailed | Select * | Export-Csv -path $CSVPath -NoTypeInformation
}
