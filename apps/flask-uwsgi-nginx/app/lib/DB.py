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
        self.greenie_pool = self._create_pool()
        self.engine = self._create_engine()
        self.metadata = self._create_metadata()
        # get list of table names from a config
        self.tables = self._get_models()
        logger.greenie_flask_logger().info(self.mysql_reference)
        return 

    def __str__(self): return self.mysql_reference


    def _create_native_connection(self):
        url = make_url(self.db_url)
        conn = MySQLdb.connect(host=url.host,user=url.username,passwd=url.password,db=url.database)
        return conn

    def _create_pool(self):
        greenie_pool = pool.QueuePool(
                    self._create_native_connection,
                    max_overflow=10,
                    pool_size=15)
        return greenie_pool

    def _create_engine(self):
        engine = create_engine(
                self.db_url,  
                pool = self.greenie_pool,
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

        tables["message"] = users
        return tables        


