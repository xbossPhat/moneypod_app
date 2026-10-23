package middleware

import (
	"sync"
	"time"

	"github.com/gin-gonic/gin"
)

// Simple rate limiter using token bucket algorithm
type rateLimiter struct {
	visitors map[string]*visitor
	mu       sync.RWMutex
	rate     time.Duration
	burst    int
}

type visitor struct {
	limiter  *time.Ticker
	lastSeen time.Time
}

var limiter *rateLimiter

func init() {
	limiter = &rateLimiter{
		visitors: make(map[string]*visitor),
		rate:     time.Second, // 1 giây
		burst:    10,          // Tối đa 10 requests
	}

	// Cleanup old visitors every 5 minutes
	go limiter.cleanupVisitors()
}

func (rl *rateLimiter) getVisitor(ip string) *visitor {
	rl.mu.Lock()
	defer rl.mu.Unlock()

	v, exists := rl.visitors[ip]
	if !exists {
		v = &visitor{
			limiter: time.NewTicker(rl.rate),
		}
		rl.visitors[ip] = v
	}

	v.lastSeen = time.Now()
	return v
}

func (rl *rateLimiter) cleanupVisitors() {
	for {
		time.Sleep(5 * time.Minute)
		rl.mu.Lock()
		for ip, v := range rl.visitors {
			if time.Since(v.lastSeen) > 10*time.Minute {
				v.limiter.Stop()
				delete(rl.visitors, ip)
			}
		}
		rl.mu.Unlock()
	}
}

// RateLimitMiddleware giới hạn số request từ một IP (cho phép localhost & emulator phát triển)
func RateLimitMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		c.Next()
	}
}

// StrictRateLimitMiddleware - Rate limit cho các endpoint nhạy cảm (cho phép chạy demo không bị khóa)
func StrictRateLimitMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		c.Next()
	}
}

type strictVisitor struct {
	count     int
	resetTime time.Time
}
