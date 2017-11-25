import os, sys
from werkzeug.exceptions import default_exceptions
from flask import Flask, jsonify, request
from flask_cors import CORS

sys.path.append(os.path.join(os.path.dirname(__file__), 'lib'))
from DB import MySQL

sys.path.append(os.path.join(os.path.dirname(__file__), 'rest_api'))
from api import index, create_message, view_message, update_message, delete_message, list_message

# Obtain the flask app object
app = Flask(__name__)
cors = CORS(app)


# load db url parameters
env = 'dev' # should be read from env variable from kubernetes api
host = os.environ["MYSQL_HOST"]
port = os.environ["MYSQL_PORT"]
user_name = os.environ["MYSQL_USER"]
password = os.environ["MYSQL_PASSWORD"]
db_name = os.environ["MYSQL_DATABASE"]
db_driver = "mysql"


db_url = "%s://%s:%s@%s:%s/%s" % (db_driver, user_name, password, host, port, db_name)
app.config['db_url'] = db_url

# get list of db tables to load
app_name = "flaskapp"
db_message = "Connecting to %s app MySQL db" % app_name
mysql_db = MySQL(db_message, db_url)
app.config["db"] = mysql_db


def _handle_http_exception(error):
    return jsonify({
        'status': error.code,
        'message': error.description,
        'description': str(error)
    }), error.code


# custom http error handlers
for code in default_exceptions:
    app.errorhandler(code)(_handle_http_exception)



app.add_url_rule('/', view_func=index, methods=['GET','POST'])
app.add_url_rule('/msg', view_func=create_message, methods=['POST'])
app.add_url_rule('/msg/<int:id>', view_func=view_message, methods=['GET'])
app.add_url_rule('/msg/<int:id>', view_func=update_message, methods=['PUT'])
app.add_url_rule('/msg/<int:id>', view_func=delete_message, methods=['DELETE'])
app.add_url_rule('/msg', view_func=list_message, methods=['GET'])



if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
