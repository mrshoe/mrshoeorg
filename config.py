import os
import json
json_file = os.environ.get('JSON_CONFIG')
json_config = json.load(open(json_file)) if json_file else {}
ARTICLES_PER_PAGE = json_config.get('ARTICLES_PER_PAGE', 5)
DATABASE_NAME = json_config.get('DATABASE_NAME', 'mrshoeblog')
PORT = json_config.get('PORT', 8088)
COMMENTS_ENABLED = json_config.get('COMMENTS_ENABLED', False)
GOOGLE_ANALYTICS_ACCOUNT = json_config.get('GOOGLE_ANALYTICS_ACCOUNT', 'UA-168882-1')
BLOGGER_NAME = json_config.get('BLOGGER_NAME', 'David Shoemaker')
BLOG_TITLE = json_config.get('BLOG_TITLE', 'MrShoe.org Blog')
BASE_URL = json_config.get('BASE_URL', 'http://mrshoe.org/')
HOME_URL = BASE_URL
BLOG_URL = BASE_URL+'blog/'
ATOM_URL = BASE_URL+'blog/index.xml'
BLOG_PASSWORD = json_config.get('BLOG_PASSWORD', open('passwd').read().strip())
