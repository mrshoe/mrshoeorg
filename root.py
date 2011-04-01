from bottle import route, run, template

@route('/')
def home():
	return template('view/home.tmpl')

run(host='0.0.0.0', port=8080, reloader=True)
