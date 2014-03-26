# Makefile -- resonate2014

WEBAPP     = $(wildcard webapp.py)

run:
	. `pwd`/.env ; python $(WEBAPP)

install:
	virtualenv venv --no-site-packages --distribute --prompt=resonate2014
	. `pwd`/.env ; pip install -r requirements.txt

freeze:
	-rm build -r
	. `pwd`/.env ; python -c "from webapp import app; from flask_frozen import Freezer; freezer = Freezer(app); freezer.freeze()"
	-rm build/static/.webassets-cache/ -r
	sed -i 's/\/static/static/g' build/index.html

# EOF
