# Script to create missing course images
$baseDir = "c:\Users\AD\Downloads\demo\src\main\webapp\assets\img"

# Missing images that need to be created
$missingImages = @(
    # Accounting
    "courses-accounting\accounting-misa.png",
    "courses-accounting\cost-accounting.png",
    "courses-accounting\financial-statements.png",
    "courses-accounting\tax-accounting.png",
    
    # Blockchain
    "courses-blockchain\defi.png",
    "courses-blockchain\nft.png",
    "courses-blockchain\smart-contract.png",
    "courses-blockchain\web3.png",
    
    # Data
    "courses-data\excel-data.png",
    "courses-data\power-bi.png",
    "courses-data\python-data.png",
    "courses-data\sql-data.png",
    "courses-data\tableau.png",
    
    # Finance
    "courses-finance\forex.png",
    
    # Marketing
    "courses-marketing\email-marketing.png"
)

foreach ($img in $missingImages) {
    $fullPath = Join-Path $baseDir $img
    $dir = Split-Path $fullPath -Parent
    
    # Create directory if not exists
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
    }
    
    # Check if source images exist with different names
    $fileName = Split-Path $img -Leaf
    $dirName = Split-Path $img -Parent
    
    Write-Host "Creating: $fullPath"
    
    # Try to copy from existing similar images or create placeholder
    if (Test-Path $fullPath) {
        Write-Host "  Already exists, skipping..." -ForegroundColor Green
    } else {
        # Look for any existing image in the same directory
        $existingImages = Get-ChildItem (Join-Path $baseDir $dirName) -Filter "*.png" | Select-Object -First 1
        if ($existingImages) {
            Copy-Item $existingImages.FullName $fullPath
            Write-Host "  Copied from: $($existingImages.Name)" -ForegroundColor Yellow
        } else {
            # Create a minimal PNG placeholder (1x1 transparent pixel)
            $bytes = [byte[]]@(0x89,0x50,0x4E,0x47,0x0D,0x0A,0x1A,0x0A,0x00,0x00,0x00,0x0D,0x49,0x48,0x44,0x52,0x00,0x00,0x00,0x01,0x00,0x00,0x00,0x01,0x08,0x06,0x00,0x00,0x00,0x1F,0x15,0xC4,0x89,0x00,0x00,0x00,0x0A,0x49,0x44,0x41,0x54,0x78,0x9C,0x63,0x00,0x01,0x00,0x00,0x05,0x00,0x01,0x0D,0x0A,0x2D,0xB4,0x00,0x00,0x00,0x00,0x49,0x45,0x4E,0x44,0xAE,0x42,0x60,0x82)
            [System.IO.File]::WriteAllBytes($fullPath, $bytes)
            Write-Host "  Created placeholder" -ForegroundColor Cyan
        }
    }
}

Write-Host "`nDone! Created/verified all missing images." -ForegroundColor Green
