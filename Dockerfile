FROM ubuntu:bionic

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update
RUN apt-get install software-properties-common -y
RUN apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 7FCC7D46ACCC4CF8
RUN add-apt-repository "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -sc)-pgdg main"
RUN apt-get install wget -y
RUN wget -q -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
RUN apt-get update
RUN apt-get install postgresql-11 -y
RUN mkdir /pgutils
RUN ldd --verbose -- "/usr/lib/postgresql/11/bin/psql"       | grep '^[[:space:]]*/[^:]*:$' | sed 's/[[:space:]]*//g' | sed 's/:$//g' | xargs -I {} cp {} "/pgutils/"
RUN ldd --verbose -- "/usr/lib/postgresql/11/bin/pg_dump"    | grep '^[[:space:]]*/[^:]*:$' | sed 's/[[:space:]]*//g' | sed 's/:$//g' | xargs -I {} cp {} "/pgutils/"
RUN ldd --verbose -- "/usr/lib/postgresql/11/bin/pg_restore" | grep '^[[:space:]]*/[^:]*:$' | sed 's/[[:space:]]*//g' | sed 's/:$//g' | xargs -I {} cp {} "/pgutils/"

FROM alpine:latest
COPY --from=0 /pgutils /pgutils
