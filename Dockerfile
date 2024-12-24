# python is the name of the Docker image, 3.9-alpine3.13 is the name of the tag that we are using
FROM python:3.9-alpine3.13
LABEL maintainer="recipe.com"

# it tells python don't want to buffer the output
ENV PYTHONUNBUFFERED=1

# copy the requirement and app file added earlier into the Docker image
COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /app
WORKDIR /app
EXPOSE 8000

ARG DEV=false
# syntax run is building our image
# Create a new virtual environment that we're going to use to store our dependencies
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ $DEV = "true" ]; \
        then /py/bin/pip install -r /tmp/requirements.dev.txt ; \
    fi && \
    # we don't want any extra dependencies on our image
    rm -rf /tmp && \
    adduser \
        --disabled-password \
        --no-create-home \
        django-user

ENV PATH="/py/bin:$PATH"

USER django-user