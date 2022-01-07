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
# 5.2 Representation properties

In the explanations below, we use the standard representation of $S_3$, which corresponds to the 2D representation of $S_3$ permuting the vertices of a triangle.

```{code-cell}
S3 = replab.S(3);
rep = S3.irrep([2 1], 'seminormal');
```

## Approximate images

For efficiency, RepLAB returns approximate images by default.

```{code-cell}
rep.image([2 3 1])
```

This call is equivalent to the following, where the second argument is the type of image returned.

```{code-cell}
rep.image([2 3 1], 'double');
```

For some sparse representations, RepLAB can return sparse matrices.

```{code-cell}
trep = S3.trivialRep('R', 3);
trep.image([2 3 1], 'double/sparse')
```

The method [errorBound](+replab.Rep.errorBound) provides an estimate of the maximal error of these approximate images.

```{code-cell}
rep.errorBound
```

## Exact images

Some representations can provide exact images of type [cyclotomic](+replab.cyclotomic).
The method [isExact](+replab.Rep.isExact) returns whether a given representation is able to compute exact images.

```{code-cell}
canProvideExactImages = rep.isExact
rep.image([2 3 1], 'exact')
```

## Unitary representations

One can check whether a representation is unitary (i.e. whether $\rho_g^{-1} = \rho_g^\dagger$) through the property [isUnitary](+replab.Rep.isUnitary).
If RepLAB knows a representation is unitary, faster and more robust algorithms can be used.

```{code-cell}
rep.isUnitary
```

This property should be detected at construction, but can be enforced if necessary.

```{code-cell}
C3 = replab.C(3);
repC = C3.repByImages('R', 3, 'preimages', {[2 3 1]}, 'images', {[0 1 0; 0 0 1; 1 0 0]}, 'isUnitary', true);
repC.isUnitary
```

## Kernel

The kernel of a representation $\rho : G \to \operatorname{GL}(\mathbb{K}^D)$ is the subgroup of $G$ that maps to the identity.
It can be computed through the method [kernel](+replab.Rep.kernel).

```{code-cell}
signRep = S3.signRep;
signRep.kernel
```

## Irreducibility

An irreducible representation is a representation that has no trivial subrepresentation (see [dedicated section](subrepresentations.md)). This property can be checked through the method [isIrreducible](+replab.Rep.isIrreducible).

```{code-cell}
rep.isIrreducible
```

## Frobenius-Schur indicator

For representations over $\mathbb{R}$, the [Frobenius-Schur indicator](https://en.wikipedia.org/wiki/Frobenius%E2%80%93Schur_indicator) indicates the type of irreducible real representation, through the method [frobeniusSchurIndicator](+replab.Rep.frobeniusSchurIndicator).
It can be equal to $1$ (real-type), $0$ (complex-type representation) or $-2$ (quaternionic-type).

Here is an example of a quaternionic-type representation over $\mathbb{R}$.

```{code-cell}
Q = replab.QuaternionGroup;
rep = Q.naturalRep
rep.frobeniusSchurIndicator
```

Here is an example of a complex-type representation over $\mathbb{R}$.

```{code-cell}
C3 = replab.C(3);
rep = C3.standardRep
rep.frobeniusSchurIndicator
```
