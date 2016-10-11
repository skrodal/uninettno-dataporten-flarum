
# Flarum & Dataporten Docker Image

The image features PHP/Nginx/Flarum, with:

- The [Dataporten extension] (https://packagist.org/packages/uninett/flarum-ext-auth-dataporten), which allows users to login using Dataporten from UNINETT
- [Norwegian translation extension](https://packagist.org/packages/pladask/flarum-ext-norwegian-bokmal)
- Command-line installation of Flarum with YAML config file (see below) 
- No need to create DB ahead of time (the config file takes care of that)
- OR run a container with ENVs pointing to an existing Flarum (DB) installation

Note 1: Built to work with Flarum `v0.1.0-beta.5`.
Note 2: By design, the image does not come with MySQL installed - it should use an external DBMS.
Note 3: Although the image is adapted to suit higher education in Norway, the workflow (and Dataporten OAuth extension) may be useful to others wanting to create something similar.

## Installation

Grab the image from Docker Hub: `docker pull uninettno/dataporten-flarum` (alt. you can build the image from this repo).

Note that, while Flarum is contained within the image, it has not been installed (i.e. configured).

### To run a fresh install of Flarum

Run a new container:

> docker run -d -p 80:80 --name flarum uninettno/dataporten-flarum

To install Flarum, you have a few choices:

1. Enter config in Flarum's web ui, or
2. Enter config in terminal:
    - `php flarum install -d` for prompts
    - `php flarum install -f filename` to use a config file (see sample below)

#### Sample config

Sample below if you would like to install Flarum using a config.yml file:

```yaml
baseUrl : "http://127.0.0.1/path_to_flarum/"
databaseConfiguration :
    host : "localhost"
    database : "flarum_database_name"
    prefix: "flarum_table_name_prefix_"
    username : "username"
    password : "password"
adminUser : 
    username : "adminuser"
    password : "adminpassword"
    password_confirmation : "adminpassword"
    email : "admin@email.com"
settings : 
    forum_title           : "Flarum Site Title"
    welcome_title         : "Welcome title"
    welcome_message       : "Welcome message"
    uninett-auth-dataporten.client_id     : "___optional___"
    uninett-auth-dataporten.client_secret : "___optional____"
    mail_from             : "noreply@flarum.dev"
    default_locale        : "no"
    theme_colored_header  : 1
    theme_primary_color   : "#ed1b34"
    theme_secondary_color : "#010777"
```

- The section `adminUser` defines Flarum's administrator account.
- Use section `settings` to change some of Flarum's defaults. Here, you may also enter your client's `Dataporten` OAuth ID and Secret (if you have already registered your client with Dataporten).

Once installation is complete, Flarum will generate `config.php` with DB settings and push other settings that DB.

### To reuse an existing Flarum DB:

If you already have a Flarum DB populated with tables, settings, users, posts, etc., you may run a new container as follows, using ENVs (fill in the blanks):

> docker run -d -p 80:80 -e DB_HOST=_______ -e DB_NAME=_______ -e DB_USER=_______ -e DB_PASS=_______ -e DB_PREFIX=_______ -e SITE_URL=_______ --name flarum uninettno/dataporten-flarum

_Of course, it is imperative that the ENV vars you enter are according to an existing Flarum DB._

The container can now access the ENV vars you passed in. The image includes an ENV-enabled Flarum config.php for this scenario. To activate it, run the following command:

> docker exec -d flarum mv /app/config.php_ /app/config.php

Done :)

## Dataporten login

Go to the URL of your Flarum installation and log in as admin with the admin credentials:

- Menu `Admin->Administration`
- Page `Extensions`
- Enable extension Dataporten (and optionally Norwegian translation extension)
    - Double-check that the Client ID and Client Secret are entered in the extension's Settings
- Log out and back in again - notice that Dataporten Login now is an option in the login window :)

The redirect URI for your client should be the URI to your Flarum site, plus `/auth/dataporten`.

More info about Dataporten in the [Dataporten extension readme on GitHub](https://github.com/skrodal/flarum-ext-auth-dataporten).


## Useful Docker commands

Stop [and remove] the container:
    
> docker stop flarum [&& docker rm flarum]

Start a stopped container named 'flarum':
    
> docker start flarum

Enter the running container:
    
> docker exec -ti flarum bash

Change terminal (e.g. to fix Nano)

> export TERM=xterm