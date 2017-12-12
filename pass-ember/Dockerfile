FROM danlynn/ember-cli:2.17.0

ARG EMBER_GIT_REPO
ENV EMBER_GIT_REPO ${EMBER_GIT_REPO:-https://github.com/DataConservancy/pass-ember}

ARG EMBER_GIT_BRANCH
ENV EMBER_GIT_BRANCH ${EMBER_GIT_BRANCH:-master}

RUN rm -rf watchman && \
    git clone ${EMBER_GIT_REPO} . && \
    git checkout ${EMBER_GIT_BRANCH} && \
    npm install