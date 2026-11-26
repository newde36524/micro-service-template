// Code scaffolded by goctl. Safe to edit.
// goctl 1.11.0

package demo

import (
	"net/http"

	"client/internal/logic/demo"
	"client/internal/svc"
	"client/internal/types"
	"github.com/zeromicro/go-zero/rest/httpx"
)

// hello world
func HelloWorldHandler(svcCtx *svc.ServiceContext) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		var req types.HelloWorldReq
		if err := httpx.Parse(r, &req); err != nil {
			httpx.ErrorCtx(r.Context(), w, err)
			return
		}

		l := demo.NewHelloWorldLogic(r.Context(), svcCtx)
		resp, err := l.HelloWorld(&req)
		if err != nil {
			httpx.ErrorCtx(r.Context(), w, err)
		} else {
			httpx.OkJsonCtx(r.Context(), w, resp)
		}
	}
}
