# Project Overview: 10^6 Bash Scripts

10^6 Bash Scripts is an open source repository designed to house an extensive collection of CI/CD and utility shell scripts. Each script is paired with its own Markdown documentation, co-located within the same directory for ease of maintenance. To avoid the hassle of manually updating a central documentation file, an automated aggregation script will scan the repository, extract metadata (via YAML front matter), and compile an aggregated, navigable documentation site. This site will be served using **Docusaurus** as the static site generator.

## Key Features

- **Massive Script Collection**: Organize hundreds (or millions) of scripts across different functional areas such as CI, CD, and common helper utilities.
- **Co-Located Documentation**: Each script has its own README or documentation file, ensuring that usage instructions and code are always in sync.
- **Automated Aggregation**: An aggregation script automatically indexes and collects all Markdown documentation, generating a central documentation hub without manual intervention.
- **Modular Structure**: Scripts are categorized into logical subdirectories (e.g., ci, cd, common) to streamline navigation and maintenance.
- **Open Source Collaboration**: Clear contribution guidelines and a consistent documentation format make it easy for the community to contribute new scripts and improvements.
- **Portability & Compatibility**: Leveraging bash and POSIX shell scripts ensures that the repository can be used across various environments and CI/CD pipelines.
- **Docusaurus Integration**: Using Docusaurus for the documentation site provides features like versioning, search, and a modern UI out of the box.

https://hasura.io/docs/3.0/index/

## Repository Structure

```sh
10^6 Bash Scripts (Repo Root)
├── README.md
├── LICENSE
├── scripts/
│   ├── ci/
│   │   ├── build/
│   │   │   ├── build.sh
│   │   │   └── README.md   # Documentation for build scripts
│   │   └── test/
│   │       ├── test.sh
│   │       └── README.md   # Documentation for test scripts
│   ├── cd/
│   │   ├── deploy/
│   │   │   ├── deploy.sh
│   │   │   └── README.md   # Documentation for deploy scripts
│   │   └── rollback/
│   │       ├── rollback.sh
│   │       └── README.md   # Documentation for rollback scripts
│   ├── utils/
│   │   ├── string/
│   │   │   ├── string_utils.sh
│   │   │   └── README.md   # Documentation for string utilities
│   │   └── file/
│   │       ├── file_utils.sh
│   │       └── README.md   # Documentation for file utilities
│   ├── monitoring/
│   │   ├── metrics/
│   │   │   ├── collect_metrics.sh
│   │   │   └── README.md   # Documentation for metrics collection
│   │   └── alerts/
│   │       ├── alert_handler.sh
│   │       └── README.md   # Documentation for alert handling
│   ├── security/
│   │   ├── scanning/
│   │   │   ├── vulnerability_scan.sh
│   │   │   └── README.md   # Documentation for security scanning
│   │   └── hardening/
│   │       ├── system_hardening.sh
│   │       └── README.md   # Documentation for system hardening
│   └── infrastructure/
│       ├── provisioning/
│       │   ├── provision_server.sh
│       │   └── README.md   # Documentation for provisioning
│       └── networking/
│           ├── setup_network.sh
│           └── README.md   # Documentation for networking
├── docs/                   # Aggregated documentation site (auto-generated)
│   └── index.md            # Landing page for aggregated docs
└── aggregation/            # Scripts/tools for automated aggregation
    └── aggregate.sh        # Aggregation script that compiles Markdown docs
```

This setup keeps your code and its documentation closely linked during development while allowing you to aggregate and publish a unified, searchable documentation site for users and contributors using Docusaurus.
