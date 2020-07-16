FROM debian:stretch-slim

COPY --from=generator-base /upload/ /upload

WORKDIR /generator/src
ADD src.tar.gz /generator/

CMD ["/bin/bash", "-c" , "ls *.m | /upload/upload.sh"]
