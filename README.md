# isucon-tools
- Makefile

First to run `make install-essentials` to install some essential tools and configure some `/etc` files to be done every server.


- isulog

Daring but convenient tool to run commands for gathering metrics and helping to deploy an app.

`isulog lotate` Refresh application logs and restart for next benchmarking jobs.

`isulog profile` Run commands in parallel set by `-t` option, and notifying to Discord using discocat.

`isulog install/uninstall` Install/Uninstall this command to/from a `--prefix` directory.

```
%  isulog -h
Usage:
        isulog -h | --help
        isulog lotate [--services=<n>...] [--nginx <log>] [--envoy <log>] [--mysql <log>] [--h2o <log>] [--no_restart] [--dry-run]
        isulog profile [--profiling_tools <n>...] [--bot <n>] [--url_pprof <n> | --port_pprof <n>] [--nginx <log> | --envoy <log> | --h2o <log>] [--work_dir <n>] [--dry-run]
        isulog install [--prefix <n>]
        isulog uninstall [--prefix <n>]

        Options:
            --mysql=<log>               MySQL slow.log. [default: /var/log/mysql/slow.log]
            --nginx=<log>               Nginx access.log. [default: /var/log/nginx/access.log]
            --envoy=<log>               Envoy access.log. [default: /var/log/envoy/access.log]
            --h2o=<log>                 h2o access.log. [default: /var/log/h2o/access.log]
            --no_restart                Do not restart Service.
            --prefix=<n>                Directory to install. [default: /usr/local/bin]
            --url_pprof=<n>             Golang pprof endpoint url. [default: http://localhost:1323/debug/pprof/profile]
            --work_dir=<n>              Working directory for tmp files. [default: /tmp]
            -b --bot=<n>                Bot name used by discocat. See discocat.yml fot details. [default: default]
            -h --help                   Show This screen.
            -n --dry-run                Dry run.
            -p --port_pprof=<n>         Golang pprof endpoint port. [http://localhost:%PORT%/debug/pprof/profile]
            -s --services=<n>           Services. [default: nginx envoy h2o mysql]
                                        e.g. % isulog lotate -s nginx -s mysql --dry-run
            -t --profiling_tools=<n>    Profiling tools to run. [default: load_sets]
                                        All available tools:  [ 'dstat', 'iostat', 'slow', 'mpstat', 'vmstat', 'iotop',
                                                                'sartcp', 'dmesg', 'kataribe', 'pprof', 'iftop', 'sardev', 'pidstat' ]
                                        All available tool-sets: [load_sets].
                                        If you want to run tools simultaneously that needs to run durning a load on your app.
                                        e.g. % isulog profile -t pprof -t iftop -t iotop -t dstat -p 3939 --dry-run
                                        If you want to run tools (pprof, kataribe are excluded) simultaneously,
                                        you can specify load_sets instead of specifying all tools separately.
                                        e.g. % isulog profile -t load_sets -p 3939 --dry-run



```

- others ...