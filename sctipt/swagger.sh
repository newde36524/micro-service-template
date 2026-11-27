#!/usr/bin/env bash
# 通用脚本：根据 API 文件生成 swagger 文件并通过 Docker 启动 swagger-ui 容器

set -e

# ============================================================
# usage 帮助函数
# basename $0 使帮助文本不受调用路径影响（兼容 sh ./sctipt/swagger.sh）
# ============================================================
SCRIPT_NAME=$(basename "$0")
usage() {
    cat <<EOF
用法: ${SCRIPT_NAME} [选项] <api文件路径>

通用脚本：根据 API 文件生成 swagger 文件，并通过 Docker 启动 swagger-ui 容器。

位置参数:
  <api文件路径>            API 文件路径（如 ../doc/client.api）

选项:
  -p, --port <端口>        Docker 映射端口（默认：12330）
  -h, --help               显示本帮助信息并退出

示例:
  ${SCRIPT_NAME} ../doc/client.api
  ${SCRIPT_NAME} -p 8080 ../doc/client.api

说明:
  - 生成的 swagger 文件名为 <API文件名>.json
  - 容器名、镜像名均为 <API文件名>_swagger
  - 容器内 swagger 文件路径：/foo/swagger/<API文件名>.json
  - 依赖工具: goctl、docker
  - goctl 若不在 PATH 中，会自动回退到 \$(go env GOPATH)/bin/goctl
EOF
    exit 0
}

# ============================================================
# 确定 goctl 可执行文件路径（自动判断）
# ============================================================
if command -v goctl >/dev/null 2>&1; then
    GOCTL="goctl"
else
    GOCTL="$(go env GOPATH)/bin/goctl"
fi

# 校验 goctl 是否存在
if [ ! -x "$GOCTL" ] && ! command -v goctl >/dev/null 2>&1; then
    echo "错误：goctl 未找到，请先安装：GOPROXY=https://goproxy.cn/,direct go install github.com/zeromicro/go-zero/tools/goctl@latest" >&2
    exit 1
fi

# ============================================================
# 参数默认值
# ============================================================
PORT=12330                 # 默认端口
IMAGE="swaggerapi/swagger-ui"   # 官方 swagger-ui 镜像

# ============================================================
# 解析命令行参数（使用 getopts）
# ============================================================
while getopts ":p:h" opt; do
    case "$opt" in
        p) PORT="$OPTARG" ;;
        h) usage ;;
        \?) echo "错误：无效选项 -$OPTARG" >&2; usage ;;
        :)  echo "错误：选项 -$OPTARG 需要参数" >&2; usage ;;
    esac
done
shift $((OPTIND - 1))

# ============================================================
# 校验 API 文件路径
# ============================================================
if [ $# -lt 1 ]; then
    echo "错误：缺少 API 文件路径参数" >&2
    usage
fi
API_FILE="$1"

# 校验文件是否存在
if [ ! -f "$API_FILE" ]; then
    echo "错误：文件 $API_FILE 不存在！" >&2
    exit 1
fi

# ============================================================
# 提取 API 文件名（不含路径和扩展名）
# ============================================================
API_BASENAME=$(basename "$API_FILE")      # 例如 admin.api
API_FILENAME="${API_BASENAME%.*}"         # 例如 admin

# swagger 输出文件名（goctl 生成的就是 <API文件名>.json）
OUT_FILENAME="${API_FILENAME}.json"

# 输出目录
DIR=$(dirname "$API_FILE")

# ============================================================
# 1. 生成 swagger 文件（goctl 直接输出 xxx.json）
# ============================================================
echo "正在生成 ${OUT_FILENAME} ..."
"$GOCTL" api swagger --api "$API_FILE" --dir "$DIR"

# 生成的 swagger 文件宿主绝对路径
OUT_FILE_ABS="$(cd "$DIR" && pwd)/${OUT_FILENAME}"

# ============================================================
# 2. 删除旧容器（忽略不存在错误）
# ============================================================
echo "删除旧容器 ${API_FILENAME}_swagger ..."
docker rm -f "${API_FILENAME}_swagger" 2>/dev/null || true

# ============================================================
# 3. 启动 swagger-ui 容器
#    -v 把生成的 xxx.json 映射到容器内 /foo/swagger/xxx.json
#    SWAGGER_JSON 指向该容器内绝对路径，与挂载目标一致
# ============================================================
echo "启动容器 ${API_FILENAME}_swagger ..."
docker run -d \
    --name "${API_FILENAME}_swagger" \
    -p "${PORT}:8080" \
    -e "SWAGGER_JSON=/foo/swagger/${OUT_FILENAME}" \
    -v "${OUT_FILE_ABS}:/foo/swagger/${OUT_FILENAME}" \
    "${IMAGE}"

echo "✅ 完成！"
echo "  - Swagger 文件：${OUT_FILE_ABS}"
echo "  - 容器内路径：/foo/swagger/${OUT_FILENAME}"
echo "  - 访问地址：http://localhost:${PORT}"
