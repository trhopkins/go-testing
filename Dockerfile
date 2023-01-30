# build environment: semi-recent Go container in minimal Linux distro
FROM --platform=${BUILDPLATFORM} golang:1.20rc3-alpine3.17 AS build
WORKDIR /src
COPY . .

# statically link all libraries and target Linux
ENV CGO_ENABLED=0
ARG TARGETOS
ARG TARGETARCH

# build the project to the 'example' executable
RUN GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -o /out/example .

# enter a new environment to dump results into bin/ directory of project
FROM scratch AS bin-unix
COPY --from=build /out/example /

# alias Linux and MacOS
FROM bin-unix AS bin-linux
FROM bin-unix AS bin-darwin

# alias Windows with a different build step
FROM scratch AS bin-windows
COPY --from=build /out/example /example.exe

# read argument correctly
FROM bin-${TARGETOS} AS bin

# copied from https://www.docker.com/blog/containerize-your-go-developer-environment-part-1/# 2022-01-29
