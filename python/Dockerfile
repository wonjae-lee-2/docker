# syntax=docker/dockerfile:1

FROM python:3.10.5

WORKDIR /root

COPY . .
RUN pip install -r requirements.txt

EXPOSE 8888 8787

CMD ["jupyter", "lab", "--allow-root", "--no-browser", "--ip=0.0.0.0", "--port=8888"]