package main

import (
	"github.com/Artem2335/mail/backend/db"
	"github.com/Artem2335/mail/backend/handlers"
	"github.com/gin-gonic/gin"
	"log"
)

func main() {
	// Initialize database
	db.InitDB()

	// Create Gin router
	router := gin.Default()

	// Enable CORS
	router.Use(CORSMiddleware())

	// Serve uploaded files
	router.Static("/uploads", "./uploads")

	// Public routes (no auth required)
	public := router.Group("/api")
	{
		public.POST("/register", handlers.Register)
		public.POST("/login", handlers.Login)
	}

	// Protected routes (auth required)
	protected := router.Group("/api")
	protected.Use(AuthMiddleware())
	{
		// Profile routes
		protected.GET("/profile/:id", handlers.GetProfile)

		// Chat routes
		protected.GET("/messages/:user_id", handlers.GetMessages)
		protected.POST("/messages", handlers.SendMessage)
		protected.POST("/upload", handlers.UploadFile)
		protected.GET("/conversations", handlers.GetConversations)
	}

	// WebSocket route
	router.GET("/ws", handlers.WebSocketHandler)

	log.Println("🚀 Server running on http://localhost:8080")
	router.Run(":8080")
}

func CORSMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		c.Writer.Header().Set("Access-Control-Allow-Origin", "*")
		c.Writer.Header().Set("Access-Control-Allow-Credentials", "true")
		c.Writer.Header().Set("Access-Control-Allow-Headers", "Content-Type, Content-Length, Accept-Encoding, X-CSRF-Token, Authorization, accept, origin, Cache-Control, X-Requested-With")
		c.Writer.Header().Set("Access-Control-Allow-Methods", "POST, OPTIONS, GET, PUT, DELETE")

		if c.Request.Method == "OPTIONS" {
			c.AbortWithStatus(204)
			return
		}

		c.Next()
	}
}
