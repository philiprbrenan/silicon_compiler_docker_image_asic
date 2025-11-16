# Silicon Compiler Docker Image

Create a [Docker](https://en.wikipedia.org/wiki/Docker_(software)) image from the latest version of [Silicon Compiler](https://docs.siliconcompiler.com/en/latest/index.html) and [install](https://en.wikipedia.org/wiki/Installation_(computer_programs)) enough tools to execute an ASIC flow.

```
docker run -it --rm silicon_compiler_docker_image_asic
```

The additional tools installed are:

```openroad klayout yosys sv2v yosys-slang```

The resulting [Docker](https://en.wikipedia.org/wiki/Docker_(software)) image can be seen at:

[Docker Image for Silicon Compiler ASIC flow](https://github.com/philiprbrenan/silicon_compiler_docker_image_asic/pkgs/container/silicon_compiler_docker_image_asic)
