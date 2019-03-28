FROM ubuntu:xenial

RUN apt-get update
RUN apt-get install software-properties-common -y
RUN add-apt-repository "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -sc)-pgdg main"
RUN apt-get install wget -y
RUN wget -q -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
RUN apt-get update
RUN apt-get install postgresql-9.6 -y
RUN mkdir /pgutils
RUN ldd --verbose -- "/usr/lib/postgresql/9.6/bin/psql"       | grep '^[[:space:]]*/[^:]*:$' | sed 's/[[:space:]]*//g' | sed 's/:$//g' | xargs -I {} cp {} "/pgutils/"
RUN ldd --verbose -- "/usr/lib/postgresql/9.6/bin/pg_dump"    | grep '^[[:space:]]*/[^:]*:$' | sed 's/[[:space:]]*//g' | sed 's/:$//g' | xargs -I {} cp {} "/pgutils/"
RUN ldd --verbose -- "/usr/lib/postgresql/9.6/bin/pg_restore" | grep '^[[:space:]]*/[^:]*:$' | sed 's/[[:space:]]*//g' | sed 's/:$//g' | xargs -I {} cp {} "/pgutils/"

FROM alpine:latest
COPY --from=0 /pgutils /pgutils
