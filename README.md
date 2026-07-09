# FieldServiceSuite MVC

Ferramenta PowerShell para o dia a dia de Field Service, estruturada em padrão MVC adaptado para scripts modulares.

## Objetivo

Registrar atendimento, coletar inventário, executar diagnóstico rápido, orientar troubleshooting, exibir dashboard e gerar relatórios em HTML, TXT e JSON.

## Arquitetura MVC

```text
FieldServiceSuite
├── Start.ps1
├── App
│   ├── Core
│   │   └── Bootstrap.ps1
│   ├── Models
│   ├── Views
│   ├── Controllers
│   └── Services
├── Config
├── Reports
├── Logs
└── Docs
```

## Camadas

- **Models**: objetos de dados do atendimento e diagnóstico.
- **Views**: interface de console, menu e dashboard.
- **Controllers**: orquestração do fluxo de uso.
- **Services**: coleta técnica, regras, recomendações, relatórios, logs e validações.

## Execução

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

```text
Reports\ANO\MES\DIA\CHAMADO-SERIAL\
```

Arquivos gerados:

- `relatorio.html`
- `relatorio.txt`
- `relatorio.json`
