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
# 3. Abstract groups

In a precedent chapter, we constructed the following permutation group:

```{code-cell}
h1 = [2 1 3 4];
h2 = [3 4 1 2];
H = replab.PermutationGroup.of(h1, h2)
```

...which is recognized by RepLAB as the [dihedral group of order 8](https://groupprops.subwiki.org/wiki/Dihedral_group:D8). And indeed, both groups are isomorphic:

```{code-cell}
D = replab.D(4);
H.isIsomorphicTo(D)
```

```{sidebar}
Due to RepLAB's internal algorithms, abstract groups work well for group orders in the thousands, not more.
```
RepLAB provides abstract groups to define groups in a way that is independent from a particular realization (permutation group, matrix group, etc).
If we look at the page describing our [dihedral group](https://groupprops.subwiki.org/wiki/Dihedral_group:D8), the following presentation is given:

$$
\left \langle x,a \middle | a^4 = x^2 = 1, x a x^{-1} = a^{-1} \right \rangle
$$

Informally, a *presentation* provides a list of generators, here $x$ and $a$, then a list of relations that those
generators satisfy. In RepLAB, the identity is written $1$, but other sources will use either $e$ or id.
The dihedral group of degree 4 and order 8 is the symmetry group of the square. The element $a$ is the rotation
by $90^\circ$, and of course applying it four times puts the square back in its original position ($a^4 = 1$).
The second generator $x$ is the mirror symmetry, and applying it twice produces the identity ($x^2 = 1$).
The last relation explains that doing a $90^\circ$ rotation sandwiched between two mirror operations is the same
as rotating in the other direction.

## Constructing abstract groups

How do we construct such a group in RepLAB? The easiest way is by providing the presentation itself.

```{code-cell}
A = replab.AbstractGroup.fromPresentation('< x, a | a^4 = x^2 = 1, x a x^-1 = a^-1 >')
```

```{note}
This section is incomplete.

Look at [the issue on GitHub](https://github.com/replab/book/issues/2) to know what to contribute.
