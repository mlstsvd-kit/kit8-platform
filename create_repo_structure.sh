#!/bin/bash

# Скрипт для создания репозитория и загрузки кода проекта KIT8 Platform на GitHub

# Установка переменных
REPO_NAME="kit8-platform"
GITHUB_USER="mlstsvd-kit"
REPO_URL="https://github.com/$GITHUB_USER/$REPO_NAME.git"

# Создание директории для проекта
mkdir -p $REPO_NAME
cd $REPO_NAME

# Инициализация git репозитория
git init

# Создание структуры проекта
mkdir -p backend/cmd/api
mkdir -p backend/internal/modules/crm
mkdir -p backend/internal/modules/inventory
mkdir -p backend/internal/modules/orders
mkdir -p backend/internal/modules/cashier
mkdir -p frontend/crm
mkdir -p frontend/deals
mkdir -p frontend/shared/components
mkdir -p docker

# Создание .gitignore
cat > .gitignore << EOF
# Dependencies
node_modules/
vendor/

# Environment specific
.env
.env.local
.env.development.local
.env.test.local
.env.production.local

# Go build files
*.exe
*.dll
*.so
*.dylib

# IDE files
.vscode/
.idea/
*.swp
*.swo

# OS generated files
.DS_Store
Thumbs.db

# Logs
*.log
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# Coverage
coverage/
*.lcov
EOF

# Создание файлов проекта

# README.md
cat > README.md << 'EOF'
# KIT8 Platform

KIT8 Platform — модульная SaaS-платформа для малого бизнеса. Концепция: "Netflix для бизнес-функций". Владельцы бизнесов выбирают нужные модули (CRM, Склад, Заказы) и платят только за них ($X/модуль/месяц).

Девиз: "Собери свой бизнес как конструктор"

## Архитектура

### Технический стек
- Frontend: Vue 3 + TypeScript + Vite + Tailwind CSS + PWA
- Backend: Go 1.21+ (Fiber framework) + PostgreSQL 15 + Redis + NATS
- Инфраструктура: Docker + Docker Compose + Nginx
- Архитектура: Микросервисы (шаблоны модулей) + единая БД с фильтрацией по company_id

### Структура каталогов
```
/home/app/kit8/
├── frontend/                    # Весь фронтенд
│   ├── index.html              # Главная страница
│   ├── crm/                    # Модуль CRM
│   │   ├── index.html
│   │   ├── styles.css
│   │   └── app.js
│   ├── deals/                  # Модуль Сделки
│   │   ├── index.html
│   │   ├── styles.css
│   │   └── app.js
│   └── shared/                 # Общие ресурсы
│       ├── styles.css
│       ├── api.js
│       └── components/
│           ├── Header.js
│           ├── Modal.js
│           └── Dropdown.js
├── backend/                    # Go бэкенд
│   ├── cmd/api/main.go
│   ├── internal/
│   │   ├── core/              # Ядро платформы
│   │   ├── modules/           # Шаблоны модулей
│   │   └── database/          # Работа с БД
│   └── pkg/
│       └── utils/
├── docker/                     # Docker конфиги
│   ├── Dockerfile.backend
│   ├── Dockerfile.frontend
│   └── docker-compose.yml
└── scripts/                   # Скрипты деплоя
```

## Дизайн система KIT8

- Цвета: Синий океана (#1E3A8A) + оранжевый акцент (#F97316)
- Логотип: Кит + цифра 8 (🐋 KIT8)
- Стиль: Чистый, минималистичный, PWA-friendly

## Модули (Приоритет разработки)

1. CRM - Супер-простая CRM за $7/мес (MVP готов)
   - Управление контактами
   - Управление сделками
   - Статистика по сделкам

2. Сделки - Воронка продаж (в разработке)
   - Доска Kanban (Новые, В работе, Выиграны, Проиграны)
   - Интеграция с CRM
   - Поиск и фильтрация

3. Склад - Учёт товаров
   - Управление товарами (CRUD)
   - Категории и артикулы
   - Статистика остатков

4. Заказы - Приём заказов
   - Управление заказами (CRUD)
   - Статусы заказов
   - Интеграция с CRM и Складом

5. Касса - Онлайн-касса
   - Обработка платежей
   - Различные методы оплаты
   - Возвраты и статистика

## Установка на Ubuntu (с помощью скрипта)

1. Скопируйте репозиторий:
```bash
git clone https://github.com/vash-proekt/kit8-platform.git
cd kit8-platform
```

2. Сделайте скрипт установки исполняемым:
```bash
chmod +x setup_project.sh
```

3. Запустите скрипт установки:
```bash
./setup_project.sh
```

Скрипт автоматически:
- Установит все необходимые зависимости (Git, Go, Node.js, Docker, Docker Compose)
- Настроит переменные окружения
- Клонирует репозиторий
- Установит зависимости для Go и Node.js
- Запустит проект с помощью Docker Compose

## Ручная установка на Ubuntu

1. Установите зависимости:
```bash
# Обновите список пакетов
sudo apt update

# Установите Git
sudo apt install -y git

# Установите Go (версия 1.21 или выше)
wget https://golang.org/dl/go1.21.0.linux-amd64.tar.gz
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf go1.21.0.linux-amd64.tar.gz
echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc
source ~/.bashrc

# Установите Node.js и npm
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install -y nodejs

# Установите Docker
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt update
sudo apt install -y docker-ce
sudo usermod -aG docker $USER

# Установите Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/v2.20.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

2. Клонируйте репозиторий:
```bash
git clone https://github.com/vash-proekt/kit8-platform.git
cd kit8-platform
```

3. Установите зависимости для Go:
```bash
cd backend
go mod tidy
cd ..
```

4. Установите зависимости для фронтенда:
```bash
cd frontend
npm install
cd ..
```

5. Запустите проект:
```bash
docker-compose -f docker/docker-compose.yml up --build
```

После запуска:
- Фронтенд будет доступен по адресу http://localhost:8080
- Бэкенд API будет доступен по адресу http://localhost:3000
- База данных PostgreSQL будет доступна на порту 5432

## Разработка

### Добавление новых модулей

Для добавления нового модуля:

1. Создайте директорию в `frontend/` с названием модуля
2. Добавьте соответствующие файлы (index.html, styles.css, app.js)
3. Реализуйте бэкенд логику в `backend/internal/modules/{module_name}/`
4. Обновите маршруты в бэкенде

### Архитектурные особенности

- Изоляция данных: Все таблицы имеют `company_id`, автоматическая фильтрация через middleware
- Шаблоны модулей: Один код → много экземпляров для разных компаний
- PWA: Работает оффлайн, устанавливается как приложение
- Ценовая модель: $X/модуль/месяц (не за пользователя!)

## API Reference

### CRM Module
- `GET /api/crm/contacts` - Получить список контактов
- `POST /api/crm/contacts` - Создать контакт
- `PUT /api/crm/contacts/{id}` - Обновить контакт
- `DELETE /api/crm/contacts/{id}` - Удалить контакт

- `GET /api/crm/deals` - Получить список сделок
- `POST /api/crm/deals` - Создать сделку
- `PUT /api/crm/deals/{id}` - Обновить сделку
- `DELETE /api/crm/deals/{id}` - Удалить сделку

- `GET /api/crm/deals/stats` - Получить статистику по сделкам

### Inventory Module
- `GET /api/inventory/products` - Получить список товаров
- `POST /api/inventory/products` - Создать товар
- `PUT /api/inventory/products/{id}` - Обновить товар
- `DELETE /api/inventory/products/{id}` - Удалить товар
- `GET /api/inventory/products/{id}` - Получить информацию о товаре
- `GET /api/inventory/stats` - Получить статистику по складу

### Orders Module
- `GET /api/orders` - Получить список заказов
- `POST /api/orders` - Создать заказ
- `PUT /api/orders/{id}` - Обновить заказ
- `DELETE /api/orders/{id}` - Удалить заказ
- `GET /api/orders/{id}` - Получить информацию о заказе
- `GET /api/orders/stats` - Получить статистику по заказам

### Cashier Module
- `GET /api/cashier/payments` - Получить список платежей
- `POST /api/cashier/payments` - Создать платеж
- `PUT /api/cashier/payments/{id}` - Обновить платеж
- `POST /api/cashier/process` - Обработать платеж
- `POST /api/cashier/refund/{id}` - Вернуть средства
- `GET /api/cashier/stats` - Получить статистику по кассе

## Deployment

Для деплоя используйте предоставленные Docker конфиги:

```bash
# Сборка образов
docker build -f docker/Dockerfile.backend -t kit8-backend .
docker build -f docker/Dockerfile.frontend -t kit8-frontend .

# Запуск в продакшене
docker-compose -f docker/docker-compose.prod.yml up -d
```

## Цели на MVP (3 месяца)

### Месяц 1: 
- Работающий CRM модуль
- 5 пилотных клиентов

### Месяц 2:
- Модули Сделки + Склад
- Биллинг

### Месяц 3:
- PWA + оффлайн-режим
- Маркетплейс модулей
EOF

# setup_project.sh
cat > setup_project.sh << 'EOF'
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
git clone https://github.com/mlstsvd-kit/kit8-platform.git
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
EOF

# backend/go.mod
cat > backend/go.mod << 'EOF'
module kit8-backend

go 1.21

require github.com/gofiber/fiber/v2 v2.52.2
EOF

# backend/cmd/api/main.go
cat > backend/cmd/api/main.go << 'EOF'
package main

import (
	"log"

	"github.com/gofiber/fiber/v2"
	"github.com/gofiber/fiber/v2/middleware/cors"
	"github.com/gofiber/fiber/v2/middleware/logger"
	
	// Импортируем наши модули
	crm "kit8-backend/internal/modules/crm"
	inventory "kit8-backend/internal/modules/inventory"
	orders "kit8-backend/internal/modules/orders"
	cashier "kit8-backend/internal/modules/cashier"
)

func main() {
	app := fiber.New()

	// Middleware
	app.Use(logger.New())
	app.Use(cors.New())

	// Инициализируем контроллеры
	crmController := crm.NewController()
	inventoryController := inventory.NewController()
	ordersController := orders.NewController()
	cashierController := cashier.NewController()

	// Маршруты API
	api := app.Group("/api")

	// CRM маршруты
	crmRoutes := api.Group("/crm")
	crmRoutes.Get("/contacts", crmController.GetContacts)
	crmRoutes.Post("/contacts", crmController.CreateContact)
	crmRoutes.Put("/contacts/:id", crmController.UpdateContact)
	crmRoutes.Delete("/contacts/:id", crmController.DeleteContact)
	crmRoutes.Get("/deals", crmController.GetDeals)
	crmRoutes.Post("/deals", crmController.CreateDeal)
	crmRoutes.Put("/deals/:id", crmController.UpdateDeal)
	crmRoutes.Delete("/deals/:id", crmController.DeleteDeal)
	crmRoutes.Get("/deals/stats", crmController.GetDealStats)

	// Inventory маршруты
	inventoryRoutes := api.Group("/inventory")
	inventoryRoutes.Get("/products", inventoryController.GetProducts)
	inventoryRoutes.Post("/products", inventoryController.CreateProduct)
	inventoryRoutes.Put("/products/:id", inventoryController.UpdateProduct)
	inventoryRoutes.Delete("/products/:id", inventoryController.DeleteProduct)
	inventoryRoutes.Get("/products/:id", inventoryController.GetProduct)
	inventoryRoutes.Get("/stats", inventoryController.GetInventoryStats)

	// Orders маршруты
	ordersRoutes := api.Group("/orders")
	ordersRoutes.Get("/orders", ordersController.GetOrders)
	ordersRoutes.Post("/orders", ordersController.CreateOrder)
	ordersRoutes.Put("/orders/:id", ordersController.UpdateOrder)
	ordersRoutes.Delete("/orders/:id", ordersController.DeleteOrder)
	ordersRoutes.Get("/orders/:id", ordersController.GetOrder)
	ordersRoutes.Get("/stats", ordersController.GetOrderStats)

	// Cashier маршруты
	cashierRoutes := api.Group("/cashier")
	cashierRoutes.Get("/payments", cashierController.GetPayments)
	cashierRoutes.Post("/payments", cashierController.CreatePayment)
	cashierRoutes.Put("/payments/:id", cashierController.UpdatePayment)
	cashierRoutes.Post("/process", cashierController.ProcessPayment)
	cashierRoutes.Post("/refund/:id", cashierController.RefundPayment)
	cashierRoutes.Get("/stats", cashierController.GetCashierStats)

	log.Fatal(app.Listen(":3000"))
}
EOF

# backend/internal/modules/crm/handlers.go
cat > backend/internal/modules/crm/handlers.go << 'EOF'
package crm

import (
	"net/http"
	"strconv"

	"github.com/gofiber/fiber/v2"
)

// Contact представляет контакт в CRM
type Contact struct {
	ID       int    `json:"id"`
	Name     string `json:"name"`
	Email    string `json:"email"`
	Phone    string `json:"phone"`
	Company  string `json:"company"`
	CustomerID int  `json:"customer_id"` // ID компании
}

// Deal представляет сделку в CRM
type Deal struct {
	ID          int     `json:"id"`
	Title       string `json:"title"`
	Value       float64 `json:"value"`
	ContactID   int     `json:"contact_id"`
	Stage       string  `json:"stage"` // new, in-progress, won, lost
	CustomerID  int     `json:"customer_id"` // ID компании
	CreatedAt   string  `json:"created_at"`
	UpdatedAt   string `json:"updated_at"`
}

// DealStats представляет статистику по сделкам
type DealStats struct {
	TotalCount   int     `json:"total_count"`
	WonCount     int     `json:"won_count"`
	LostCount    int     `json:"lost_count"`
	TotalValue   float64 `json:"total_value"`
	AverageValue float64 `json:"average_value"`
}

// Контроллер CRM
type Controller struct {
	// Здесь будут зависимости, например, сервисы и репозитории
	// Для упрощения в этом примере будем использовать заглушку
}

// NewController создает новый контроллер CRM
func NewController() *Controller {
	return &Controller{}
}

// GetContacts возвращает список контактов
func (ctrl *Controller) GetContacts(c *fiber.Ctx) error {
	// Получаем ID компании из контекста (предполагается, что он был установлен в middleware)
	customerID := c.Locals("customer_id").(int)
	
	// В реальном приложении здесь будет вызов сервисного слоя
	// и фильтрация по customerID
	contacts := []Contact{
		{ID: 1, Name: "Иван Петров", Email: "ivan@example.com", Phone: "+71234567890", Company: "ООО Ромашка", CustomerID: customerID},
		{ID: 2, Name: "Мария Сидорова", Email: "maria@example.com", Phone: "+71234567891", Company: "ИП Сидоров", CustomerID: customerID},
	}
	
	return c.JSON(contacts)
}

// CreateContact создает новый контакт
func (ctrl *Controller) CreateContact(c *fiber.Ctx) error {
	// Получаем ID компании из контекста
	customerID := c.Locals("customer_id").(int)
	
	// Парсим тело запроса
	var contact Contact
	if err := c.BodyParser(&contact); err != nil {
		return c.Status(http.StatusBadRequest).JSON(fiber.Map{"error": "Invalid request body"})
	}
	
	// Устанавливаем ID компании для нового контакта
	contact.CustomerID = customerID
	
	// В реальном приложении здесь будет вызов сервисного слоя
	// для сохранения контакта в базе данных
	// contact.ID = generateNextID() // генерация нового ID
	
	// Возвращаем созданный контакт
	return c.JSON(contact)
}

// UpdateContact обновляет существующий контакт
func (ctrl *Controller) UpdateContact(c *fiber.Ctx) error {
	// Получаем ID компании из контекста
	customerID := c.Locals("customer_id").(int)
	
	// Получаем ID контакта из параметров URL
	id, err := strconv.Atoi(c.Params("id"))
	if err != nil {
		return c.Status(http.StatusBadRequest).JSON(fiber.Map{"error": "Invalid contact ID"})
	}
	
	// Парсим тело запроса
	var updatedContact Contact
	if err := c.BodyParser(&updatedContact); err != nil {
		return c.Status(http.StatusBadRequest).JSON(fiber.Map{"error": "Invalid request body"})
	}
	
	// В реальном приложении здесь будет вызов сервисного слоя
	// для обновления контакта в базе данных с проверкой, 
	// принадлежит ли он текущей компании (customerID)
	
	// Возвращаем обновленный контакт
	updatedContact.ID = id
	updatedContact.CustomerID = customerID
	return c.JSON(updatedContact)
}

// DeleteContact удаляет контакт
func (ctrl *Controller) DeleteContact(c *fiber.Ctx) error {
	// Получаем ID компании из контекста
	customerID := c.Locals("customer_id").(int)
	
	// Получаем ID контакта из параметров URL
	id, err := strconv.Atoi(c.Params("id"))
	if err != nil {
		return c.Status(http.StatusBadRequest).JSON(fiber.Map{"error": "Invalid contact ID"})
	}
	
	// В реальном приложении здесь будет вызов сервисного слоя
	// для удаления контакта из базы данных с проверкой, 
	// принадлежит ли он текущей компании (customerID)
	
	// Возвращаем успешный ответ
	return c.SendStatus(http.StatusOK)
}

// GetDeals возвращает список сделок
func (ctrl *Controller) GetDeals(c *fiber.Ctx) error {
	// Получаем ID компании из контекста
	customerID := c.Locals("customer_id").(int)
	
	// В реальном приложении здесь будет вызов сервисного слоя
	// и фильтрация по customerID
	deals := []Deal{
		{ID: 1, Title: "Сделка 1", Value: 10000.0, ContactID: 1, Stage: "new", CustomerID: customerID, CreatedAt: "2023-01-01T00:00:00Z", UpdatedAt: "2023-01-01T00:00:00Z"},
		{ID: 2, Title: "Сделка 2", Value: 25000.0, ContactID: 2, Stage: "in-progress", CustomerID: customerID, CreatedAt: "2023-01-02T00:00:00Z", UpdatedAt: "2023-01-02T00:00:00Z"},
		{ID: 3, Title: "Сделка 3", Value: 15000.0, ContactID: 1, Stage: "won", CustomerID: customerID, CreatedAt: "2023-01-03T00:00:00Z", UpdatedAt: "2023-01-03T00:00:0Z"},
	}
	
	return c.JSON(deals)
}

// CreateDeal создает новую сделку
func (ctrl *Controller) CreateDeal(c *fiber.Ctx) error {
	// Получаем ID компании из контекста
	customerID := c.Locals("customer_id").(int)
	
	// Парсим тело запроса
	var deal Deal
	if err := c.BodyParser(&deal); err != nil {
		return c.Status(http.StatusBadRequest).JSON(fiber.Map{"error": "Invalid request body"})
	}
	
	// Устанавливаем ID компании для новой сделки
	deal.CustomerID = customerID
	deal.Stage = "new" // Устанавливаем начальный этап
	
	// В реальном приложении здесь будет вызов сервисного слоя
	// для сохранения сделки в базе данных
	// deal.ID = generateNextID() // генерация нового ID
	
	// Возвращаем созданную сделку
	return c.JSON(deal)
}

// UpdateDeal обновляет существующую сделку
func (ctrl *Controller) UpdateDeal(c *fiber.Ctx) error {
	// Получаем ID компании из контекста
	customerID := c.Locals("customer_id").(int)
	
	// Получаем ID сделки из параметров URL
	id, err := strconv.Atoi(c.Params("id"))
	if err != nil {
		return c.Status(http.StatusBadRequest).JSON(fiber.Map{"error": "Invalid deal ID"})
	}
	
	// Парсим тело запроса
	var updatedDeal Deal
	if err := c.BodyParser(&updatedDeal); err != nil {
		return c.Status(http.StatusBadRequest).JSON(fiber.Map{"error": "Invalid request body"})
	}
	
	// В реальном приложении здесь будет вызов сервисного слоя
	// для обновления сделки в базе данных с проверкой, 
	// принадлежит ли она текущей компании (customerID)
	
	// Возвращаем обновленную сделку
	updatedDeal.ID = id
	updatedDeal.CustomerID = customerID
	return c.JSON(updatedDeal)
}

// DeleteDeal удаляет сделку
func (ctrl *Controller) DeleteDeal(c *fiber.Ctx) error {
	// Получаем ID компании из контекста
	customerID := c.Locals("customer_id").(int)
	
	// Получаем ID сделки из параметров URL
	id, err := strconv.Atoi(c.Params("id"))
	if err != nil {
		return c.Status(http.StatusBadRequest).JSON(fiber.Map{"error": "Invalid deal ID"})
	}
	
	// В реальном приложении здесь будет вызов сервисного слоя
	// для удаления сделки из базы данных с проверкой, 
	// принадлежит ли она текущей компании (customerID)
	
	// Возвращаем успешный ответ
	return c.SendStatus(http.StatusOK)
}

// GetDealStats возвращает статистику по сделкам
func (ctrl *Controller) GetDealStats(c *fiber.Ctx) error {
	// Получаем ID компании из контекста
	customerID := c.Locals("customer_id").(int)
	
	// В реальном приложении здесь будет вызов сервисного слоя
	// для получения статистики из базы данных с фильтрацией по customerID
	stats := DealStats{
		TotalCount:   10,
		WonCount:     4,
		LostCount:    2,
		TotalValue:   125000.0,
		AverageValue: 12500.0,
	}
	
	return c.JSON(stats)
}
EOF

# backend/internal/modules/inventory/handlers.go
cat > backend/internal/modules/inventory/handlers.go << 'EOF'
package inventory

import (
	"net/http"
	"strconv"

	"github.com/gofiber/fiber/v2"
)

// Product представляет товар на складе
type Product struct {
	ID          int     `json:"id"`
	Name        string  `json:"name"`
	Description string  `json:"description"`
	Price       float64 `json:"price"`
	Quantity    int     `json:"quantity"`
	SKU         string  `json:"sku"`         // Артикул
	Category    string `json:"category"`
	ImageURL    string  `json:"image_url"`
	CustomerID  int     `json:"customer_id"` // ID компании
	CreatedAt   string `json:"created_at"`
	UpdatedAt   string  `json:"updated_at"`
}

// InventoryStats представляет статистику по складу
type InventoryStats struct {
	TotalProducts   int     `json:"total_products"`
	TotalValue      float64 `json:"total_value"`
	LowStockCount   int     `json:"low_stock_count"`   // Товары с низким остатком
	OutOfStockCount int     `json:"out_of_stock_count"` // Товары отсутствующие на складе
}

// Контроллер Склада
type Controller struct {
	// Здесь будут зависимости, например, сервисы и репозитории
	// Для упрощения в этом примере будем использовать заглушку
}

// NewController создает новый контроллер Склада
func NewController() *Controller {
	return &Controller{}
}

// GetProducts возвращает список товаров
func (ctrl *Controller) GetProducts(c *fiber.Ctx) error {
	// Получаем ID компании из контекста (предполагается, что он был установлен в middleware)
	customerID := c.Locals("customer_id").(int)
	
	// В реальном приложении здесь будет вызов сервисного слоя
	// и фильтрация по customerID
	products := []Product{
		{ID: 1, Name: "Ноутбук", Description: "Ультрабук", Price: 5000.0, Quantity: 10, SKU: "NB-01", Category: "Электроника", ImageURL: "", CustomerID: customerID, CreatedAt: "2023-01-01T00:00:00Z", UpdatedAt: "2023-01-01T00:00:00Z"},
		{ID: 2, Name: "Мышь", Description: "Беспроводная мышь", Price: 150.0, Quantity: 50, SKU: "MS-001", Category: "Аксессуары", ImageURL: "", CustomerID: customerID, CreatedAt: "2023-01-02T00:00:00Z", UpdatedAt: "2023-01-02T00:00:00Z"},
		{ID: 3, Name: "Клавиатура", Description: "Механическая клавиатура", Price: 4500.0, Quantity: 0, SKU: "KB-001", Category: "Аксессуары", ImageURL: "", CustomerID: customerID, CreatedAt: "2023-01-03T00:00:00Z", UpdatedAt: "2023-01-03T00:00:0Z"},
	}
	
	return c.JSON(products)
}

// CreateProduct создает новый товар
func (ctrl *Controller) CreateProduct(c *fiber.Ctx) error {
	// Получаем ID компании из контекста
	customerID := c.Locals("customer_id").(int)
	
	// Парсим тело запроса
	var product Product
	if err := c.BodyParser(&product); err != nil {
		return c.Status(http.StatusBadRequest).JSON(fiber.Map{"error": "Invalid request body"})
	}
	
	// Устанавливаем ID компании для нового товара
	product.CustomerID = customerID
	
	// В реальном приложении здесь будет вызов сервисного слоя
	// для сохранения товара в базе данных
	// product.ID = generateNextID() // генерация нового ID
	
	// Возвращаем созданный товар
	return c.JSON(product)
}

// UpdateProduct обновляет существующий товар
func (ctrl *Controller) UpdateProduct(c *fiber.Ctx) error {
	// Получаем ID компании из контекста
	customerID := c.Locals("customer_id").(int)
	
	// Получаем ID товара из параметров URL
	id, err := strconv.Atoi(c.Params("id"))
	if err != nil {
		return c.Status(http.StatusBadRequest).JSON(fiber.Map{"error": "Invalid product ID"})
	}
	
	// Парсим тело запроса
	var updatedProduct Product
	if err := c.BodyParser(&updatedProduct); err != nil {
	return c.Status(http.StatusBadRequest).JSON(fiber.Map{"error": "Invalid request body"})
	}
	
	// В реальном приложении здесь будет вызов сервисного слоя
	// для обновления товара в базе данных с проверкой, 
	// принадлежит ли он текущей компании (customerID)
	
	// Возвращаем обновленный товар
	updatedProduct.ID = id
	updatedProduct.CustomerID = customerID
	return c.JSON(updatedProduct)
}

// DeleteProduct удаляет товар
func (ctrl *Controller) DeleteProduct(c *fiber.Ctx) error {
	// Получаем ID компании из контекста
	customerID := c.Locals("customer_id").(int)
	
	// Получаем ID товара из параметров URL
	id, err := strconv.Atoi(c.Params("id"))
	if err != nil {
		return c.Status(http.StatusBadRequest).JSON(fiber.Map{"error": "Invalid product ID"})
	}
	
	// В реальном приложении здесь будет вызов сервисного слоя
	// для удаления товара из базы данных с проверкой, 
	// принадлежит ли он текущей компании (customerID)
	
	// Возвращаем успешный ответ
	return c.SendStatus(http.StatusOK)
}

// GetProduct возвращает информацию о конкретном товаре
func (ctrl *Controller) GetProduct(c *fiber.Ctx) error {
	// Получаем ID компании из контекста
	customerID := c.Locals("customer_id").(int)
	
	// Получаем ID товара из параметров URL
	id, err := strconv.Atoi(c.Params("id"))
	if err != nil {
		return c.Status(http.StatusBadRequest).JSON(fiber.Map{"error": "Invalid product ID"})
	}
	
	// В реальном приложении здесь будет вызов сервисного слоя
	// для получения товара из базы данных с проверкой, 
	// принадлежит ли он текущей компании (customerID)
	
	product := Product{
		ID: id, Name: "Пример товара", Description: "Описание товара", Price: 1000.0, 
	Quantity: 5, SKU: "EX-001", Category: "Категория", ImageURL: "", 
	CustomerID: customerID, CreatedAt: "2023-01-01T00:00:00Z", UpdatedAt: "2023-01-01T00:00:00Z",
	}
	
	return c.JSON(product)
}

// GetInventoryStats возвращает статистику по складу
func (ctrl *Controller) GetInventoryStats(c *fiber.Ctx) error {
	// Получаем ID компании из контекста
	customerID := c.Locals("customer_id").(int)
	
	// В реальном приложении здесь будет вызов сервисного слоя
	// для получения статистики из базы данных с фильтрацией по customerID
	stats := InventoryStats{
	TotalProducts:   100,
		TotalValue:      1500000.0,
		LowStockCount:   15,
		OutOfStockCount: 5,
	}
	
	return c.JSON(stats)
}
EOF

# backend/internal/modules/orders/handlers.go
cat > backend/internal/modules/orders/handlers.go << 'EOF'
package orders

import (
	"net/http"
	"strconv"

	"github.com/gofiber/fiber/v2"
)

// OrderItem представляет товар в заказе
type OrderItem struct {
	ID       int     `json:"id"`
	ProductID int    `json:"product_id"`
	ProductName string `json:"product_name"`
	Quantity int     `json:"quantity"`
	Price    float64 `json:"price"`
	Total    float64 `json:"total"` // Quantity * Price
}

// Order представляет заказ
type Order struct {
	ID           int          `json:"id"`
	CustomerID   int          `json:"customer_id"` // ID компании
	ContactID    int          `json:"contact_id"`  // ID клиента из CRM
	Items        []OrderItem `json:"items"`
	TotalAmount  float64      `json:"total_amount"`
	Status       string       `json:"status"`      // new, confirmed, in-progress, shipped, delivered, cancelled
	PaymentStatus string      `json:"payment_status"` // unpaid, paid, refunded, pending
	ShippingAddress string   `json:"shipping_address"`
	Notes        string       `json:"notes"`
	CreatedAt    string       `json:"created_at"`
	UpdatedAt    string       `json:"updated_at"`
}

// OrderStats представляет статистику по заказам
type OrderStats struct {
	TotalOrders     int     `json:"total_orders"`
	TotalRevenue    float64 `json:"total_revenue"`
	PendingOrders   int     `json:"pending_orders"`
	ProcessingOrders int    `json:"processing_orders"`
	CompletedOrders int     `json:"completed_orders"`
}

// Контроллер Заказов
type Controller struct {
	// Здесь будут зависимости, например, сервисы и репозитории
	// Для упрощения в этом примере будем использовать заглушку
}

// NewController создает новый контроллер Заказов
func NewController() *Controller {
	return &Controller{}
}

// GetOrders возвращает список заказов
func (ctrl *Controller) GetOrders(c *fiber.Ctx) error {
	// Получаем ID компании из контекста (предполагается, что он был установлен в middleware)
	customerID := c.Locals("customer_id").(int)
	
	// В реальном приложении здесь будет вызов сервисного слоя
	// и фильтрация по customerID
	orders := []Order{
		{
			ID: 1, CustomerID: customerID, ContactID: 1, 
			Items: []OrderItem{
				{ID: 1, ProductID: 1, ProductName: "Ноутбук", Quantity: 1, Price: 5000.0, Total: 5000.0},
			},
			TotalAmount: 50000.0, Status: "confirmed", PaymentStatus: "paid", 
			ShippingAddress: "г. Москва, ул. Примерная, д. 1", 
			Notes: "", CreatedAt: "2023-01-01T00:00:00Z", UpdatedAt: "2023-01-01T00:00:00Z",
		},
		{
			ID: 2, CustomerID: customerID, ContactID: 2, 
			Items: []OrderItem{
				{ID: 2, ProductID: 2, ProductName: "Мышь", Quantity: 2, Price: 1500.0, Total: 3000.0},
			},
			TotalAmount: 3000.0, Status: "new", PaymentStatus: "unpaid", 
			ShippingAddress: "г. Санкт-Петербург, ул. Образцовая, д. 5", 
			Notes: "Доставить после 18:00", CreatedAt: "2023-01-02T00:00:0Z", UpdatedAt: "2023-01-02T00:00:00Z",
		},
	}
	
	return c.JSON(orders)
}

// CreateOrder создает новый заказ
func (ctrl *Controller) CreateOrder(c *fiber.Ctx) error {
	// Получаем ID компании из контекста
	customerID := c.Locals("customer_id").(int)
	
	// Парсим тело запроса
	var order Order
	if err := c.BodyParser(&order); err != nil {
	return c.Status(http.StatusBadRequest).JSON(fiber.Map{"error": "Invalid request body"})
	}
	
	// Устанавливаем ID компании для нового заказа
	order.CustomerID = customerID
	order.Status = "new" // Устанавливаем начальный статус
	order.PaymentStatus = "unpaid" // Устанавливаем начальный статус оплаты
	
	// Вычисляем общую сумму заказа
	total := 0.0
	for i := range order.Items {
	order.Items[i].Total = order.Items[i].Quantity * order.Items[i].Price
		total += order.Items[i].Total
	}
	order.TotalAmount = total
	
	// В реальном приложении здесь будет вызов сервисного слоя
	// для сохранения заказа в базе данных
	// order.ID = generateNextID() // генерация нового ID
	
	// Возвращаем созданный заказ
	return c.JSON(order)
}

// UpdateOrder обновляет существующий заказ
func (ctrl *Controller) UpdateOrder(c *fiber.Ctx) error {
	// Получаем ID компании из контекста
	customerID := c.Locals("customer_id").(int)
	
	// Получаем ID заказа из параметров URL
	id, err := strconv.Atoi(c.Params("id"))
	if err != nil {
		return c.Status(http.StatusBadRequest).JSON(fiber.Map{"error": "Invalid order ID"})
	}
	
	// Парсим тело запроса
	var updatedOrder Order
	if err := c.BodyParser(&updatedOrder); err != nil {
	return c.Status(http.StatusBadRequest).JSON(fiber.Map{"error": "Invalid request body"})
	}
	
	// В реальном приложении здесь будет вызов сервисного слоя
	// для обновления заказа в базе данных с проверкой, 
	// принадлежит ли он текущей компании (customerID)
	
	// Возвращаем обновленный заказ
	updatedOrder.ID = id
	updatedOrder.CustomerID = customerID
	return c.JSON(updatedOrder)
}

// DeleteOrder удаляет заказ
func (ctrl *Controller) DeleteOrder(c *fiber.Ctx) error {
	// Получаем ID компании из контекста
	customerID := c.Locals("customer_id").(int)
	
	// Получаем ID заказа из параметров URL
	id, err := strconv.Atoi(c.Params("id"))
	if err != nil {
		return c.Status(http.StatusBadRequest).JSON(fiber.Map{"error": "Invalid order ID"})
	}
	
	// В реальном приложении здесь будет вызов сервисного слоя
	// для удаления заказа из базы данных с проверкой, 
	// принадлежит ли он текущей компании (customerID)
	
	// Возвращаем успешный ответ
	return c.SendStatus(http.StatusOK)
}

// GetOrder возвращает информацию о конкретном заказе
func (ctrl *Controller) GetOrder(c *fiber.Ctx) error {
	// Получаем ID компании из контекста
	customerID := c.Locals("customer_id").(int)
	
	// Получаем ID заказа из параметров URL
	id, err := strconv.Atoi(c.Params("id"))
	if err != nil {
		return c.Status(http.StatusBadRequest).JSON(fiber.Map{"error": "Invalid order ID"})
	}
	
	// В реальном приложении здесь будет вызов сервисного слоя
	// для получения заказа из базы данных с проверкой, 
	// принадлежит ли он текущей компании (customerID)
	
	order := Order{
		ID: id, CustomerID: customerID, ContactID: 1, 
		Items: []OrderItem{
			{ID: 1, ProductID: 1, ProductName: "Ноутбук", Quantity: 1, Price: 5000.0, Total: 50000.0},
		},
		TotalAmount: 50000.0, Status: "confirmed", PaymentStatus: "paid", 
		ShippingAddress: "г. Москва, ул. Примерная, д. 1", 
		Notes: "", CreatedAt: "2023-01-01T00:00:00Z", UpdatedAt: "2023-01-01T00:00:00Z",
	}
	
	return c.JSON(order)
}

// GetOrderStats возвращает статистику по заказам
func (ctrl *Controller) GetOrderStats(c *fiber.Ctx) error {
	// Получаем ID компании из контекста
	customerID := c.Locals("customer_id").(int)
	
	// В реальном приложении здесь будет вызов сервисного слоя
	// для получения статистики из базы данных с фильтрацией по customerID
	stats := OrderStats{
		TotalOrders:     50,
		TotalRevenue:    125000.0,
		PendingOrders:   5,
		ProcessingOrders: 8,
		CompletedOrders: 35,
	}
	
	return c.JSON(stats)
}
EOF

# backend/internal/modules/cashier/handlers.go
cat > backend/internal/modules/cashier/handlers.go << 'EOF'
package cashier

import (
	"net/http"
	"strconv"

	"github.com/gofiber/fiber/v2"
)

// PaymentMethod представляет способ оплаты
type PaymentMethod struct {
	ID   int    `json:"id"`
	Name string `json:"name"`   // Название способа оплаты (например, "Наличные", "Карта", "Перевод")
	Type string `json:"type"`   // Тип (cash, card, transfer)
}

// Payment представляет платеж
type Payment struct {
	ID             int     `json:"id"`
	OrderID        int     `json:"order_id"`
	CustomerID     int     `json:"customer_id"` // ID компании
	Amount         float64 `json:"amount"`
	PaymentMethod  string  `json:"payment_method"` // Способ оплаты
	Status         string  `json:"status"`         // pending, completed, failed, refunded
	TransactionID  string  `json:"transaction_id"` // ID транзакции у платежного провайдера
	PaymentDate    string `json:"payment_date"`
	CreatedAt      string  `json:"created_at"`
	UpdatedAt      string  `json:"updated_at"`
}

// CashierStats представляет статистику по кассе
type CashierStats struct {
	TotalRevenue     float64 `json:"total_revenue"`
	TodaysRevenue    float64 `json:"todays_revenue"`
	TotalTransactions int    `json:"total_transactions"`
	TodaysTransactions int   `json:"todays_transactions"`
	RefundAmount     float64 `json:"refund_amount"`
}

// Контроллер Кассы
type Controller struct {
	// Здесь будут зависимости, например, сервисы и репозитории
	// Для упрощения в этом примере будем использовать заглушку
}

// NewController создает новый контроллер Кассы
func NewController() *Controller {
	return &Controller{}
}

// GetPayments возвращает список платежей
func (ctrl *Controller) GetPayments(c *fiber.Ctx) error {
	// Получаем ID компании из контекста (предполагается, что он был установлен в middleware)
	customerID := c.Locals("customer_id").(int)
	
	// В реальном приложении здесь будет вызов сервисного слоя
	// и фильтрация по customerID
	payments := []Payment{
		{
			ID: 1, OrderID: 1, CustomerID: customerID, Amount: 50000.0, 
			PaymentMethod: "card", Status: "completed", TransactionID: "txn_123456789", 
			PaymentDate: "2023-01-01T10:00:00Z", CreatedAt: "2023-01-01T10:00Z", UpdatedAt: "2023-01-01T10:00Z",
		},
		{
			ID: 2, OrderID: 2, CustomerID: customerID, Amount: 3000.0, 
			PaymentMethod: "cash", Status: "completed", TransactionID: "cash_987654321", 
			PaymentDate: "2023-01-02T11:30:00Z", CreatedAt: "2023-01-02T11:30:00Z", UpdatedAt: "2023-01-02T11:30:00Z",
		},
	}
	
	return c.JSON(payments)
}

// CreatePayment создает новый платеж
func (ctrl *Controller) CreatePayment(c *fiber.Ctx) error {
	// Получаем ID компании из контекста
	customerID := c.Locals("customer_id").(int)
	
	// Парсим тело запроса
	var payment Payment
	if err := c.BodyParser(&payment); err != nil {
		return c.Status(http.StatusBadRequest).JSON(fiber.Map{"error": "Invalid request body"})
	}
	
	// Устанавливаем ID компании для нового платежа
	payment.CustomerID = customerID
	payment.Status = "pending" // Устанавливаем начальный статус
	
	// В реальном приложении здесь будет вызов сервисного слоя
	// для обработки платежа через платежный шлюз
	// payment.ID = generateNextID() // генерация нового ID
	// payment.TransactionID = generateTransactionID() // генерация ID транзакции
	
	// Возвращаем созданный платеж
	return c.JSON(payment)
}

// UpdatePayment обновляет существующий платеж
func (ctrl *Controller) UpdatePayment(c *fiber.Ctx) error {
	// Получаем ID компании из контекста
	customerID := c.Locals("customer_id").(int)
	
	// Получаем ID платежа из параметров URL
	id, err := strconv.Atoi(c.Params("id"))
	if err != nil {
		return c.Status(http.StatusBadRequest).JSON(fiber.Map{"error": "Invalid payment ID"})
	}
	
	// Парсим тело запроса
	var updatedPayment Payment
	if err := c.BodyParser(&updatedPayment); err != nil {
		return c.Status(http.StatusBadRequest).JSON(fiber.Map{"error": "Invalid request body"})
	}
	
	// В реальном приложении здесь будет вызов сервисного слоя
	// для обновления платежа в базе данных с проверкой, 
	// принадлежит ли он текущей компании (customerID)
	
	// Возвращаем обновленный платеж
	updatedPayment.ID = id
	updatedPayment.CustomerID = customerID
	return c.JSON(updatedPayment)
}

// ProcessPayment обрабатывает платеж (основной метод кассы)
func (ctrl *Controller) ProcessPayment(c *fiber.Ctx) error {
	// Получаем ID компании из контекста
	customerID := c.Locals("customer_id").(int)
	
	// Парсим тело запроса
	var payment Payment
	if err := c.BodyParser(&payment); err != nil {
		return c.Status(http.StatusBadRequest).JSON(fiber.Map{"error": "Invalid request body"})
	}
	
	// Устанавливаем ID компании для платежа
	payment.CustomerID = customerID
	payment.Status = "pending"
	
	// В реальном приложении здесь будет:
	// 1. Проверка данных заказа
	// 2. Вызов платежного шлюза
	// 3. Обработка ответа от платежного шлюза
	// 4. Обновление статуса платежа
	// 5. Обновление статуса заказа
	
	// Возвращаем результат обработки платежа
	return c.JSON(fiber.Map{
		"status": "pending",
		"transaction_id": payment.TransactionID,
		"amount": payment.Amount,
	})
}

// RefundPayment возвращает средства
func (ctrl *Controller) RefundPayment(c *fiber.Ctx) error {
	// Получаем ID компании из контекста
	customerID := c.Locals("customer_id").(int)
	
	// Получаем ID платежа из параметров URL
	id, err := strconv.Atoi(c.Params("id"))
	if err != nil {
		return c.Status(http.StatusBadRequest).JSON(fiber.Map{"error": "Invalid payment ID"})
	}
	
	// В реальном приложении здесь будет вызов сервисного слоя
	// для обработки возврата средств через платежный шлюз
	// с проверкой, принадлежит ли платеж текущей компании (customerID)
	
	// Возвращаем результат возврата
	return c.JSON(fiber.Map{
	"status": "refunded",
		"payment_id": id,
	})
}

// GetCashierStats возвращает статистику по кассе
func (ctrl *Controller) GetCashierStats(c *fiber.Ctx) error {
	// Получаем ID компании из контекста
	customerID := c.Locals("customer_id").(int)
	
	// В реальном приложении здесь будет вызов сервисного слоя
	// для получения статистики из базы данных с фильтрацией по customerID
	stats := CashierStats{
		TotalRevenue:     125000.0,
		TodaysRevenue:    15000.0,
		TotalTransactions: 50,
		TodaysTransactions: 5,
		RefundAmount:     2500.0,
	}
	
	return c.JSON(stats)
}
EOF

# frontend/index.html
cat > frontend/index.html << 'EOF'
<!DOCTYPE html>
<html lang="ru">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>KIT8 - Платформа для малого бизнеса</title>
  <link rel="stylesheet" href="shared/styles.css">
  <link rel="icon" href="/favicon.ico" type="image/x-icon">
</head>
<body>
 <div id="header-container"></div>
  
  <main class="main">
    <div class="container">
      <h1>Добро пожаловать в KIT8 Platform</h1>
      <p>Модульная SaaS-платформа для малого бизнеса. Соберите свой бизнес как конструктор!</p>
      
      <div class="modules-grid">
        <div class="module-card">
          <h3>📞 CRM</h3>
          <p>Супер-простая CRM за $7/мес</p>
          <a href="/crm/" class="btn btn-primary">Перейти</a>
        </div>
        
        <div class="module-card">
          <h3>💼 Сделки</h3>
          <p>Воронка продаж</p>
          <a href="/deals/" class="btn btn-primary">Перейти</a>
        </div>
        
        <div class="module-card">
          <h3>📦 Склад</h3>
          <p>Учёт товаров</p>
          <a href="/inventory/" class="btn btn-primary">Перейти</a>
        </div>
        
        <div class="module-card">
          <h3>🛒 Заказы</h3>
          <p>Приём заказов</p>
          <a href="/orders/" class="btn btn-primary">Перейти</a>
        </div>
        
        <div class="module-card">
          <h3>💳 Касса</h3>
          <p>Онлайн-касса</p>
          <a href="/cashier/" class="btn btn-primary">Перейти</a>
        </div>
      </div>
    </div>
  </main>

  <script src="shared/components/Header.js"></script>
  <script>
    // Инициализируем шапку
    const header = new KIT8Header('header-container');
  </script>
</body>
</html>
EOF

# frontend/shared/styles.css
cat > frontend/shared/styles.css << 'EOF'
/* Общие стили для KIT8 Platform */

* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

body {
  font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
  line-height: 1.6;
  color: #33;
  background-color: #f8fafc;
}

.container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 1rem;
}

.main {
  padding: 2rem 0;
}

h1 {
  color: #1E3A8A; /* Синий океана */
  text-align: center;
  margin-bottom: 1rem;
}

.modules-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
  gap: 1.5rem;
  margin-top: 2rem;
}

.module-card {
  background-color: white;
  border-radius: 8px;
  padding: 1.5rem;
 box-shadow: 0 4px 6px rgba(0,0,0,0.1);
  text-align: center;
  transition: transform 0.3s, box-shadow 0.3s;
}

.module-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 6px 12px rgba(0,0,0,0.15);
}

.module-card h3 {
  color: #1E3A8A;
  margin-bottom: 0.5rem;
  font-size: 1.25rem;
}

.module-card p {
  color: #64748b;
  margin-bottom: 1rem;
}

.btn {
  padding: 0.5rem 1rem;
  border-radius: 4px;
  border: none;
  cursor: pointer;
  text-decoration: none;
  display: inline-block;
  text-align: center;
  transition: background-color 0.3s;
}

.btn-primary {
  background-color: #F97316; /* Оранжевый акцент */
  color: white;
}

.btn-primary:hover {
  background-color: #ea580c;
}

/* Стили для форм */
.form-group {
 margin-bottom: 1rem;
}

.form-group label {
 display: block;
  margin-bottom: 0.5rem;
  color: #1e293b;
}

.form-group input,
.form-group select,
.form-group textarea {
  width: 100%;
  padding: 0.5rem;
  border: 1px solid #cbd5e1;
  border-radius: 4px;
  box-sizing: border-box;
}

/* Стили для таблиц */
table {
  width: 100%;
  border-collapse: collapse;
  background-color: white;
  border-radius: 8px;
  overflow: hidden;
  box-shadow: 0 4px 6px rgba(0,0,0,0.1);
}

th, td {
  padding: 0.75rem;
  text-align: left;
  border-bottom: 1px solid #e2e8f0;
}

th {
  background-color: #f1f5f9;
  color: #1e293b;
  font-weight: 600;
}

tr:hover {
  background-color: #f8fafc;
}

/* Адаптивные стили */
@media (max-width: 768px) {
  .modules-grid {
    grid-template-columns: 1fr;
  }
  
  .container {
    padding: 0 0.5rem;
  }
}
EOF

# frontend/shared/api.js
cat > frontend/shared/api.js << 'EOF'
// Единый API клиент для всех модулей KIT8 Platform

class KIT8API {
  constructor(baseURL = '/api') {
    this.baseURL = baseURL;
    this.defaultHeaders = {
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${localStorage.getItem('token') || ''}`
    };
  }

  // Общий метод для выполнения запросов
  async request(endpoint, options = {}) {
    const url = `${this.baseURL}${endpoint}`;
    const config = {
      headers: { ...this.defaultHeaders, ...options.headers },
      ...options
    };

    // Добавляем токен авторизации, если он есть
    const token = localStorage.getItem('token');
    if (token && !config.headers.Authorization) {
      config.headers.Authorization = `Bearer ${token}`;
    }

    try {
      const response = await fetch(url, config);
      
      // Обработка ошибок
      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }
      
      const data = await response.json();
      return data;
    } catch (error) {
      console.error('API request error:', error);
      throw error;
    }
  }

  // GET запрос
  async get(endpoint, params = {}) {
    const queryString = new URLSearchParams(params).toString();
    const url = queryString ? `${endpoint}?${queryString}` : endpoint;
    return this.request(url, { method: 'GET' });
  }

  // POST запрос
  async post(endpoint, data) {
    return this.request(endpoint, {
      method: 'POST',
      body: JSON.stringify(data)
    });
 }

  // PUT запрос
  async put(endpoint, data) {
    return this.request(endpoint, {
      method: 'PUT',
      body: JSON.stringify(data)
    });
  }

  // DELETE запрос
  async delete(endpoint) {
    return this.request(endpoint, { method: 'DELETE' });
  }

  // Метод для авторизации
  async login(credentials) {
    try {
      const response = await fetch(`${this.baseURL}/auth/login`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify(credentials)
      });

      if (!response.ok) {
        throw new Error('Login failed');
      }

      const data = await response.json();
      localStorage.setItem('token', data.token);
      return data;
    } catch (error) {
      console.error('Login error:', error);
      throw error;
    }
  }

  // Метод для выхода
  logout() {
    localStorage.removeItem('token');
  }

  // Метод для проверки авторизации
  isAuthenticated() {
    const token = localStorage.getItem('token');
    return !!token;
  }

  // Простое кэширование
  cache = new Map();
  
  async getCached(endpoint, params = {}, ttl = 60000) { // TTL по умолчанию 1 минута
    const cacheKey = `${endpoint}?${new URLSearchParams(params).toString()}`;
    const cached = this.cache.get(cacheKey);
    
    if (cached && Date.now() - cached.timestamp < ttl) {
      return cached.data;
    }
    
    const data = await this.get(endpoint, params);
    this.cache.set(cacheKey, {
      data: data,
      timestamp: Date.now()
    });
    
    return data;
  }
}

// Экспортируем экземпляр API клиента
const apiClient = new KIT8API();

export default apiClient;
EOF

# frontend/shared/components/Header.js
cat > frontend/shared/components/Header.js << 'EOF'
// Компонент шапки для всех модулей KIT8 Platform

class KIT8Header {
  constructor(containerId) {
    this.container = document.getElementById(containerId);
    this.modules = [
      { name: 'CRM', path: '/crm/', icon: '📞' },
      { name: 'Сделки', path: '/deals/', icon: '💼' },
      { name: 'Склад', path: '/inventory/', icon: '📦' },
      { name: 'Заказы', path: '/orders/', icon: '🛒' },
      { name: 'Касса', path: '/cashier/', icon: '💳' }
    ];
    this.render();
    this.addEventListeners();
  }

  render() {
    const isLoggedIn = this.isAuthenticated();
    const user = this.getCurrentUser();

    this.container.innerHTML = `
      <header class="kit8-header">
        <div class="header-container">
          <div class="logo-section">
            <a href="/" class="logo-link">
              <div class="logo-animation">
                <span class="whale-logo">🐋</span>
                <h1>KIT8</h1>
              </div>
            </a>
          </div>
          
          <nav class="main-nav">
            <ul class="nav-menu">
              ${isLoggedIn ? this.renderNavItems() : ''}
            </ul>
          </nav>
          
          <div class="user-section">
            ${isLoggedIn ? this.renderUserInfo(user) : this.renderAuthButtons()}
          </div>
        </div>
      </header>
      
      <style>
        .kit8-header {
          background-color: #1E3A8A; /* Синий океана */
          color: white;
          padding: 0.5rem 0;
          position: sticky;
          top: 0;
          z-index: 1000;
          box-shadow: 0 2px 4px rgba(0,0,0.1);
        }
        
        .header-container {
          max-width: 1200px;
          margin: 0 auto;
          display: flex;
          justify-content: space-between;
          align-items: center;
          padding: 0 1rem;
        }
        
        .logo-section .logo-link {
          text-decoration: none;
          display: flex;
          align-items: center;
        }
        
        .logo-animation {
          display: flex;
          align-items: center;
          animation: float 3s ease-in-out infinite;
        }
        
        @keyframes float {
          0% { transform: translateY(0px); }
          50% { transform: translateY(-5px); }
          100% { transform: translateY(0px); }
        }
        
        .whale-logo {
          font-size: 2rem;
          margin-right: 0.5rem;
        }
        
        .logo-section h1 {
          color: white;
          margin: 0;
          font-size: 1.5rem;
        }
        
        .nav-menu {
          display: flex;
          list-style: none;
          margin: 0;
          padding: 0;
          gap: 1rem;
        }
        
        .nav-menu li {
          position: relative;
        }
        
        .nav-menu a {
          color: white;
          text-decoration: none;
          padding: 0.5rem 1rem;
          border-radius: 4px;
          transition: background-color 0.3s;
          display: flex;
          align-items: center;
          gap: 0.5rem;
        }
        
        .nav-menu a:hover {
          background-color: rgba(255, 255, 255, 0.1);
        }
        
        .user-section .user-info,
        .user-section .auth-buttons {
          display: flex;
          align-items: center;
          gap: 1rem;
        }
        
        .user-dropdown {
          position: relative;
        }
        
        .dropdown-content {
          display: none;
          position: absolute;
          right: 0;
          background-color: white;
          min-width: 160px;
          box-shadow: 0px 8px 16px rgba(0,0,0,0.2);
          z-index: 1001;
          border-radius: 4px;
          overflow: hidden;
        }
        
        .user-dropdown:hover .dropdown-content {
          display: block;
        }
        
        .dropdown-content a {
          color: black;
          padding: 12px 16px;
          text-decoration: none;
          display: block;
        }
        
        .dropdown-content a:hover {
          background-color: #f1f1f1;
        }
        
        .btn {
          padding: 0.5rem 1rem;
          border-radius: 4px;
          border: none;
          cursor: pointer;
          text-decoration: none;
          display: inline-block;
          text-align: center;
          transition: background-color 0.3s;
        }
        
        .btn-primary {
          background-color: #F97316; /* Оранжевый акцент */
          color: white;
        }
        
        .btn-primary:hover {
          background-color: #ea580c;
        }
        
        .btn-secondary {
          background-color: transparent;
          color: white;
          border: 1px solid white;
        }
        
        .btn-secondary:hover {
          background-color: rgba(255, 255, 255, 0.1);
        }
        
        @media (max-width: 768px) {
          .header-container {
            flex-direction: column;
            gap: 1rem;
            padding: 0 0.5rem;
          }
          
          .nav-menu {
            width: 100%;
            justify-content: center;
          }
        }
      </style>
    `;
  }

  renderNavItems() {
    return this.modules.map(module => `
      <li><a href="${module.path}">
        <span>${module.icon}</span>
        <span>${module.name}</span>
      </a></li>
    `).join('');
  }

  renderUserInfo(user) {
    return `
      <div class="user-section">
        <div class="user-dropdown">
          <button class="btn btn-secondary">${user.name || user.email}</button>
          <div class="dropdown-content">
            <a href="/profile/">Профиль</a>
            <a href="#" id="logout-btn">Выход</a>
          </div>
        </div>
      </div>
    `;
  }

 renderAuthButtons() {
    return `
      <div class="auth-buttons">
        <a href="/login/" class="btn btn-secondary">Вход</a>
        <a href="/register/" class="btn btn-primary">Регистрация</a>
      </div>
    `;
  }

 addEventListeners() {
    const logoutBtn = this.container.querySelector('#logout-btn');
    if (logoutBtn) {
      logoutBtn.addEventListener('click', (e) => {
        e.preventDefault();
        this.logout();
        this.render(); // Перерендер после выхода
      });
    }
  }

  isAuthenticated() {
    // Проверяем наличие токена в localStorage
    const token = localStorage.getItem('token');
    return !!token;
  }

 getCurrentUser() {
    // В реальном приложении здесь будет декодирование JWT токена
    // или получение информации о пользователе из API
    const token = localStorage.getItem('token');
    if (token) {
      try {
        // Простая демонстрация - в реальном приложении использовать JWT декодирование
        return { email: 'user@example.com', name: 'Имя Пользователя' };
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  logout() {
    // Вызываем метод logout из api клиента
    localStorage.removeItem('token');
    // Перенаправляем на главную страницу
    window.location.href = '/';
  }
}

// Экспортируем класс для использования в других модулях
export default KIT8Header;
EOF

# frontend/crm/index.html
cat > frontend/crm/index.html << 'EOF'
<!DOCTYPE html>
<html lang="ru">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>KIT8 - CRM</title>
  <link rel="stylesheet" href="../shared/styles.css">
 <link rel="icon" href="/favicon.ico" type="image/x-icon">
</head>
<body>
 <div id="header-container"></div>
  
  <main class="crm-main">
    <div class="container">
      <h1>CRM Модуль</h1>
      <p>Управление контактами и сделками</p>
      
      <div class="crm-controls">
        <button id="add-contact-btn" class="btn btn-primary">+ Новый контакт</button>
        <input type="text" id="search-contacts" placeholder="Поиск контактов..." class="search-input">
      </div>
      
      <div class="crm-content">
        <div class="contacts-section">
          <h2>Контакты</h2>
          <table id="contacts-table">
            <thead>
              <tr>
                <th>Имя</th>
                <th>Email</th>
                <th>Телефон</th>
                <th>Компания</th>
                <th>Действия</th>
              </tr>
            </thead>
            <tbody id="contacts-list">
              <!-- Контакты будут загружены здесь -->
            </tbody>
          </table>
        </div>
        
        <div class="deals-section">
          <h2>Сделки</h2>
          <button id="add-deal-btn" class="btn btn-primary">+ Новая сделка</button>
          <table id="deals-table">
            <thead>
              <tr>
                <th>Название</th>
                <th>Контакт</th>
                <th>Сумма</th>
                <th>Этап</th>
                <th>Действия</th>
              </tr>
            </thead>
            <tbody id="deals-list">
              <!-- Сделки будут загружены здесь -->
            </tbody>
          </table>
        </div>
      </div>
    </div>
  </main>
  
  <!-- Модальное окно для нового контакта -->
  <div id="contact-modal" class="modal">
    <div class="modal-content">
      <span class="close">&times;</span>
      <h2>Новый контакт</h2>
      <form id="contact-form">
        <div class="form-group">
          <label for="contact-name">Имя:</label>
          <input type="text" id="contact-name" required>
        </div>
        <div class="form-group">
          <label for="contact-email">Email:</label>
          <input type="email" id="contact-email" required>
        </div>
        <div class="form-group">
          <label for="contact-phone">Телефон:</label>
          <input type="text" id="contact-phone">
        </div>
        <div class="form-group">
          <label for="contact-company">Компания:</label>
          <input type="text" id="contact-company">
        </div>
        <button type="submit" class="btn btn-primary">Создать контакт</button>
      </form>
    </div>
  </div>

  <script src="../shared/components/Header.js"></script>
  <script src="../shared/api.js"></script>
  <script src="app.js"></script>
</body>
</html>
EOF

# frontend/crm/app.js
cat > frontend/crm/app.js << 'EOF'
// Логика CRM модуля

document.addEventListener('DOMContentLoaded', () => {
 // Инициализируем шапку
 const header = new KIT8Header('header-container');
  
  // Получаем элементы DOM
  const addContactBtn = document.getElementById('add-contact-btn');
  const contactModal = document.getElementById('contact-modal');
  const closeModal = document.querySelector('.close');
  const contactForm = document.getElementById('contact-form');
  const contactsList = document.getElementById('contacts-list');
  const searchInput = document.getElementById('search-contacts');
  
  // Открытие модального окна
  addContactBtn.addEventListener('click', () => {
    contactModal.style.display = 'block';
  });
  
  // Закрытие модального окна
  closeModal.addEventListener('click', () => {
    contactModal.style.display = 'none';
  });
  
  // Закрытие модального окна при клике вне его
  window.addEventListener('click', (event) => {
    if (event.target === contactModal) {
      contactModal.style.display = 'none';
    }
  });
  
  // Отправка формы контакта
  contactForm.addEventListener('submit', async (e) => {
    e.preventDefault();
    
    const name = document.getElementById('contact-name').value;
    const email = document.getElementById('contact-email').value;
    const phone = document.getElementById('contact-phone').value;
    const company = document.getElementById('contact-company').value;
    
    try {
      const newContact = await apiClient.post('/crm/contacts', {
        name,
        email,
        phone,
        company
      });
      
      // Добавляем новый контакт в список
      addContactToList(newContact);
      
      // Сбрасываем форму и закрываем модальное окно
      contactForm.reset();
      contactModal.style.display = 'none';
      
      // Показываем сообщение об успехе
      showMessage('Контакт успешно создан!', 'success');
    } catch (error) {
      console.error('Ошибка при создании контакта:', error);
      showMessage('Ошибка при создании контакта', 'error');
    }
  });
  
  // Функция добавления контакта в список
  function addContactToList(contact) {
    const row = document.createElement('tr');
    row.innerHTML = `
      <td>${contact.name}</td>
      <td>${contact.email}</td>
      <td>${contact.phone}</td>
      <td>${contact.company}</td>
      <td>
        <button class="btn btn-secondary edit-contact" data-id="${contact.id}">Изменить</button>
        <button class="btn btn-secondary delete-contact" data-id="${contact.id}">Удалить</button>
      </td>
    `;
    
    contactsList.appendChild(row);
    
    // Добавляем обработчики для кнопок
    row.querySelector('.edit-contact').addEventListener('click', () => editContact(contact.id));
    row.querySelector('.delete-contact').addEventListener('click', () => deleteContact(contact.id));
  }
  
  // Функция редактирования контакта
  async function editContact(id) {
    // В реальном приложении здесь будет логика редактирования
    console.log(`Редактирование контакта с ID: ${id}`);
    
    // Показываем модальное окно с формой редактирования
    // (в этой версии просто показываем сообщение)
    showMessage('Функция редактирования контакта в разработке', 'info');
  }
  
 // Функция удаления контакта
 async function deleteContact(id) {
    if (confirm('Вы уверены, что хотите удалить этот контакт?')) {
      try {
        await apiClient.delete(`/crm/contacts/${id}`);
        
        // Удаляем контакт из DOM
        const rows = contactsList.querySelectorAll('tr');
        rows.forEach(row => {
          if (row.querySelector('.delete-contact').dataset.id == id) {
            row.remove();
          }
        });
        
        showMessage('Контакт успешно удален!', 'success');
      } catch (error) {
        console.error('Ошибка при удалении контакта:', error);
        showMessage('Ошибка при удалении контакта', 'error');
      }
    }
 }
  
  // Функция загрузки и отображения всех контактов
  async function loadContacts() {
    try {
      const contacts = await apiClient.get('/crm/contacts');
      
      // Очищаем текущий список
      contactsList.innerHTML = '';
      
      // Добавляем каждый контакт в таблицу
      contacts.forEach(contact => {
        addContactToList(contact);
      });
    } catch (error) {
      console.error('Ошибка при загрузке контактов:', error);
      showMessage('Ошибка при загрузке контактов', 'error');
    }
  }
  
  // Функция поиска контактов
  searchInput.addEventListener('input', () => {
    const searchTerm = searchInput.value.toLowerCase();
    
    // Скрываем все строки
    const rows = contactsList.querySelectorAll('tr');
    rows.forEach(row => {
      row.style.display = 'none';
    });
    
    // Показываем только те, которые соответствуют поисковому запросу
    rows.forEach(row => {
      const name = row.cells[0].textContent.toLowerCase();
      const email = row.cells[1].textContent.toLowerCase();
      const company = row.cells[3].textContent.toLowerCase();
      
      if (name.includes(searchTerm) || email.includes(searchTerm) || company.includes(searchTerm)) {
        row.style.display = 'table-row';
      }
    });
  });
  
  // Показ сообщений пользователю
  function showMessage(message, type) {
    // Создаем элемент сообщения
    const messageEl = document.createElement('div');
    messageEl.className = `message message-${type}`;
    messageEl.textContent = message;
    messageEl.style.cssText = `
      position: fixed;
      top: 20px;
      right: 20px;
      padding: 1rem;
      border-radius: 4px;
      color: white;
      z-index: 1002;
      ${type === 'success' ? 'background-color: #10b981;' : 
        type === 'error' ? 'background-color: #ef4444;' : 
        'background-color: #3b82f6;'}
    `;
    
    document.body.appendChild(messageEl);
    
    // Удаляем сообщение через 3 секунды
    setTimeout(() => {
      messageEl.remove();
    }, 3000);
 }
  
  // Загружаем контакты при инициализации
  loadContacts();
});
EOF

# frontend/deals/index.html
cat > frontend/deals/index.html << 'EOF'
<!DOCTYPE html>
<html lang="ru">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>KIT8 - Сделки</title>
  <link rel="stylesheet" href="../shared/styles.css">
  <link rel="stylesheet" href="styles.css">
  <link rel="icon" href="/favicon.ico" type="image/x-icon">
</head>
<body>
  <div id="header-container"></div>
  
  <main class="deals-main">
    <div class="container">
      <h1>Модуль Сделок</h1>
      <p>Управление воронкой продаж и отслеживание сделок</p>
      
      <div class="deals-controls">
        <button id="add-deal-btn" class="btn btn-primary">+ Новая сделка</button>
        <input type="text" id="search-deals" placeholder="Поиск сделок..." class="search-input">
      </div>
      
      <div class="deals-board">
        <div class="deal-stage" data-stage="new">
          <h3>Новые</h3>
          <div class="deals-list" id="new-deals"></div>
        </div>
        
        <div class="deal-stage" data-stage="in-progress">
          <h3>В работе</h3>
          <div class="deals-list" id="in-progress-deals"></div>
        </div>
        
        <div class="deal-stage" data-stage="won">
          <h3>Выиграны</h3>
          <div class="deals-list" id="won-deals"></div>
        </div>
        
        <div class="deal-stage" data-stage="lost">
          <h3>Проиграны</h3>
          <div class="deals-list" id="lost-deals"></div>
        </div>
      </div>
    </div>
  </main>
  
  <!-- Модальное окно для новой сделки -->
  <div id="deal-modal" class="modal">
    <div class="modal-content">
      <span class="close">&times;</span>
      <h2>Новая сделка</h2>
      <form id="deal-form">
        <div class="form-group">
          <label for="deal-title">Название сделки:</label>
          <input type="text" id="deal-title" required>
        </div>
        <div class="form-group">
          <label for="deal-contact">Контакт:</label>
          <select id="deal-contact" required></select>
        </div>
        <div class="form-group">
          <label for="deal-value">Сумма:</label>
          <input type="number" id="deal-value" required>
        </div>
        <div class="form-group">
          <label for="deal-stage">Этап:</label>
          <select id="deal-stage" required>
            <option value="new">Новая</option>
            <option value="in-progress">В работе</option>
            <option value="won">Выиграна</option>
            <option value="lost">Проиграна</option>
          </select>
        </div>
        <button type="submit" class="btn btn-primary">Создать сделку</button>
      </form>
    </div>
  </div>

  <script src="../shared/components/Header.js"></script>
  <script src="../shared/api.js"></script>
  <script src="app.js"></script>
</body>
</html>
EOF

# frontend/deals/styles.css
cat > frontend/deals/styles.css << 'EOF'
/* Стили для модуля Сделок */

.deals-main {
  padding: 2rem 0;
}

.deals-controls {
  display: flex;
 justify-content: space-between;
  margin-bottom: 2rem;
  gap: 1rem;
  flex-wrap: wrap;
}

.search-input {
  flex-grow: 1;
  max-width: 300px;
  padding: 0.5rem;
  border: 1px solid #ccc;
  border-radius: 4px;
}

.deals-board {
 display: flex;
 gap: 1rem;
  overflow-x: auto;
 padding-bottom: 1rem;
}

.deal-stage {
  min-width: 250px;
 flex: 1;
  background-color: #f8fafc;
  border-radius: 8px;
  padding: 1rem;
}

.deal-stage h3 {
  margin-top: 0;
  margin-bottom: 1rem;
  color: #1e3a8a;
  border-bottom: 1px solid #e2e8f0;
  padding-bottom: 0.5rem;
}

.deals-list {
  min-height: 200px;
}

.deal-card {
 background-color: white;
  border: 1px solid #e2e8f0;
  border-radius: 4px;
  padding: 1rem;
  margin-bottom: 0.5rem;
  box-shadow: 0 1px 3px rgba(0,0,0,0.1);
  cursor: pointer;
  transition: transform 0.2s, box-shadow 0.2s;
}

.deal-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 6px rgba(0,0,0,0.1);
}

.deal-card h4 {
  margin: 0 0 0.5rem 0;
  color: #1e293b;
}

.deal-card p {
  margin: 0;
  color: #64748b;
  font-size: 0.9rem;
}

.deal-value {
  font-weight: bold;
  color: #1e3a8a;
  margin-top: 0.5rem;
  display: block;
}

/* Стили для модального окна */
.modal {
  display: none;
  position: fixed;
  z-index: 1001;
  left: 0;
  top: 0;
  width: 100%;
  height: 100%;
  background-color: rgba(0,0,0,0.5);
}

.modal-content {
  background-color: white;
 margin: 5% auto;
  padding: 2rem;
  border: none;
  border-radius: 8px;
  width: 90%;
  max-width: 500px;
  position: relative;
}

.close {
  position: absolute;
  right: 1rem;
 top: 1rem;
  font-size: 1.5rem;
  font-weight: bold;
  cursor: pointer;
}

.form-group {
  margin-bottom: 1rem;
}

.form-group label {
 display: block;
 margin-bottom: 0.5rem;
  color: #1e293b;
}

.form-group input,
.form-group select {
  width: 100%;
  padding: 0.5rem;
  border: 1px solid #cbd5e1;
  border-radius: 4px;
  box-sizing: border-box;
}

.btn {
  padding: 0.5rem 1rem;
 border-radius: 4px;
  border: none;
 cursor: pointer;
 text-decoration: none;
  display: inline-block;
  text-align: center;
 transition: background-color 0.3s;
}

.btn-primary {
  background-color: #F97316; /* Оранжевый акцент */
  color: white;
}

.btn-primary:hover {
  background-color: #ea580c;
}

@media (max-width: 768px) {
  .deals-board {
    flex-direction: column;
  }
  
  .deals-controls {
    flex-direction: column;
  }
  
  .search-input {
    max-width: 100%;
  }
}
EOF

# frontend/deals/app.js
cat > frontend/deals/app.js << 'EOF'
// Логика модуля Сделок

document.addEventListener('DOMContentLoaded', () => {
 // Инициализируем шапку
  const header = new KIT8Header('header-container');
  
  // Получаем элементы DOM
  const addDealBtn = document.getElementById('add-deal-btn');
  const dealModal = document.getElementById('deal-modal');
  const closeModal = document.querySelector('.close');
  const dealForm = document.getElementById('deal-form');
  const searchInput = document.getElementById('search-deals');
  
  // Открытие модального окна
 addDealBtn.addEventListener('click', () => {
    loadContactsForSelect();
    dealModal.style.display = 'block';
  });
  
  // Закрытие модального окна
  closeModal.addEventListener('click', () => {
    dealModal.style.display = 'none';
  });
  
 // Закрытие модального окна при клике вне его
  window.addEventListener('click', (event) => {
    if (event.target === dealModal) {
      dealModal.style.display = 'none';
    }
  });
  
  // Отправка формы сделки
  dealForm.addEventListener('submit', async (e) => {
    e.preventDefault();
    
    const title = document.getElementById('deal-title').value;
    const contactId = document.getElementById('deal-contact').value;
    const value = document.getElementById('deal-value').value;
    const stage = document.getElementById('deal-stage').value;
    
    try {
      const newDeal = await apiClient.post('/deals/', {
        title,
        contact_id: parseInt(contactId),
        value: parseFloat(value),
        stage
      });
      
      // Добавляем новую сделку на доску
      addDealToBoard(newDeal);
      
      // Сбрасываем форму и закрываем модальное окно
      dealForm.reset();
      dealModal.style.display = 'none';
      
      // Показываем сообщение об успехе
      showMessage('Сделка успешно создана!', 'success');
    } catch (error) {
      console.error('Ошибка при создании сделки:', error);
      showMessage('Ошибка при создании сделки', 'error');
    }
  });
  
  // Функция загрузки контактов для выпадающего списка
  async function loadContactsForSelect() {
    try {
      const contacts = await apiClient.get('/crm/contacts');
      const contactSelect = document.getElementById('deal-contact');
      
      // Очищаем текущие опции
      contactSelect.innerHTML = '';
      
      // Добавляем новые опции
      contacts.forEach(contact => {
        const option = document.createElement('option');
        option.value = contact.id;
        option.textContent = contact.name || contact.email;
        contactSelect.appendChild(option);
      });
    } catch (error) {
      console.error('Ошибка при загрузке контактов:', error);
    }
 }
  
  // Функция добавления сделки на доску
  function addDealToBoard(deal) {
    const stageContainer = document.querySelector(`#deals-${deal.stage} .deals-list`);
    if (!stageContainer) return;
    
    const dealCard = createDealCard(deal);
    stageContainer.appendChild(dealCard);
  }
  
  // Функция создания карточки сделки
  function createDealCard(deal) {
    const card = document.createElement('div');
    card.className = 'deal-card';
    card.dataset.id = deal.id;
    
    card.innerHTML = `
      <h4>${deal.title}</h4>
      <p>Сумма: <span class="deal-value">${deal.value} ₽</span></p>
      <p>Контакт: ${deal.contact?.name || deal.contact?.email || 'Не указан'}</p>
    `;
    
    // Добавляем обработчик клика для редактирования
    card.addEventListener('click', () => {
      editDeal(deal.id);
    });
    
    return card;
  }
  
  // Функция редактирования сделки
  async function editDeal(id) {
    // В реальном приложении здесь будет логика редактирования
    console.log(`Редактирование сделки с ID: ${id}`);
    
    // Показываем модальное окно с формой редактирования
    // (в этой версии просто показываем сообщение)
    showMessage('Функция редактирования сделки в разработке', 'info');
  }
  
  // Функция загрузки и отображения всех сделок
  async function loadDeals() {
    try {
      const deals = await apiClient.get('/deals/');
      
      // Очищаем все доски
      document.querySelectorAll('.deals-list').forEach(list => {
        list.innerHTML = '';
      });
      
      // Добавляем каждую сделку на соответствующую доску
      deals.forEach(deal => {
        addDealToBoard(deal);
      });
    } catch (error) {
      console.error('Ошибка при загрузке сделок:', error);
      showMessage('Ошибка при загрузке сделок', 'error');
    }
  }
  
  // Функция поиска сделок
  searchInput.addEventListener('input', () => {
    const searchTerm = searchInput.value.toLowerCase();
    
    // Скрываем все карточки
    document.querySelectorAll('.deal-card').forEach(card => {
      card.style.display = 'none';
    });
    
    // Показываем только те, которые соответствуют поисковому запросу
    document.querySelectorAll('.deal-card').forEach(card => {
      const title = card.querySelector('h4').textContent.toLowerCase();
      if (title.includes(searchTerm)) {
        card.style.display = 'block';
      }
    });
  });
  
  // Показ сообщений пользователю
 function showMessage(message, type) {
    // Создаем элемент сообщения
    const messageEl = document.createElement('div');
    messageEl.className = `message message-${type}`;
    messageEl.textContent = message;
    messageEl.style.cssText = `
      position: fixed;
      top: 20px;
      right: 20px;
      padding: 1rem;
      border-radius: 4px;
      color: white;
      z-index: 1002;
      ${type === 'success' ? 'background-color: #10b981;' : 
        type === 'error' ? 'background-color: #ef4444;' : 
        'background-color: #3b82f6;'}
    `;
    
    document.body.appendChild(messageEl);
    
    // Удаляем сообщение через 3 секунды
    setTimeout(() => {
      messageEl.remove();
    }, 3000);
 }
  
  // Загружаем сделки при инициализации
  loadDeals();
});
EOF

# docker/Dockerfile.backend
cat > docker/Dockerfile.backend << 'EOF'
FROM golang:1.21-alpine AS builder

WORKDIR /app

COPY backend/go.mod backend/go.sum ./
RUN go mod download

COPY backend/ .

RUN go build -o main cmd/api/main.go

FROM alpine:latest
RUN apk --no-cache add ca-certificates
WORKDIR /root/
COPY --from=builder /app/main .
EXPOSE 3000
CMD ["./main"]
EOF

# docker/Dockerfile.frontend
cat > docker/Dockerfile.frontend << 'EOF'
FROM nginx:alpine

COPY frontend/ /usr/share/nginx/html/
EOF

# docker/docker-compose.yml
cat > docker/docker-compose.yml << 'EOF'
version: '3.8'

services:
 backend:
    build:
      context: ..
      dockerfile: docker/Dockerfile.backend
    ports:
      - "300:3000"
    environment:
      - DATABASE_URL=postgresql://user:password@db:5432/kit8?sslmode=disable
    depends_on:
      - db

  frontend:
    build:
      context: ..
      dockerfile: docker/Dockerfile.frontend
    ports:
      - "8080:80"
    depends_on:
      - backend

  db:
    image: postgres:15
    environment:
      POSTGRES_DB: kit8
      POSTGRES_USER: user
      POSTGRES_PASSWORD: password
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data

volumes:
 postgres_data:
EOF

# Добавление всех файлов в git
git add .

# Создание коммита
git commit -m "Initial commit: KIT8 Platform with all modules"

# Добавление удаленного репозитория
git remote add origin $REPO_URL

# Пуш в репозиторий
git push -u origin main

echo "Репозиторий создан и код загружен на GitHub!"
echo "Теперь вы можете клонировать репозиторий на вашей виртуальной машине Ubuntu:"
echo "git clone $REPO_URL"