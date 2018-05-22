FROM alpine:3.7
COPY data.tar /
RUN tar xvf /data.tar -C /

FROM alpine:3.7
COPY --from=0 /data/ /data
RUN chmod a+rwx /data
