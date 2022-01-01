5. Representations
==================

Let $V$ be a finite dimensional vector space over the real or complex numbers.
We identify $V$ respectively with $\mathbb{R}^D$ or $\mathbb{C}^D$.
Below, we write $\mathbb{K}$ for either of $\mathbb{R}$ or $\mathbb{C}$.

Let $G$ be a compact group (this family contains finite groups and the :ref:`continuous groups <continuous-groups>` that can be constructed in RepLAB).
A linear representation of a group $G$ is a map from the group to the group of invertible $D \times D$ matrices over $\mathbb{K}$.
We direct the reader to :cite:t:`Serre1977` for a gentle introduction to the topic.

RepLAB proposes ways to construct and manipulate representations.

* Some groups have natural representations: permutation groups act on Euclidean space coordinates, matrix groups provide ... matrices.

* Representations of finite groups are defined simply by providing the matrices corresponding to the images of the generators.

* Representations can be transformed by taking the complex conjugate, the dual representation, changing the underlying field.

* Representations can be combined by taking tensor products or writing direct sums.

* One can find and manipulate subrepresentations.

Those operations are described in the following sections.

.. toctree::
  :maxdepth: 1

  construction
  properties
  manipulation
  subrepresentations
