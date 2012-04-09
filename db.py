import psycopg2

db_pools = {}
def get_conn(dbname):
	db_cons = db_pools.setdefault(dbname, set())
	if not db_cons:
		return psycopg2.connect(database=dbname)
	else:
		return db_cons.pop()

def put_conn(dbname, conn):
	db_cons = db_pools.setdefault(dbname, set())
	db_cons.add(conn)

class db_conn(object):
	def execute(self, query, params=()):
		self.cur.execute(query, params)
	def execute_fetch(self, query, params=()):
		self.cur.execute(query, params)
		return self.cur.fetchall()
	def execute_fetchone(self, query, params=()):
		self.cur.execute(query, params)
		result = self.cur.fetchall()
		if result:
			return result[0]

	def __init__(self, dbname):
		self.dbname = dbname

	def __enter__(self):
		self.conn = get_conn(self.dbname)
		self.cur = self.conn.cursor()
		return self
	
	def __exit__(self, type, value, traceback):
		if type is None:
			self.conn.commit()
		self.cur.close()
		self.conn.rollback()
		put_conn(self.dbname, self.conn)
