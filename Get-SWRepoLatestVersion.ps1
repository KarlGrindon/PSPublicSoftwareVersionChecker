<#
.SYNOPSIS
    A script to check for the latest version of software.
.DESCRIPTION
    This script will take a config file in JSON format, check the URLs defined in said file for the latest version
    and return those results.
.EXAMPLE
    .\Get-SWRepoLatestVersion.ps1 -ConfigFile config.json
.INPUTS
    $ConfigFile - a json file in the format of the json file in the repo.
.OUTPUTS
    product           version    osType platform
    -------           -------    ------ --------
    minecraft_bedrock 1.16.200.2 server windows
    notepadpp         7.9.1      client windows

    As an example.

.NOTES
    Sadly you'll need to work out the regex needed to pull appropriate version numbers from the website.

    Additionally, this script makes use of the 'version' type, therefore if the software you're checking doesn't
    use correct versions (1.1.1.1, 1.1.1.0, 1.1 etc) it won't work.
#>

[CmdletBinding()]
param (
    [Parameter(Mandatory)]
    [string]
    $ConfigFile
)
# get information from config file
$config = (Get-Content -LiteralPath $ConfigFile -Raw | ConvertFrom-Json).products

# class to describe results
class resultData {
    [string]$product
    [string]$version
    [string]$osType
    [string]$platform
}

function Get-HighestVersionFromPage {
    param (
    [Parameter(Mandatory)]
    [string]
    $Uri
    )
    Write-Verbose "Checking $($product.product_name) for latest version"
    $pageData = Invoke-WebRequest -Uri $product.url -UseBasicParsing
    
    # Use regex with a name capture group to pull valid versions from the page
    $versions = (($pageData.Content |
                    Select-String -Pattern $regex -AllMatches).Matches.Groups |
                    where {$_.Name -match 'version' -and $_.Value -ne ''}).Value
    
    # Only return the highest version
    ([version[]]$versions | sort asc | measure -Maximum).Maximum
}

$results = @()

foreach ($product in $config) {
    $result = New-Object resultData
    $result.product = $product.product_name
    $result.version = Get-HighestVersionFromPage -Uri $product.url
    $result.osType  = $product."os-type"
    $result.platform = $product.platform

    $results += $result
}

return $results