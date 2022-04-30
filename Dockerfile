FROM arm64v8/golang as build
RUN apt update && apt install -y git dmsetup
RUN git clone \
        --branch release-v0.38 \
        --depth 1 \
        https://github.com/google/cadvisor.git \
        /go/src/github.com/google/cadvisor
WORKDIR /go/src/github.com/google/cadvisor
RUN make build

FROM arm64v8/debian
COPY --from=build /go/src/github.com/google/cadvisor/cadvisor /usr/bin/cadvisor
EXPOSE 8080
ENTRYPOINT ["/usr/bin/cadvisor", "-logtostderr"]