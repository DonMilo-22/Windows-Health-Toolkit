# 🩺 Windows Health Toolkit

> Quick Windows diagnostics from PowerShell.

![PowerShell](https://img.shields.io/badge/PowerShell-7%2B-5391FE?logo=powershell&logoColor=white)
![Windows](https://img.shields.io/badge/platform-Windows-0078D4?logo=windows)
![License](https://img.shields.io/badge/license-MIT-green)

Windows Health Toolkit collects useful system information in one run: hardware, memory, disks, network, uptime and resource-heavy processes.

## ✨ Features

- Computer and Windows information
- RAM usage
- Disk health overview
- IPv4 network information
- Top CPU and memory processes
- Optional JSON export
- Human-readable console report

## 🚀 Run

```powershell
pwsh ./WindowsHealth.ps1
```

Export the report:

```powershell
pwsh ./WindowsHealth.ps1 -ExportJson report.json
```

## 🔐 Permissions

Most checks work as a regular user. Running PowerShell as Administrator may expose additional system details depending on Windows configuration.

## 🧠 What it demonstrates

PowerShell functions, CIM queries, pipelines, calculated properties, JSON serialization and practical Windows administration.

## 📄 License

MIT.

## 🆕 Recent changes

### 2026-10-08

- Added the last boot timestamp alongside uptime in the system report.

### 2026-10-07

- Added operating system architecture to both the console summary and JSON report.

### 2026-10-06

- Added a report generation timestamp, including in JSON exports.

### 2026-10-05

- Added the current RAM usage percentage to the system summary.

### 2026-10-04

- Added a warning when any local disk has less than 15% free space.

### Previous update

- Added a `-Top` option to choose how many CPU and memory-heavy processes are displayed.
