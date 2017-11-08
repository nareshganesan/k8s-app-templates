import os, sys
from flask import Flask,request
from flask_cors import CORS

sys.path.append(os.path.join(os.path.dirname(__file__), 'rest_api'))
from api import index

# Obtain the flask app object
app = Flask(__name__)
cors = CORS(app)


app.add_url_rule('/', view_func=index, methods=['GET','POST'])

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)