# syntax=docker/dockerfile:1

FROM julia:1.7.3

WORKDIR /home

COPY requirements.jl requirements.jl
COPY jupyter.sh jupyter.sh
COPY pluto.sh pluto.sh
RUN julia requirements.jl

EXPOSE 8888 1234

CMD ["/root/.julia/conda/3/bin/jupyter", "lab", "--allow-root", "--no-browser", "--ip=0.0.0.0", "--port=8888"]
