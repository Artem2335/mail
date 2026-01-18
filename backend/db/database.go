package db

import (
	"github.com/Artem2335/mail/backend/models"
	"gorm.io/driver/sqlite"
	"gorm.io/gorm"
	"log"
)

var DB *gorm.DB

func InitDB() {
	// Using modernc.org/sqlite driver (CGO-free)
	db, err := gorm.Open(sqlite.Open("file:messenger.db?cache=shared"), &gorm.Config{})
	if err != nil {
		log.Fatal("Failed to connect to database:", err)
	}

	DB = db
	log.Println("Database connected successfully")

	// Auto migrate models
	db.AutoMigrate(&models.User{}, &models.Message{})
	log.Println("Database migrations completed")
}

func GetDB() *gorm.DB {
	return DB
}
