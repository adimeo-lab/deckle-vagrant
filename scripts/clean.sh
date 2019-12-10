# clear what previous executions may have left behind...
if [ -d "/tmp/apps" ]; then
rm -rf /tmp/apps
fi

if [ -d "/tmp/docker.service.d" ]; then
rm -rf /tmp/docker.service.d
fi
