[![logo](https://raw.githubusercontent.com/dperson/gogs/master/logo.png)](http://gogs.io/)

# Gogs (Go Git Service)

Gogs docker container

# What is Gogs?

Gogs (Go Git Service) is a painless self-hosted Git service. The goal of this
project is to make the easiest, fastest, and most painless way to set up a
self-hosted Git service. With Go, this can be done via an independent binary
distribution across ALL platforms that Go supports, including Linux, Mac OS X,
and Windows.

# How to use this image

Once it's up connect to configure Gogs.

## Hosting a Gogs instance

    sudo docker run -p 80:3000 -p 2222:2222 -d dperson/gogs

OR set local storage:

    sudo docker run --name gogs -p 80:3000 -p 2222:2222 \
                -v /path/to/directory:/mount \
                -d dperson/gogs

## Configuration

    sudo docker run -it --rm dperson/gogs -h
    Usage: gogs.sh [-opt] [command]
    Options (fields in '[]' are optional, '<>' are required):
        -h          This help
        -t ""       Configure timezone
                    possible arg: "[timezone]" - zoneinfo timezone for container

    The 'command' (if provided and valid) will be run instead of gogs

ENVIRONMENT VARIABLES (only available with `docker run`)

 * `TZ` - As above, configure the zoneinfo timezone, IE `EST5EDT`
 * `USERID` - Set the UID for the app user
 * `GROUPID` - Set the GID for the app user

## Examples

### Start an instance and set the timezone:

Any of the commands can be run at creation with `docker run` or later with
`docker exec gogs.sh` (as of version 1.3 of docker).

### Setting the Timezone

    sudo docker run -p 139:139 -p 445:445 -d dperson/gogs -t EST5EDT

OR using `environment variables`

    sudo docker run -p 139:139 -p 445:445 -e TZ=EST5EDT -d dperson/gogs

Will get you the same settings as

    sudo docker run --name gogs -p 139:139 -p 445:445 -d dperson/gogs
    sudo docker exec gogs gogs.sh -t EST5EDT ls -AlF /etc/localtime
    sudo docker restart gogs

# User Feedback

## Issues

If you have any problems with or questions about this image, please contact me
through a [GitHub issue](https://github.com/dperson/gogs/issues).
