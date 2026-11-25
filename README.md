# WeChat Official Accounts API（微信公众号 API）

[English](#english) · [中文](#中文)

## English

This repo reads public WeChat Official Accounts data with Python or curl. You can search articles by keyword, read article text and comments, and look up an official account's profile. You need one EveryInfra API key. You do not need a WeChat account or cookie. The same API also works as an MCP tool in Claude and Cursor. Billing is per call: these 4 capabilities cost $5.56 to $8.00 per 1,000 calls. Failed calls and empty results are not charged. The EveryInfra WeChat Official Accounts API has 13 capabilities; 12 are available now. All are listed on the platform page: <https://everyinfra.com/en/wechat-oa-api?utm_source=github&utm_medium=example_repo&utm_campaign=wechat-oa-api>

### Quick start

```bash
git clone https://github.com/everyinfra/wechat-oa-api.git
cd wechat-oa-api
pip install -r requirements.txt
export EVERYINFRA_API_KEY=<your API key>
python main.py search 咖啡机 --out articles.csv
python main.py article "<article url>" --out article.json
python main.py comments "<article url>" --out comments.csv
python main.py account "<account>"
```

- Take the article link from the `url` field of a `search` result.
- For `account`, pass the account name. The test run used the `account_name` from a `search` result. The `account_id` it returns is the original ID that starts with gh_.
- `comments` reads the comments under an article. An article without comments returns 0 rows and is not charged.
- Without `--out`, the command prints the first 3 rows as JSON. With `--out`, it saves a .csv or .json file. The CSV has a BOM, so Excel opens it without garbled text.
- Register at everyinfra.com, then create the API key in the console. Steps: <https://everyinfra.com/en/docs?utm_source=github&utm_medium=example_repo&utm_campaign=wechat-oa-api#quickstart>

### curl

```bash
curl -X POST https://api.everyinfra.com/api/v1/social \
  -H "Authorization: Bearer $EVERYINFRA_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"platform":"wechat_oa","action":"article_search","params":{"keyword":"咖啡机"}}'
```

All capabilities use the same URL. Change `action` and `params` to call another one. Examples for `article_detail`, `article_comments`, and `account_profile` are in [examples/curl.sh](examples/curl.sh).

### Claude and Cursor (MCP)

The remote MCP URL is <https://api.everyinfra.com/mcp>. Add the `Authorization: Bearer` header with your API key. EveryInfra runs the server, so you install no local program.

Claude Code:

```bash
claude mcp add --transport http everyinfra https://api.everyinfra.com/mcp --header "Authorization: Bearer <API Key>"
```

Cursor and other clients that read `mcp.json` ([examples/mcp.json](examples/mcp.json)):

```json
{
  "mcpServers": {
    "everyinfra": {
      "url": "https://api.everyinfra.com/mcp",
      "headers": {
        "Authorization": "Bearer <API Key>"
      }
    }
  }
}
```

Custom connectors in Claude on the web and desktop, and ChatGPT, accept only a URL. Enter <https://api.everyinfra.com/mcp/all>, sign in to EveryInfra when asked, and allow access. You do not need to enter a key. Full steps: <https://everyinfra.com/en/mcp-server?utm_source=github&utm_medium=example_repo&utm_campaign=wechat-oa-api>

### Price

| `action` | Per 1,000 calls |
|---|---|
| `article_search` | $8.00 |
| `article_detail` | $5.56 |
| `article_comments` | $6.76 |
| `account_profile` | $8.00 |

- Billing is per call, about $0.0056 to $0.008 each. Failed calls, empty results, parameter errors, and authentication failures are not charged.
- A new account gets a $1 trial allowance, valid for 24 hours. No credit card is needed. How to claim it: <https://everyinfra.com/en/pricing?utm_source=github&utm_medium=example_repo&utm_campaign=wechat-oa-api>
- Prices for the other 8 available WeChat Official Accounts capabilities are on the platform page: <https://everyinfra.com/en/wechat-oa-api?utm_source=github&utm_medium=example_repo&utm_campaign=wechat-oa-api>

### Fields

These are the fields that the 4 capabilities returned in our test. Each meaning is the first sentence of the field's entry in the API documentation. The link under each table has the full text.

#### `article_search` (article search)

| Field | Meaning |
|---|---|
| `title` | Title. null when the platform has no titles (for example text-only posts). |
| `summary` | Article summary shown in the search result. |
| `url` | Link to the record on the platform. |
| `cover_image_url` | Cover image URL of the article. |
| `account_name` | Name of the Official Account that published the article. |
| `posted_at` | Publish time in ISO 8601, UTC (for example 2026-08-07T12:34:56+00:00). |
| `platform` | Source platform identifier, the same as platform in the request (for example xiaohongshu, tiktok). |

All parameters and fields: <https://everyinfra.com/en/wechat-oa-api/article_search?utm_source=github&utm_medium=example_repo&utm_campaign=wechat-oa-api>

#### `article_detail` (article details)

| Field | Meaning |
|---|---|
| `title` | Title. null when the platform has no titles (for example text-only posts). |
| `url` | Link to the record on the platform. |
| `content_text` | Full article body as plain text (no HTML tags). |
| `content_html` | Full article body as original HTML, preserving layout and image references. |
| `author` | Article byline (often a personal pen name, not necessarily the account name). |
| `account_name` | Name of the Official Account that published the article. |
| `account_ghid` | The account's raw ID, unique within WeChat. |
| `cover_image_url` | Cover image URL of the article. |
| `images` | Image URL list from the article body. |
| `is_original` | Whether the article carries an original-content declaration. |
| `posted_at` | Publish time in ISO 8601, UTC (for example 2026-08-07T12:34:56+00:00). |
| `ip_region` | IP region shown at publish time (province/country). |
| `platform` | Source platform identifier, the same as platform in the request (for example xiaohongshu, tiktok). |

All parameters and fields: <https://everyinfra.com/en/wechat-oa-api/article_detail?utm_source=github&utm_medium=example_repo&utm_campaign=wechat-oa-api>

#### `article_comments` (article comments)

| Field | Meaning |
|---|---|
| `id` | The record's unique ID on WeChat. |
| `text` | Body text with HTML removed, returned in full and never cut short (on a few platforms the list results themselves carry only an excerpt; the platform's field notes say so). |
| `author_name` | Author's display name. |
| `author_avatar_url` | Author's avatar. |
| `like_count` | Likes. null means the platform or this capability does not disclose it; it is not 0. |
| `posted_at` | Publish time in ISO 8601, UTC (for example 2026-08-07T12:34:56+00:00). |
| `is_top` | Whether the content is pinned. |
| `reply_count` | Replies, usually replies to a comment. null means not disclosed. |
| `country` | Country or region: a full name or an ISO code depending on the platform, not normalized. |
| `province` | Province where it is located. |
| `platform` | Source platform identifier, the same as platform in the request (for example xiaohongshu, tiktok). |

All parameters and fields: <https://everyinfra.com/en/wechat-oa-api/article_comments?utm_source=github&utm_medium=example_repo&utm_campaign=wechat-oa-api>

#### `account_profile` (account details)

| Field | Meaning |
|---|---|
| `account_id` | Official Account ID (its WeChat ID). |
| `name` | Name of the object itself, for account, product and business capabilities. |
| `account_type` | Account type (subscription account or service account). |
| `platform` | Source platform identifier, the same as platform in the request (for example xiaohongshu, tiktok). |

All parameters and fields: <https://everyinfra.com/en/wechat-oa-api/account_profile?utm_source=github&utm_medium=example_repo&utm_campaign=wechat-oa-api>

### FAQ

**Do I need a WeChat account or cookie to call the API?**

No. Send the `Authorization: Bearer` header with your API key. The request body holds `platform`, `action`, and the capability parameters. You do not scan a QR code, keep a login session, or open a browser.

**How much does it cost? Are failed calls charged? Is there a free allowance?**

Billing is per call, from $5.56 per 1,000 calls. Failed calls, empty results, parameter errors, and authentication failures are not charged. A new account gets a $1 trial allowance, valid for 24 hours. No credit card is needed. How to claim it: <https://everyinfra.com/en/pricing?utm_source=github&utm_medium=example_repo&utm_campaign=wechat-oa-api>

**Can I connect the WeChat Official Accounts API to Claude or Cursor?**

Yes. The remote MCP URL is <https://api.everyinfra.com/mcp>. Add the `Authorization: Bearer` header with your API key. You install no local program. Setup for Claude, Cursor, ChatGPT, and Claude Code: <https://everyinfra.com/en/mcp-server?utm_source=github&utm_medium=example_repo&utm_campaign=wechat-oa-api>.

**What legal points apply when I use WeChat Official Accounts data?**

The EveryInfra Terms of Service require you to make sure your use of the data follows applicable law and the terms of the relevant platform. Do not use the data for anything illegal or anything that violates privacy or intellectual property rights. Do not use bulk scraping for harassment, fraud, or other abuse. When you use personal information such as nicknames and avatars, keep only the fields your business needs.

**Which WeChat Official Accounts data can I get?**

The EveryInfra WeChat Official Accounts API has 13 capabilities; 12 are available now:

- article search
- article details
- account search
- search suggestions
- account details
- account owner
- account articles
- today's account articles
- article comments
- comment replies
- article engagement
- WeChat Index

Parameters and return fields for each capability are on the platform page: <https://everyinfra.com/en/wechat-oa-api?utm_source=github&utm_medium=example_repo&utm_campaign=wechat-oa-api>

### Tested

Before release, we ran the 4 commands in Quick start against the live API with this repo's code.

| Command | Time (Singapore, UTC+8) | Rows | Charged |
|---|---|---|---|
| `python main.py search 咖啡机 --out articles.csv` | 2026-11-21 09:21 | 20 | $0.008000 |
| `python main.py article "<article url>" --out article.json` | 2026-11-21 09:22 | 1 | $0.005556 |
| `python main.py comments "<article url>" --out comments.csv` | 2026-11-21 09:22 | 13 | $0.006764 |
| `python main.py account "<account>"` | 2026-11-21 09:23 | 1 | $0.008000 |

## 中文

本仓库用 Python 或 curl 读微信公众号公开数据：按关键词搜文章，读文章正文和留言，查公众号资料。只需一把 EveryInfra API Key，不用微信公众号账号和 Cookie，也能作为 MCP 工具接进 Claude、Cursor。按调用次数计费，这 4 个能力每千次 $5.56 到 $8.00，失败和空结果不收费。微信公众号共 13 个能力，其中 12 个现在可用：<https://everyinfra.com/wechat-oa-api?utm_source=github&utm_medium=example_repo&utm_campaign=wechat-oa-api>

### 快速开始

```bash
git clone https://github.com/everyinfra/wechat-oa-api.git
cd wechat-oa-api
pip install -r requirements.txt
export EVERYINFRA_API_KEY=<你的 API Key>
python main.py search 咖啡机 --out articles.csv
python main.py article "<文章链接>" --out article.json
python main.py comments "<文章链接>" --out comments.csv
python main.py account "<公众号>"
```

- 文章链接用 `search` 结果里的 `url`。
- `account` 传公众号名称，实测用的是 `search` 结果里的 `account_name`；返回的 `account_id` 是 gh_ 开头的原始 ID。
- `comments` 读文章下的留言，文章没有留言时返回 0 条，不收费。
- 不加 `--out` 时打印前 3 条 JSON；加 `--out` 存成 .csv 或 .json。CSV 带 BOM，Excel 直接打开不乱码。
- API Key 在 everyinfra.com 注册后到控制台创建，步骤见 <https://everyinfra.com/docs?utm_source=github&utm_medium=example_repo&utm_campaign=wechat-oa-api#quickstart>

### 用 curl 调

```bash
curl -X POST https://api.everyinfra.com/api/v1/social \
  -H "Authorization: Bearer $EVERYINFRA_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"platform":"wechat_oa","action":"article_search","params":{"keyword":"咖啡机"}}'
```

所有能力都发到同一个地址，换 `action` 和 `params` 就行；`article_detail`、`article_comments`、`account_profile` 的写法见 [examples/curl.sh](examples/curl.sh)。

### 接进 Claude、Cursor（MCP）

远程 MCP 地址是 <https://api.everyinfra.com/mcp>，请求头加 `Authorization: Bearer` 和 API Key；服务器由 EveryInfra 运行，不用装本地程序。

Claude Code：

```bash
claude mcp add --transport http everyinfra https://api.everyinfra.com/mcp --header "Authorization: Bearer <API Key>"
```

Cursor 等读 `mcp.json` 的客户端（[examples/mcp.json](examples/mcp.json)）：

```json
{
  "mcpServers": {
    "everyinfra": {
      "url": "https://api.everyinfra.com/mcp",
      "headers": {
        "Authorization": "Bearer <API Key>"
      }
    }
  }
}
```

Claude 网页版和桌面版的自定义连接器、ChatGPT 只能填网址：填 <https://api.everyinfra.com/mcp/all>，连接时登录 EveryInfra 并允许，不用填 Key。完整步骤见 <https://everyinfra.com/mcp-server?utm_source=github&utm_medium=example_repo&utm_campaign=wechat-oa-api>

### 价格

| 能力 | `action` | 每千次 |
|---|---|---|
| 文章搜索 | `article_search` | $8.00 |
| 文章正文 | `article_detail` | $5.56 |
| 文章评论 | `article_comments` | $6.76 |
| 公众号资料 | `account_profile` | $8.00 |

- 按调用次数计费，每次约 $0.0056 到 $0.008；失败、空结果、参数错误和鉴权失败都不收费。
- 新账号有 $1 试用额度，24 小时内有效，不用信用卡，领取方式见 <https://everyinfra.com/pricing?utm_source=github&utm_medium=example_repo&utm_campaign=wechat-oa-api>
- 微信公众号其他 8 个可用能力的单价见平台页 <https://everyinfra.com/wechat-oa-api?utm_source=github&utm_medium=example_repo&utm_campaign=wechat-oa-api>

### 返回字段

下面是这 4 个能力实测返回的字段，含义取自接口文档每条说明的第一句，完整说明在每张表下面的链接里。

#### `article_search`（文章搜索）

| 字段 | 含义 |
|---|---|
| `title` | 标题。 |
| `summary` | 摘要。 |
| `url` | 该记录在原平台上的可访问链接。 |
| `cover_image_url` | 封面图。 |
| `account_name` | 公众号名称。 |
| `posted_at` | 发布时间，ISO 8601 格式、UTC 时区（如 2026-08-07T12:34:56+00:00）。 |
| `platform` | 数据来源平台标识，与请求里的 platform 一致（如 xiaohongshu、tiktok）。 |

完整参数和字段：<https://everyinfra.com/wechat-oa-api/article_search?utm_source=github&utm_medium=example_repo&utm_campaign=wechat-oa-api>

#### `article_detail`（文章正文）

| 字段 | 含义 |
|---|---|
| `title` | 标题。 |
| `url` | 该记录在原平台上的可访问链接。 |
| `content_text` | 文章正文（纯文本，无 HTML 标签）。 |
| `content_html` | 文章正文（原始 HTML，保留排版与图片引用）。 |
| `author` | 文章作者（可能是个人笔名，不一定是公众号名）。 |
| `account_name` | 公众号名称。 |
| `account_ghid` | 公众号的原始 ID，微信体系内唯一。 |
| `cover_image_url` | 封面图。 |
| `images` | 正文内图片 URL 列表。 |
| `is_original` | 是否为原创声明文章。 |
| `posted_at` | 发布时间，ISO 8601 格式、UTC 时区（如 2026-08-07T12:34:56+00:00）。 |
| `ip_region` | 发布时显示的 IP 属地（省份/国家）。 |
| `platform` | 数据来源平台标识，与请求里的 platform 一致（如 xiaohongshu、tiktok）。 |

完整参数和字段：<https://everyinfra.com/wechat-oa-api/article_detail?utm_source=github&utm_medium=example_repo&utm_campaign=wechat-oa-api>

#### `article_comments`（文章评论）

| 字段 | 含义 |
|---|---|
| `id` | 该记录在原平台上的唯一标识。 |
| `text` | 正文内容，已去除 HTML 标签，全文返回、不截断（个别平台的列表结果本身只有摘要，以该平台的字段说明为准）。 |
| `author_name` | 作者昵称（显示名）。 |
| `author_avatar_url` | 作者头像。 |
| `like_count` | 点赞数。 |
| `posted_at` | 发布时间，ISO 8601 格式、UTC 时区（如 2026-08-07T12:34:56+00:00）。 |
| `is_top` | 是否为置顶内容。 |
| `reply_count` | 回复数，通常用于评论的子回复。 |
| `country` | 国家或地区。 |
| `province` | 所在省份。 |
| `platform` | 数据来源平台标识，与请求里的 platform 一致（如 xiaohongshu、tiktok）。 |

完整参数和字段：<https://everyinfra.com/wechat-oa-api/article_comments?utm_source=github&utm_medium=example_repo&utm_campaign=wechat-oa-api>

#### `account_profile`（公众号资料）

| 字段 | 含义 |
|---|---|
| `account_id` | 公众号 ID。 |
| `name` | 名称。 |
| `account_type` | 账号类型（订阅号 / 服务号）。 |
| `platform` | 数据来源平台标识，与请求里的 platform 一致（如 xiaohongshu、tiktok）。 |

完整参数和字段：<https://everyinfra.com/wechat-oa-api/account_profile?utm_source=github&utm_medium=example_repo&utm_campaign=wechat-oa-api>

### 常见问题

**调用时要不要提供微信公众号账号或 Cookie？**

不用，请求头带 `Authorization: Bearer` 和 API Key 就能调，请求体写 `platform`、`action` 和能力参数。不用扫码、维护登录状态，也不用开浏览器。

**怎么收费？失败了收不收钱？有免费额度吗？**

按调用次数计费，每千次 $5.56 起。失败、空结果、参数错误和鉴权失败都不收费。新账号有 $1 试用额度，24 小时内有效，不用信用卡，领取方式见定价页 <https://everyinfra.com/pricing?utm_source=github&utm_medium=example_repo&utm_campaign=wechat-oa-api>

**能把微信公众号接口接进 Claude、Cursor 吗？**

能，远程 MCP 地址是 <https://api.everyinfra.com/mcp>，请求头加 `Authorization: Bearer` 和 API Key，不用装本地程序。Claude、Cursor、ChatGPT、Claude Code 配置见 <https://everyinfra.com/mcp-server?utm_source=github&utm_medium=example_repo&utm_campaign=wechat-oa-api>。

**用微信公众号数据要注意哪些合规问题？**

EveryInfra 服务条款要求你自行确保数据用法符合适用法律和相关平台条款，禁止用于违法、侵犯隐私或知识产权，或批量抓取用于骚扰、欺诈等恶意用途。用到昵称、头像等个人信息时，只留业务用得上的字段。

**可以拿到微信公众号的哪些数据？**

微信公众号有 13 个能力，其中 12 个现在可用：文章搜索、文章正文、公众号搜索、搜索联想、公众号资料、公众号主体信息、公众号历史文章、公众号当日文章、文章评论、评论回复、文章传播数据、微信指数。每个能力的参数和返回字段见平台页 <https://everyinfra.com/wechat-oa-api?utm_source=github&utm_medium=example_repo&utm_campaign=wechat-oa-api>

### 实测记录

发布前用本仓的代码对线上接口跑过一遍，命令就是「快速开始」里的 4 条。

| 命令 | 时间（新加坡时间） | 返回条数 | 扣费 |
|---|---|---|---|
| `python main.py search 咖啡机 --out articles.csv` | 2026-11-21 09:21 | 20 | $0.008000 |
| `python main.py article "<文章链接>" --out article.json` | 2026-11-21 09:22 | 1 | $0.005556 |
| `python main.py comments "<文章链接>" --out comments.csv` | 2026-11-21 09:22 | 13 | $0.006764 |
| `python main.py account "<公众号>"` | 2026-11-21 09:23 | 1 | $0.008000 |

`article_detail` 返回的一条（正文截到 60 字，作者字段没放进来）：

```json
{
  "title": "家用咖啡机怎么选？从几百到上万，按需求买才不踩坑",
  "content_text": "很多人买家用咖啡机，第一个误区就是：只看品牌、只看价格。其实咖啡机不是越贵越适合你，而是要先看你每天到底怎么喝。\n如果你…",
  "is_original": true,
  "posted_at": "2026-06-15T06:04:57+00:00"
}
```

## License

MIT
