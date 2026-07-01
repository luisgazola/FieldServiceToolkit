# FieldServiceToolkit

Toolkit em PowerShell 7 para apoio técnico em Field Service.

## Recursos

- Menu interativo.
- Diagnóstico completo ou por módulo.
- Coleta técnico, cliente/escola e número do chamado.
- Identifica hostname, fabricante, modelo e serial da BIOS.
- Analisa placa-mãe, CPU, memória e discos.
- Verifica saúde de SSD/NVMe/HD via Get-PhysicalDisk.
- Verifica bateria.
- Verifica BitLocker.
- Verifica atualizações pendentes do Windows.
- Verifica logs recentes do Windows.
- Testa rede sem alterar configurações corporativas.
- Permite opções controladas de energia.
- Gera relatório TXT organizado por data, chamado e serial.

## Requisito

PowerShell 7.

## Execução

```powershell
pwsh .\src\FieldServiceToolkit.ps1