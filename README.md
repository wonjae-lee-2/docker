# How to create and start docker containers.

## Build and run containers.

1. Create the `compose.yml` file.

```Shell
cd ~/github/docker
sed "s/PASSWORD_FILE/$(cat ~/password)/g" template.yml > compose.yml
```

2. Build and start all containers or one container in the background.

```Shell
docker compose up -d
docker compose up -d python
```

3. See the log of a running container.

```Shell
docker logs docker-python-1
```

4. Stop all running containers and restart a stopped container.

```Shell
docker stop $(docker ps -q)
docker start docker-python-1
```

5. Build all containters or one of them.

```Shell
docker compose build --no-cache
docker compose build --no-cache python
```

6. Run a container for once.

```Shell
docker compose run --rm --service-ports python # Replace python with r, julia, psql or mysql
```

## Forward ports through SSH.

1. For the python jupyter lab, press `shift` + `` ` `` + `c` and then type `-L 8888:localhost:8888` to request local forward. Replace the port number `8888` with `8787` or `1234` for the R and Julia containers.

2. For the python jupyter lab, copy the token dispalyed on the virtual machine and go to `localhost:8888` in the browser of the local machine.  Replace the port number `8888` with `8787` or `1234` for the R and Julia containers.

## Run custom commands.

1. Run Pluto in a new Julia container.

```Shell
# Type below after you build the Julia image.
docker compose run --rm --service-ports julia /pluto.sh
```

2. Start a bash shell in the running PostgreSQL container.

```Shell
# Type below after you start the PostgreSQL container.
docker compose exec -u postgres psql bash
# Use the username 'postgres' and the password from 'PASSWORD_FILE' to connect to the database remotely.
```

3. Start a bash shell in the running MySQL container.

```Shell
# Type below after you start the MySQL container.
docker compose exec mysql bash
# Use the username 'root' and the password from 'PASSWORD_FILE' to connect to the database remotely.
```

## Run Dask inside the Python container.



## Run Spkarlyr inside the R container.

Sparklyr should use the standard cluster because the connection with the autopilot cluster can be interrupted unexpectedly. The container's `.profile` runs `~/gcloud-auth.sh` at startup to set up connection with the GKE cluster using `key-gcloud.json` inside the `~/keys` folder and sets the namespace to `lee`.

## Run Julia Jupyter Lab in the kubernetes cluster.

1. Run `julia-push.sh` to re-tag and push the Julia image to the Google Cloud.

2. Check the image in the `julia-pod.yml` matches the pushed image.

3. Run `julia-kube.sh` to run and sync with the julia container.

4. Copy the external IP address of the node and the token dispalyed in the container log.

5. Go to `<public-node-ip>:<node-port>` in the browser of the local machine. (The node port is set to 31234 in the `julia-service.yml`.)

6. Enter the token from the container log.

Pluto cannot add worker procedures, so there is no point in running it in the Kubernetes cluster.

