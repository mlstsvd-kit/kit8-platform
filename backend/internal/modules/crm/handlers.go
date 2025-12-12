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
	UpdatedAt   string  `json:"updated_at"`
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
	// Получаем ID контакта из параметров URL
	_, err := strconv.Atoi(c.Params("id"))
	if err != nil {
		return c.Status(http.StatusBadRequest).JSON(fiber.Map{"error": "Invalid contact ID"})
	}

	// Получаем ID компании из контекста
	_ = c.Locals("customer_id").(int)
	
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
		{ID: 3, Title: "Сделка 3", Value: 15000.0, ContactID: 1, Stage: "won", CustomerID: customerID, CreatedAt: "2023-01-03T00:00:00Z", UpdatedAt: "2023-01-03T00:00:00Z"},
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
	// Получаем ID сделки из параметров URL
	_, err := strconv.Atoi(c.Params("id"))
	if err != nil {
		return c.Status(http.StatusBadRequest).JSON(fiber.Map{"error": "Invalid deal ID"})
	}

	// Получаем ID компании из контекста
	_ = c.Locals("customer_id").(int)
	
	// В реальном приложении здесь будет вызов сервисного слоя
	// для удаления сделки из базы данных с проверкой, 
	// принадлежит ли она текущей компании (customerID)
	
	// Возвращаем успешный ответ
	return c.SendStatus(http.StatusOK)
}

// GetDealStats возвращает статистику по сделкам
func (ctrl *Controller) GetDealStats(c *fiber.Ctx) error {
	// Получаем ID компании из контекста
	_ = c.Locals("customer_id").(int)
	
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