import Mathlib.Data.ENat.Basic

inductive EFin : ℕ∞ → Type where
  | fin (i : ℕ) (lt : i < n) : EFin n
  | inf (i : ℕ) : EFin ⊤

namespace EFin
  @[inline, simp]
  def mk {n : ℕ∞} (i : ℕ) (lt : i < n) : EFin n :=
    match n with
    | some _ => .fin i (WithTop.some_lt_some.1 lt)
    | ⊤      => .inf i

  @[inline, simp]
  def val : EFin n → ℕ
    | .fin i _ => i
    | .inf i   => i

  attribute [coe] EFin.val

  @[inline, simp]
  def lt (i : EFin n) : i.val < n :=
    match i with
    | .fin _ lt => WithTop.coe_lt_coe.2 lt
    | .inf i    => WithTop.coe_lt_top i

  @[inline, simp]
  def succ : EFin n → EFin (Order.succ n)
    | .fin i lt => fin i.succ (Nat.succ_lt_succ lt)
    | .inf i    => inf i.succ

  @[inline, simp]
  def castInfty {n : ℕ} (i : EFin n) : EFin ⊤ :=
    match i with | .fin i _ => .inf i

  @[inline, simp]
  def castLT {m : ℕ} {n : ℕ∞} (h : m < n) (i : EFin m) : EFin n :=
    match n with
    | some _ => match i with | .fin i lt => fin i (Nat.lt_trans lt (WithTop.some_lt_some.1 h))
    | ⊤      => i.castInfty

  @[inline, simp]
  def castLT' {m n : ℕ} (i : EFin m) (h : i.val < n) : EFin n :=
    match i with | .fin i _ => (fin i h : EFin n)

  @[inline, simp]
  def castSucc (i : EFin n) : EFin (Order.succ n) :=
    match i with
    | .fin i lt => fin i (Nat.lt_succ_of_lt lt)
    | .inf i    => inf i

  @[inline, simp]
  def zero : EFin (Order.succ n) :=
    match n with
    | some _ => .fin 0 (Nat.zero_lt_succ _)
    | ⊤      => .inf 0

  @[inline, simp]
  def zero' (h : 0 < n) : EFin n :=
    match n with
    | some _ => .fin 0 (WithTop.some_lt_some.1 h)
    | ⊤      => .inf 0

  @[inline, simp]
  def mkSucc (i : ℕ) : EFin (i.succ) :=
    .fin i (Nat.lt_succ_self i)

  instance : LT (EFin n) where
    lt i j := LT.lt i.val j.val

  instance : LE (EFin n) where
    le i j := LE.le i.val j.val

  @[inline, simp]
  def toFin {n : ℕ} (i : EFin (↑n)) : Fin n := by
    cases i with
    | fin i lt => exact ⟨i, lt⟩
end EFin
