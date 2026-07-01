function Get-FstSystemInfo {
    [CmdletBinding()]
    param()

    $bios     = Get-CimInstance Win32_BIOS
    $computer = Get-CimInstance Win32_ComputerSystem
    $board    = Get-CimInstance Win32_BaseBoard
    $cpu      = Get-CimInstance Win32_Processor
    $memory   = Get-CimInstance Win32_PhysicalMemory
    $disks    = Get-CimInstance Win32_DiskDrive

    [pscustomobject]@{
        ComputerName = $env:COMPUTERNAME
        Manufacturer = $computer.Manufacturer
        Model        = $computer.Model
        SerialNumber = $bios.SerialNumber
        Motherboard  = "$($board.Manufacturer) $($board.Product)"
        Cpu          = $cpu.Name
        MemoryGb     = [math]::Round(($memory.Capacity | Measure-Object -Sum).Sum / 1GB, 2)
        Disks        = $disks | ForEach-Object {
            [pscustomobject]@{
                Model     = $_.Model
                SizeGb    = [math]::Round($_.Size / 1GB, 2)
                MediaType = $_.MediaType
                Interface = $_.InterfaceType
            }
        }
    }
}

function Get-FstStorageHealth {
    [CmdletBinding()]
    param()

    try {
        Get-PhysicalDisk | ForEach-Object {
            [pscustomobject]@{
                FriendlyName      = $_.FriendlyName
                MediaType         = $_.MediaType
                BusType           = $_.BusType
                SizeGb            = [math]::Round($_.Size / 1GB, 2)
                HealthStatus      = $_.HealthStatus
                OperationalStatus = $_.OperationalStatus -join ", "
                Suggestion        = switch -Regex ($_.HealthStatus.ToString()) {
                    '^Healthy$'   { "Sem falha indicada pelo Windows."; break }
                    '^Warning$'   { "Recomendar backup e ferramenta do fabricante."; break }
                    '^Unhealthy$' { "Crítico. Recomendar backup imediato e possível troca."; break }
                    default       { "Status inconclusivo. Validar manualmente." }
                }
            }
        }
    }
    catch {
        [pscustomobject]@{
            FriendlyName      = "Indisponível"
            MediaType         = "Indisponível"
            BusType           = "Indisponível"
            SizeGb            = "Indisponível"
            HealthStatus      = "Não coletado"
            OperationalStatus = $_.Exception.Message
            Suggestion        = "Executar como administrador ou validar manualmente."
        }
    }
}

Export-ModuleMember -Function Get-FstSystemInfo, Get-FstStorageHealth