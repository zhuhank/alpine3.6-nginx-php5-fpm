#!/bin/sh
crond&&supervisord -n -c /etc/supervisord.conf

