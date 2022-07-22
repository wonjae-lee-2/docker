# How to create and start docker containers.

## Build, push and update images.

1. Create the `compose.yml` and `values.yml` files.

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

## Run and manage images.

1. Start all containers or one container in the background.

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
docker compose logs python
```

4. Stop all running containers and restart a stopped container.

```Shell
docker compose stop
docker compose start python
```

5. Stop and remove all containers as well as netowrks.

```Shell
docker compose down
```

## Run Jupyter Lab and RStudio Server from containers.

1. Start the container.

```Shell
cd ~/github/docker
docker compose up -d python; or
docker compose up -d r; or
docker compose up -d julia
```

2. Show the container log and copy the token or password.

```Shell
docker compose logs python; or
docker compose logs r; or
docker compose logs julia
```

3. Request port-forwarding between the local machine and the spot VM.

```
Press shift + ` + c, and then -L 8888:localhost:8888; or # Python
Press shift + ` + c, and then -L 8787:localhost:8787; or # R
Press shift + ` + c, and then -L 1234:localhost:1234 # Julia
```

4. Go to the following addresses in the web browser of the local machine.

```
localhost:8888; or # Python
localhost:8787; or # R
localhost:1234 # Julia
```

5. In case of RStudio Server, use the username `rstudio`.

6. Follow instructions in the `cookbook` repository to run Dask, Spark and Julia clusters on Kubernetes. (In case of Julia, Pluto does not run as the master and cannot add workers, so it cannot run on the Kubernetes cluster.)

## Run PostgreSQL and Trino on the virtual machine.

1. Start the PostgreSQL and Trino containers.

```Shell
docker compose up -d postgres trino
```

2. Start the PostgreSQL CLI.

```Shell
# Type below after you start the PostgreSQL container.
docker compose exec -u postgres postgres psql
# Use the username 'postgres' and the password from 'compose.yml' to connect remotely.
```

3. Open the Trino web UI in the browser.

```
Press `shift` + `` ` `` + `c` and then type `-L 8080:localhost:8080`.
Go to `localhost:8080` in the browser of the local machine.
At the log in page, enter any username (or trino, for example) and press enter.
```

4. Start the Trino CLI.

```Shell
docker compose exec trino trino
docker compose exec -u root trino trino # Type this if you run into this error: `WARNING: Failed to save history`.
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
