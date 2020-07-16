FROM python:3.7

WORKDIR /generator
COPY --from=generator-base /upload/ /upload
ADD images.tar /generator
ADD generate.sh subset.py /generator/

CMD [ "/bin/bash", "-c", "./generate.sh | /upload/upload.sh" ]
