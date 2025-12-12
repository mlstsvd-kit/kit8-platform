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