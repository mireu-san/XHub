# 공식 Python 런타임을 기반 이미지로 사용합니다.
FROM python:3.11.4-alpine3.18

# 환경 변수 설정
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
ENV PATH="/py/bin:$PATH"

# Python 및 PostgreSQL에 필요한 시스템 패키지를 설치합니다.
RUN apk update \
    && apk add --no-cache postgresql-dev gcc musl-dev jpeg-dev zlib-dev libffi-dev \
    && python3 -m ensurepip \
    && pip3 install --no-cache --upgrade pip setuptools

# 컨테이너 내 작업 디렉토리를 /app으로 설정합니다.
WORKDIR /app

# 현재 디렉토리의 내용을 컨테이너의 /app에 복사합니다.
COPY . /app

# Python 가상 환경 설정
RUN python -m venv /py

# requirements.txt에 지정된 패키지를 설치합니다.
RUN /py/bin/pip install --upgrade pip \
    && /py/bin/pip install -r requirements.txt

# 빌드에만 필요한 패키지를 제거합니다.
RUN apk del gcc musl-dev libffi-dev


# 컨테이너 외부에서 8000 포트에 액세스할 수 있도록 합니다.
EXPOSE 8000

# Django 서버를 시작하는 명령을 실행합니다.
ARG SERVICE_TYPE=django
CMD ["sh", "-c", "if [ \"$SERVICE_TYPE\" = \"daphne\" ]; then daphne -u /tmp/daphne.sock core.asgi:application; else gunicorn core.wsgi:application --bind 0.0.0.0:8000 --timeout 120; fi"]