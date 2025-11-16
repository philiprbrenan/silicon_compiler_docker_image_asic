#!/usr/bin/perl -I/home/phil/perl/cpan/DataTableText/lib/ -I/home/phil/perl/cpan/GitHubCrud/lib/
#-------------------------------------------------------------------------------
# Create a docker image for silicon compiler
# Philip R Brenan at gmail dot com, Appa Apps Ltd Inc., 2025
#-------------------------------------------------------------------------------
use v5.38;
use warnings FATAL => qw(all);
use strict;
use Carp;
use Data::Dump qw(dump);
use Data::Table::Text qw(:all);
use GitHub::Crud qw(:all);

my $repo     = q(silicon_compiler_docker_image_asic);                           # Repo
my $user     = q(philiprbrenan);                                                # User
my $home     = fpd q(/home/phil/sc/), $repo;                                    # Home folder
my $wf       = q(.github/workflows/run.yml);                                    # Work flow on Ubuntu
my $shaFile  = fpe $home, q(sha);                                               # Sh256 file sums for each known file to detect changes
my @ext      = qw(.pl .py .txt .md);                                            # Extensions of files to upload to github

my $registry = 'ghcr.io';                                                       # Container registery
my $baseOS   = 'ubuntu:22.04';                                                  # Base docker image
my $stepsDir = 'steps';                                                         # Folder containing docker build files for each step of the builds
my $base     = q(base);                                                         # Base for silicon compiler
my @tools    = ($base, qw(openroad klayout yosys sv2v yosys-slang));            # Base plus tools to install for silicon compiler

sub container($tag)                                                             # The name of the container to be produced at each step
 {my $f = fpf $registry, $user, $repo;                                          # Untagged name
  return qq($f:latest) if $tag eq $tools[-1];                                   # Each tool is installed separately with the last tool being installed to create the final version of the image
  qq($f:$tag)                                                                   # Intermediate image
 }

say STDERR timeStamp,  " Push to github $repo";                                 # Tile of the piece

clearFolder $stepsDir, 10;                                                      # Empty folder containiong docker build files if present

owf(fpe($stepsDir, $base, q(txt)), <<END);                                      # Docker image for silicon compiler base
# Silicon Compiler Development Environment for ASIC Development Installed in a Docker Image
FROM $baseOS

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Install system dependencies
RUN apt-get update
RUN apt-get install -y --no-install-recommends git sudo build-essential python3-venv python3-pip
RUN rm -rf /var/lib/apt/lists/*

# Clone SiliconCompiler repository
WORKDIR /opt
RUN git clone https://github.com/siliconcompiler/siliconcompiler

# Set working directory
WORKDIR /opt/siliconcompiler

# Upgrade pip and install SiliconCompiler
RUN python3 -m pip install --upgrade pip
RUN python3 -m pip install --no-cache-dir .
RUN python3 -m pip list
END

for my $t(@tools)                                                               # Install each tool in a seperate docker image built on the previous image
 {next if $t eq $base;                                                          # Skip base as already installed
  my $from = container($t);                                                     # Precious docker image
  owf(fpe($stepsDir, $t, q(txt)), <<END),                                       # The tools start at 1 because 0 is occupied by the base install
FROM $from
RUN sc-install $t
WORKDIR /app
CMD ["/bin/bash"]
END
 }

my $dt  = dateTimeStamp;                                                        # Ensure update occurs by making the file contents unique
my @yml = <<"END";                                                              # Create workflow
# Test $dt
name: Build and Push Docker Image
run-name: $repo

on:
  push:
    paths:
      - .github/workflows/run.yml

jobs:
END

for my $step(keys @tools)                                                       # Add each tool to the build
 {my $name  = $tools[$step];
  my $step1 = $step - 1;
  my $needs = $step ? "needs: step$step1" : "";                                 # Base build has no predecessor, otherwise use output of previous step

  my $job_header = <<"JOB_HEADER";                                              # Each step is built as a separate job so that we get a clean empty machine each time - else we will run out of file space
  step$step:
    name: $name
    runs-on: ubuntu-latest
    $needs
    steps:
JOB_HEADER

  my $checkout = <<"CHECKOUT";                                                  # Checkout the repo
      - name: Checkout repo $repo
        uses: actions/checkout\@v3
CHECKOUT

  my $login = <<"LOGIN";                                                        # Login in to the container registry

      - name: Log in to GitHub Container Registry
        uses: docker/login-action\@v2
        with:
          registry: $registry
          username: \${{ github.actor }}
          password: \${{ secrets.GITHUB_TOKEN }}
LOGIN

  my $image = container($name);                                                 # The image we are going to build
  my $build = <<"BUILD";                                                        # Add this tool to the previous image built

      - name: $name
        uses: docker/build-push-action\@v4
        with:
          context: $stepsDir
          file: $stepsDir/$name.txt
          push: true
          tags: $image
BUILD

  push @yml, join "\n", $job_header, $checkout, $login, $build;                 # Complete job for this step
 }
#@yml = ($yml[0], $yml[6]);

my $yml = join "\n", @yml;                                                      # Workflow as a string
#say STDERR $yml; exit;

my @files = searchDirectoryTreesForMatchingFiles($home, @ext);                  # Files to upload
   @files = changedFiles $shaFile, @files;                                      # Filter out files that have not changed

for my $s(@files)                                                               # Upload each selected file
 {my $c = readBinaryFile $s;                                                    # Load file

  $c = expandWellKnownWordsAsUrlsInMdFormat $c if $s =~ m(README);              # Expand README

  my $t = swapFilePrefix $s, $home;                                             # File on github
  my $w = writeFileUsingSavedToken($user, $repo, $t, $c);                       # Write file into github
  lll "$w  $t";
 }

my $workFlowUpload = writeFileUsingSavedToken $user, $repo, $wf, $yml;          # Upload workflow
lll "$workFlowUpload  Ubuntu work flow for $repo";
