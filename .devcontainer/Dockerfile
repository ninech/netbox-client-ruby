ARG RUBY_VERSION=3.2
FROM ruby:${RUBY_VERSION}

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    # Remove imagemagick due to https://security-tracker.debian.org/tracker/CVE-2019-10131
    && apt-get purge -y imagemagick imagemagick-6-common

# Install the Dependencies
# we don't install git here as it's installed in the devcontainer.json
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get install -y --no-install-recommends \
    # build-essential is required for native extensions
    build-essential \
    ruby-dev \
    && rm -rf /var/lib/apt/lists/*
