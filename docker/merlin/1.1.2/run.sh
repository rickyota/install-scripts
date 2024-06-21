#!/bin/bash

set -eux

APP=merlin
VER=1.1.2


#wget https://csg.sph.umich.edu/abecasis/merlin/download/${APP}-${VER}.tar.gz

#tar -zxvf ./${APP}-${VER}.tar.gz
#rm -rf ./${APP}-${VER}.tar.gz



#lib="./ghm-${VER}"

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


