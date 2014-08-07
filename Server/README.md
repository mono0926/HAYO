SheepYo (Server)
=======

```
curl -s https://www.parse.com/downloads/cloud_code/installer.sh | sudo /bin/bash
pyenv local 2.7.6
parse new SheepDev
cd SheepDev
parse deploy
```

http://hayo.parseapp.com/

```
curl -X POST \
  -H "X-Parse-Application-Id: jmhZPiIg1DZLjIs7b7p5jyTa5cKHzJEw0YPHo794" \
  -H "X-Parse-REST-API-Key: NqsH0k5qe2v3mtXcwAWpqMmYFQwB3Rok0d6om47P" \
  -H "Content-Type: application/json" \
  -d '{}' \
  https://api.parse.com/1/functions/hello
```

```
curl -X POST \
  -H "X-Parse-Application-Id: jmhZPiIg1DZLjIs7b7p5jyTa5cKHzJEw0YPHo794" \
  -H "X-Parse-REST-API-Key: NqsH0k5qe2v3mtXcwAWpqMmYFQwB3Rok0d6om47P" \
  -H "Content-Type: application/json" \
  -d '{"from": "qZTbMdqYlkwVWg9meLfDrsVJ5", "to": "tfuOLiuZzJLRlstF5d7s5tXsx", "message": "test"}' \
  https://api.parse.com/1/functions/hayo
```