from ubuntu:13.10
run sudo apt-get update
run sudo apt-get install -yq build-essential curl git-core
run mkdir -p /workspace
workdir /workspace
run curl -L https://github.com/heroku/heroku-buildpack-nodejs/archive/v56.tar.gz > /workspace/buildpack.tar.gz
run mkdir buildpack
run tar xzf buildpack.tar.gz -C buildpack --strip-components=1
add compile.sh /workspace/compile.sh
run chmod u+x compile.sh
volume ["/workspace/app_source"]
entrypoint ["/bin/bash", "/workspace/compile.sh"]
