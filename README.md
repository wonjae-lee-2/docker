# How to create and start docker containers.

## Build and run containers.

1. Create the `compose.yml` file.

```Shell
cd ~/github/docker
./generate-compose.sh
```

2. Build and start all containers or one container in the background.

```Shell
docker compose up -d
docker compose up -d python
```

3. Stop all running containers and restart a stopped container.

```Shell
docker stop $(docker ps -q)
docker start docker-python-1
```

4. See the log of a running container.

```Shell
docker logs docker-python-1
```

5. Build all containters or one of them.

```Shell
docker compose build --no-cache
docker compose build --no-cache --progress=plain python
```

6. Run a container for once.

```Shell
docker compose run --rm --service-ports python # Replace python with r, julia or psql.
```

## Update packages and build docker images again.

```Shell
cd ~/github/docker
./update-images.sh
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

## Run Dask remotely on the Kubernetes cluster.

1. Start the Python container in the background.

```Shell
cd ~/github/docker
docker compose up -d python
```

2. Check the token for Jupyter Lab.

```Shell
docker logs docker-python-1
```

3. Request local forward from the local machine to the virtual machine. 

```
Press `shift` + `` ` `` + `c` and then type `-L 8888:localhost:8888`
```

4. Go to `localhost:8888` in the browser of the local machine.

5. Follow instructions in the `dask.ipynb` within the `cookbook` repository.

## Run Sparklyr remotely on the Kubernetes cluster.

1. Build and push a Spark image to the artifact registry.

```Shell
cd ~/github/docker
./spark.sh
```

2. Start the R container in the background.

```Shell
cd ~/github/docker
docker compose up -d r
```

3. Check the password for RStudio.

```Shell
docker logs docker-r-1
```

4. Request local forward from the local machine to the virtual machine. 

```
Press `shift` + `` ` `` + `c` and then type `-L 8787:localhost:8787`
```

5. Go to `localhost:8787` in the browser of the local machine.

6. Follow instructions in the `sparklyr.rmd` within the `cookbook` repository.

7. Sparklyr should use the standard cluster because the connection with the autopilot cluster can be interrupted unexpectedly.

## Run Julia Jupyter Lab inside the kubernetes cluster.

1. Run `julia-push.sh` to re-tag and push the Julia image to the Google Cloud.

2. Type `gcloud container clusters resize cluster-1 --num-nodes=1 --zone=us-central1-c` to scale up the Kubernetes cluster.

3. Run `julia-kube.sh` to run and sync with the julia container. (Check the container log for the Jupyter Lab token.)

4. Open a new terminal and request local forward by pressing shift + ` + c and then -L 1234:localhost:1234.

5. In the new terminal, run `kubectl port-forward pod/julia 1234:1234`.

6. Go to `localhost:1234` in the browser of the local machine. (Enter the token from the container log.)

7. After shutting down the Jupyter Lab, run `gcloud container clusters resize cluster-1 --async --num-nodes=0 --zone=us-central1-c` to scale down the cluster.

Pluto does not run as the master and cannot add workers, so there is no point in running it in the Kubernetes cluster.
