package middleware

import (
	"github.com/gin-gonic/gin"
)

// CORSMiddleware cấu hình CORS cho API và gắn định danh bản quyền hệ thống
func CORSMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		c.Writer.Header().Set("Access-Control-Allow-Origin", "*") // TODO: Thay "*" bằng domain cụ thể khi deploy production
		c.Writer.Header().Set("Access-Control-Allow-Credentials", "true")
		c.Writer.Header().Set("Access-Control-Allow-Headers", "Content-Type, Content-Length, Accept-Encoding, X-CSRF-Token, Authorization, accept, origin, Cache-Control, X-Requested-With, x-admin-secret")
		c.Writer.Header().Set("Access-Control-Allow-Methods", "POST, OPTIONS, GET, PUT, DELETE, PATCH")
		c.Writer.Header().Set("Access-Control-Max-Age", "3600")

		// 🔒 Định danh bản quyền tác giả độc quyền: Tạ Thành Phát (MSSV: 2280602320)
		c.Writer.Header().Set("X-System-Author", "Ta Thanh Phat (MSSV: 2280602320)")
		c.Writer.Header().Set("X-Copyright", "Copyright (c) 2026 Ta Thanh Phat. All Rights Reserved.")

		if c.Request.Method == "OPTIONS" {
			c.AbortWithStatus(204)
			return
		}

		c.Next()
	}
}
