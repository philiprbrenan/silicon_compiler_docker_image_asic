# Silicon Compiler Docker Image

Create a [Docker](https://en.wikipedia.org/wiki/Docker_(software)) image from the latest version of [Silicon Compiler](https://docs.siliconcompiler.com/en/latest/index.html) and [install](https://en.wikipedia.org/wiki/Installation_(computer_programs)) enough tools to execute an ASIC flow.

The additional tools installed are:

```openroad klayout yosys sv2v yosys-slang```

The resulting [Docker](https://en.wikipedia.org/wiki/Docker_(software)) image can be seen at:

[Docker Image for Silicon Compiler ASIC flow](https://github.com/philiprbrenan/silicon_compiler_docker_image_asic/pkgs/container/silicon_compiler_docker_image_asic)

Running the [Docker](https://en.wikipedia.org/wiki/Docker_(software)) image shows that the requested tools have been installed as
requested:

```
docker run -it --rm ghcr.io/philiprbrenan/silicon_compiler_docker_image_asic:latest

root@a0093cf19ad3:/# python3 -c "import siliconcompiler;print(siliconcompiler.__version__)"
0.35.3

root@a0093cf19ad3:/# ./root/.local/bin/openroad
OpenROAD v2.0-26154-g795facf91f

root@a0093cf19ad3:/# klayout -v
KLayout 0.30.5

root@a0093cf19ad3:/# ./root/.local/bin/yosys

 /----------------------------------------------------------------------------\
 |  yosys -- Yosys Open SYnthesis Suite                                       |
 |  Copyright (C) 2012 - 2025  Claire Xenia Wolf <claire@yosyshq.com>         |
 |  Distributed under an ISC-like license, type "license" to see terms        |
 \----------------------------------------------------------------------------/
 Yosys 0.59+0 (git sha1 26b51148a, g++ 11.4.0-1ubuntu1~22.04.2 -fPIC -O3)

root@a0093cf19ad3:/# ./root/.local/bin/sv2v --version
sv2v v0.0.13-5-gc1ce7d0
```
