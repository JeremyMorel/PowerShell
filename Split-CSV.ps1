function Split-Csv
{

Param(
    [Parameter(Mandatory=$True,Position=1,HelpMessage="File path")]
    [string]$Path,
    [Parameter(Mandatory=$True,HelpMessage="Batch size")]
    [int]$BatchSize
)

If(!(Test-Path $Path -ErrorAction SilentlyContinue)) {
    Write-Error "$Path not found."
    Return
}

$inputFile = Get-Item $Path

$ParentDirectory = Split-Path $Path

$strFilename = dir $Path | Select-Object BaseName,Extension

$strBaseName = $strFilename.BaseName
$strExtension = $strFilename.Extension

$objFile = Import-Csv $Path

$Count = [math]::ceiling($objFile.Count/$BatchSize)

$Length = "D" + ([math]::floor([math]::Log10($Count) + 1)).ToString()

1 .. $Count | ForEach-Object {
    $i = $_.ToString($Length)
    $Offset = $BatchSize * ($_ - 1)
    $outputFile = $ParentDirectory + "\" + $strBaseName + "_Batch_" + $i + $strExtension
    If($_ -eq 1) {
        $objFile | Select-Object -First $BatchSize | Export-Csv $outputFile -NoTypeInformation
    } Else {
        $objFile | Select-Object -First $BatchSize -Skip $Offset | Export-Csv $outputFile -NoTypeInformation
    }
}
}
