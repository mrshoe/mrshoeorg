from bottle import debug, route, run, static_file, template, redirect, abort
import datetime
import psycopg2
import os

import util

db_cons = set()
def get_conn():
	if not db_cons:
		return psycopg2.connect(database='mrshoeblog')
	else:
		return db_cons.pop()

def put_conn(conn):
	db_cons.add(conn)

class db_conn(object):
	def execute(self, query, params=()):
		self.cur.execute(query, params)
	def execute_fetch(self, query, params=()):
		self.cur.execute(query, params)
		return self.cur.fetchall()

	def __enter__(self):
		self.conn = get_conn()
		self.cur = self.conn.cursor()
		return self
	
	def __exit__(self, type, value, traceback):
		if type is None:
			self.conn.commit()
		self.cur.close()
		self.conn.rollback()
		put_conn(self.conn)

@route('/')
def home():
	return redirect('/blog')

@route('/blog')
@route('/blog/')
def blog():
	with db_conn() as conn:
		articles = conn.execute_fetch('select title, body, published from entries where published is not null order by published desc limit 5')
		if not articles:
			abort(404, 'Not found')
		return template('view/blog', articles=articles, util=util)

@route('/blog/:year#[0-9]{4}#/:month#[0-9]{2}#/:day#[0-9]{2}#/:slug')
def article(year, month, day, slug):
	with db_conn() as conn:
		articles = conn.execute_fetch('select title, body, published from entries where published is not null and slug=%s', (slug,))
		if not articles:
			abort(404, 'Not found')
		return template('view/blog', articles=articles, util=util)

@route('/blog/draft/:slug')
def draft(slug):
	try:
		homedir = os.environ.get('HOME', '/tmp')
		blogdir = os.path.join(homedir, '.blog')
		f = open(os.path.join(blogdir, slug))
		lines = f.readlines()
		title = lines[0].strip()
		published = lines[-1].strip().lower() == 'published'
		bodylines = lines[1:-1] if published else lines[1:]
		body = ''.join(bodylines)
		with db_conn() as conn:
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
			return template('view/blog', articles=[(title, body, datetime.datetime.now())], util=util)
	except IOError:
		abort(404, 'No such entry')

@route('/static/:path#.+#')
def static(path):
	return static_file(path, root='static')

debug(True)
run(host='0.0.0.0', port=8088, reloader=True)
