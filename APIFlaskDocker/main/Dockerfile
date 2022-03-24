FROM python:3.8

RUN apt update

RUN apt install python3 python3-pip python3-venv -y

RUN mkdir /opt/main

COPY . /opt/main

WORKDIR /opt/main

RUN pip3 install -r requirements.txt

ENTRYPOINT ["python3", "app.py"]