FROM maven:3-ibmjava-8
RUN apt-get update && \
    apt-get install -y --no-install-recommends python git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
RUN curl https://storage.googleapis.com/git-repo-downloads/repo \
        > /usr/local/bin/repo && \
    chmod a+x /usr/local/bin/repo
