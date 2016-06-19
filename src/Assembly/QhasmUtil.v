
Require Import ZArith NArith NPeano.
Require Import QhasmCommon.
Require Export Bedrock.Word.

Delimit Scope nword_scope with w.
Local Open Scope nword_scope.

Notation "& x" := (wordToN x) (at level 30) : nword_scope.
Notation "** x" := (NToWord _ x) (at level 30) : nword_scope.

Section Util.
  Definition convS {A B: Set} (x: A) (H: A = B): B :=
    eq_rect A (fun B0 : Set => B0) x B H.

  Definition high {k n: nat} (p: (k <= n)%nat) (w: word n): word k.
    refine (split1 k (n - k) (convS w _)).
    abstract (replace n with (k + (n - k)) by omega; intuition).
  Defined.

  Definition low {k n: nat} (p: (k <= n)%nat) (w: word n): word k.
    refine (split2 (n - k) k (convS w _)).
    abstract (replace n with (k + (n - k)) by omega; intuition).
  Defined.

  Definition extend {k n: nat} (p: (k <= n)%nat) (w: word k): word n.
    refine (convS (zext w (n - k)) _).
    abstract (replace (k + (n - k)) with n by omega; intuition).
  Defined.

  Definition shiftr {n} (w: word n) (k: nat): word n :=
    match (le_dec k n) with
    | left p => extend p (high p w)
    | right _ => wzero n
    end.

  Definition mask {n} (k: nat) (w: word n): word n :=
    match (le_dec k n) with
    | left p => extend p (low p w)
    | right _ => w
    end.

  Definition overflows {n} (out0 out1: word n) :
      {(&out0 + &out1 >= Npow2 n)%N} + {(&out0 + &out1 < Npow2 n)%N}.
    refine (
      let c := ((& out0)%w + (& out1)%w ?= Npow2 n)%N in
      match c as c' return c = c' -> _ with
      | Lt => fun _ => right _
      | _ => fun _ => left _
      end eq_refl); abstract (
        unfold c in *; unfold N.lt, N.ge;
        rewrite _H in *; intuition; try inversion H).
  Defined.

  Definition break {n} (m: nat) (x: word n): word m * word (n - m).
    refine match (le_dec m n) with
    | left p => (extend _ (low p x), extend _ (@high (n - m) n _ x))
    | right p => (extend _ x, _)
    end; try abstract intuition.

    replace (n - m) with O by abstract omega; exact WO.
  Defined.

  (* Option utilities *)
  Definition omap {A B} (x: option A) (f: A -> option B) :=
    match x with | Some y => f y | _ => None end.

  Notation "A <- X ; B" := (omap X (fun A => B)) (at level 70, right associativity).

End Util.

Close Scope nword_scope.