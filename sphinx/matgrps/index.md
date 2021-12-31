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

# 4. Matrix and continuous groups

```{sidebar}
RepLAB's algorithms {cite:p}`Rosset2021a` handle any compact group, given an oracle that samples from the Haar measure.
One then simply subclasses [CompactGroup](+replab.CompactGroup).
However, it is easier to work with the primitives RepLAB already provides.
```
We now move to symmetries of the Euclidean space, including continuous symmetries.
RepLAB provide two matrix group types.

* Finite matrix groups are described by [MatrixGroup](+replab.MatrixGroup), and their coefficients must necessarily
  be taken from the [field of cyclotomics](https://en.wikipedia.org/wiki/Cyclotomic_field). Their elements are
  cyclotomic matrices of type [cyclotomic](+replab.cyclotomic). RepLAB provides an implementation of exact arithmetic
  in the field of cyclotomics using a Java library.

* Classical compact Lie groups are provided by [ClassicalCompactGroup](+replab.ClassicalCompactGroup). Their elements
  are matrices with floating-point coefficients, and thus all the operations on those group elements are approximate.

## Finite, exact, matrix groups

Here, we define a finite matrix group with two generators. The first one is a permutation matrix, and can thus be
represented exactly using floating-point numbers (i.e, the standard MATLAB/Octave notation).
The second, however, cannot, and we need to construct an exact [cyclotomic](+replab.cyclotomic) matrix. Note that
the argument to [cyclotomic](+replab.cyclotomic) is given as a string, and it will be parsed inside RepLAB.

```{code-cell}
M1 = [0 1; 1 0];
M2 = replab.cyclotomic('[1/sqrt(2), 1/sqrt(2); 1/sqrt(2), -1/sqrt(2)]');
G = replab.MatrixGroup(2, {M1, M2})
```

One can use most of the methods already discussed for [permutation groups](/permgrps) on matrix groups.

```{code-cell}
M3 = replab.cyclotomic('[i, 0; 0, 1]');
H = replab.MatrixGroup(2, {M3});
G_inter_H = G.intersection(H)
```

Finite, exact, matrix groups are provided for convenience and pedagogical purposes. As of December 2021, they are
implemented using brute-force enumeration algorithms, and are limited to group orders in the low hundreds.

## Continuous groups

The following continuous groups are available in RepLAB.

* Over real $n \times n$ matrices, the orthogonal group [O(n)](+replab.O) and the special orthogonal [SO(n)](+replab.SO) group.

* Over complex $n \times n$ matrices, the unitary group [U(n)](+replab.U) and the special unitary [SU(n)](+replab.SU) group.

* Over quaternionic $n \times n$ matrices, the compact symplectic group [Sp(n)](+replab.Sp). Its elements are quaternionic matrices
  of type [replab.H](+replab.H). But usually, one works with an encoding of its elements over the complex numbers.

By themselves, those groups provide one useful operation: sampling from their Haar measure.

For the (special) orthogonal group:

```{code-cell}
O3 = replab.O(3);
sample_O3 = O3.sample
SO3 = replab.SO(3);
sample_SO3 = SO3.sample
det_SO3 = det(sample_SO3)
```

For the (special) unitary group:

```{code-cell}
U2 = replab.U(2);
sample_U2 = U2.sample
SU2 = replab.SU(2);
sample_SU2 = SU2.sample
det_U2 = det(sample_U2)
det_SU2 = det(sample_SU2)
```

For the compact symplectic group:

```{code-cell}
Sp2 = replab.Sp(2);
sample_Sp2 = Sp2.sample
```

We will find more applications of continuous groups when we study group representations.
