#!/bin/bash

# ==============================================================================
# Script de Configuração do UFW (Versão 1 - Servidor Web e Teste de Velocidade)
#
# Configura o firewall para:
# 1. Acesso SSH restrito a um IP confiável.
# 2. Portas abertas para servidores web (HTTP/HTTPS).
# 3. Portas abertas para servidores de teste de velocidade (Ookla/nPerf).
# 4. Política de saída padrão permissiva, que já inclui DNS, HTTP, etc.
# ==============================================================================

# Cores para a saída
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # Sem Cor

# --- Verificações Iniciais ---
echo -e "${GREEN}Iniciando a configuração completa do firewall UFW...${NC}"

if [ "$EUID" -ne 0 ]; then
  echo -e "${RED}Erro: Este script precisa ser executado como root (use sudo).${NC}"
  exit 1
fi

# --- Detecção e Confirmação do IP ---
DETECTED_IP=$(who -m | awk '{print $5}' | tr -d '()')

if [ -z "$DETECTED_IP" ]; then
    echo -e "${RED}Não foi possível detectar seu endereço IP atual. Abortando por segurança.${NC}"
    exit 1
fi

echo -e "\n${YELLOW}----------------------------------------------------------------------${NC}"
echo -e "${YELLOW}AVISO: O acesso SSH (porta 22) será restrito a um único IP.${NC}"
echo -e "Certifique-se de que o IP fornecido é estático e confiável."
echo -e "${YELLOW}----------------------------------------------------------------------${NC}"

echo -e "\nDetectamos que sua conexão atual é do IP: ${GREEN}${DETECTED_IP}${NC}"
read -p "Insira o IP confiável para acesso SSH (ou pressione Enter para usar o detectado): " TRUSTED_IP

TRUSTED_IP=${TRUSTED_IP:-$DETECTED_IP}

echo ""
echo -e "O acesso SSH será permanentemente permitido para o IP: ${GREEN}${TRUSTED_IP}${NC}"
read -p "Você confirma que esta informação está correta? (s/n): " confirm
if [[ "$confirm" != "s" && "$confirm" != "S" ]]; then
    echo -e "${RED}Configuração abortada pelo usuário.${NC}"
    exit 1
fi

# --- Configuração Segura do UFW ---
echo -e "\n${GREEN}Iniciando a sequência de configuração segura...${NC}"

echo "[PASSO 1/5] Definindo políticas padrão..."
ufw default deny incoming
ufw default allow outgoing
echo -e "   -> Política de ENTRADA: ${RED}NEGAR TUDO${NC}"
echo -e "   -> Política de SAÍDA:   ${GREEN}PERMITIR TUDO${NC}"

# AVISO SOBRE AS REGRAS DE SAÍDA
echo -e "\n${YELLOW}💡 Nota sobre as regras de saída (OUTGOING):${NC}"
echo -e "Como a política padrão é 'allow outgoing', o servidor já tem permissão"
echo -e "para realizar conexões de saída em TODAS as portas (incluindo DNS 53,"
echo -e "HTTP 80 e HTTPS 443). Adicionar regras específicas de saída é redundante"
echo -e "e não é necessário.${NC}"


echo -e "\n[PASSO 2/5] Adicionando regra de segurança para seu IP (${TRUSTED_IP})..."
ufw allow from ${TRUSTED_IP} to any port 22 proto tcp

echo "[PASSO 3/5] Adicionando regras de ENTRADA para serviços..."
# Regras para Servidor Web
echo "   -> Permitindo HTTP (80) e HTTPS (443)..."
ufw allow 80/tcp
ufw allow 443/tcp
# Regras para Servidores de Aplicação/Teste
echo "   -> Permitindo portas de aplicação e teste (8080, 8081, 8443)..."
ufw allow 8080/tcp
ufw allow 8081/tcp
ufw allow 8443/tcp
# Regras para OoklaServer e nPerf (UDP)
echo "   -> Permitindo portas UDP para testes de velocidade..."
ufw allow 8080/udp
ufw allow 5060/tcp
ufw allow 5060/udp
ufw allow 5000:5100/udp

echo "[PASSO 4/5] Removendo regras SSH genéricas antigas (se existirem)..."
ufw delete allow ssh > /dev/null 2>&1
ufw delete allow 22 > /dev/null 2>&1

echo "[PASSO 5/5] Ativando o UFW com as novas regras (modo não interativo)..."
ufw_enable_output=$(ufw --force enable)

if [[ "$ufw_enable_output" == *"Firewall is active and enabled on system startup"* ]]; then
    echo -e "\n${GREEN}============================================================${NC}"
    echo -e "${GREEN}      Firewall Configurado e Ativo com Sucesso!             ${NC}"
    echo -e "${GREEN}      Seu acesso a partir de ${TRUSTED_IP} está garantido.${NC}"
    echo -e "${GREEN}============================================================${NC}"
else
    echo -e "\n${RED}ATENÇÃO: Ocorreu um problema ao ativar o UFW. Verifique a saída.${NC}"
fi

# --- Exibindo o Status Final ---
echo -e "\n${YELLOW}Status final do UFW:${NC}"
ufw status verbose
