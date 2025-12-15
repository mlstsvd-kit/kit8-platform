package main

import (
	"log"

	"github.com/gofiber/fiber/v2"
	"github.com/gofiber/fiber/v2/middleware/cors"
	"github.com/gofiber/fiber/v2/middleware/logger"

	// Импортируем наши модули
	cashier "kit8-backend/internal/modules/cashier"
	crm "kit8-backend/internal/modules/crm"
	inventory "kit8-backend/internal/modules/inventory"
	orders "kit8-backend/internal/modules/orders"
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

	// Основные маршруты
	app.Get("/health", func(c *fiber.Ctx) error {
		return c.JSON(fiber.Map{
			"status":  "ok",
			"version": "1.0.0",
		})
	})

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
	crmRoutes.Get("/stats", crmController.GetCRMStats)

	// Inventory маршруты
	inventoryRoutes := api.Group("/inventory")
	inventoryRoutes.Get("/products", inventoryController.GetProducts)
	inventoryRoutes.Post("/products", inventoryController.CreateProduct)
	inventoryRoutes.Put("/products/:id", inventoryController.UpdateProduct)
	inventoryRoutes.Delete("/products/:id", inventoryController.DeleteProduct)
	inventoryRoutes.Get("/products/:id", inventoryController.GetProduct)
	inventoryRoutes.Get("/stats", inventoryController.GetInventoryStats)
	// Дополнительные маршруты для инвентаря (если требуются)

	// Orders маршруты
	ordersRoutes := api.Group("/orders")
	// Дополнительные маршруты для заказов (если требуются)
	ordersRoutes.Get("/stats", ordersController.GetOrderStats)
	ordersRoutes.Get("/orders", ordersController.GetOrders)
	ordersRoutes.Post("/orders", ordersController.CreateOrder)
	ordersRoutes.Put("/orders/:id", ordersController.UpdateOrder)
	ordersRoutes.Delete("/orders/:id", ordersController.DeleteOrder)
	ordersRoutes.Get("/orders/:id", ordersController.GetOrder)

	// Cashier маршруты
	cashierRoutes := api.Group("/cashier")
	// Дополнительные маршруты для кассы (если требуются)
	cashierRoutes.Get("/stats", cashierController.GetCashierStats)
	cashierRoutes.Get("/payments", cashierController.GetPayments)
	cashierRoutes.Post("/payments", cashierController.CreatePayment)
	cashierRoutes.Put("/payments/:id", cashierController.UpdatePayment)
	cashierRoutes.Post("/process", cashierController.ProcessPayment)
	cashierRoutes.Post("/refund/:id", cashierController.RefundPayment)

	log.Fatal(app.Listen(":3000"))
}
