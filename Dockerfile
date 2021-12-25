FROM elixir:1.13.1

RUN apt-get update && apt-get -y install apt-file && apt-file update
RUN apt-get -y upgrade

RUN apt-get -y install bash git vim sudo openjdk-11-jdk

ARG UID=1000
ARG GID=1000

RUN groupadd -g $GID devel
RUN useradd -u $UID -g devel -m devel
RUN echo "devel ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

COPY --chown=devel:devel . /work

USER devel

WORKDIR /work

RUN mix local.hex --force
RUN mix local.rebar --force
RUN echo elixirjava > /home/devel/.erlang.cookie
RUN chmod 400 /home/devel/.erlang.cookie
