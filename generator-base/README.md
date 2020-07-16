# Base Generator Image #

This is a base image, essentially it wraps a set of functionality to be 
used by all generators. It has a folder called /upload with at least an
`upload.sh` script inside of it. Generators are responsible to include the
following:

```
COPY --from=generator-base /upload /upload
```

...and as part of their Docker entrypoint/command they must pipe a list of
files (one per line) to /upload/upload.sh, which will handle the rest.
Here's an example:

```
CMD ["/bin/bash", "-c", "python generate.py | /upload/upload.sh"]
```

It is recommended that the list of files are absolute paths.

It is currently in a debug configuration, upload.sh will echo each file to 
it's stdout (for debugging) and will copy each file to an /out directory.
To use this when making a generator in challenge dev, you can mount a local
directory to /out as follows:

```
docker run -it --rm -v `pwd`/out:/out sample-challenge:generator
```

