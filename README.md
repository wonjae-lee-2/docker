# How to create and start docker containers.

## Build and run containers.

1. Create the `compose.yml` file.

```Shell
cd ~/github/docker
sed "s/PASSWORD_FILE/$(cat ~/password)/g" template.yml > compose.yml
```

2. Copy the gcloud service account key to the r sub-folder.

```Shell
cp ~/key-gcloud.json r
```

3. Build all containters or one of them.

```Shell
docker compose build
docker compose build python
```

4. Run a container for once.

```Shell
docker compose run --rm --service-ports python # Replace python with r, julia, psql or mysql
```

5. Build and start all containers without auto-removal on exit.

```Shell
docker compose up
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

## Run Spkarlyr inside the R container.

Sparklyr should use the standard cluster because the connection with the autopilot cluster can be interrupted unexpectedly. The container's `.profile` sets up connection with the GKE cluster using `key-gcloud.json` inside the `~/keys` folder.

## Run Julia in the kubernetes cluster.

1. Run `julia-push.sh` to re-tag and push the Julia image to the Google Cloud.

2. Check the image in the `julia-pod.yml` matches the pushed image.

3. Press `shift` + `` ` `` + `c` to forward the port of the local machine to the virtual machine.

4. Run `julia-kube.sh` to run, sync with and attach to the julia container.

5. Copy the token or secret dispalyed in the container and go to `localhost:8888` in the browser of the local machine.
