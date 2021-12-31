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
# 5.1 Constructing representations

Those representations can be constructed on a variety of groups.

## Trivial representation

This representation always maps all group elements to the identity matrix.
It can be constructed for any compact group.
One picks the field (`'R'` or `'C'`) and the dimension.

```{code-cell}
S3 = replab.S(3);
rep = S3.trivialRep('R', 3)
```

Not very interesting in itself, the trivial representation is useful as part of larger constructions.

## By images of generators

For finite groups, we define representations from images of the generators.
For example, the *sign* representation of a permutation is one-dimensional, and the images are $1$ for even permutations, $-1$ for odd permutations.
The sign of a transposition is always odd, so, by picking the generators `[2 1 3]` and `[1 3 2]`, we construct the sign representation of $S_3$ pretty easily.

```{code-cell}
S3 = replab.S(3);
rep = S3.repByImages('R', 1, 'preimages', {[2 1 3], [1 3 2]}, 'images', {[-1], [-1]})
rep.image([2 3 1])
```

While RepLAB has experimental support for inexact representations, it is best to provide exact images.
If the images have integer entries, it is sufficient to provide standard MATLAB/Octave floating-point matrices.
Beyond that, RepLAB supports images in the cyclotomic field, and those need to be encoded in a particular way
(we do not support the Symbolic Toolbox of either MATLAB or Octave).

The simplest is to provide a [cyclotomic](+replab.cyclotomic) matrix constructed from a string representation, taking care to separate the columns with commas.

```{code-cell}
S3 = replab.S(3);
img_231 = replab.cyclotomic('[-1/2, 3/4; -1, -1/2]');
img_213 = replab.cyclotomic('[1, 0; 0, -1]');
rep = S3.repByImages('R', 2, 'preimages', {[2 3 1], [2 1 3]}, 'images', {img_231, img_213})
rep.image([2 3 1])
```

To check whether the representation is defined correctly, one can simply run a few randomized checks.

```{code-cell}
rep.check
```

## Natural/defining representations

Permutation groups have a *natural representation* that permutes Euclidean coordinates.
While there are two choices on how to encode a permutation as a permutation matrix, there is only one choice that obeys $\rho_{g \cdot h} = \rho_g \cdot \rho_h$, which is the one that RepLAB provides.

```{code-cell}
S3 = replab.S(3);
rep = S3.naturalRep;
rep.image([2 3 1])
```

Classical compact matrix groups have a *defining representation*, which simply returns the matrix element.

```{code-cell}
U2 = replab.U(2);
rep = U2.definingRep;
g = U2.sample
img = rep.image(g)
```

## Irreducible representations of $S_n$

The symmetric group provides three constructions of the irreducible representations of the symmetric group.
Those irreducible representations are indexed by Young diagrams, which are simply written as integer row vectors.

```{code-cell}
S3 = replab.S(3);
youngDiagram = [2 1];
repSpecht = S3.irrep(youngDiagram, 'specht');
repSeminormal = S3.irrep(youngDiagram, 'seminormal');
repOrthogonal = S3.irrep(youngDiagram, 'orthogonal');
g = [2 3 1];
imgSpecht = repSpecht.image(g, 'exact')
imgSeminormal = repSeminormal.image(g, 'exact')
imgOrthogonal = repOrthogonal.image(g, 'exact')
```
