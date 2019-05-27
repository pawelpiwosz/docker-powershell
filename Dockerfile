FROM alpine:latest AS builder

ARG PS_VER=6.2.1
ARG INSTALL_PATH=/opt/microsoft/powershell/${PS_VER}

ENV INSTALL_PATH=${INSTALL_PATH}

ADD https://github.com/PowerShell/PowerShell/releases/download/v${PS_VER}/powershell-${PS_VER}-linux-alpine-x64.tar.gz  /tmp/linux.tar.gz

RUN mkdir -p ${INSTALL_PATH}
RUN tar zxf /tmp/linux.tar.gz -C ${INSTALL_PATH}


FROM alpine:latest

ARG PS_VER=6.2.1
ARG INSTALL_PATH=/opt/microsoft/powershell/${PS_VER}

LABEL maintainer="Pawel Piwosz <devops@pawelpiwosz.net>"

# For Travis build
ARG BUILD_DATE
ARG VCS_REF
ARG VER

LABEL org.label-schema.schema-version="1.0"
LABEL org.label-schema.build-date=$BUILD_DATE
LABEL org.label-schema.vcs-ref=$VCS_REF
LABEL org.label-schema.vcs-url="https://github.com/pawelpiwosz/docker-awscli"
LABEL org.label-schema.name="docker-awscli"
LABEL org.label-schema.description="CLI for AWS in Docker container"
LABEL org.label-schema.version=$VER

ENV INSTALL_PATH=${INSTALL_PATH}
ENV DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=false
ENV LC_ALL=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV PSModuleAnalysisCachePath=/var/cache/microsoft/powershell/PSModuleAnalysisCache/ModuleAnalysisCache

COPY --from=builder ["/opt/microsoft/powershell", "/opt/microsoft/powershell"]

RUN apk add --update --no-cache \
    ca-certificates \
    less \
    ncurses-terminfo-base \
    krb5-libs \
    libgcc \
    libintl \
    libssl1.1 \
    libstdc++ \
    tzdata \
    userspace-rcu \
    zlib \
    icu-libs
RUN apk -X https://dl-cdn.alpinelinux.org/alpine/edge/main --update --no-cache add lttng-ust
RUN ln -s ${INSTALL_PATH}/pwsh /usr/bin/pwsh \
    && chmod a+x,o-w ${INSTALL_PATH}/pwsh
RUN pwsh -NoLogo -NoProfile -Command " \
    \$ErrorActionPreference = 'Stop' ; \
    \$ProgressPreference = 'SilentlyContinue' ; \
    while(!(Test-Path -Path \$env:PSModuleAnalysisCachePath)) {  \
        Write-Host "'Waiting for $env:PSModuleAnalysisCachePath'" ; \
        Start-Sleep -Seconds 6 ; \
    }"

CMD ["pwsh"]
