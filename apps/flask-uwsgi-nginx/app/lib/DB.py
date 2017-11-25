import os, sys
import traceback
import threading
import MySQLdb

import sqlalchemy.pool as pool
from sqlalchemy import create_engine
from sqlalchemy.schema import MetaData, Table
from sqlalchemy.engine.url import make_url


class DB(object):
    __singleton_lock = threading.Lock()
    __singleton_instance = None

    def __new__(cls, *args, **kwargs):
        if cls.__singleton_instance is None:
            with cls.__singleton_lock:
                if cls.__singleton_instance is None:
                    cls.__singleton_instance =  super(DB, cls).__new__(cls, *args, **kwargs)
        return cls.__singleton_instance


class MySQL(DB):
    """
    All transactions are autocommit
    isolation level: SERIALIZABLE
    Ref: https://dev.mysql.com/doc/refman/5.7/en/innodb-transaction-isolation-levels.html#isolevel_serializable
    """  
    def __init__(self, arg, db_url):  
        """ 
        Initialise MySQL sqlalchemy engine 
        """  
        self.mysql_reference = arg
        self.db_url = db_url
        self.app_pool = self._create_pool()
        self.engine = self._create_engine()
        self.metadata = self._create_metadata()
        # get list of table names from a config
        self.tables = self._get_models()
        return 

    def __str__(self): return self.mysql_reference


    def _create_connection(self):
        url = make_url(self.db_url)
        conn = MySQLdb.connect(host=url.host,user=url.username,passwd=url.password,db=url.database)
        return conn

    def _create_pool(self):
        tmp_pool = pool.QueuePool(
                    self._create_connection,
                    max_overflow=10,
                    pool_size=15)
        return tmp_pool

    def _create_engine(self):
        engine = create_engine(
                self.db_url,  
                pool = self.app_pool,
                echo=False,
                connect_args = {
                    'pool_recycle': 300 # Should be less them MySQL WAIT_TIMEOUT
                }
            )
        return engine

    def _create_metadata(self):
        return MetaData(bind=self.engine)

    def _load_tables(self):
        # loads all db tables in sqlalchemy table base classes.
        metadata = MetaData()
        metadata.reflect(bind=self.engine, only=self.table_names, extend_existing=False, autoload_replace=True)
        tables = {}
        for index, key in enumerate(self.table_names, start=1):
            tables[key] = metadata.tables[key]
        return tables

    def _get_models(self):
        # loads all db tables in sqlalchemy table base classes.
        tables = {}
        message = Table('message', self.metadata, autoload=True)

        tables["message"] = message
        return tables        

    def fetchone(self, query, params=None):  
        """ 
        Fetchs one row 
        """ 
        data = None
        print 'query: %s' % query
        print 'params: %s' % str(params)
        try:
            cnx = self.app_pool.connect()
            cnx.autocommit = True
            cur = cnx.cursor()
            query = MySQLdb.escape_string(query)
            cur.execute(query, params if params else None)
            data = cur.fetchone()
            print data
            cnx.commit()
            cur.close()
            cnx.close()  
            return data
        except MySQLdb.OperationalError as ex:  
            print ex            
            return data

    def fetchall(self, query, params=None):  
        """ 
        Fetchs all the rows 
        """ 
        data = None
        print 'query: %s' % query
        print 'params: %s' % str(params)
        try:
            cnx = self.app_pool.connect()
            cnx.autocommit = True
            cur = cnx.cursor()
            query = MySQLdb.escape_string(query)
            cur.execute(query, params if params else None)
            data = cur.fetchall()
            count = cur.rowcount
            print data
            cnx.commit()
            cur.close()
            cnx.close()  
            return {
                "data" : data,
                "count": count
                }

        except MySQLdb.OperationalError as ex: 
            print ex            
            return data

    def execute(self, query, params=None):  
        """ 
        Executes query for create, insert, update, delete 
        returns lastrowid of (autoincremented) INSERT or UPDATE statement or None when there is no such value available
        """
        data = None
        print 'query: %s' % query
        print 'params: %s' % str(params)
        try:
            cnx = self.app_pool.connect()
            cur = cnx.cursor()
            query = MySQLdb.escape_string(query)
            cur.execute(query, params if params else None)
            lastrowid = cur.lastrowid
            print lastrowid
            cnx.commit()
            cur.close()
            cnx.close()  
            return {
                "data" : data,
                "lastrowid": lastrowid
                }
        except MySQLdb.OperationalError as ex:
            print ex            
            return data    
