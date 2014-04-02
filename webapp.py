#!/usr/bin/env python
# Encoding: utf-8
# -----------------------------------------------------------------------------
# Project : Resonate 2014
# -----------------------------------------------------------------------------
# Author : Edouard Richard                                  <edou4rd@gmail.com>
# -----------------------------------------------------------------------------
# License : GNU Lesser General Public License
# -----------------------------------------------------------------------------
# Creation : 26-Mar-2014
# Last mod : 31-Mar-2014
# -----------------------------------------------------------------------------
from flask import Flask, render_template, request, send_file, g, \
	send_from_directory, Response, abort, session, redirect, url_for, make_response
from flask.ext.assets import Environment, YAMLLoader
from flask.ext.babel import Babel

# app
app = Flask(__name__)
app.config.from_pyfile("settings.cfg")
# i18n
babel = Babel(app)
# assets
assets  = Environment(app)
bundles = YAMLLoader("assets.yaml").load_bundles()
assets.register(bundles)

# -----------------------------------------------------------------------------
#
# Site pages
#
# -----------------------------------------------------------------------------
@app.route('/')
def index():
	response = make_response(render_template('home.html'))
	return response

@app.route('/fr.html')
def page_fr():
	g.language = "fr"
	return make_response(render_template('home.html'))
	return index()

@app.route('/de.html')
def page_de():
	g.language = "de"
	return index()

# -----------------------------------------------------------------------------
#
#    UTILS
#
# -----------------------------------------------------------------------------
@babel.localeselector
def get_locale():
	# try to guess the language from the user accept
	# header the browser transmits.
	if not g.get("language"):
		g.language = request.accept_languages.best_match(['fr', 'de'])
	return g.get("language")

# -----------------------------------------------------------------------------
#
# Main
#
# -----------------------------------------------------------------------------
if __name__ == '__main__':
	# run application
	app.run(extra_files=("assets.yaml",), host="0.0.0.0")

# EOF
