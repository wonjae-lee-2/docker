# syntax=docker/dockerfile:1

ARG JULIA_VERSION

FROM julia:${JULIA_VERSION}

ARG HOME=/home/julia

RUN useradd -m julia

USER julia

WORKDIR ${HOME}

COPY Project.toml Project.toml
COPY Manifest.toml Manifest.toml
COPY spec-file.txt spec-file.txt
RUN julia -e 'using Pkg; Pkg.activate("."); Pkg.instantiate(); import Conda; Conda.update()'; \
    ${HOME}/.julia/conda/3/bin/conda install -y --file spec-file.txt

COPY pluto.sh pluto.sh

EXPOSE 1234

CMD ["/home/julia/.julia/conda/3/bin/jupyter", "lab", "--no-browser", "--ip=0.0.0.0", "--port=1234"]
