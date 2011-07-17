import datetime

def timezonefix(dt):
	return dt - datetime.timedelta(hours=7)

def datefmt(dt):
	if dt.year == datetime.datetime.now().year:
		return dt.strftime('%d %b')
	else:
		return dt.strftime('%d %b, %Y')

def dateurl(dt):
	return dt.strftime('%Y/%m/%d')
