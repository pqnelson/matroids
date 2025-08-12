This is an exploration of formalizing some aspects of Matroid theory
which were formalized in the forthcoming article "1-, 2-, and 3-Sums
of Regular Matroids are Regular — Formally Verified in Lean 4" by
Martin Dvorak, Tristan Figueroa-Reid, Rida Hamadani, Byung-Hak Hwang,
Evgenia Karunus, Vladimir Kolmogorov, Alex Meiburg, Peter Nelson, Mark
Sandey, Ivan Sergeev.

The [Lean formalization](https://github.com/Ivan-Sergeyev/seymour/)
and [project page](https://ivan-sergeyev.github.io/seymour/) are a
useful comparison.

# Differences in the Formalization

If I "blindly" translated the definitions from the paper, I would have
the following:

```mizar
definition
  let F be non empty 1-sorted;
  structure StandardRepStr over F
  (# X -> Nat,
     Y -> Nat,
     B -> Matrix of the X, the Y, F #)
end;

definition
  let F be non empty 1-sorted;
  let IT be StandardRepStr over F;
  attr IT is StandardRep-like means
  the X of IT <> the Y of IT;
end;

registration
  let F be non empty 1-sorted;
  cluster StandardRep-like for StandardRepStr;
  existence; :: omit the proof
end;

definition
  let F be non empty 1-sorted;
  mode StandardRep is StandardRep-like StandardRepStr;
end;
```

This is the idiomatic Mizar translation of the definition found in the
beginning of Section 4 of the paper (when we define a new gadget, we
have a structure with suffix `Str` and then the axioms it satisfies
are attributes, usually one of them is called `Gadget-like` where
"Gadget" here is a placeholder like "foo" or "bar" among programmers).

I must confess some discomfort as a group theorist: for us, we always
speak of "a representation of G". To speak of "a representation"
without parametrizing it by a group, it's like a number theorist
seeing "Let p be a composite number". This is what prompted me to
consult Oxley's book.

## Outline of notions formalized

The formalization follows Oxley:
1. The predicate `are_isomorphic` is formalized as an equivalence
   relation on matroids
2. The term `vector_matroid Mat` produces a Matroid from the matrix
   `Mat`. The underlying set is the finite set of numbers corresponding
   to the column indices of `Mat`, the set of independent matrices
   corresponds to the sets of indices of linearly-independent columns
   of `Mat`
3. The attribute ["adjective"] `R-representable` is introduced on
   Matroids when there is a matrix `Mat` over R such that
   `vector_matroid Mat` is isomorphic to the given matroid (using the
   equivalence relation formalized back from item (1)).
4. The attribute `M-representation` asserts a matrix is a
   representation of `M` (i.e., its vector matroid is isomorphic to `M`)
5. The mode ["type"] `Representation of M` is defined as an
   abbreviation for `M-representation Matrix of R`. This addresses
   concerns that the Mizar formalization is somehow "different" than
   the Lean formalization: a Representation of M _really is a Matrix_
   which just so happens to satisfy some property.
6. The attribute `full` is defined for `Representation of M` for when
   the representation can be written as $[I_{r} | D]$ in block form.
7. The attribute `standard` is defined for `Representation of M` for
   when the representation (call it $D$) is such that $[I_{r} | D]$ is
   a full representation of `M`.
   
Note the divergence is caused by Mizar's classical semantics: a type
cannot be empty in Mizar, otherwise we would end up with a [free logic](https://plato.stanford.edu/entries/logic-free/)
(not a classical logic). This would result in surprising consequences
discussed before on the Mizar mailing list (e.g., Freek Wiedijk's 
[Why do Mizar types need to be non empty?](http://mizar.uwb.edu.pl/forum/archive/0210/msg00001.html),
[Re: weak types](http://mizar.uwb.edu.pl/forum/archive/0311/msg00002.html),
and
[Once more, empty types](http://mizar.uwb.edu.pl/forum/archive/0711/msg00003.html)).

This is why a "Representation of [a matroid]" requires the assumption
tha the matroid is representable (otherwise the type would be
empty). That forced me to introduce the attribute `R-representable`
for matroids.

(Why is it an attribute and not a predicate `is_representable_over R`?
We can take advantage of the attribute system of Mizar, and register
things like vector matroids over R are always R-representable. This
would be impossible if we formalized the notion using predicates.)


## Oxley's Full Representation Theorem

The first difference is in Oxley's full representation
theorem (in the Mizar formalization, it is `theorem ThOxleyFullRep:`).
Basically: given an $m\times n$ matrix $A$ with entries in a
field $\mathbb{F}$, and any basis $G$ of the vector matroid of $A$,
there exists a sequence of elementary transformations
$\mathcal{F}_{i}$ such that 

$`(\prod_{i}\mathcal{F}_{i})A = \begin{bmatrix}S\\ \mathbf{0}_{m-|G|,n}\end{bmatrix}`$

where $S$ is a $|G|\times n$ matrix which is a standard representation
of the vector matroid of $A$, and $\mathbf{0}_{m-|G|,n}$ is an
$(m-|G|)\times n$ zero matrix.

Moreover, each $\mathcal{F}_{i}$ is an elementary row operation (i.e.,
swapping two rows, multiplying a row by a nonzero scalar, or adding a
nonzero multiple of one row to another).

Note that, stated as such, we make explicit that $S$ may have fewer
than $m$ rows (whereas Oxley left it implicitly understood).
