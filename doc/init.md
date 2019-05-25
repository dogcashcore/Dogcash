Sample init scripts and service configuration for dogcashd
==========================================================

Sample scripts and configuration files for systemd, Upstart and OpenRC
can be found in the contrib/init folder.

    contrib/init/dogcashd.service:    systemd service unit configuration
    contrib/init/dogcashd.openrc:     OpenRC compatible SysV style init script
    contrib/init/dogcashd.openrcconf: OpenRC conf.d file
    contrib/init/dogcashd.conf:       Upstart service configuration file
    contrib/init/dogcashd.init:       CentOS compatible SysV style init script

Service User
---------------------------------

All three Linux startup configurations assume the existence of a "dogcash" user
and group.  They must be created before attempting to use these scripts.
The OS X configuration assumes dogcashd will be set up for the current user.

Configuration
---------------------------------

At a bare minimum, dogcashd requires that the rpcpassword setting be set
when running as a daemon.  If the configuration file does not exist or this
setting is not set, dogcashd will shutdown promptly after startup.

This password does not have to be remembered or typed as it is mostly used
as a fixed token that dogcashd and client programs read from the configuration
file, however it is recommended that a strong and secure password be used
as this password is security critical to securing the wallet should the
wallet be enabled.

If dogcashd is run with the "-server" flag (set by default), and no rpcpassword is set,
it will use a special cookie file for authentication. The cookie is generated with random
content when the daemon starts, and deleted when it exits. Read access to this file
controls who can access it through RPC.

By default the cookie is stored in the data directory, but it's location can be overridden
with the option '-rpccookiefile'.

This allows for running dogcashd without having to do any manual configuration.

`conf`, `pid`, and `wallet` accept relative paths which are interpreted as
relative to the data directory. `wallet` *only* supports relative paths.

For an example configuration file that describes the configuration settings,
see `contrib/debian/examples/dogcash.conf`.

Paths
---------------------------------

### Linux

All three configurations assume several paths that might need to be adjusted.

Binary:              `/usr/bin/dogcashd`  
Configuration file:  `/etc/dogcash/dogcash.conf`  
Data directory:      `/var/lib/dogcashd`  
PID file:            `/var/run/dogcashd/dogcashd.pid` (OpenRC and Upstart) or `/var/lib/dogcashd/dogcashd.pid` (systemd)  
Lock file:           `/var/lock/subsys/dogcashd` (CentOS)  

The configuration file, PID directory (if applicable) and data directory
should all be owned by the dogcash user and group.  It is advised for security
reasons to make the configuration file and data directory only readable by the
dogcash user and group.  Access to dogcash-cli and other dogcashd rpc clients
can then be controlled by group membership.

### Mac OS X

Binary:              `/usr/local/bin/dogcashd`  
Configuration file:  `~/Library/Application Support/DogCash/dogcash.conf`  
Data directory:      `~/Library/Application Support/DogCash`  
Lock file:           `~/Library/Application Support/DogCash/.lock`  

Installing Service Configuration
-----------------------------------

### systemd

Installing this .service file consists of just copying it to
/usr/lib/systemd/system directory, followed by the command
`systemctl daemon-reload` in order to update running systemd configuration.

To test, run `systemctl start dogcashd` and to enable for system startup run
`systemctl enable dogcashd`

### OpenRC

Rename dogcashd.openrc to dogcashd and drop it in /etc/init.d.  Double
check ownership and permissions and make it executable.  Test it with
`/etc/init.d/dogcashd start` and configure it to run on startup with
`rc-update add dogcashd`

### Upstart (for Debian/Ubuntu based distributions)

Drop dogcashd.conf in /etc/init.  Test by running `service dogcashd start`
it will automatically start on reboot.

NOTE: This script is incompatible with CentOS 5 and Amazon Linux 2014 as they
use old versions of Upstart and do not supply the start-stop-daemon utility.

### CentOS

Copy dogcashd.init to /etc/init.d/dogcashd. Test by running `service dogcashd start`.

Using this script, you can adjust the path and flags to the dogcashd program by
setting the PRODUCTIONCHAIND and FLAGS environment variables in the file
/etc/sysconfig/dogcashd. You can also use the DAEMONOPTS environment variable here.

### Mac OS X

Copy org.dogcash.dogcashd.plist into ~/Library/LaunchAgents. Load the launch agent by
running `launchctl load ~/Library/LaunchAgents/org.dogcash.dogcashd.plist`.

This Launch Agent will cause dogcashd to start whenever the user logs in.

NOTE: This approach is intended for those wanting to run dogcashd as the current user.
You will need to modify org.dogcash.dogcashd.plist if you intend to use it as a
Launch Daemon with a dedicated dogcash user.

Auto-respawn
-----------------------------------

Auto respawning is currently only configured for Upstart and systemd.
Reasonable defaults have been chosen but YMMV.
