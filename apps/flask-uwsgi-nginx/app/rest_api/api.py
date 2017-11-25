import os, sys
import datetime
import socket
from flask import current_app
from flask import jsonify, request
from sqlalchemy import insert, select, update, delete

sys.path.append(os.path.join(os.path.dirname(__file__), '..', 'utils'))
from utility import resp_dict
from db_utils import result_proxy_to_list

def index():
    user = request.values.get("user", "anonymous") 
    app = "flask"
    hostname = socket.gethostname()
    return jsonify(resp_dict("OK", 
        "Greetings %s! \n This is a %s template bundled with uwsgi reverse proxied behind nginx.(host: %s)" % (user, app, hostname), 
        {"code": 200}))

def create_message():
    msg = str(request.values.get("msg", ""))
    if msg is not "":
        mysql_db = current_app.config["db"]
        message = mysql_db.tables["message"]
        query = str(insert(message).values(name=msg))
        params = (msg,)
        resp = mysql_db.execute(query, params)
        if resp is None or not resp:
            return jsonify(resp_dict(
                    "error", "message could not be created"
                ))
        return jsonify(resp_dict(
                "OK", "message inserted", resp
            ))
    else:
        return jsonify(resp_dict(
                "error", "msg parameter cannot be empty or null"
            ))

def view_message(id):
    id = "" if id is None else id
    if id == "":
        return jsonify(resp_dict(
                "error", "id parameter cannot be empty or null"
            ))
    else:
        mysql_db = current_app.config["db"]
        message = mysql_db.tables["message"]
        resp = message.select().where(message.c.id == int(id)).execute()
        resp = result_proxy_to_list(resp)        
        if resp is None or not resp:
            return jsonify(resp_dict(
                    "error", "message not found"
                ))        
        return jsonify(resp_dict(
                "OK", "message found for id %s" % id, {"data": resp}
            ))

def update_message(id):
    id = "" if id is None else id
    msg = str(request.values.get("msg", ""))
    if id == "":
        return jsonify(resp_dict(
                "error", "id parameter cannot be empty or null"
            ))
    else:
        mysql_db = current_app.config["db"]
        message = mysql_db.tables["message"]
        query = str(update(message).where(message.c.id == id).values(name=msg))
        params = (msg, id,)
        resp = mysql_db.execute(query, params)
        if resp is None:
            return jsonify(resp_dict(
                "error", "Internal error"
                ))
        return jsonify(resp_dict(
                "OK", "message id %s updated" % id
            ))

def delete_message(id):
    id = "" if id is None else id
    if id == "":
        return jsonify(resp_dict(
                "error", "id parameter cannot be empty or null"
            ))
    else:
        mysql_db = current_app.config["db"]
        message = mysql_db.tables["message"]
        query = str(delete(message).where(message.c.id == id))
        params = (id,)
        resp = mysql_db.execute(query, params)
        if resp is None:
            return jsonify(resp_dict(
                "error", "Internal error"
                ))
        return jsonify(resp_dict(
                "OK", "message id %s deleted" % id
            ))

def list_message():
    search = str(request.values.get("search", ""))
    mysql_db = current_app.config["db"]
    message = mysql_db.tables["message"]
    if search is not "" and search is not None:
        resp = message.select().where(message.c.name.contains(search)).execute()
    else:
        resp = message.select().execute()
    resp = result_proxy_to_list(resp)        
    if resp is None or not resp:
        return jsonify(resp_dict(
                "error", "message not found"
            ))        
    return jsonify(resp_dict(
            "OK", "message found for id %s" % id, {"data": resp}
        ))
