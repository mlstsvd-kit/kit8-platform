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
		{ID: 1, Name: "Ноутбук", Description: "Ультрабук", Price: 50000.0, Quantity: 10, SKU: "NB-01", Category: "Электроника", ImageURL: "", CustomerID: customerID, CreatedAt: "2023-01-01T00:00:00Z", UpdatedAt: "2023-01-01T00:00:00Z"},
		{ID: 2, Name: "Мышь", Description: "Беспроводная мышь", Price: 1500.0, Quantity: 50, SKU: "MS-001", Category: "Аксессуары", ImageURL: "", CustomerID: customerID, CreatedAt: "2023-01-02T00:00:00Z", UpdatedAt: "2023-01-02T00:00:00Z"},
		{ID: 3, Name: "Клавиатура", Description: "Механическая клавиатура", Price: 4500.0, Quantity: 0, SKU: "KB-001", Category: "Аксессуары", ImageURL: "", CustomerID: customerID, CreatedAt: "2023-01-03T00:00:00Z", UpdatedAt: "2023-01-03T00:00:00Z"},
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
	// Получаем ID товара из параметров URL
	_, err := strconv.Atoi(c.Params("id"))
	if err != nil {
		return c.Status(http.StatusBadRequest).JSON(fiber.Map{"error": "Invalid product ID"})
	}

	// Получаем ID компании из контекста
	_ = c.Locals("customer_id").(int)
	
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
	_ = c.Locals("customer_id").(int)
	
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