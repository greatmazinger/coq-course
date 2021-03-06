Load "ex6.v".

(** * Norm: Normalization of STLC *)

(** _Based on a chapter written and maintained by Andrew Tolmach_. *)
(* I recommend not looking at the chapter in SF, as it gives the whole
   proof away. *)

Definition halts (t:tm) : Prop := exists t', t ⇒* t' /\ value t'.

(** The logical relation we will use.
   Compare chapter 12 of Types and Programming Languages (Pierce).
*)
Fixpoint R (T:ty) (t:tm) : Prop :=
    match T with
      TBool         => t ⇒* ttrue \/ t ⇒* tfalse
    | TArrow T1 T2  => halts t /\ forall u, R T1 u -> R T2 (tapp t u)
    end.

Lemma R_halts : forall {T} {t}, R T t -> halts t.
Proof. destruct T; simpl; firstorder. Qed.

(** _Exercise 1_ (warm up): Show that the reduction relation is deterministic.
   This is a very strong property; one may want to do the proof with a non-deterministic
   reduction relation. *)
Lemma red_deterministic : forall t a b (r : t ⇒ a) (s : t ⇒ b), a = b.
Admitted.

(** _Exercise 2_: Show that [R] is preserved by the reduction relation, back and forth: *)
Lemma step_preserves_R : forall T t t', t ⇒ t' -> R T t -> R T t'.
Admitted.

Lemma step_preserves_R' : forall T t t', t ⇒ t' -> R T t' -> R T t.
Admitted.

(** _Exercise 3_: *)

(** We define the analogous [R] for substitutions: *)
Definition Rsubst (Γ : context) σ : Prop := forall x T, Γ x = Some T -> R T (σ x).

(** Show that [R] holds for all closed terms.
   For the induction to work, we need to consider a stronger property: *)
Lemma subst_R : forall Γ t T σ,
    Rsubst Γ σ ->
    Γ ⊢ t ∈ T ->
    R T (t.[σ]).
Admitted.

(** Then, proving [closed_R] is easy. *)
Lemma closed_R : forall t T, empty ⊢ t ∈ T -> R T t.
Admitted.

(** _Exercise 4_: Prove that the STλC is normalizing.
   You can do this exercise even before doing any of the earlier exercises.
 *)
Lemma normalization (t : tm) (T : ty) : empty ⊢ t ∈ T -> halts t.
Admitted.

(** _Exercise extra 1_: Strong normalization also! *)
Inductive strongly_normalizing : tm -> Prop :=
  | sn : forall t, (forall t', t ⇒ t' -> strongly_normalizing t') -> strongly_normalizing t.

Lemma strong_normalization : forall t T, empty ⊢ t ∈ T -> strongly_normalizing t.
Admitted.

(* BONUS: Extend the logical relation and the rest of the proof to work with sum types.
<<
       t ⇒* inl v    R A v
       -------------------
          R (Sum A B) t

       t ⇒* inr v    R B v
       -------------------
          R (Sum A B) t
>>
*)
