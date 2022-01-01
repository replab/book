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
# 5.3 Representation manipulation

In the explanations below, we use the standard representation of $S_3$, which corresponds to the 2D representation of $S_3$ permuting the vertices of a triangle.

```{code-cell}
S3 = replab.S(3);
rep = S3.irrep([2 1], 'seminormal');
```

## Change of basis

From a representation, one can return a similar representation under a change of basis: $\rho_g \to T \rho_g T^{-1}$

```{code-cell}
T = [1 0; 0 -1];
sim = rep.similarRep(T)
```

The original representation is called the [parent](+replab.SubRep.parent), and the change of basis matrix is available through the [basis](+replab.SubRep.basis) method.

At construction, one can provide the inverse, if known, so it does not need to be recomputed.

```{code-cell}
T = [1 0; 0 -1];
rep.similarRep(T, 'inverse', inv(T))
```

## Unitarize a representation

Given a non-unitary representation, we can automatically construct a unitary similar representation.
The method [unitarize](+replab.Rep.unitarize) computes this similar representation.

```{code-cell}
uni = rep.unitarize;
basis = uni.basis
uni.isUnitary
```

## Complexified representation

Given a representation over $\mathbb{R}$, one can easily construct a representation over $\mathbb{C}$ by extending the field of scalars through the [complexification](+replab.Rep.complexification) method.

```{code-cell}
rep.complexificiation
```

## Conjugate representation

Given a representation, one can compute the conjugate representation; of course this has an effect only on complex-valued representations.
The standard [conj](+replab.Rep.conj) syntax is available for that purpose.

```{code-cell}
C4 = replab.C(4);
repC4 = C4.repByImages('C', 1, 'preimages', {[2 3 4 1]}, 'images', {[1i]});
img = repC4.image([2 3 4 1])
conjRep = conj(repC4);
conjImg = conjRep.image([2 3 4 1])
```

## Dual representation

The dual representation has images that are the transpose of the inverse of the original images; it is computed through the [dual](+replab.Rep.dual) method.

```{code-cell}
img = rep.image([2 3 1]);
img1 = inv(img).'
dualRep = dual(rep);
img2 = dualRep.image([2 3 1])
```

## Tensor product and powers

Given two (or more!) representations of the same group, one can compute the tensor product.
For that purpose, we prodive an overload of the standard [kron](+replab.Rep.kron) MATLAB/Octave syntax.

```{code-cell}
rep2 = kron(rep, rep)
rep2.image([2 3 1])
```

When computing the tensor power, we have a dedicated method [tensorPower](+replab.Rep.tensorPower).

```{code-cell}
rep2 = rep.tensorPower(2);
rep2.image([2 3 1])
```

## Direct sum

Given two (or more) representations, one can compute the direct sum, whose images are block-diagonal matrices;
this is provided through the overload of the standard [blkdiag](+replab.Rep.blkdiag) syntax.


```{code-cell}
rep2 = blkdiag(rep, rep)
rep2.image([2 3 1])
```
