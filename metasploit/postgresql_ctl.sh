#!/bin/bash
#usage: ./postgresql_ctl.sh {start|stop|restart|status}
pg_ctl -D /var/lib/postgresql $1
