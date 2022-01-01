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
# 5.4 Subrepresentations

Let $V = \mathbb{K}^D$ be the space on which a representation $\rho: G \to \operatorname{GL}(V)$ acts, with $\mathbb{K} = \mathbb{R}$ or $\mathbb{C}$.
An subspace $W$ of $V$ is invariant under $\rho$ if and only if: for all $\vec{w} \in W$ and $g \in G$, we have $\rho_g \vec{w} \in W$.

```{sidebar}
In most representation theory textbooks, including {cite:p}`Serre1977`, the authors assume right at the beginning that all representations are unitary.
Then, the invariant subspaces are singled out using orthonormal bases.
The approach we employ in RepLAB is more general as it works with non-unitary (sub)representations.
Working with non-unitary (sub)representations is particularly important when working in exact arithmetic.
```
In MATLAB/Octave it is customary to work with matrices and vectors. With $d$ the dimension of $W$, we identify $W \sim \mathbb{K}^d$.
It remains to define the relationship between $V$ and $W$.
For that purpose, we define two linear maps: the *injection map* $I: W \to V$ and the *projection map* $P: V \to W$.
The injection map is identified with a $D \times d$ matrix such that:

$$
\vec{w} \to \vec{v} = I \cdot \vec{w}
$$

injects a vector from the subspace in the larger parent space.
The projection map is identified with a $d \times D$ matrix such that

$$
\vec{v} \to \vec{w} = P \cdot \vec{v}.
$$

a vector of the parent space is projected into the subspace. The projector on the subspace is given by $\Pi = I \cdot P$.

In RepLAB, subrepresentations, of type [SubRep](+replab.SubRep) can be constructed in several ways:

* by providing the parent representation and the injection map,

* by computing the complement subrepresentation of a subrepresentation,

* by splitting a representation,

* by computing the irreducible decomposition of a representation.

Note that *similar representations*, already seen in the previous section, are a special case of subrepresentations where $D=d$ and the projection and injection maps are bijective.

In the examples below, we will work with the three-dimensional natural representation of $S_3$.

```{code-cell}
S3 = replab.S(3);
rep = S3.naturalRep
```

## Explicit subrepresentations

A subrepresentation can be explicitly constructed using the [subRep](+replab.Rep.subRep) method.
Given the natural representation of $S_3$, one can compute the trivial subrepresentation corresponding to the subspace spanned by the vector $I = (1,1,1)^\top$.

```{code-cell}
I = [1;1;1];
trivialSubRep = rep.subRep(I)
```

The injection and projection maps are available through the [injection](+replab.SubRep.injection) and [projection](+replab.SubRep.projection) methods.

In the example above, we see that the projection map was automatically computed:

```{code-cell}
trivialSubRep.projection
```

This projection map is computed in exact arithmetic, when the injection map is given in exact arithmetic as well.
This can slow down the computations considerably, however.

```{code-cell}
I = replab.cyclotomic([1;1;1]);
trivialSubRep = rep.subRep(I)
trivialSubRep.projection('exact')
```

If known, one can provide the projection map, either in exact or approximate form:

```{code-cell}
P = replab.cyclotomic('[1/3, 1/3, 1/3]');
trivialSubRep = rep.subRep(I, 'projection', P);
```

## Complement subrepresentation

Given a subrepresentation, one can compute the complement. Here, the trivial subrepresentation has dimension $d=1$, the parent representation has dimension $D=3$, so the complement has dimension $D-d = 2$.

The method name is [maschke](+replab.Rep.maschke) as it uses [Maschke's theorem](https://en.wikipedia.org/wiki/Maschke%27s_theorem) as a theoretical basis.

```{code-cell}
standardRep = rep.maschke(trivialSubRep)
```

## Splitting a representation

The [split](+replab.Rep.split) method enumerate all irreducible subrepresentations, without doing further processing.

```{code-cell}
rep.split
```

## Decomposing a representation (approximate)

```{sidebar}
The default decomposition algorithm is approximate, works for all compact groups, and is optimized for speed.
It can handle representations of dimension $> 10000$. For some groups and representations, it is able to exploit
the mathematical structure for optimization purposes.
```
More powerful than the [split](+replab.Rep.split) method, the [decomposition](+replab.Rep.decomposition) method computes a decomposition of a representation into isotypic components, identifying equivalent irreducible representations present.
The corresponding theory is discussed in Section 2.7 of {cite:p}`Serre1977`.

```{code-cell}
dec = rep.decomposition
```

The returned object is of type [Irreducible](+replab.Irreducible), and it contains isotypic [components](+replab.Irreducible.components) of type [Isotypic](+replab.Isotypic).
However, all these objects are subrepresentations in themselves, so the projection/injection methods can be called.

```{code-cell}
c1 = dec.component(1);
c2 = dec.component(2);
inj1 = c1.injection
inj2 = c2.injection
```

Isotypic components themselves can contain multiple copies of irreducible representations (for this example, a single copy!).

```{code-cell}
c1.irreps
```

## Refine subrepresentations

Given an inexact subrepresentation, one can ask RepLAB to refine the approximate injection and projection maps.

```{code-cell}
errBefore = c1.errorBound
refined = c1.refine;
errAfter = refined.errorBound
```

## Decomposing a representation (exact)

RepLAB was developed originally to work with approximate decompositions.
Later on, we added support for exact real and complex character tables.
However, RepLAB is unable to compute those character tables by itself, and relies either on precomputed data or known construction for families of groups.

To decompose a representation, one first needs to verify that the corresponding character table (real or complex), is available.

```{code-cell}
rep.group.realCharacterTable
```

Note that for some groups, only the complex character table is known; in those case, one can [complexify](+replab.Rep.complexification) a real representation before decomposing it.

The method call is [decomposition](+replab.Rep.decomposition) with an extra parameter:

```{code-cell}
dec = rep.decomposition('exact')
```

And then, the injection/projection maps can be recovered in exact arithmetic.

```{code-cell}
I = dec.injection('exact')
P = dec.projection('exact')
```

## Adding a group to the Atlas

If a group is not known in RepLAB, it is possible to add it to the Atlas, using a JSON interoperability format.
Group data can be exported from [GAP System](https://www.gap-system.org/).

First, one needs to install [GAP System](https://www.gap-system.org/) and set the [gapBinaryPath](+replab.+globals.gapBinaryPath) variable.

Then, one runs the [computeAndAdd](+replab.Atlas.computeAndAdd) method.

```
G = replab.PermutationGroup.of([2 3 1 4 5], [2 1 3 4 5], [1 2 3 5 4]);
replab.Atlas.computeAndAdd(G);
```

Before asking for the character table of that group, one needs to restart RepLAB, as of January 2022. This limitation may be lifted in the future.
