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

## Update packages and build docker images again.

```Shell
./update.sh
```

## Forward ports through SSH.

1. For the python jupyter lab, press `shift` + `` ` `` + `c` and then type `-L 8888:localhost:8888` to request local forward. Replace the port number `8888` with `8787` or `1234` for the R and Julia containers.

2. For the python jupyter lab, copy the token dispalyed on the virtual machine and go to `localhost:8888` in the browser of the local machine.  Replace the port number `8888` with `8787` or `1234` for the R and Julia containers.

## Run custom commands.

1. Run Pluto in a new Julia container.

```Shell
# Type below after you build the Julia image.
docker compose run --rm --service-ports julia ./pluto.sh
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

## Run Dask and Sparklyr remotely on the Kubernetes cluster.

The container user's `.profile` runs `~/gcloud-auth.sh` at startup to set up connection with the GKE cluster using `key-gcloud.json` inside the `~/keys` folder and set the namespace to `cluster`. Use `kubectl port-forward` to connect to the dashboard on the Dask scheduler service or Sparklyr driver pod.

Sparklyr should use the standard cluster because the connection with the autopilot cluster can be interrupted unexpectedly. 

## Run Julia Jupyter Lab inside the kubernetes cluster.

1. Run `julia-push.sh` to re-tag and push the Julia image to the Google Cloud.

2. Check the image in the `julia-pod.yml` matches the pushed image.

3. Run `julia-kube.sh` to run and sync with the julia container. (Check the container log for the Jupyter Lab token.)

4. Open a new terminal and request local forward by pressing shift + ` + c and then -L 1234:localhost:1234.

5. In the new terminal, run `kubectl port-forward pod/julia 1234:1234`.

6. Go to `localhost:1234` in the browser of the local machine. (Enter the token from the container log.)

Pluto does not run as the master and cannot add workers, so there is no point in running it in the Kubernetes cluster.
