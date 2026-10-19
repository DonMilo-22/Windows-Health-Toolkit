param(
  [Parameter(Mandatory=$true)][string]$ReportPath,
  [ValidateRange(1,100)][int]$RamLimit = 90,
  [ValidateRange(1,100)][int]$DiskFreeLimit = 15
)
if (!(Test-Path -LiteralPath $ReportPath -PathType Leaf)) {
  Write-Error "Report file not found: $ReportPath"
  exit 1
}
$report = Get-Content -LiteralPath $ReportPath -Raw | ConvertFrom-Json
$warnings = @()
if ($null -ne $report.RAM_Used_Percent -and [double]$report.RAM_Used_Percent -ge $RamLimit) {
  $warnings += "RAM usage: $($report.RAM_Used_Percent)% (limit $RamLimit%)."
}
foreach ($disk in @($report.Disks)) {
  if ($null -ne $disk.FreePercent -and [double]$disk.FreePercent -lt $DiskFreeLimit) {
    $warnings += "$($disk.Drive) free space: $($disk.FreePercent)% (minimum $DiskFreeLimit%)."
  }
}
if ($warnings.Count -eq 0) {
  Write-Host "No RAM or disk-space thresholds exceeded."
} else {
  Write-Host "Warnings:"
  $warnings | ForEach-Object { Write-Host "- $_" }
  exit 2
}
