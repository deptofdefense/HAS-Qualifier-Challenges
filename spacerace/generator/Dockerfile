FROM ubuntu:18.04

WORKDIR /generator
COPY --from=generator-base /upload/ /upload
COPY --from=spacerace:challenge /challenge/space_race /generator

CMD ["/bin/bash", "-c", "echo /generator/space_race | /upload/upload.sh"]
