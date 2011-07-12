from bottle import debug, route, run, static_file, template

@route('/')
def home():
	return template('view/home.tmpl')

@route('/static/:path#.+#')
def static(path):
	return static_file(path, root='/home/mrshoe/dev/mrshoeorg/static')

debug(True)
run(host='0.0.0.0', port=8088, reloader=True)
