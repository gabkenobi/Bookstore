# `python-base`
FROM python:3.10.5-slim as python-base

# Python
ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1

# pip
ENV PIP_NO_CACHE_DIR=off
ENV PIP_DISABLE_PIP_VERSION_CHECK=on
ENV PIP_DEFAULT_TIMEOUT=100

# Poetry
ENV POETRY_VERSION=1.1.15
ENV POETRY_HOME="/opt/poetry"
ENV POETRY_VIRTUALENVS_IN_PROJECT=true
ENV POETRY_NO_INTERACTION=1

# Paths
ENV PYSETUP_PATH="/opt/pysetup"
ENV VENV_PATH="/opt/pysetup/.venv"
ENV PATH="$POETRY_PATH/bin:$VENV_PATH/bin:$PATH"

# Installations
# Dependencies
RUN apt-get update && apt-get upgrade -y --no-install-recommends
RUN apt-get install -y curl build-essential libpq-dev gcc

# Poetry
RUN pip install poetry==$POETRY_VERSION

# Copying project files
WORKDIR $PYSETUP_PATH
COPY poetry.lock pyproject.toml ./

# Installing Poetry dependencies
RUN poetry config virtualenvs.create false
RUN poetry install --no-dev
RUN poetry install

WORKDIR /app
COPY . /app/

CMD ["poetry", "run", "python", "manage.py", "runserver", "0.0.0.0:8000"]
