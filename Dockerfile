# Dockerfile based on ideas from https://pythonspeed.com/

FROM docker.io/python:3.12-slim AS base

LABEL maintainer "Steven Armstrong <steven@armstrong.cc>"

ENV \
   LANG=C.UTF-8 \
   LC_ALL=C.UTF-8 \
   # python:
   PYTHONFAULTHANDLER=1 \
   PYTHONUNBUFFERED=1 \
   PYTHONHASHSEED=random \
   PYTHONDONTWRITEBYTECODE=1 \
   # pip:
   PIP_NO_CACHE_DIR=off \
   PIP_DISABLE_PIP_VERSION_CHECK=on \
   PIP_DEFAULT_TIMEOUT=100


FROM base AS compile-image

RUN apt-get update
RUN apt-get install -y --no-install-recommends build-essential gcc

ENV VIRTUAL_ENV=/venv
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
RUN pip install --upgrade pip
RUN pip install wheel

# Dumb-init as pid 1.
RUN pip install dumb-init

# Install python packages into virtual env.
COPY requirements.txt .
RUN pip install -r requirements.txt


FROM base AS runtime-image

COPY --from=compile-image /venv /venv

# Install runtime dependencies.
COPY redmine-lifecycle-bot /venv/bin
RUN chmod +x /venv/bin/redmine-lifecycle-bot

RUN useradd redmine-bot
USER redmine-bot

# Ensure exectutables from virtualenv are prefered.
ENV PATH "/venv/bin:${PATH}"
ENTRYPOINT ["/venv/bin/dumb-init", "--", "redmine-lifecycle-bot"]
