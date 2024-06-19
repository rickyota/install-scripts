#!/bin/bash

set -eux

APP=genehunter-modscore
VER=4.0

# https://www.unimedizin-mainz.de/imbei/biometriegenomische-statistik-und-bioinformatik/software/genehunter-modscore-40.html

#wget https://www.unimedizin-mainz.de/typo3temp/secure_downloads/47384/0/190f92b3862017c629c1c57deb103c11336a12f3/ghm-${VER}.tgz
#tar xvfz ./ghm-${VER}.tgz
#rm -rf ./ghm-${VER}.tgz



lib="./ghm-${VER}"

dockerfile="./Dockerfile"


cat <<__END__ >$dockerfile

FROM --platform=linux/amd64 debian:bookworm-slim AS runner

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    libnlopt-dev \
    libreadline-dev

WORKDIR /app/
COPY ${lib}/ghm_linux ./ghm


ENTRYPOINT ["/app/ghm"]

__END__



# cannot run in `bash ./run.sh`; run in interactive shell
#docker build -t $APP -f $dockerfile
# check if it works
#docker run -it $APP


#docker login
#docker tag $APP rickyota/${APP}:${VER}
#docker push rickyota/${APP}:${VER}


