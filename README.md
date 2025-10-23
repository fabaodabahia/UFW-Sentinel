# UFW-Sentinel
# Script de Configuração Segura do UFW para Servidores Nperf e Speedtest

Este repositório contém um script `bash` para configurar de forma segura e automatizada o **Uncomplicated Firewall (UFW)** em servidores baseados em Ubuntu.

O script foi projetado para fortalecer a segurança do servidor, permitindo o acesso a serviços essenciais (SSH, Web, Testes de Velocidade), ao mesmo tempo em que previne o bloqueio acidental do administrador durante o processo.

-----

## (English Version Bellow)

## 🇧🇷 Versão em Português

### ✨ Funcionalidades

  * **Configuração Automatizada:** Aplica um conjunto robusto de regras de firewall com um único comando.
  * **Prevenção de Bloqueio SSH:** Detecta automaticamente o IP da sua conexão atual e o utiliza como sugestão, garantindo que você não perca o acesso ao servidor.
  * **Acesso SSH Restrito:** Permite conexões na porta 22 apenas a partir de um endereço IP estático e confiável que você definir.
  * **Pronto para Servidores Web:** Abre as portas padrão para tráfego HTTP (`80`), HTTPS (`443`) e portas alternativas comuns (`8081`, `8443`).
  * **Pronto para Testes de Velocidade:** Configura as portas necessárias para os servidores **Ookla Speedtest** e **nPerf**.
  * **Seguro por Padrão:** Adota a política padrão de bloquear todo o tráfego de entrada (`incoming`) e permitir todo o tráfego de saída (`outgoing`).

### 📋 Pré-requisitos

  * Um sistema operacional baseado em Ubuntu (ex: Ubuntu 20.04, 22.04, etc.).
  * Acesso ao servidor com privilégios de `sudo` ou `root`.
  * O `UFW` deve estar instalado (geralmente vem por padrão no Ubuntu).

### 🚀 Como Usar

1.  **Clone o repositório ou baixe o script:**

    ```bash
    git clone [URL_DO_SEU_REPOSITÓRIO_GIT]
    cd [NOME_DO_SEU_REPOSITÓRIO]
    ```

    Ou, para baixar apenas o script:

    ```bash
    wget https://raw.githubusercontent.com/[SEU_USUARIO]/[SEU_REPOSITORIO]/main/firewall_final_setup.sh
    ```

2.  **Dê permissão de execução ao script:**

    ```bash
    chmod +x firewall_final_setup.sh
    ```

3.  **Execute o script com `sudo`:**

    ```bash
    sudo ./firewall_final_setup.sh
    ```

4.  **Siga as instruções:**

      * O script irá detectar e exibir seu endereço IP atual.
      * Você será solicitado a confirmar este IP ou inserir outro IP confiável para o acesso SSH.
      * Confirme a operação para que as regras sejam aplicadas e o firewall ativado.

### Firewall Rules Applied

O script aplicará as seguintes regras de **ENTRADA (INCOMING)**:

| Porta(s) | Protocolo | Origem | Descrição |
| :--- | :--- | :--- | :--- |
| `22` | TCP | **Seu IP Confiável** | Acesso SSH seguro |
| `80`, `443` | TCP | Qualquer Lugar | Servidor Web (HTTP, HTTPS) |
| `8080`, `8081`, `8443` | TCP | Qualquer Lugar | Portas alternativas para aplicações web/serviços |
| `8080`, `5060` | TCP/UDP | Qualquer Lugar | Servidor Ookla Speedtest |
| `5000:5100` | UDP | Qualquer Lugar | Transferência de dados do nPerf Server |

A política de **SAÍDA (OUTGOING)** é **PERMITIR TUDO** por padrão, o que já cobre as necessidades de DNS, atualizações de pacotes e outras conexões iniciadas pelo servidor.

-----

-----

## 🇺🇸 English Version

### ✨ Features

  * **Automated Setup:** Applies a robust set of firewall rules with a single command.
  * **SSH Lockout Prevention:** Automatically detects the IP of your current connection and suggests it, ensuring you don't lose access to your server.
  * **Restricted SSH Access:** Allows connections on port 22 only from a static, trusted IP address that you define.
  * **Web Server Ready:** Opens standard ports for HTTP (`80`), HTTPS (`443`), and common alternative ports (`8081`, `8443`).
  * **Speed Test Ready:** Configures the necessary ports for **Ookla Speedtest** and **nPerf** servers.
  * **Secure by Default:** Adopts the standard policy of blocking all incoming traffic and allowing all outgoing traffic.

### 📋 Prerequisites

  * An Ubuntu-based operating system (e.g., Ubuntu 20.04, 22.04, etc.).
  * Server access with `sudo` or `root` privileges.
  * `UFW` must be installed (it is included by default in Ubuntu).

### 🚀 How to Use

1.  **Clone the repository or download the script:**

    ```bash
    git clone [YOUR_GIT_REPOSITORY_URL]
    cd [YOUR_REPOSITORY_NAME]
    ```

    Or, to download just the script file:

    ```bash
    wget https://raw.githubusercontent.com/[YOUR_USERNAME]/[YOUR_REPO]/main/firewall_final_setup.sh
    ```

2.  **Make the script executable:**

    ```bash
    chmod +x firewall_final_setup.sh
    ```

3.  **Run the script with `sudo`:**

    ```bash
    sudo ./firewall_final_setup.sh
    ```

4.  **Follow the on-screen prompts:**

      * The script will detect and display your current IP address.
      * You will be asked to confirm this IP or enter another trusted IP for SSH access.
      * Confirm the operation to apply the rules and enable the firewall.

### Firewall Rules Applied

The script will apply the following **INCOMING** rules:

| Port(s) | Protocol | Source | Description |
| :--- | :--- | :--- | :--- |
| `22` | TCP | **Your Trusted IP** | Secure SSH Access |
| `80`, `443` | TCP | Anywhere | Web Server (HTTP, HTTPS) |
| `8080`, `8081`, `8443` | TCP | Anywhere | Alternative ports for web apps/services |
| `8080`, `5060` | TCP/UDP | Anywhere | Ookla Speedtest Server |
| `5000:5100` | UDP | Anywhere | nPerf Server data transfer |

The **OUTGOING** policy is set to **ALLOW ALL** by default, which already covers the needs for DNS, package updates, and other connections initiated by the server.
