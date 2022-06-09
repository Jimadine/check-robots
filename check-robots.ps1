<#
    Author: Jim Adamson
    Date: 27/05/2022
    Purpose: Batch check a list of websites for a robots.txt file
             See sample check-robots.domainList
    Usage:   .\check-robots.ps1 check-robots.domainList

#>
$domainsFile = $args[0]
If (-not $args[0]) {
  "Filepath argument not supplied"
  Return
}

ForEach($domain in (Get-Content -Path $domainsFile) ) {
    try
    {   
        $Request = "https://${domain}/robots.txt"
        $Response = Invoke-WebRequest -URI $Request
        # This will only execute if the Invoke-WebRequest is successful.
        $StatusCode = $Response.StatusCode
    }
    catch
    {
        $StatusCode = $_.Exception.Response.StatusCode.value__
    }

    If ($StatusCode -eq '200'){ "${domain} has a robots.txt (HTTP Status Code ${StatusCode})" } 
    Elseif ($StatusCode -eq '404'){ Write-Host -ForegroundColor Red "${domain} does NOT have a robots.txt (HTTP Status Code ${StatusCode})" } 
    Else { "${domain} returned a non-200 status code (${StatusCode})" }

}