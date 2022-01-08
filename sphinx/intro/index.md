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

# 1. Introduction

Group theory is often considered an abstract topic and as a result is seldom used, or even taught, outside strictly theoretical contexts. Yet symmetries are universal and very concrete phenomenons, present in numerous fields.

By its constructive and interactive nature, RepLAB provides a simple way to modelize groups and representations. It makes it a good tool to learn these topics through exploration without limited prior knowledge.

The purpose of this book is to introduce the basic ingredients of RepLAB. Ultimately, this book will be usable as an introduction to group theory and representation theory.

## 1.1 Structure of the book

The book is structured in thematic chapters, which are accessible on the left menu. The first chapters describe groups from various perspectives. First, [finite permutation groups](../permgrps/index.md) are presented, followed by [abstract groups](../absgrps/index.md). Then, [finite and continuous matrix groups](../matgrps/index.md) are introduced. Finally, the text turns to the fruitful topic of [group representations](../reps/index.md).


## 1.2 Installing RepLAB

* We assume RepLAB has been installed, see the [installation instructions](https://replab.github.io/web/tutorials/installation.html) for more details.

* The library is initialized by running the command `replab_init` in the main replab folder




```{code-cell}
run ../../external/replab/replab_init.m
```

## 1.3 Programming style

RepLAB follows an object-oriented architecture. This allows the creation of new group and representations by simple combination of existing objects.

## 1.4 Help system

RepLAB comes with an integrated help system, accessible through the command `help`. Information on any RepLAB object, class and function is accessible in this way:

```{code-cell}
:tags: [remove-cell]

help replab
```

```{code-cell}
help replab.S
```

This help is fully interactive, allowing for an easy exploration of RepLAB material.

See also the dedicated [blog post](https://replab.github.io/web/blog/20200123-RepLAB-website-live.html) for more details.
