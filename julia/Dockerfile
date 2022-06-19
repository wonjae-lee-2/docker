# syntax=docker/dockerfile:1

FROM julia:1.7.3

ARG HOME=/home/julia

RUN useradd -m julia

WORKDIR ${HOME}

COPY Project.toml Project.toml
COPY Manifest.toml Manifest.toml
COPY spec-file.txt spec-file.txt
COPY pluto.sh pluto.sh
RUN julia -e 'using Pkg; Pkg.activate("/home"); Pkg.instantiate(); import Conda; Conda.update()'; \
    ${HOME}/.julia/conda/3/bin/conda install -y --file spec-file.txt

EXPOSE 1234

CMD ["${HOME}/.julia/conda/3/bin/jupyter", "lab", "--allow-root", "--no-browser", "--ip=0.0.0.0", "--port=1234"]
