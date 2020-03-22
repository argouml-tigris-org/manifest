FROM python
RUN curl https://storage.googleapis.com/git-repo-downloads/repo \
        > /usr/local/bin/repo && \
    chmod a+x /usr/local/bin/repo
