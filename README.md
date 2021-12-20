# `minectl` - Simple Minecraft Server Management

This tool makes it very easy to run and manage multiple minecraft servers.
It uses tmux to run and provide shell access to the game servers.

## Installation

```shell
chmod +x minectl.sh
bash minectl.sh init
```

## Documentation

### File Structure

The general file structure will look something like this:
```
minectl
    lib
        servers
            paper-1.17.1.jar
            velocity-3.0.0.jar
        plugins
            plugin1.jar
            plugin2.jar
    path
    scripts
    servers
        minecraft
            (server1)
                server.jar -> lib/servers/...
                start.sh
            (server2)
                server.jar -> lib/servers/...
                start.sh
            (...)
        proxies
            (proxy1)
                server.jar -> lib/servers/...
                start.sh
            (...)
    server-list.txt
```

The `scripts` and `path` directories contain the files minectl needs to run,
you don't need to change them.

Inside the `servers` directory, you will find places to put your game server and proxy files. I strongly suggest using PaperMC and Velocity servers, since they perform best and the start scrips work best with them.

`lib` contains symlinked server and plugin JARs. The server JARs are downloaded automatically, the plugin JARs have to be downloaded by hand

### Commands

#### `minectl start`

Creates tmux sessions and runs `start.sh` for all servers in `server-list.txt` and `proxy-list.txt`

#### `minectl restart`

Sends CTRL-C to all sessions listed in `server-list.txt` and `proxy-list.txt`. Since the start scripts are configured to always restart when stopped, all servers should come back online.
Afterwards, please check with `minectl list` if all sessions are up and running.

#### `minectl list`

Lists all session in `server-list.txt` and `proxy-list.txt` and perfomes three checks:
1. server folder exists
2. tmux session is running
3. the configured port is reachable

#### `minectl generate`

Generate new proxy or server with a start script and link the current server jar.

#### `minectl pull`

Pull all latest server jars for configured versions.
Only run this while all servers are stopped!

#### `minectl killall`

Sends a SIGHUP signal to all sessions (which in our specific case should stop the minecraft server gracefully). Since the behaviour of `tmux kill-session` and the `SIGHUP` is not consistent, I do not recommend using this but rather stopping all servers manually. 

### Autostart

Open `crontab -e` and insert the following line:
```
@reboot /bin/bash /path/to/minectl.sh start
```

You can use different methods of starting the script on boot but this should be the easiest. on boot but this should be the easiest.