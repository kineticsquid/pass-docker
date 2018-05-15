FROM alpine:3.7
COPY final.tar /
RUN tar xvf /final.tar -C /

FROM alpine:3.7
COPY --from=0 /data/ /data
RUN chmod a+rwx /data
