# How to create and start docker containers.

## Build and run containers.

1. Create the `compose.yml` and `compose-ec2.yml` file.

```Shell
cd ~/github/docker
./generate-compose.sh
```

2. Build all containters or one of them.

```Shell
docker compose build --no-cache
docker compose build --no-cache --progress=plain python
```

3. Build and start all containers or one container in the background.

```Shell
docker compose up -d
docker compose up -d python
```

4. Stop all running containers and restart a stopped container.

```Shell
docker stop $(docker ps -q)
docker start docker-python-1
```

5. See the log of a running container.

```Shell
docker logs docker-python-1
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

## Make Julia access the kubernetes cluster.

1. Run `julia-push.sh` to re-tag and push the Julia image to the Google Cloud.

2. Start the Julia container in the background.

```Shell
docker compose up -d julia
```

3. Check the token for Jupyter Lab.

```Shell
docker logs docker-julia-1
```

4. Request local forward between the local machine and the virtual machine.

```Shell
Press `shift` + `` ` `` + `c` and then -L 1234:localhost:1234
```

5. Go to `localhost:8787` in the browser of the local machine. (Enter the token from the container log.)

6. Follow instructions in the `julia.ipynb` within the `cookbook` repository.

Pluto does not run as the master and cannot add workers, so there is no point in running it in the Kubernetes cluster.

## Work with the Trino Docker container.

1. Start the Trino docker container.

```Shell
docker compose up -d trino
```

2. Request local forward from the local machine to the virtual machine for the web UI.

```
Press `shift` + `` ` `` + `c` and then type `-L 8080:localhost:8080`
```

2. Get a shell to the Trino CLI.

```Shell
docker exec -it docker-trino-1 trino
```

4. Go to `localhost:8080` in the browser of the local machine for the web UI.

## Work with the Trino Helm chart.

1. Install the Trino helm chart and get a shell to the Trino CLI.

```Shell
./trino.sh
```

2. Check the external IP address of the load balancer.

3. Go to `<load-balancer-external-ip>:8080` in the browser of the local machine for the web UI.

## Run PostgreSQL and Trino on the virtual machine.

1. Copy the script to install docker to the virtual machine.

```Shell
scp ~/github/script/install/docker.sh aws:~
```

2. Copy the files to launch the PostgreSQL and Trino containers.

```Shell
scp ~/github/docker/compose-ec2.yml aws:~/compose.yml
scp -r ~/github/docker/trino/* aws:~/trino
```

3. Log in to the virtual machine.

```Shell
ssh aws
```

4. Install docker.

```Shell
./docker.sh
```

5. Start the PostgreSQL and Trino containers.

```Shell
docker compose up -d
```
