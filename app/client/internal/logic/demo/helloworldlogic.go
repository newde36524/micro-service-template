// Code scaffolded by goctl. Safe to edit.
// goctl 1.11.0

package demo

import (
	"context"

	"client/internal/svc"
	"client/internal/types"

	"github.com/zeromicro/go-zero/core/logx"
)

type HelloWorldLogic struct {
	logx.Logger
	ctx    context.Context
	svcCtx *svc.ServiceContext
}

// hello world
func NewHelloWorldLogic(ctx context.Context, svcCtx *svc.ServiceContext) *HelloWorldLogic {
	return &HelloWorldLogic{
		Logger: logx.WithContext(ctx),
		ctx:    ctx,
		svcCtx: svcCtx,
	}
}

func (l *HelloWorldLogic) HelloWorld(req *types.HelloWorldReq) (resp *types.HelloWorldResp, err error) {
	resp = &types.HelloWorldResp{
		Msg: "hello world",
	}
	return
}
