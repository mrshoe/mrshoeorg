import datetime
import pytz

pacific = pytz.timezone('US/Pacific')

def timezonefix(dt):
	return pytz.utc.localize(dt).astimezone(pacific)

def datefmt(dt):
	if dt.year == datetime.datetime.now().year:
		return dt.strftime('%d %b')
	else:
		return dt.strftime('%d %b, %Y')

def timefmt(dt):
	if dt.year == datetime.datetime.now().year:
		return dt.strftime('%a, %b %d, %I:%M %p')
	else:
		return dt.strftime('%a, %b %d, %Y, %I:%M %p')

def dateurl(dt):
	return dt.strftime('%Y/%m/%d')

def zulutime(dt):
	return dt.strftime('%Y-%m-%dT%H:%M:%SZ')

def copyyear():
	return datetime.datetime.now().year
