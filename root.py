from bottle import debug, route, run, static_file, template, redirect, abort, response
import datetime
import os
import db
import util

@route('/N5779V')
@route('/n5779v')
def n5779v():
	return template('view/n5779v')

@route('/N4WR')
@route('/n4wr')
def n4wr():
	return template('view/n4wr')

ARTICLES_PER_PAGE = 5
@route('/')
@route('/blog')
@route('/blog/')
@route('/blog/:page#[0-9]*#')
def blog(page=0):
	with db.db_conn('mrshoeblog') as conn:
		page = int(page)
		articles = conn.execute_fetch('select title, body, published, slug from entries where published is not null order by published desc limit %s offset %s', (ARTICLES_PER_PAGE, page*ARTICLES_PER_PAGE))
		if not articles:
			abort(404, 'Not found')
		article_count = conn.execute_fetchone('select count(*) from entries')
		if not article_count:
			abort(404, 'Not found')
		if page == 1:
			nxt = '/blog/'
		elif page > 1:
			nxt = '/blog/%d' % (page-1)
		else:
			nxt = None
		prev = '/blog/%d' % (page+1) if article_count[0] > ((page+1) * ARTICLES_PER_PAGE) else None
		return template('view/blog', articles=articles, next=nxt, previous=prev)

def get_next_prv(conn, pubdate):
	nextdate = conn.execute_fetchone('select published, slug from entries where published > %s order by published limit 1', (pubdate,))
	prevdate = conn.execute_fetchone('select published, slug from entries where published < %s order by published desc limit 1', (pubdate,))
	nxt = make_url(*nextdate) if nextdate else None
	prev = make_url(*prevdate) if prevdate else None
	return nxt, prev

def make_url(pubdate, slug):
	return '/blog/' + util.dateurl(util.timezonefix(pubdate)) + '/' + slug

@route('/blog/:year#[0-9]{4}#/:month#[0-9]{2}#/:day#[0-9]{2}#/:slug')
def article(year, month, day, slug):
	with db.db_conn('mrshoeblog') as conn:
		articles = conn.execute_fetch('select title, body, published, slug from entries where published is not null and slug=%s', (slug,))
		if not articles:
			abort(404, 'Not found')
		nxt, prev = get_next_prv(conn, articles[0][2])
		return template('view/blog', articles=articles, next=nxt, previous=prev)

@route('/blog/draft/:slug')
def draft(slug):
	try:
#		homedir = os.environ.get('HOME', '/tmp')
		homedir = '/home/mrshoe'
		blogdir = os.path.join(homedir, '.blog')
		f = open(os.path.join(blogdir, slug))
		lines = f.readlines()
		title = lines[0].strip()
		published = lines[-1].strip().lower() == 'published'
		bodylines = lines[1:-1] if published else lines[1:]
		body = ''.join(bodylines)
		with db.db_conn('mrshoeblog') as conn:
			article = conn.execute_fetch('select published from entries where slug=%s', (slug.strip(),))
			if len(article) > 1:
				abort(500, 'Multiple entries with that slug')
			elif len(article) == 1:
				if published:
					if article[0][0] is not None: # already published
						conn.execute('update entries set title=%s, body=%s where slug=%s', (title, body, slug))
					else:
						conn.execute('update entries set title=%s, body=%s, published=now() where slug=%s', (title, body, slug))
				else:
					conn.execute('update entries set title=%s, body=%s, published=null where slug=%s', (title, body, slug))
			else:
				if published:
					conn.execute('insert into entries values (default, %s, %s, now(), %s)', (title, body, slug))
				else:
					conn.execute('insert into entries values (default, %s, %s, NULL, %s)', (title, body, slug))
			return template('view/blog', articles=[(title, body, datetime.datetime.now(), slug)], next=None, previous=None)
	except IOError:
		abort(404, 'No such entry')

@route('/blog/index.xml')
def atomfeed():
	with db.db_conn('mrshoeblog') as conn:
		articles = conn.execute_fetch('select title, body, published, slug from entries where published is not null order by published desc limit 20')
		if not articles:
			abort(404, 'Not found')
		response.content_type = 'application/atom+xml'
		return template('view/atom', articles=articles)

@route('/blog/:year#[0-9]{4}#/:month#[0-9]{2}#/:filename')
def oldblog(year, month, filename):
	return template(os.path.join('static', 'oldblog', year, month, filename))

@route('/static/:path#.+#')
def static(path):
	return static_file(path, root='static')

@route('/favicon.ico')
def favicon():
	return static_file('favicon.ico', root='static')

debug(True)
run(host='0.0.0.0', port=8088, reloader=True)
