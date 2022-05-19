FROM ubuntu:22.04
RUN apt -y update && apt -y upgrade && apt -y install debmirror gnupg xz-utils

COPY mirrorbuild.sh /
RUN chmod 777 /mirrorbuild.sh
ENV \
  MIRRORDIR="/apt" \
  KEYRINGS="/keyring" \
  DEBUGFILE="debmirror-debug.log"

RUN \
  mkdir -p ${MIRRORDIR} && \
  chmod 0777 ${MIRRORDIR} && \
  mkdir -p ${KEYRINGS} && \
  chmod 0777 ${KEYRINGS}
 
COPY ubuntu-keyring* /
RUN dpkg -x /ubuntu-keyring_2020.02.11.2_all.deb ~
RUN dpkg -x /ubuntu-keyring_2020.02.11.4_all.deb ~
RUN gpg --keyring ~/usr/share/keyrings/ubuntu-archive-keyring.gpg --export| gpg --no-default-keyring --keyring ${KEYRINGS}/trustedkeys.gpg --import

ENTRYPOINT ["/mirrorbuild.sh"]

