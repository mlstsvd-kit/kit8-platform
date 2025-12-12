#!/bin/bash

# Скрипт для установки и запуска проекта KIT8 Platform на Ubuntu

echo "Установка зависимостей для проекта KIT8 Platform..."

# Обновление списка пакетов
sudo apt update

# Установка Git
echo "Установка Git..."
sudo apt install -y git

# Установка Go
echo "Установка Go..."
wget https://golang.org/dl/go1.21.0.linux-amd64.tar.gz
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf go1.21.0.linux-amd64.tar.gz
echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc
source ~/.bashrc

# Установка Node.js и npm
echo "Установка Node.js и npm..."
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install -y nodejs

# Установка Docker
echo "Установка Docker..."
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt update
sudo apt install -y docker-ce
sudo usermod -aG docker $USER

# Установка Docker Compose
echo "Установка Docker Compose..."
sudo curl -L "https://github.com/docker/compose/releases/download/v2.20.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Клонирование репозитория
echo "Клонирование репозитория..."
git clone https://github.com/vash-proekt/kit8-platform.git
cd kit8-platform

# Установка зависимостей для Go
echo "Установка зависимостей для Go..."
cd backend
go mod tidy
cd ..

# Установка зависимостей для фронтенда
echo "Установка зависимостей для фронтенда..."
cd frontend
npm install
cd ..

# Возврат в корень проекта
cd ..

# Запуск проекта
echo "Запуск проекта..."
docker-compose -f docker/docker-compose.yml up --build