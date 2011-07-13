import datetime

def datefmt(dt):
	dt = dt - datetime.timedelta(hours=7)
	if dt.year == datetime.datetime.now().year:
		return dt.strftime('%d %b')
	else:
		return dt.strftime('%d %b, %Y')

