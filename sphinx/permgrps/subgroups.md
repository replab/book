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
# 2.4 Subgroups

We start with the symmetric group of degree $4$, the alternating group of degree $4$, and the cyclic group of order 4.

```{code-cell}
S4 = replab.PermutationGroup.symmetric(4);
A4 = replab.PermutationGroup.alternating(4);
C4 = replab.PermutationGroup.cyclic(4);
```

## Subgroup test

We can ask whether a group is a subgroup of another. Of course, both `A4` and `C4` are subgroups of `S4`.

But we remark that none of `A4` and `C4` is contained in the other.

```{code-cell}
A4.isSubgroupOf(C4)
C4.isSubgroupOf(A4)
```

## Group intersection

We just saw that `A4` and `C4` have a non-trivial intersection. Let us compute it.

```{code-cell}
A4.intersection(C4)
```

Observe that `C4` contains all cyclic shifts of the elements `[1 2 3 4]`; but only shifting by an even number of elements
leads to an even permutation. Thus the intersection contains two elements: the identity and the cyclic-shift-by-two `[3 4 1 2]`.

RepLAB can compute the intersection of arbitrary groups as long as they have the same *type*. For example, it would be an error to
compute the intersection of $S_4$ and $S_5$ defined as such:

```{code-cell}
:tags: ["raises-exception"]
S4 = replab.PermutationGroup.symmetric(4);
S5 = replab.PermutationGroup.symmetric(5);
S4.hasSameTypeAs(S5) % no! thus the following is an error
S4.intersection(S5)
```

## Subgroup leaving vector invariant

Permutations act on vectors by permuting their coordinates. For example, given a row or column vector $\vec{v}$:

```{code-cell}
h = [2 3 4 1];
v = [1.3 2.3 2.3 1.3];
v1 = v(h)
```

```{sidebar}
We can write `v2(h) = v` as well. For invariance under permutation, the choice does not matter.
Formally, only `v2`
corresponds to the [left action](https://en.wikipedia.org/wiki/Group_action#Left_group_action) of `h` on `v`.
We want a left action because of how we defined permutation composition.
```
Given a group $G$, we are now looking for the subgroup of $G$ that leaves $\vec{v}$ invariant under permutation.
This can be readily computed using the [vectorStabilizer](+replab.PermutationGroup.stabilizer) method.

In the present case, this will be the [group of order four](https://groupprops.subwiki.org/wiki/Klein_four-group) that contains:

* the identity,
* the permutation of the first and last element,
* the permutation of the two middle elements,
* the permutation that swaps the first/last, and the two middle elements at the same time.

```{code-cell}
G = S4.vectorStabilizer(v)
```

One can of course start with another group than the symmetric group, and compute its subgroup leaving $\vec{v}$ invariant.
If one starts with the alternating group, there is only one non-trivial element that satisfies the requirement.

```{code-cell}
H = A4.vectorStabilizer(v)
```

## Setwise stabilizer

The setwise stabilizer is the subgroup that leaves a subset of the integer $1, \ldots, n$ invariant, while not preserving
necessarily their place inside the set.
If we start from the group of all permutations acting on four elements, and ask that the first two elements stay in the first
two positions, we can swap the first two elements, swap the last two elements, or do both.

```{code-cell}
S4.setwiseStabilizer([1 2])
```

## Pointwise stabilizer

The pointwise stabilzier is the subgroup that leaves every point of a set in place. If we start from the group of all
permutations acting on four elements, and ask that the first two elements stay in place, we can only swap the two last
elements.

```{code-cell}
S4.pointwiseStabilizer([1 2])
```

## Partition stabilizer

There are several conflicting notions of a *partition* in discrete mathematics. Here, a [Partition](+replab.Partition) is
the description of the set $\{1,\ldots,n\}$ as the union of disjoint subsets.

A partition can be created from blocks.

```{code-cell}
P = replab.Partition.fromBlocks({[1 2] [3 4]})
```

Then, we can ask for the unordered partition stabilizer, i.e. the subgroup of a group that preserves the partition structure,
but without keeping the blocks at their place.
For the partition above, that means we can reorder the elements inside a block, and permute blocks of the same size.

```{code-cell}
S4.unorderedPartitionStabilizer(P)
```
