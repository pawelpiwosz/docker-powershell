## Powershell container

Powershell version: 6.2.1

#### Tests status

[![Build Status](https://travis-ci.org/pawelpiwosz/docker-powershell.svg?branch=master)](https://travis-ci.org/pawelpiwosz/docker-powershell)

### Synopsis

If you have this strange feeling to answer for one question: "How it is to
work with Powershell?" but without installing Windows - this container
is for you.

### Pull image

In orderto pull image from dockerhub registry, run:

```
docker pull almerhor/powershell
```

### Build

In order to build the image, run:

```
docker build -t powershell .
```

### Run

In order to work with Powershell, run:

```
docker run --rm -it powershell
```

### Credits

I wrote this container based on [this source](https://github.com/PowerShell/PowerShell-Docker)
