param([string]$ExportJson)

$os = Get-CimInstance Win32_OperatingSystem
$cs = Get-CimInstance Win32_ComputerSystem
$cpu = Get-CimInstance Win32_Processor | Select-Object -First 1
$disks = Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3" | ForEach-Object {
  [pscustomobject]@{ Drive=$_.DeviceID; SizeGB=[math]::Round($_.Size/1GB,2); FreeGB=[math]::Round($_.FreeSpace/1GB,2); FreePercent=if($_.Size){[math]::Round(($_.FreeSpace/$_.Size)*100,1)}else{0} }
}
$network = Get-NetIPAddress -AddressFamily IPv4 -ErrorAction SilentlyContinue | Where-Object { $_.IPAddress -notlike "169.254*" -and $_.InterfaceAlias -notlike "*Loopback*" } | Select-Object InterfaceAlias,IPAddress

$report = [pscustomobject]@{
  Computer=$env:COMPUTERNAME
  Windows=$os.Caption
  Version=$os.Version
  CPU=$cpu.Name
  RAM_GB=[math]::Round($cs.TotalPhysicalMemory/1GB,2)
  RAM_Free_GB=[math]::Round($os.FreePhysicalMemory/1MB,2)
  Uptime_Hours=[math]::Round(((Get-Date)-$os.LastBootUpTime).TotalHours,1)
  Disks=$disks
  Network=$network
  TopCPU=Get-Process | Sort-Object CPU -Descending | Select-Object -First 5 Name,Id,@{N="CPU_s";E={[math]::Round($_.CPU,1)}}
  TopMemory=Get-Process | Sort-Object WorkingSet64 -Descending | Select-Object -First 5 Name,Id,@{N="RAM_MB";E={[math]::Round($_.WorkingSet64/1MB,1)}}
}

Write-Host "`nWindows Health Toolkit" -ForegroundColor Cyan
Write-Host "======================"
Write-Host "PC:       $($report.Computer)"
Write-Host "Windows:  $($report.Windows) $($report.Version)"
Write-Host "CPU:      $($report.CPU)"
Write-Host "RAM:      $($report.RAM_GB) GB total / $($report.RAM_Free_GB) GB free"
Write-Host "Uptime:   $($report.Uptime_Hours) hours"
Write-Host "`nDisks" -ForegroundColor Yellow
$report.Disks | Format-Table -AutoSize
Write-Host "Network" -ForegroundColor Yellow
$report.Network | Format-Table -AutoSize
Write-Host "Top CPU processes" -ForegroundColor Yellow
$report.TopCPU | Format-Table -AutoSize
Write-Host "Top memory processes" -ForegroundColor Yellow
$report.TopMemory | Format-Table -AutoSize
if ($ExportJson) { $report | ConvertTo-Json -Depth 5 | Set-Content -Path $ExportJson -Encoding UTF8; Write-Host "Report exported to $ExportJson" -ForegroundColor Green }