#!/usr/bin/env bash
# 微信公众号 API 的 curl 示例：所有能力都发到同一个地址，只换 action 和 params。
# curl examples for the WeChat Official Accounts API: every capability uses the same URL; only action and params change.
#
#   export EVERYINFRA_API_KEY=<your API key>
#   bash examples/curl.sh article_search 咖啡机
#   bash examples/curl.sh article_detail "<article url>"   # search 结果里的 url / the url from a search result
#   bash examples/curl.sh article_comments "<article url>"
#   bash examples/curl.sh account_profile "<account>"      # 公众号名称、微信号或 gh_ 开头的 ID / account name, WeChat ID or gh_ ID
set -euo pipefail
: "${EVERYINFRA_API_KEY:?Set EVERYINFRA_API_KEY first: https://everyinfra.com/docs#quickstart}"
action=${1:?"usage: bash examples/curl.sh <article_search|article_detail|article_comments|account_profile> <value>"}
value=${2:?"value: a keyword, an article url or an account"}

case "$action" in
  article_search)                    params="{\"keyword\":\"$value\"}" ;;
  article_detail | article_comments) params="{\"url\":\"$value\"}" ;;
  account_profile)                   params="{\"account\":\"$value\"}" ;;
  *) echo "unknown action: $action (use article_search, article_detail, article_comments or account_profile)" >&2; exit 2 ;;
esac

curl -sS -X POST https://api.everyinfra.com/api/v1/social \
  -H "Authorization: Bearer $EVERYINFRA_API_KEY" \
  -H "Content-Type: application/json" \
  -d "{\"platform\":\"wechat_oa\",\"action\":\"$action\",\"params\":$params}"
echo
