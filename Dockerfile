FROM alpine:latest

# https://github.com/detekt/detekt/releases
#ARG DETEKT_VERSION="1.23.1"
# https://github.com/reviewdog/reviewdog/releases
ARG REVIEWDOG_VERSION="master"

RUN apk --no-cache --update add git openjdk11 bash \
    && rm -rf /var/cache/apk/*

RUN DETEKT_VERSION=$(wget -qO - https://github.com/detekt/detekt/releases/latest|cat -|grep "<title>Release"|awk '{print $2}'|cut -dv -f2) \
 && DETEKT_FILE_NAME="detekt-cli-${DETEKT_VERSION}-all.jar" \
 && DETEKT_URL="https://github.com/detekt/detekt/releases/download/v${DETEKT_VERSION}/${DETEKT_FILE_NAME}" \
 && DETEKT_FORMATTING_FILE_NAME="detekt-formatting-${DETEKT_VERSION}.jar" \
 && DETEKT_FORMATTING_URL="https://github.com/detekt/detekt/releases/download/v${DETEKT_VERSION}/${DETEKT_FORMATTING_FILE_NAME}" \
 && wget -O /opt/detekt.jar -q ${DETEKT_URL} \
 && wget -O /opt/detekt-formatting.jar -q ${DETEKT_FORMATTING_URL}

RUN wget -O - -q https://raw.githubusercontent.com/reviewdog/reviewdog/${REVIEWDOG_VERSION}/install.sh | sh -s -- -b /usr/local/bin/

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
