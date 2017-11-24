import datetime
import socket
from flask import jsonify, request

def resp_dict(status, msg, additional_msg=None):
    status_dict = {
        "status": status,
        "message": msg
    }
    if additional_msg is not None:
        status_dict.update(additional_msg)
    return status_dict

def index():
    user = request.values.get("user", "anonymous") 
    app = "flask"
    hostname = socket.gethostname()
    return jsonify(resp_dict("OK", 
        "Greetings %s! \n This is a %s template bundled with uwsgi reverse proxied behind nginx.(host: %s)" % (user, app, hostname), 
        {"code": 200}))

def create_message():
    message = request.values.get("msg", "")
    
