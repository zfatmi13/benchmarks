# Artifact: Robust Bisimilarity

This is the artifact for CAV 2025 Paper 117, titled *Robust Probabilistic Bisimilarity for Labelled Markov Chains*, in particular Sections 5 and 6.

We claim the artifact to be **available**, **functional** and **reusable**. We describe its content and usage below.


### Requirements

Docker will need to be installed, with a *Memory Limit* of at least 12GB (under Resources in the Settings menu).

The artifact is a Docker image, which will automatically set up a container containing all relevant files, software, and dependencies. We used a MacBook with an M1 chip and 16GB memory in our evaluation, therefore, we recommend a system of at least **16GB RAM**.


### Getting Started

First, load the docker image from the .tar archive (Docker may require `sudo` root privileges) and run the container with:
```
docker load -i robust-bisimilarity.tar.gz
docker run -it --name=robust-bisimilarity robust-bisimilarity:latest
```
Note that if you exit the container and want to enter it again, use `docker start -i robust-bisimilarity`.

The file structure and content of the container is as follows:
* **home**: the main folder of the artifact, which contains the *LICENSE*, a PDF of the submitted paper, and evaluation scripts to reproduce the tables (described in the section below)
  * **prism**: the PRISM model checker, https://github.com/prismmodelchecker/prism
  * **jpf**: Java PathFinder, https://github.com/javapathfinder/jpf-core
  * **benchmarks**: a folder containing the benchmarks used in our evaluation
    * *qvbs*: the QVBS benchmarks used 
    * *jpf*: the jpf examples used

**Smoke-Test**: In order to check that there are no technical difficulties, you can run `./table4.sh` which will generate Table 4 from the paper in about 5 minutes.


### Functionality

To replicate all of the experiments of the paper (i.e. Tables 1 - 4 in Section 6), we have provided evaluation scripts which can be run by following the steps outlined below. We have provided an estimate for how long each command will take, after which the corresponding table will be printed to the console and saved in a text file, such as `table1.txt` for example.

1. Run `./table1.sh` (takes up to 1.5 hours): Note that the benchmarks `oscillators` and `setIsolation` have the parameters attached to the model file name instead of in the model constants column.
2. Run `./table2.sh` (depends on step 1 - takes approximately 5 minutes)
3. Run `./table3.sh` (depends on step 1 - takes up to 1 hour): Benchmarks `egl`, `leader_sync`, `oscillators` and `erdos-renyi model` will have two rows (one per property), which we combined in the paper due to the similarity of the % increase in time. If some benchmarks run very quickly, their time to compute bisimulation will be recorded as `0` and we cannot compute the % increase in time. For such instances, a divide by zero warning will be printed to the console, along with the benchmark name, and one less instance will be reported in `table3.txt`. Note that, since we are dividing by very small numbers in most cases, the % increase in time may differ quite a bit.
4. Run `./table4.sh` (takes approximately 5 minutes)

Please note that the rows of the tables may appear in a different order than that of the paper! Furthermore, due to differing architectures, the time required to run the bisimilarity algorithm may differ slightly (note that the time is reported in seconds in the tables). If you would prefer to run all of the 4 scripts above in one go, you can use `./all-tables.sh`.

Detailed raw logs can be found in `benchmarks/qvbs/table1/logs` (similarly for tables 2 to 4) and `benchmarks/jpf/logs`.

We implemented our robust bisimilarity algorithm in the PRISM probabilistic model checker. Our implementation (described in Sections 5 and 6 of the paper) can be found in the PRISM package `explicit.bisim`, in particular the file `prism/prism/src/explicit/bisim/RobustBisimulation.java`.


### Reusability

PRISM is an open-source tool. PRISM has extensive documentation and user manuals at https://www.prismmodelchecker.org/, with instructions on how to install it on different systems. The documentation includes a description of the input language, details on how to run PRISM, and analyses of case studies. Since our algorithm is included in PRISM (can be used with the command-line options `-ex -bisim -robust`), we believe that this makes it easy for our algorithm to be repurposed and used beyond the paper.

Regarding the benchmarks sets used in the paper, QVBS (https://qcomp.org/benchmarks/) and JPF (https://github.com/javapathfinder/jpf-core/wiki) are also well-documented.
