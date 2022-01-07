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
# 2.1 Permutations in RepLAB

In RepLAB, a permutation $g$ is described using the row vector of permutation images $(g(1), g(2), \ldots, g(n))$.
This corresponds to the behavior of the [randperm](https://www.mathworks.com/help/matlab/ref/randperm.html) and [perms](https://www.mathworks.com/help/matlab/ref/perms.html) functions, and enables the use of such vectors of indices as matrix/vector subscripts.

Let us define two permutations.
Note that in RepLAB permutations act on a set of given size: `[1 2 3]` and `[1 2 3 4]` are not equivalent, even though they both represent the identity of a permutation group.

```{code-cell}
g = [2 1 3];
h = [3 2 1];
```

```{sidebar}
This behavior is different from other computer algebra systems. For example, [GAP System](https://www.gap-system.org/Manuals/doc/ref/chap42.html) represents permutations as a product of cycles.
[SymPy](https://docs.sympy.org/latest/modules/combinatorics/permutations.html) has a specific type of object to describe permutations.
In RepLAB we prefer using existing conventions of the MATLAB/Octave ecosystem every time it is possible.
```

To compute the action of a permutation on a point, we write:

```{code-cell}
g(2)
```

Let $k = g h$ be the composition of $g$ and $h$. It is well defined if we ask that $k(i) = g(h(i))$, then:

```{code-cell}
gh2 = g(h(2))
k = g(h)
k2 = k(2)
```

```{sidebar}
In some textbooks, for example {cite:p}`Holt2005`, the exponent notation is used for permutations: one then writes $2^g$ for the image of 2 under the permutation $g$. The composition $g h$ is then defined as $(2^g)^h$, and $g$ is applied first! This differs from the RepLAB convention, which rather matches the standard definition of [function composition](https://en.wikipedia.org/wiki/Function_composition).
One should then be careful when mixing different textbooks or computer algebra systems.
```
But how can one compute the inverse of a permutation? Luckily, we can construct the group of all permutations of a given size
in RepLAB, and call its methods to perform group operations. The function [replab.S(n)](+replab.S) creates the
symmetric group acting on $\{1,2,\ldots,n\}$. The returned object is of type [replab.PermutationGroup](+replab.PermutationGroup)
and it proposes notably the [identity](+replab.PermutationGroup.identity), [compose](+replab.PermutationGroup.compose) and
[inverse](+replab.PermutationGroup.inverse) methods:

```{code-cell}
G = replab.S(3);
gh = G.compose(g, h)
gInv = G.inverse(g)
g_gInv = G.compose(g, gInv)
```
