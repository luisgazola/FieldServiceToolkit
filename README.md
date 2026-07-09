# FieldServiceSuite

Ferramenta PowerShell para técnico de **Field Service** registrar atendimento, coletar inventário de hardware, executar diagnóstico rápido, seguir troubleshooting guiado, visualizar dashboard e gerar relatório técnico.

## Versão

`v1.2.0` — arquitetura `src` com MVC + Service Layer.

## Funcionalidades

- Cadastro do atendimento com Regex
- Inventário de hardware
- Diagnóstico rápido
- Disco/SMART
- Bateria
- Rede
- Energia
- Drivers
- Checklist manual
- Troubleshooting guiado
- Motor simples de regras
- Recomendações automáticas
- Dashboard
- Relatórios em HTML, TXT e JSON

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
├── src
│   ├── Core
│   ├── Controllers
│   ├── Models
│   ├── Services
│   ├── Views
│   ├── Helpers
│   ├── Validators
│   └── RulesEngine
├── Config
├── KnowledgeBase
├── Assets
├── Docs
├── Tests
├── Reports
└── Logs
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

## Documentação

- `Docs/ARCHITECTURE.md`
- `Docs/DIAGRAMS.md`
- `Docs/MVC-SERVICE-LAYER.md`
- `Docs/GUIA-DE-USO.md`
- `Docs/TROUBLESHOOTING.md`
- `Docs/REQUISITOS-FUNCIONAIS.md`
- `Docs/REQUISITOS-NAO-FUNCIONAIS.md`
- `Docs/DEVELOPER-GUIDE.md`
