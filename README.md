# docker-tvnamer

Dockerfile for creating a tiny [tvnamer](https://github.com/dbr/tvnamer) container.

[tvnamer](https://github.com/dbr/tvnamer) - Automatic TV episode file renamer, uses data from thetvdb.com via tvdb_api

## Usage
`docker run -it -e PUID=<UID> -e PGID=<GID> -v <path/to/tv/directory>:/tv lewazo/tvnamer tvnamer [additional tvnamer arguments]`

## Examples
`docker run -it -e PUID=99 -e PGID=100 -v /appdata/tvnamer:/config -v /media/tv:/tv lewazo/tvnamer tvnamer -r /tv/Dexter`
What this does is start a new tvnamer container, assign the appropriate UID and GID and rename all files inside `/Volumes/media/tv/Dexter` based on the formats in the config file.

tvnamer is an interactive tool, hence the `-it` flag. This container isn't made for automation purposes.

## Docker-compose
Alternatively, you can use `docker-compose` to start the container. Here is a sample config file.
```
tvnamer:
  image: lewazo/tvnamer
  volumes:
    - /media/tv:/tv
    - /appdata/tvnamer:/config
  environment:
    - PUID=6577
    - PGID=6577
  command: /bin/bash

```
Simply run `docker-compose run tvnamer`. You will enter into the container's shell. From there, simply run the `tvnamer` command with any of the usual arguments. Once you are done with the renaming, simplt `exit` out of the container. It will automatically shutdown.

## Parameters
  * `-v /tv` - The directory used for storing your tv shows | required
  * `-v /config` - The directory used for storing tvnamer's config files | required
  * `-e PUID` - Your user's UID on the host | optional
  * `-e PGID` - You user's GID on the host | optional

## Configuration
When the container is created, a `.tvnamer.json` file will be created in the location specified for
the `/config` volume. Refer to the [tvnamer documentation](https://github.com/dbr/tvnamer) for all the config settings.

## About PUID and PGID
By default, Docker runs the container as the user `root`. Since your files stored on the host are most likely not owned by `root`, you may find yourself with permissions issues when tvnamer renames the files.

To avoid that, you can specify the UID and GID you want the container to run with. You should set those variables to those of the files owner.
