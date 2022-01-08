---
jupytext:
  formats: md:myst
  text_representation:
    extension: .md
    format_name: myst
    format_version: 0.13
    jupytext_version: 1.13.5
kernelspec:
  display_name: Octave
  language: octave
  name: octave
---
```{code-cell}
:tags: [remove-cell]
run ../../external/replab/replab_init.m
```
# 2.2b Groups from graphs

By [Frucht's theorem](https://en.wikipedia.org/wiki/Frucht's_theorem), evey permutation group is the symmetric group of some finite undirected graph. It is thus possible to construct group from the symmetries of a graph.

## Constructing an undirected graph

An undirected graph is simply defined as a set of vertices, joined by a set of edges. In RepLAB, vertices are numbered from `1` to `nVertices` so that only the total number of vertices matter. Edges are stored as pairs of vertices listed in a matrix.

For instance, the triangle graph can be constructed by 

```{code-cell}
triGraph = replab.UndirectedGraph.fromEdges([1 2; 2 3; 3 1], 3)
```

Alternatively, a graph can also be constructed from its [adjacency matrix](https://en.wikipedia.org/wiki/Adjacency_matrix):

```{code-cell}
triGraph = replab.UndirectedGraph.fromAdjacencyMatrix([0 1 1; 1 0 1; 1 1 0])
```

## Graph automorphism

In RepLAB, the symmetry group of a graph is simply obtained by calling the `automorphismGroup` method:

```{code-cell}
triGroup = triGraph.automorphismGroup
```

The triangle is invariant under any permutation of its vertices. Its automorphism group is thus `S_3`, which is also identical to the dihedral group of order 6.
