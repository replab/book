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
# 2.3 Computing group properties

Let us construct a few example groups.
```{code-cell}

h1 = [2 1 3 4];
h2 = [3 4 1 2];
D8 = replab.PermutationGroup.of(h1, h2);
H.order
```

## Group order

We already
