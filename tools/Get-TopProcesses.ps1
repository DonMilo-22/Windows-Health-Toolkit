param([ValidateRange(1,50)][int]$Count = 10)

$processes = Get-Process -ErrorAction SilentlyContinue |
  Sort-Object WorkingSet64 -Descending |
  Select-Object -First $Count @{Name="Process";Expression={$_.ProcessName}},
    @{Name="RAM_MB";Expression={[math]::Round($_.WorkingSet64 / 1MB, 1)}},
    Id

if (-not $processes) {
  Write-Warning "No process information could be read."
  exit 1
}
$processes | Format-Table -AutoSize
