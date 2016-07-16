FROM alpine:latest

COPY make_imapfilter_and_clean.sh /
RUN source /make_imapfilter_and_clean.sh

ENTRYPOINT ["imapfilter"]