def resp_dict(status, msg, additional_msg=None):
    status_dict = {
        "status": status,
        "message": msg
    }
    if additional_msg is not None:
        status_dict.update(additional_msg)
    return status_dict