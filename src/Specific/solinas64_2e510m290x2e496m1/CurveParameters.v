Require Import Crypto.Specific.Framework.RawCurveParameters.
Require Import Crypto.Util.LetIn.

(***
Modulus : 2^510 - 290*2^496 - 1
Base: 51
***)

Definition curve : CurveParameters :=
  {|
    sz := 10%nat;
    base := 51;
    bitwidth := 64;
    s := 2^510;
    c := [(1, 1); (290, 2^496)];
    carry_chains := Some [[8; 9]; [9; 0; 1; 2; 3; 4; 5; 6; 7; 8]; [9; 0]]%nat;

    a24 := None;
    coef_div_modulus := Some 2%nat;

    goldilocks := Some false;
    montgomery := false;
    freeze := Some true;
    ladderstep := false;

    mul_code := None;

    square_code := None;

    upper_bound_of_exponent := None;
    allowable_bit_widths := None;
    freeze_extra_allowable_bit_widths := None;
    modinv_fuel := None
  |}.

Ltac extra_prove_mul_eq _ := idtac.
Ltac extra_prove_square_eq _ := idtac.