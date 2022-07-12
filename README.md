# How to create and start docker containers.

## Build, push and update images on WSL.

1. Create the `compose.yml`, `compose-ec2.yml` and `values.yml` files.

```Shell
cd ~/github/docker
bash generate-compose.sh
```

2. Install the Rclone plugin.

```Shell
bash rclone-plugin.sh
```

3. Build and push all images, including spark and julia-worker images for Kubernetes.

```Shell
cd ~/github/docker
bash build-images.sh
```

4. Update packages and rebuild all images.

```Shell
cd ~/github/docker
bash update-images.sh
```

5. Build all images or one of them with `compose.yml`.

```Shell
docker compose build --no-cache
docker compose build --no-cache --progress=plain python
```

## Run and manage images on WSL.

1. Start all containers or one container in the background on WSL.

```Shell
docker compose up -d
docker compose up -d python
```

2. Run Pluto in a new Julia container.

```Shell
docker compose run --rm --service-ports julia pluto.sh
```

3. See the log of a running container.

```Shell
docker logs docker-python-1
```

4. For the Python and Julia container, copy the token dispalyed in the log and go to `localhost:8888` or `localhost:1234` in the browser. The R container does not show any password, so go to `localhost:8787` in the browser and enter the username `root` as well as the password included in `compose.yml` instead.

5. Stop all running containers and restart a stopped container.

```Shell
docker compose stop
docker compose start python
```

6. Stop and remove all containers as well as netowrks.

```Shell
docker compose down
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

3. Go to `localhost:8888` in the browser of the local machine.

4. Follow instructions in the `dask.ipynb` within the `cookbook` repository.

## Run Sparklyr remotely on the Kubernetes cluster.

1. Start the R container in the background.

```Shell
cd ~/github/docker
docker compose up -d r
```

2. Go to `localhost:8787` in the browser of the local machine.

3. Enter the username `root` and the password included in the `compose.yml`.

4. Follow instructions in the `sparklyr.rmd` within the `cookbook` repository.

5. Sparklyr should use the standard cluster because the connection with the autopilot cluster can be interrupted unexpectedly.

## Make Julia access the kubernetes cluster.

1. Start the Julia container in the background.

```Shell
docker compose up -d julia
```

2. Check the token for Jupyter Lab.

```Shell
docker logs docker-julia-1
```

3. Go to `localhost:1234` in the browser of the local machine. (Enter the token from the container log.)

4. Follow instructions in the `julia.ipynb` within the `cookbook` repository.

Pluto does not run as the master and cannot add workers, so there is no point in running it in the Kubernetes cluster.

## Run PostgreSQL and Trino on the virtual machine.

1. Copy files to the virtual machine.

```Shell
bash scp-aws.sh
```

2. Log in to the virtual machine.

```Shell
ssh aws
```

3. Install docker.

```Shell
bash docker.sh
```

4. Log out from and log back in to the virutal machine.

```Shell
logout
ssh aws
```

5. Install the Docker Volume Plugin.

```Shell
bash rclone-plugin.sh
```

6. Start the PostgreSQL and Trino containers.

```Shell
docker compose up -d
```

7. Start the PostgreSQL CLI.

```Shell
# Type below after you start the PostgreSQL container.
docker compose exec -u postgres postgres psql
# Use the username 'postgres' and the password from 'compose.yml' to connect remotely.
```

8. Open the Trino web UI in the browser.

```
Press `shift` + `` ` `` + `c` and then type `-L 8080:localhost:8080`.
Go to `localhost:8080` in the browser of the local machine.
At the log in page, enter any username (or trino, for example) and press enter.
```

9. Start the Trino CLI.

```Shell
docker compose exec trino trino
```

## Work with the Trino Helm chart.

1. Install the Trino helm chart and get a shell to the Trino CLI.

```Shell
bash trino.sh
```

2. Check the external IP address of the load balancer.

3. Go to `<load-balancer-external-ip>:8080` in the browser of the local machine for the web UI.

4. After use, uninstall the Trino Helm chart to delete all pods.

```Shell
helm uninstall -n trino trino
```
