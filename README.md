# FieldServiceSuite

Ferramenta PowerShell para técnico Field Service no dia a dia: atendimento, inventário, diagnóstico rápido, troubleshooting guiado, dashboard e relatórios HTML/TXT/JSON.

## Requisitos

- Windows 10 ou Windows 11
- PowerShell 5.1 ou PowerShell 7+
- Execução como administrador recomendada para módulos de energia e algumas coletas

## Como executar

```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\Start.ps1
```

## Menu

```text
1. Novo atendimento
2. Diagnóstico rápido
3. Troubleshooting guiado
4. Inventário de hardware
5. Rede
6. Disco/SMART
7. Bateria
8. Energia
9. Drivers
10. Checklist manual
11. Dashboard
12. Gerar relatório
0. Sair
```

## Relatórios

Os relatórios são salvos em:

```text
Reports\ANO\MES\DIA\CHAMADO-SERIAL\
```

Formatos gerados:

- HTML
- TXT
- JSON

## Observação

O projeto prioriza uso prático em campo e baixa dependência. Alterações de energia exigem confirmação via menu e podem exigir permissão administrativa.
