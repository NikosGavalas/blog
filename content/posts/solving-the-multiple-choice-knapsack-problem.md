---
title: "Solving the Multiple Choice Knapsack Problem"
date: "2019-02-06"
categories:
    - algorithms
tags:
    - algorithms
    - programming
draft: false
---

The 0-1 Knapsack problem is a popular combinatorial optimization problem:

> Given a set of n items, each having a value \\( p\_i \\) and a weight of \\( w_i \\), find a subset of these items such that the total value is maximized, while keeping the total weight of the items under a given constant weight capacity W.

Formally, we need to maximize \\( \sum\_{i=1}^{n}{p\_{i}f\_{i}} \\), while subjecting to \\( \sum\_{i=1}^{n}{w\_{i}f\_{i}} \le W \\), \\( f\_i \in \\{0, 1\\}, \forall i \in \\{ 1, ..., n\\} \\).

This problem has a nice Dynamic Programming solution, which runs in \\( O(nW) \\) time ([pseudopolynomial](https://en.wikipedia.org/wiki/Pseudo-polynomial_time)). It is a computationally hard problem, as it is NP-Complete, but it has many important applications.

It has [many known variations](https://en.wikipedia.org/wiki/List_of_knapsack_problems), one of which is the Multiple Choice Knapsack Problem. In this case, the items are subdivided into \\( k \\) classes, each having \\( N\_i \\) items, and exactly one item must be taken from each class. Formally, we need to maximize \\( \sum\_{i=1}^{k}\sum\_{j \in N\_i}{p\_{ij}x\_{ij}} \\), while subjecting to \\( \sum\_{i=1}^{k}\sum\_{j \in N\_i}{w\_{ij}x\_{ij}} \le W\\), with \\( \sum\_{j \in N\_i}{x\_{ij}} = 1, \forall i \in \\{1, ..., k\\}\\) and \\( x\_{ij} \in \\{0, 1\\}, \forall i \in \\{1, ..., k\\} \\) and \\( \forall j \in N\_i \\).

To solve this problem, we will use a Dynamic Programming approach. The recursive equation that describes the relation between the overlapping subproblems is the following:

\\[ Value[i, j] = \max\_{1 \le u \le N\_i, w\_{iu} \le j}\\{ Value[i-1, j-w\_{iu}] + p\_{iu} \\} \\]

Below is an implementation in C++:

```cpp
#include <algorithm>
#include <iostream>
#include <vector>

using namespace std;

int max_value(const vector<vector<int>>& weight,
               const vector<vector<int>>& value,
               int max_weight) {
    if (weight.empty())
        return 0;

    vector<int> last(max_weight + 1, -1);
    for (int i = 0; i < weight[0].size(); ++i) {
        if (weight[0][i] < max_weight)
            last[weight[0][i]] = max(last[weight[0][i]], value[0][i]);
    }

    vector<int> current(max_weight + 1);
    for (int i = 1; i < weight.size(); ++i) {
        fill(current.begin(), current.end(), -1);
        for (int j = 0; j < weight[i].size(); ++j) {
            for (int k = weight[i][j]; k <= max_weight; ++k) {
                if (last[k - weight[i][j]] > 0)
                    current[k] = max(current[k],
                                     last[k - weight[i][j]] + value[i][j]);
            }
        }
        swap(current, last);
    }

    return *max_element(last.begin(), last.end());
}

// driver code
int main(int argc, char const* argv[]) {
    vector<int> values_class_1;
    values_class_1.push_back(2);
    values_class_1.push_back(3);

    vector<int> weights_class_1;
    weights_class_1.push_back(3);
    weights_class_1.push_back(4);

    vector<int> values_class_2;
    values_class_2.push_back(1);
    values_class_2.push_back(2);

    vector<int> weights_class_2;
    weights_class_2.push_back(2);
    weights_class_2.push_back(3);

    vector<vector<int>> values;
    values.push_back(values_class_1);
    values.push_back(values_class_2);
    vector<vector<int>> weights;
    weights.push_back(weights_class_1);
    weights.push_back(weights_class_2);

    int max_weight = 7;

    cout << max_value(weights, values, max_weight) << endl;

    return 0;
}
```

The time complexity of this solution is \\(O(C\sum\_{i=1}^{k}{N\_i})\\).
