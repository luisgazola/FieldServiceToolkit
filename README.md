# FieldServiceSuite

Ferramenta em PowerShell para técnicos de **Field Service**, focada em registro de atendimento, inventário de hardware, diagnóstico rápido, troubleshooting guiado, dashboard e relatório técnico.

## Objetivo

Ajudar o técnico no atendimento diário sem transformar o projeto em uma suíte pesada. O foco é ser prático, portátil, claro e útil em campo.

## Recursos principais

- Cadastro do atendimento com validação por Regex.
- Inventário de hardware.
- Diagnóstico rápido.
- Análise de disco/SMART.
- Análise de bateria.
- Diagnóstico de rede.
- Verificação de drivers com erro.
- Configurações práticas de energia.
- Troubleshooting guiado por sintoma.
- Motor simples de regras.
- Recomendações automáticas.
- Dashboard no terminal.
- Relatórios em HTML, TXT e JSON.
- Organização por chamado e número de série.

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

## Estrutura

```text
FieldServiceSuite
├── Start.ps1
├── App
│   ├── Core
│   ├── Models
│   ├── Views
│   ├── Controllers
│   └── Services
├── Config
├── Reports
├── Logs
├── Docs
└── Tests
```

## Relatórios

Os relatórios são salvos em:

```text
Reports\ANO\MES\DIA\CHAMADO-SERIAL\
```

Formatos:

- HTML
- TXT
- JSON

## Documentação

- `Docs/GUIA-DE-USO.md`
- `Docs/REQUISITOS-FUNCIONAIS.md`
- `Docs/REQUISITOS-NAO-FUNCIONAIS.md`
- `Docs/ARQUITETURA-MVC-DETALHADA.md`
- `Docs/FLUXOGRAMAS-E-DIAGRAMAS.md`
- `Docs/TROUBLESHOOTING.md`
- `Docs/CONFIGURACAO.md`
- `Docs/RELATORIOS.md`
- `Docs/CONVENCOES.md`
- `Docs/TESTES.md`
- `Docs/ROADMAP.md`

## Arquitetura

O projeto usa MVC adaptado para PowerShell:

- `Models`: dados do atendimento e diagnóstico.
- `Views`: interface do terminal e dashboard.
- `Controllers`: fluxo da aplicação.
- `Services`: diagnóstico, regras, configuração, logs e relatórios.

## Requisitos

- Windows 10 ou Windows 11.
- PowerShell 5.1 ou PowerShell 7+.
- Permissão administrativa recomendada para algumas coletas.

## Status

Versão atual: `v1.1-MVC-Docs`.

