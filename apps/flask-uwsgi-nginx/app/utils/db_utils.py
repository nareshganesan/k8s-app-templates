from sqlalchemy.engine import ResultProxy, RowProxy

def result_proxy_to_list(result_proxy):
    
    rows = result_proxy
    result = []
    if isinstance(result_proxy, ResultProxy):
        print('isinstance: ResultProxy %s' % (str(isinstance(result_proxy, ResultProxy))) )
        print('query result_proxy data:')
        for row in rows:
            result_row = {}
            for col in row.keys():
                result_row[str(col)] = str(row[col])
            result.append(result_row)
            print("row: %s" % str(row) )
    else:
        print('isinstance: ResultProxy %s' % (str(isinstance(result_proxy, ResultProxy))) )
        print('query result_proxy data:')
        print(result_proxy)
        result_row = {}
        if rows:
            for col in rows.items():
                result_row[str(col[0])] = str(col[1])
            result.append(result_row)

    print("formatted result proxy: " )
    print(result )
    return result