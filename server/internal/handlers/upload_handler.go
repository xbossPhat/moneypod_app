package handlers

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/xbossPhat/moneypod_app/server/internal/services"
)

type UploadHandler struct {
	storageService *services.StorageService
}

// Constructor
func NewUploadHandler(storageService *services.StorageService) *UploadHandler {
	return &UploadHandler{storageService: storageService}
}

// UploadImage godoc
// @Summary      Upload ảnh lên Cloudinary
// @Description  Upload file ảnh lên Cloudinary và trả về URL
// @Tags         Upload
// @Accept       multipart/form-data
// @Produce      json
// @Security     BearerAuth
// @Param        file  formData  file  true  "File ảnh cần upload (hỗ trợ key: file, image, avatar)"
// @Success      200  {object}  map[string]interface{} "Upload thành công, trả về URL"
// @Failure      400  {object}  map[string]interface{} "Không nhận được file"
// @Failure      500  {object}  map[string]interface{} "Lỗi upload"
// @Router       /upload [post]
func (h *UploadHandler) UploadImage(c *gin.Context) {
	if h.storageService == nil {
		c.JSON(http.StatusServiceUnavailable, gin.H{
			"error": "Dịch vụ upload ảnh (Cloudinary) chưa được cấu hình",
		})
		return
	}

	// 1. Nhận file từ request - Hỗ trợ linh hoạt các key: "file", "image", "avatar", "images"
	file, header, err := c.Request.FormFile("file")
	if err != nil {
		file, header, err = c.Request.FormFile("image")
		if err != nil {
			file, header, err = c.Request.FormFile("avatar")
			if err != nil {
				file, header, err = c.Request.FormFile("images")
				if err != nil {
					c.JSON(http.StatusBadRequest, gin.H{
						"error": "Vui lòng gửi file ảnh (key: 'file', 'image', hoặc 'avatar')",
					})
					return
				}
			}
		}
	}
	defer file.Close()

	// 2. Gọi Service để upload lên Cloudinary
	url, err := h.storageService.UploadFile(file, header)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"error": "Lỗi upload ảnh: " + err.Error(),
		})
		return
	}

	// 3. Trả về URL ảnh cho App Flutter (hỗ trợ cả data.url và url phẳng)
	c.JSON(http.StatusOK, gin.H{
		"message": "Upload thành công",
		"url":     url,
		"data": gin.H{
			"url":        url,
			"secure_url": url,
		},
	})
}
