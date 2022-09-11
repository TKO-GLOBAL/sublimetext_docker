# syntax=docker/dockerfile:1

FROM ubuntu:latest

ARG USER="${USER:-sublime-user}"
ARG UID="${UID:-1000}"

USER root

RUN useradd --uid ${UID} --create-home ${USER} \
	&& mkdir --parents /run/user/${UID} \
	&& chown --recursive ${USER}:${USER} /run/user/${UID}

ENV HOME=/home/${USER} \
	XDG_RUNTIME_DIR=/run/user/${UID} \
	DEBIAN_FRONTEND=noninteractive

WORKDIR ${HOME}/sublime

COPY ./apt-packages.txt ./apt-packages.txt
RUN apt-get update \
	&& apt-get --yes upgrade \
	&& apt-get install --yes --no-install-recommends \
		$(cat ./apt-packages.txt \
			| awk '/\r$/ { $0 = substr($0, 1, length($0) -1 ) } {print $1}' \
			| grep -o '^[^#]*' \
		) \
	&& rm --recursive --force /var/lib/apt/lists/* \
	&& sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen \
	&& locale-gen

ENV LANG=en_US.UTF-8 \
	LANGUAGE=en_US:en \
	LC_ALL=en_US.UTF-8

WORKDIR ${HOME}

RUN wget --output-document - https://download.sublimetext.com/sublimehq-pub.gpg \
		| gpg --dearmor \
		> /etc/apt/trusted.gpg.d/sublimehq-archive.gpg \
	&& echo "deb https://download.sublimetext.com/ apt/stable/" \
		> /etc/apt/sources.list.d/sublime-text.list \
	&& apt-get update \
	&& apt-get install --yes --no-install-recommends \
		sublime-text \
	&& rm --recursive --force ${HOME}/sublime

USER ${USER}
RUN mkdir --parents ${HOME}/.config/sublime-text/Packages \
	&& chown --recursive ${USER}:${USER} ${HOME}/
