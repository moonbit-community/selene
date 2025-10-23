# Selene Main Page 

```shell
cd examples 
moon build

cd ..
python3 publish.py

cd page
python3 -m http.server 8000
# Or other http servers
```

Then access `localhost:8000` with your browser.

## Clean 

```shell
python3 publish.py clean
```