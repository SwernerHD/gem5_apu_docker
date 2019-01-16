# gem5_apu_docker
Repo contains docker files that install, build, and run the gem5 apu and its dependencies
Dockerfile is partially from an AMD intern and automatically installs all Rocm packages into opt/Rocm/
Dockerfile_manually installs all libraries/dependencies (i.e. HCC, Roct, Rocr, HIP) manually. This might be necessary to make it work as currently none of the ComputeApps or HCC_Applications are running. 

