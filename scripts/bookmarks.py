import json
import os
from dataclasses import dataclass
from datetime import datetime, timezone
from functools import lru_cache
from typing import Literal, Sequence

import requests


@lru_cache() # lol
def get_current_time_iso():
    return datetime.now(timezone.utc).isoformat(timespec='seconds') + "Z"


@lru_cache()
def get_tag_id(tag_name: str) -> str:
  tags = _req("tags").get("tags", [])
  for tag in tags:
    if tag["name"] == tag_name:
       return tag["id"]
  raise ValueError(f"Could not find tag with name {tag_name}")

def _req(url: str, method: Literal["GET", "POST", "DELETE"] = "GET", payload = None):
  headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': f'Bearer {api_token}'
  }

  url = f"https://{base_url}/api/v1/" + url
  if payload:
    payload = json.dumps(payload)
  response = requests.request(method, url, headers=headers, data=payload)
  if response.status_code != 200:
     raise ValueError("Ooops")
  return response.json()

@dataclass
class Tag:

  name: str

  @property
  def id(self) -> str:
    return get_tag_id(self.name)

class InvalidBookmark(ValueError):
  pass

@dataclass
class Bookmark:

  b_id: str
  url: str
  title: str

  @classmethod
  def from_data(cls, data: dict[str, str]):
    try:
      res = cls(
        b_id=data.get("id"),
        url=data.get("content").get("url"),
        title=data.get("content").get("title"),
      )
    except KeyError:
      raise InvalidBookmark()

    return res

  def dump(self, bookmarks_path: str):
    with open(f"{bookmarks_path}/{self.b_id}.md", "w") as f:
      f.write(self.get_file_contents())

  def get_file_contents(self) -> str:
    return f"""---
title: '{self.title}'
date: {get_current_time_iso()}
draft: false
link: {self.url}
---
[{self.title}]({self.url})
"""
  
  def _tag_modify(self, method: Literal["POST", "DELETE"], tag: Tag):
    payload = { "tags": [ { "tagId": tag.id, "tagName": tag.name } ] }
    _req(f"bookmarks/{self.b_id}/tags", method=method, payload=payload)
  
  def add_tag(self, tag: Tag):
    self._tag_modify("POST", tag)

  def remove_tag(self, tag: Tag):
    self._tag_modify("DELETE", tag)

def get_tagged_bookmarks(tag: Tag) -> Sequence[Bookmark]:
  res = _req(f"tags/{tag.id}/bookmarks")
  bookmarks = []
  for data in res.get("bookmarks"):
    try:
      bookmarks.append(Bookmark.from_data(data))
    except InvalidBookmark:
      pass
  return bookmarks

if __name__ == "__main__":
  rss_feed_tag_prefix = os.environ.get("HRSS_RSS_FEED_TAG_PREFIX")
  base_url = os.environ.get("HRSS_BASE_URL")
  api_token = os.environ.get("HRSS_HOARDER_API_TOKEN")
  bookmarks_content_path = "content/bookmarks"

  tag_unpub = Tag(f"{rss_feed_tag_prefix}_unpublished")
  tag_pub = Tag(f"{rss_feed_tag_prefix}_published")
  tag_error = Tag(f"{rss_feed_tag_prefix}_error")

  bookmarks_unpub = get_tagged_bookmarks(tag_unpub)
  for bm in bookmarks_unpub:
    try:
        bm.dump(bookmarks_content_path)
        bm.add_tag(tag_pub)
        bm.remove_tag(tag_unpub)
    except:
        bm.add_tag(tag_error)