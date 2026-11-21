"""微信公众号 API 示例（WeChat Official Accounts API in Python）。

  python main.py search 咖啡机 --out articles.csv         # 按关键词搜文章 / search articles
  python main.py article "<文章链接>" --out article.json  # 文章正文 / article text
  python main.py comments "<文章链接>" --out comments.csv # 文章留言 / comments
  python main.py account "<公众号>"                       # 公众号资料 / account profile
"""
import argparse

from everyinfra import fetch, report


def main():
    p = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    sub = p.add_subparsers(dest="cmd", required=True)
    s = sub.add_parser("search", help="按关键词搜文章 / search articles by keyword")
    s.add_argument("keyword")
    ar = sub.add_parser("article", help="文章正文 / one article")
    ar.add_argument("url")
    c = sub.add_parser("comments", help="文章留言 / comments of one article")
    c.add_argument("url")
    ac = sub.add_parser("account", help="公众号资料 / account profile")
    ac.add_argument("account")
    for x in (s, ar, c, ac):
        x.add_argument("--out", help="存成 .csv 或 .json / write .csv or .json")
    a = p.parse_args()

    if a.cmd == "search":
        rows, charged = fetch("article_search", {"keyword": a.keyword})
    elif a.cmd == "article":
        rows, charged = fetch("article_detail", {"url": a.url})
    elif a.cmd == "comments":
        rows, charged = fetch("article_comments", {"url": a.url})
    else:
        rows, charged = fetch("account_profile", {"account": a.account})
    report(rows, charged, a.out)


if __name__ == "__main__":
    main()
