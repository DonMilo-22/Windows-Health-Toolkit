# Windows Health Toolkit

Informe local de recursos de Windows desde PowerShell.

Reúne información del equipo, memoria, discos, red y procesos en una ejecución, con exportación JSON opcional.

## Funciones actuales

- Equipo, Windows, arquitectura, CPU y procesadores lógicos.
- RAM total, libre y porcentaje usado.
- Fecha del informe, último arranque y horas encendido.
- Espacio de discos locales y aviso si queda menos de 15% libre.
- Direcciones IPv4 y procesos con mayor CPU acumulada o memoria actual.
- Número configurable de procesos y exportación a JSON.

## Requisitos

Windows y PowerShell 7 o superior (`pwsh`), con los cmdlets CIM y `Get-NetIPAddress` disponibles. El script utiliza interfaces de Windows; no es multiplataforma.

## Instalación y uso

```powershell
git clone https://github.com/DonMilo-22/Windows-Health-Toolkit.git
cd Windows-Health-Toolkit
pwsh ./WindowsHealth.ps1
pwsh ./WindowsHealth.ps1 -Top 10 -ExportJson report.json
```

## Opciones

| Parámetro | Predeterminado | Uso |
|---|---|---|
| `-Top <n>` | `5` | Entre 1 y 50 procesos por clasificación. |
| `-ExportJson <ruta>` | Sin exportación | Guarda el informe como JSON. |

## Almacenamiento y permisos

Solo escribe un archivo si se indica `-ExportJson`; una ruta relativa se resuelve desde el directorio de trabajo. Las consultas suelen funcionar con usuario normal; algunos detalles pueden depender de permisos y configuración de Windows.

## Límites y comprobaciones

Es una fotografía del sistema, no monitoreo continuo. `CPU_s` representa segundos de CPU acumulados por proceso, no porcentaje instantáneo. El apartado de discos mide espacio, no salud SMART. Ejecuta el script y compara el informe de consola con el JSON para revisar la exportación en tu equipo.

## Autor y licencia

Desarrollado por [DonMilo-22](https://github.com/DonMilo-22).

Licencia: MIT.

## Actualización 2026-10-12

- Added the number of detected IPv4 addresses to the network summary.

## Actualización adicional 2026-10-12

- Added the Windows installation date to the collected system report.

- Added the Windows installation date to the collected system report.

## Historial

Consulta [CHANGELOG.md](CHANGELOG.md) para ver las actualizaciones.

## Actualización 2026-10-14

- Added a RAM status field that flags memory usage at 90% or higher in the console report and JSON export.

## Actualización 2026-10-15

- The report now counts drives with less than 15% free space.


## Actualización 2026-10-16

- The report now includes battery charge/status when a battery is detected; desktop systems without a battery show `Not detected`.


## New utility: report threshold check

Generate a JSON report, then check whether RAM usage or disk free space has crossed a chosen threshold:

```powershell
pwsh ./WindowsHealth.ps1 -ExportJson report.json
pwsh ./tools/HealthThresholdReport.ps1 -ReportPath report.json
pwsh ./tools/HealthThresholdReport.ps1 -ReportPath report.json -RamLimit 85 -DiskFreeLimit 20
```

The helper reads an existing report and prints warnings without changing system settings or files. It returns exit code `2` when a threshold is exceeded, which is useful in scripts.


## New utility: top RAM-consuming processes

List the processes using the most memory:

```powershell
pwsh ./tools/Get-TopProcesses.ps1
pwsh ./tools/Get-TopProcesses.ps1 -Count 5
```

The read-only helper reports process name, RAM in MiB and process ID. Some protected processes may not expose full information without elevated permissions.


## Actualización 2026-10-25

- Added `-ExportProcessesCsv` to export the top CPU and memory process lists to one CSV file, with a `Group` column identifying each ranking. Also repaired line breaks in the battery report section.

```powershell
.\WindowsHealth.ps1 -ExportProcessesCsv .\top-processes.csv
```

## Actualización 2026-10-30

- Added `-ExportDisksCsv` to export drive names, capacities, free space, and free-space percentages. Example: `.\WindowsHealth.ps1 -ExportDisksCsv .\disks.csv`.
