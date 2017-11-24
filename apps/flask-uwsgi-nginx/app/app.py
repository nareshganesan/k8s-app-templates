import os, sys
from flask import Flask,request
from flask_cors import CORS

sys.path.append(os.path.join(os.path.dirname(__file__), 'lib'))
from DB import MySQL

sys.path.append(os.path.join(os.path.dirname(__file__), 'rest_api'))
from api import index

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


app.add_url_rule('/', view_func=index, methods=['GET','POST'])

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
