// Code scaffolded by goctl. Safe to edit.
// goctl 1.11.0

package demo

import (
	"context"

	"admin/internal/svc"
	"admin/internal/types"

	"github.com/zeromicro/go-zero/core/logx"
)

type UserDelLogic struct {
	logx.Logger
	ctx    context.Context
	svcCtx *svc.ServiceContext
}

// 删除用户
func NewUserDelLogic(ctx context.Context, svcCtx *svc.ServiceContext) *UserDelLogic {
	return &UserDelLogic{
		Logger: logx.WithContext(ctx),
		ctx:    ctx,
		svcCtx: svcCtx,
	}
}

func (l *UserDelLogic) UserDel(req *types.UserDelReq) (resp *types.UserDelResp, err error) {
	// todo: add your logic here and delete this line

	return
}
