echo '== Setting up Dpkg options ==' &&
  export DEBIAN_FRONTEND=noninteractive &&
  echo -e 'Dpkg::Options {\n  "--force-confnew";\n}' > ~/../usr/etc/apt/apt.conf.d/local &&
  echo '== Removing invalid repositories ==' &&
  pkg remove -y game-repo &&
  pkg remove -y science-repo &&
  echo '== Updating repositories and upgrading packages ==' &&
  pkg update -y &&
  pkg upgr -y &&
  echo '== Installing python, openssl, nodejs and proot ==' &&
  pkg i -y python openssl nodejs-lts proot &&
  echo '== Creating a stub /proc/stat file ==' &&
  echo 'cpu 1132 34 1441 11311718 3675 127 438' > ~/stat &&
  echo 'cpu0 1132 34 1441 11311718 3675 127 438' >> ~/stat &&
  echo '== Removing added Dpkg options ==' &&
  rm ~/../usr/etc/apt/apt.conf.d/local &&
  echo '== Installing homebridge and homebridge-config-ui ==' &&
  mkdir ~/.gyp && echo "{'variables':{'android_ndk_path':''}}" > ~/.gyp/include.gypi
  npm install -g --unsafe-perm homebridge &&
  npm install -g --unsafe-perm homebridge-config-ui-x &&
  echo '== Creating default config ==' &&
  mkdir -p ~/.homebridge &&
  echo -e '{\n        "bridge": {\n                "name": "Homebridge BA3D",\n                "username": "0E:F1:D3:85:BA:3D",\n                "port": 51248,\n                "pin": "171-94-744",\n                "advertiser": "bonjour-hap"\n        },\n        "accessories": [],\n        "platforms": [\n                {\n                        "name": "Config",\n                        "port": 8581,\n                        "platform": "config",\n                        "log": {\n                                "method": "file",\n                                "path": "/data/data/com.termux/files/home/.homebridge/homebridge.log"\n                        }\n                }\n        ]\n}\n' > ~/.homebridge/config.json &&
  echo '== Adding homebridge commands ==' &&
  echo 'exec npx homebridge "$@" 2>&1 | tee ~/.homebridge/homebridge.log' > ~/../usr/bin/hb &&
  chmod +x ~/../usr/bin/hb &&
  echo 'alias hb-start="proot -b ~/stat:/proc/stat hb"' >> ~/.profile &&
  chmod +x ~/.profile &&
  . ~/.profile &&
  echo -e '== Installation successful ==\nRestart Termux via exit command. Then execute hb-start command to launch Homebridge'