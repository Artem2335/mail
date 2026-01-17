package models

import (
	"time"
)

type Message struct {
	ID        string    `gorm:"primaryKey" json:"id"`
	SenderID  string    `json:"sender_id"`
	Receiver  string    `json:"receiver_id"`
	Content   string    `json:"content"`
	FileURL   string    `json:"file_url"`
	FileType  string    `json:"file_type"` // text, image, video
	FileName  string    `json:"file_name"`
	CreatedAt time.Time `json:"created_at"`
}

type SendMessageRequest struct {
	ReceiverID string `json:"receiver_id" binding:"required"`
	Content    string `json:"content"`
}

type ChatMessage struct {
	ID        string    `json:"id"`
	Sender    User      `json:"sender"`
	Receiver  User      `json:"receiver"`
	Content   string    `json:"content"`
	FileURL   string    `json:"file_url"`
	FileType  string    `json:"file_type"`
	FileName  string    `json:"file_name"`
	CreatedAt time.Time `json:"created_at"`
}
