
echo "-----------------------------------------------------------"
echo Tunneling PostgreSQL through port 63333...
echo "-----------------------------------------------------------"

LOCAL_PORT=54320
REMOTE_PORT=31663

ssh -N -L $LOCAL_PORT:localhost:$REMOTE_PORT tonioc@www.intellisoa.com
