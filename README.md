# Silicon Compiler Docker Image

## Installation

Create a [Docker](https://en.wikipedia.org/wiki/Docker_(software)) image from the latest version of [Silicon Compiler](https://docs.siliconcompiler.com/en/latest/index.html) and [install](https://en.wikipedia.org/wiki/Installation_(computer_programs)) enough tools to execute an ASIC flow such as the one shown in
https://github.com/philiprbrenan/silicon_compiler_mod_A_in_mod_B.

The additional tools installed are:

```openroad klayout yosys sv2v yosys-slang
```

The resulting [Docker](https://en.wikipedia.org/wiki/Docker_(software)) image can be seen at:https://github.com/philiprbrenan/silicon_compiler_docker_image_asic/pkgs/container/silicon_compiler_docker_image_asic

## Set up $PATH

To set the path to the tools:

```
export PATH="/root/.local/bin:$PATH"
```

## Verification

Running the [Docker](https://en.wikipedia.org/wiki/Docker_(software)) image shows that the requested tools have been installed as
requested:

```
docker run -it --rm ghcr.io/philiprbrenan/silicon_compiler_docker_image_asic:latest
```

### [Silicon Compiler](https://docs.siliconcompiler.com/en/latest/index.html) 
```
root@a0093cf19ad3:/# python3 -c "import siliconcompiler;print(siliconcompiler.__version__)"
0.35.3
```

### [Open Road](https://openroad-flow-scripts.readthedocs.io/en/latest/mainREADME.html) 
```

root@a0093cf19ad3:/# openroad
OpenROAD v2.0-26154-g795facf91f
```

### klayout

```

root@a0093cf19ad3:/# klayout -v
KLayout 0.30.5
```

### [Yosys](https://yosyshq.readthedocs.io/en/latest/) 
```

root@a0093cf19ad3:/# yosys

 /----------------------------------------------------------------------------\
 |  yosys -- Yosys Open SYnthesis Suite                                       |
 |  Copyright (C) 2012 - 2025  Claire Xenia Wolf <claire@yosyshq.com>         |
 |  Distributed under an ISC-like license, type "license" to see terms        |
 \----------------------------------------------------------------------------/
 Yosys 0.59+0 (git sha1 26b51148a, g++ 11.4.0-1ubuntu1~22.04.2 -fPIC -O3)
```

### sv2v

```

root@a0093cf19ad3:/# sv2v --version
sv2v v0.0.13-5-gc1ce7d0
```
