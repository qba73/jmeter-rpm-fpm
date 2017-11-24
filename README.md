# jmeter-rpm-fpm


## Install dependencies

```bash
$ make deps
```

## List make targets

```bash
$ make
```

## Build rpm

Execute make target:
```bash
$ make build
```

## Upload rpm artifact to s3
Execute make target:
```bash
$ make upload-to-s3
```

## Upload rpm artifact to local JMeter repository
Execute make target:
```bash
$ make upload-to-repo
```

## Upload rpm artifact to both places
Execute make target:
```bash
$ make upload
```


# Usage

Show help:
```bash
$ make 

=============== JMeter RPM builder ===============

make deps           - run once to install fpm tool (RH)
make build          - build jmeter rpm
make clean          - clean the build environment
make upload-to-s3   - 
make upload-to-repo -
make upload         - upload rpm to either s3 bucket or hoster rpm repo
make mrproper       - wipeout environment and artifacts
```

Build rpm:
```bash
$ make build
rm -rf /tmp/installdir
mkdir /tmp/installdir
rm -rf *.rpm
test -f apache-jmeter-3.3.tgz || curl -O http://ftp.heanet.ie/mirrors/www.apache.org/dist/jmeter/binaries/apache-jmeter-3.3.tgz 
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 49.2M  100 49.2M    0     0  3148k      0  0:00:16  0:00:16 --:--:-- 4405k
tar -xzf apache-jmeter-3.3.tgz -C /tmp/installdir/
fpm -s dir -t rpm -n jmeter -v 3.3 -p jmeter_VERSION_ARCH.rpm -a x86_64 -m "<jakub.jarosz@postpro.net>" --prefix /opt/jmeter -C /tmp/installdir/apache-jmeter-3.3 .
Created package {:path=>"jmeter_3.3_x86_64.rpm"}
```

Wipeout buid environment:
```bash
$ make mrproper
rm -rf /tmp/installdir
mkdir /tmp/installdir
rm -rf *.rpm
rm -rf apache-jmeter-3.3.tgz
```
