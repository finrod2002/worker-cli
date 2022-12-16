FROM openjdk:8u242-jdk-stretch as builder
COPY ./ /worker-cli/
RUN sh -c 'apt-get update && apt-get install -y gcc && apt-get -y install g++ && apt-get -y install zlib1g-dev'

FROM builder as builder1
COPY ./ /worker-cli/
RUN sh -c 'cd worker-cli && ./cli/scripts/build-linux-native-image.sh'

FROM bitnami/minideb:stretch
COPY --from=builder1 /worker-cli/cli/build/graal/sandbox-worker-cli-linux-x86_64 /sandbox-worker-cli
ENV LANG C.UTF-8
CMD /sandbox-worker-cli ${MEMORY_OPTS:--Xmx128m -Xmx128m -Xss128k} ${JAVA_OPTS:--Dmicronaut.server.netty.worker.threads=2} --base=/base --port=${PORT:-80} --watch=false ${JAVA_PARAMS} run
