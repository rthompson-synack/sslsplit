#!/bin/sh

hostname >  /sys/fs/cgroup/net_cls/net_cls.classid

exec sslsplit "$@"
