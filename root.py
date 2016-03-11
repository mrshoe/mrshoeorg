from bottle import debug, route, run, static_file, template, redirect, abort, response, request
import datetime
import os
import re
import json
import db
import util
import config

@route('/N5779V')
@route('/n5779v')
def n5779v():
	return template('view/n5779v')

@route('/N4WR')
@route('/n4wr')
def n4wr():
	return template('view/n4wr')

@route('/')
@route('/blog')
@route('/blog/')
@route('/blog/:page#[0-9]*#')
def blog(page=0):
	with db.db_conn(config.DATABASE_NAME) as conn:
		page = int(page)
		articles = conn.execute_fetch('select title, body, published, slug, id from entries where published is not null order by published desc limit %s offset %s', (config.ARTICLES_PER_PAGE, page*config.ARTICLES_PER_PAGE))
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
		prev = '/blog/%d' % (page+1) if article_count[0] > ((page+1) * config.ARTICLES_PER_PAGE) else None
		articleids = [str(a[4]) for a in articles]
		comment_counts = dict(conn.execute_fetch('select entryid, count(*) from comments where entryid in (%s) group by entryid' % ','.join(articleids),()))
		for k,v in comment_counts.iteritems():
			if v == 1:
				comment_counts[k] = '1 comment'
			else:
				comment_counts[k] = '%d comments' % v
		return template('view/blog', articles=articles, comments=[], comment_counts=comment_counts, single_post=False, next=nxt, previous=prev)

def get_next_prv(conn, pubdate):
	nextdate = conn.execute_fetchone('select published, slug from entries where published > %s order by published limit 1', (pubdate,))
	prevdate = conn.execute_fetchone('select published, slug from entries where published < %s order by published desc limit 1', (pubdate,))
	nxt = make_url(*nextdate) if nextdate else None
	prev = make_url(*prevdate) if prevdate else None
	return nxt, prev

def make_url(pubdate, slug):
	return '/blog/' + util.dateurl(util.timezonefix(pubdate)) + '/' + slug

def sameday(pubdate, year, month, day):
	pubdate = util.timezonefix(pubdate)
	return pubdate.day == day and pubdate.month == month and pubdate.year == year

def get_article(conn, year, month, day, slug):
	articles = conn.execute_fetch('select title, body, published, slug, id from entries where published is not null and slug=%s', (slug,))
	articles = [a for a in articles if sameday(a[2], int(year), int(month), int(day))]
	if not articles:
		abort(404, 'Not found')
	return articles

@route('/blog/:year#[0-9]{4}#/:month#[0-9]{2}#/:day#[0-9]{2}#/:slug')
def article(year, month, day, slug):
	with db.db_conn(config.DATABASE_NAME) as conn:
		articles = get_article(conn, year, month, day, slug)
		comments = conn.execute_fetch('select commenter, comment, tstamp from comments where entryid=%s order by tstamp', (articles[0][4],))
		nxt, prev = get_next_prv(conn, articles[0][2])
		return template('view/blog', articles=articles, comments=comments, comment_counts={}, single_post=True, next=nxt, previous=prev)

@route('/blog/draft/:slug')
def draft(slug):
	try:
		homedir = '/home/mrshoe'
		blogdir = os.path.join(homedir, '.blog')
		f = open(os.path.join(blogdir, slug))
		lines = f.readlines()
		title = lines[0].strip()
		published = lines[-1].strip().lower() == 'published'
		bodylines = lines[1:-1] if published else lines[1:]
		body = ''.join(bodylines)
		with db.db_conn(config.DATABASE_NAME) as conn:
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

@route('/blog/:year#[0-9]{4}#/:month#[0-9]{2}#/:day#[0-9]{2}#/:slug', 'POST')
def comment(year, month, day, slug):
	with db.db_conn(config.DATABASE_NAME) as conn:
		articles = get_article(conn, year, month, day, slug)
		if request.forms['jstest'] == 'valid':
			conn.execute("insert into comments values (default, %s, %s, %s, now() at time zone 'US/Pacific')", (articles[0][4], request.forms['commenter'].strip(), request.forms['comment'].strip()))
	redirect(request.path)

@route('/blog/index.xml')
def atomfeed():
	with db.db_conn(config.DATABASE_NAME) as conn:
		articles = conn.execute_fetch('select title, body, published, slug from entries where published is not null order by published desc limit 20')
		if not articles:
			abort(404, 'Not found')
		response.content_type = 'application/atom+xml'
		return template('view/atom', articles=articles)

@route('/blog/:year#[0-9]{4}#/:month#[0-9]{2}#/:filename')
def oldblog(year, month, filename):
	return template(os.path.join('static', 'oldblog', year, month, filename))

@route('/blog/upload', 'PUT')
@route('/blog/upload/:entryid#[0-9]+#', 'PUT')
def upload(entryid=None):
	if request.get_header('X-Maximal') != config.BLOG_PASSWORD:
		abort(403, 'Forbidden')
	title = request.json.get('title')
	body = request.json.get('body')
	slug = re.sub('\s+', '-', title.strip().lower())
	slug = re.sub('[^\w-]', '', slug)
	with db.db_conn(config.DATABASE_NAME) as conn:
		response.content_type = 'text/json'
		if entryid is None:
			inserted = conn.execute_fetchone('insert into entries values (default, %s, %s, now(), %s) returning id', (title, body, slug))
			return json.dumps({'id':inserted[0]})
		else:
			entryid = int(entryid)
			conn.execute('update entries set title=%s, body=%s, slug=%s where id=%s', (title, body, slug, entryid))
			return json.dumps({'id':entryid})

@route('/static/:path#.+#')
def static(path):
	return static_file(path, root='static')

@route('/favicon.ico')
def favicon():
	return static_file('favicon.ico', root='static')

debug(False)
run(host='0.0.0.0', port=config.PORT, reloader=False)
