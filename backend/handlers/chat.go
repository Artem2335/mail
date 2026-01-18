package handlers

import (
	"github.com/Artem2335/mail/backend/db"
	"github.com/Artem2335/mail/backend/models"
	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
	"github.com/gorilla/websocket"
	"log"
	"net/http"
	"os"
	"path/filepath"
	"strings"
	"time"
)

var upgrader = websocket.Upgrader{
	ReadBufferSize:  1024,
	WriteBufferSize: 1024,
	CheckOrigin: func(r *http.Request) bool {
		return true
	},
}

var connections = make(map[string]*websocket.Conn)

func SendMessage(c *gin.Context) {
	userID, exists := c.Get("user_id")
	if !exists {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Unauthorized"})
		return
	}

	var req models.SendMessageRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	message := models.Message{
		ID:        uuid.New().String(),
		SenderID:  userID.(string),
		Receiver:  req.ReceiverID,
		Content:   req.Content,
		FileType:  "text",
		CreatedAt: time.Now(),
	}

	if err := db.DB.Create(&message).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to save message"})
		return
	}

	c.JSON(http.StatusCreated, message)
}

func GetMessages(c *gin.Context) {
	userID, exists := c.Get("user_id")
	if !exists {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Unauthorized"})
		return
	}

	otherUserID := c.Param("user_id")

	var messages []models.Message
	db.DB.Where(
		"(sender_id = ? AND receiver = ?) OR (sender_id = ? AND receiver = ?)",
		userID, otherUserID, otherUserID, userID,
	).Order("created_at ASC").Find(&messages)

	c.JSON(http.StatusOK, messages)
}

func UploadFile(c *gin.Context) {
	userID, exists := c.Get("user_id")
	if !exists {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Unauthorized"})
		return
	}

	receiverID := c.PostForm("receiver_id")
	file, err := c.FormFile("file")
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "No file uploaded"})
		return
	}

	// Create uploads directory if it doesn't exist
	os.MkdirAll("uploads", os.ModePerm)

	// Generate unique filename
	filename := uuid.New().String() + filepath.Ext(file.Filename)
	filepath := filepath.Join("uploads", filename)

	if err := c.SaveUploadedFile(file, filepath); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to save file"})
		return
	}

	// Determine file type
	fileType := "file"
	if strings.HasPrefix(file.Header.Get("Content-Type"), "image") {
		fileType = "image"
	} else if strings.HasPrefix(file.Header.Get("Content-Type"), "video") {
		fileType = "video"
	}

	message := models.Message{
		ID:        uuid.New().String(),
		SenderID:  userID.(string),
		Receiver:  receiverID,
		FileURL:   "/uploads/" + filename,
		FileType:  fileType,
		FileName:  file.Filename,
		CreatedAt: time.Now(),
	}

	if err := db.DB.Create(&message).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to save message"})
		return
	}

	c.JSON(http.StatusCreated, message)
}

func WebSocketHandler(c *gin.Context) {
	userID := c.Query("user_id")

	ws, err := upgrader.Upgrade(c.Writer, c.Request, nil)
	if err != nil {
		log.Println("WebSocket upgrade error:", err)
		return
	}
	defer ws.Close()

	connections[userID] = ws
	log.Printf("User %s connected", userID)

	for {
		var msg map[string]interface{}
		err := ws.ReadJSON(&msg)
		if err != nil {
			delete(connections, userID)
			log.Printf("User %s disconnected", userID)
			break
		}

		receiverID := msg["receiver_id"].(string)
		if receiverWs, ok := connections[receiverID]; ok {
			receiverWs.WriteJSON(msg)
		}
	}
}

func GetConversations(c *gin.Context) {
	userID, exists := c.Get("user_id")
	if !exists {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Unauthorized"})
		return
	}

	var conversations []models.Message
	db.DB.Where(
		"sender_id = ? OR receiver = ?",
		userID, userID,
	).Distinct("CASE WHEN sender_id = ? THEN receiver ELSE sender_id END", userID).Find(&conversations)

	c.JSON(http.StatusOK, conversations)
}
