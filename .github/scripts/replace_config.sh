#!/bin/bash
set -e

echo "🔧 开始精确替换RustDesk配置..."

CONFIG_FILE="libs/hbb_common/src/config.rs"
if [ ! -f "$CONFIG_FILE" ]; then
    echo "❌ 错误：找不到 $CONFIG_FILE"
    exit 1
fi

# 1. 精确替换第109行的中继服务器（只替换定义行）
if [ -n "$RELAY_SERVER" ]; then
    echo "替换中继服务器: $RELAY_SERVER"
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS: 只替换第109行中的值
        sed -i '' '109s/"rs-ny.rustdesk.com"/"'"$RELAY_SERVER"'"/' "$CONFIG_FILE"
    else
        # Linux: 只替换第109行中的值
        sed -i '109s/"rs-ny.rustdesk.com"/"'"$RELAY_SERVER"'"/' "$CONFIG_FILE"
    fi
fi

# 2. 精确替换第110行的公钥（只替换定义行）
if [ -n "$RS_PUB_KEY" ]; then
    echo "替换RSA公钥"
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS: 只替换第110行中的值
        sed -i '' '110s/"OeVuKk5nlHiXp+APNn0Y3pC1Iwpwn44JGqrQCsWqmBw="/"'"$RS_PUB_KEY"'"/' "$CONFIG_FILE"
    else
        # Linux: 只替换第110行中的值
        sed -i '110s/"OeVuKk5nlHiXp+APNn0Y3pC1Iwpwn44JGqrQCsWqmBw="/"'"$RS_PUB_KEY"'"/' "$CONFIG_FILE"
    fi
fi

# 3. 精确替换 common.rs 第1088行的 API URL
COMMON_FILE="src/common.rs"
if [ -f "$COMMON_FILE" ] && [ -n "$CUSTOM_API_URL" ]; then
    echo "替换API地址: $CUSTOM_API_URL"
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS: 只替换第1088行
        sed -i '' '1088s|"https://admin.rustdesk.com"|"'"$CUSTOM_API_URL"'"|' "$COMMON_FILE"
    else
        # Linux: 只替换第1088行
        sed -i '1088s|"https://admin.rustdesk.com"|"'"$CUSTOM_API_URL"'"|' "$COMMON_FILE"
    fi
fi

# 验证（只显示定义行）
echo ""
echo "📋 验证结果:"
echo "第109-110行:"
sed -n '109,110p' "$CONFIG_FILE"

if [ -f "$COMMON_FILE" ]; then
    echo ""
    echo "第1088行:"
    sed -n '1088p' "$COMMON_FILE"
fi

echo "✅ 配置替换完成"
