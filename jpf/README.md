# The jpf-probabilistic examples

The Java PathFinder (JPF) extension jpf-probabilistic includes Java implementations of 60 randomized algorithms under the GNU GPL v3 license. For more details, see https://github.com/javapathfinder/jpf-probabilistic and the paper:
Syyeda Zainab Fatmi, Xiang Chen, Yash Dhamija, Maeve Wildes, Qiyi Tang and Franck van Breugel. Probabilistic model checking of randomized Java code. In _Proceedings of the 27th International Symposium on Model Checking Software, SPIN_, Springer (Jul 2021)

A description of the examples used in our evaluation:
* Erdös-Rényi Model: a model for generating a random (directed or undirected) graph. A graph with a given number of vertices `v` is constructed by placing an edge between each pair of vertices with a given probability `p`, independent from every other edge. We check the probability that the generated graph is connected (for every pair of nodes, there is a path).
* Fair Baised Coin: makes a fair coin from a biased coin, where `p` denotes the probability by which the biased coin tosses heads. We check the probability that the coin toss results in heads.
* Has Majority Element: a Monte Carlo algorithm that determines whether an integer array has a majority element (appears more than half of the time in the array). The parameter `s` denotes the size of the given array, `t` denotes the number of trials, and `m` denotes the amount of times that the majority element occurs in the array. We check the probability that the algorithm erroneously reports that the array does not have a majority element.
* Pollards Integer Factorization: finds a factor of an integer `i`. We check the probability that the algorithm returns `i`, when `i` is not prime.
* Queens: attempts to place a queen on each row of an `n×n` chess board such that no queen can attack another. We check the probability of success.
* Set Isolation: finds a sample of the universe `U` that is disjoint from the subset `S` but not disjoint from the subset `T`. Let `u` denote the size of the universe and
`st` denote the size of `S` and `T`. We check the probability that the randomly selected sample is good, that is, disjoint from `S` and intersects `T`.
