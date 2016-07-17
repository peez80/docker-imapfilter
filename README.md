# docker-imapfilter

Docker container running imapfilter based on alpine linux to have the smallest footprint possible.
Imapfilter is built from the current git sources so it's guaranteed to have the newest version possible always. Apt and APK for example don't have the most recent versions.

Imapfilter is a tool to filter mails in remote IMAP servers. This containers generally has imapfilter installed and
additionally a default config script to ease up configuration.

config.lua
----------
Imapfilter is entirely configured using a LUA script. You could write your own from scratch or use the template that's shipped with this image.
This image contains the file *config_template.lua* that can be used for easy setup. You just need to set some variables, all other magic is already done
by the script.

The script is intended to filter one or more source directories and move the found messages to a target directory. I use this script in addition to my
mail provider's spam filter because the possibilities there are not so good in my opinion. Especially I need regex filtering since I use my own catchall domain for possible spammers.

### Supported filters
Due to my current needs the template script supports only the recipient filtering by *regex* or by a simple *contains*. If you need different filterings it's quite easy to add other fields (from, subject, header, body, ...).
If you need different filterings you're invited to file a pull request or if you're not so into IT just leave me a comment ;) If there is time, I'll add the filter for you.


Usage
-----
ImapFilter is run once when the docker container is run. So in order to have some background service you could use a interval run by crontab.

            docker run -it --rm -v [path_to_your_config.lua]:/root/.imapfilter/config.lua:ro peez/imapfilter

ImapFilter
----------
For details about the .lua file see https://github.com/lefcha/imapfilter or use google ;)
