#!/bin/bash

# cannot compile
# 
# tried but failed: 
# - add -std=c++03 in Makefile CXXFLAGS

exit 1

# bash ./run.sh

set -eux

APP=merlin
VER=1.1.2

#wget https://csg.sph.umich.edu/abecasis/merlin/download/${APP}-${VER}.tar.gz

#tar -zxvf ./${APP}-${VER}.tar.gz
#rm -rf ./${APP}-${VER}.tar.gz



lib="./${APP}-${VER}"

dockerfile="./Dockerfile"


cat <<__END__ >$dockerfile

FROM --platform=linux/amd64 debian:bookworm-slim AS builder


WORKDIR /opt/${APP}-${VER}/
COPY ${lib} .

RUN apt update && \
	apt install -y --no-install-recommends \
	make build-essential libz-dev

RUN make all
RUN make install INSTALLDIR=/opt/bin/



FROM --platform=linux/amd64 debian:bookworm-slim AS runner

WORKDIR /app/
COPY --from=builder /opt/bin/* /app/

WORKDIR /script/
COPY ./commands.sh /script/commands.sh
ENTRYPOINT ["/script/commands.sh"]

__END__



# cannot run in `bash ./run.sh`; run in interactive shell
#docker build -t $APP -f $dockerfile
# check if it works
#docker run -it $APP


#docker login
#docker tag $APP rickyota/${APP}:${VER}
#docker push rickyota/${APP}:${VER}


