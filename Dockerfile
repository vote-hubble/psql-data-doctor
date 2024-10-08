ARG ALPINE_VERSION
FROM alpine:${ALPINE_VERSION}
ARG TARGETARCH

ENV POSTGRES_DATABASE ''
ENV POSTGRES_HOST ''
ENV POSTGRES_PORT 5432
ENV POSTGRES_USER ''
ENV POSTGRES_PASSWORD ''
ENV PGDUMP_EXTRA_OPTS ''
ENV S3_ACCESS_KEY_ID ''
ENV S3_SECRET_ACCESS_KEY ''
ENV S3_BUCKET ''
ENV S3_REGION 'us-west-1'
ENV S3_PATH 'backups'
ENV S3_ENDPOINT ''
ENV CRON_SCHEDULE '* 1 * * *'
ENV PASSPHRASE ''
ENV CALLBACK_URL ''

RUN apk update && apk add --no-cache postgresql-client gnupg s3cmd curl

ADD src/* /
RUN chmod +x env.sh backup.sh restore.sh
RUN echo "${CRON_SCHEDULE} cd / && ./backup.sh" >> /var/spool/cron/crontabs/root

CMD ["crond", "-f", "-d", "8"]
