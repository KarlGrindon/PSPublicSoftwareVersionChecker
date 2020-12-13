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