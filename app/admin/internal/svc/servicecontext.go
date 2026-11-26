// Code scaffolded by goctl. Safe to edit.
// goctl 1.11.0

package svc

import (
	"admin/internal/config"
	"admin/internal/middleware"
	"github.com/zeromicro/go-zero/rest"
)

type ServiceContext struct {
	Config    config.Config
	AdminAuth rest.Middleware
}

func NewServiceContext(c config.Config) *ServiceContext {
	return &ServiceContext{
		Config:    c,
		AdminAuth: middleware.NewAdminAuthMiddleware().Handle,
	}
}
