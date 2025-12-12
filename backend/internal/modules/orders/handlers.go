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
				{ID: 1, ProductID: 1, ProductName: "Ноутбук", Quantity: 1, Price: 50000.0, Total: 50000.0},
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
			Notes: "Доставить после 18:00", CreatedAt: "2023-01-02T00:00:00Z", UpdatedAt: "2023-01-02T00:00:00Z",
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
		order.Items[i].Total = float64(order.Items[i].Quantity) * order.Items[i].Price
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
	// Получаем ID заказа из параметров URL
	_, err := strconv.Atoi(c.Params("id"))
	if err != nil {
		return c.Status(http.StatusBadRequest).JSON(fiber.Map{"error": "Invalid order ID"})
	}

	// Получаем ID компании из контекста
	_ = c.Locals("customer_id").(int)
	
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
			{ID: 1, ProductID: 1, ProductName: "Ноутбук", Quantity: 1, Price: 50000.0, Total: 50000.0},
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
	_ = c.Locals("customer_id").(int)
	
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