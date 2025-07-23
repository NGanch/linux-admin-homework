#!/bin/bash

# Кольори для виводу
GREEN='\033[0;32m'
NC='\033[0m' # Без кольору

echo -e "${GREEN}Починаємо встановлення DevOps-інструментів...${NC}"

# Оновлення системи
sudo apt update -y && sudo apt upgrade -y
    
# Встановлення Docker
if ! command -v docker &> /dev/null; then
    echo -e "${GREEN}Встановлюємо Docker...${NC}"
    sudo apt install -y ca-certificates curl gnupg lsb-release
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt update -y
    sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    sudo usermod -aG docker "$USER"
    echo -e "${GREEN}Docker встановлено.${NC}"
else
    echo -e "${GREEN}Docker вже встановлено.${NC}"
fi

# Встановлення Docker Compose
if ! docker compose version &> /dev/null; then
    echo -e "${GREEN}Встановлюємо Docker Compose...${NC}"
    DOCKER_COMPOSE_VERSION="2.20.2"
    sudo curl -L "https://github.com/docker/compose/releases/download/v$DOCKER_COMPOSE_VERSION/docker-compose-$(uname -s)-$(uname -m)" \
      -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    echo -e "${GREEN}Docker Compose встановлено.${NC}"
else
    echo -e "${GREEN}Docker Compose вже встановлено.${NC}"
fi

# Встановлення Python
if ! python3 --version | grep -q "3.9\|[4-9]"; then
    echo -e "${GREEN}Встановлюємо Python 3.9+...${NC}"
    sudo apt install -y software-properties-common
    sudo add-apt-repository -y ppa:deadsnakes/ppa
    sudo apt update -y
    sudo apt install -y python3.9 python3.9-venv python3.9-dev python3-pip
    sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.9 1
    echo -e "${GREEN}Python встановлено.${NC}"
else
    echo -e "${GREEN}Python вже встановлено.${NC}"
fi

# Встановлення Django
if ! python3 -m pip show django &> /dev/null; then
    echo -e "${GREEN}Встановлюємо Django...${NC}"
    python3 -m pip install --upgrade pip
    python3 -m pip install django
    echo -e "${GREEN}Django встановлено.${NC}"
else
    echo -e "${GREEN}Django вже встановлено.${NC}"
fi

echo -e "${GREEN}Усі інструменти успішно встановлено.${NC}"
