FROM tiangolo/uwsgi-nginx:python3.8

COPY ./app /app
COPY requirements.txt requirements.txt
RUN pip3 install -r requirements.txt