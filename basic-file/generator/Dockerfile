FROM ubuntu:18.04

WORKDIR /generator
COPY --from=generator-base /upload/ /upload
ADD make_challenge.sh /generator/

CMD ["/bin/bash", "-c", "sh make_challenge.sh | /upload/upload.sh"]
