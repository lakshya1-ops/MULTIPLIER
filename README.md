# Parameterized Complex Multiplier

Parameterized complex number multiplier implemented in Verilog using:
- Half Adders
- Full Adders
- Array Multiplier architecture
- Structural arithmetic composition

The design supports scalable bit-width operation using Verilog parameters and performs complex multiplication using four parallel array multipliers.

---

# Complex Multiplication Equation

For two complex numbers:

\[
(a + jb)(c + jd)
\]

The output is:

\[
(ac - bd) + j(ad + bc)
\]

Implemented internally as:

| Signal | Operation |
|---|---|
| m | a_real × b_real |
| l | a_img × b_img |
| o | a_real × b_img |
| p | a_img × b_real |

Final outputs:

\[
\text{real\_out} = m - l
\]

\[
\text{img\_out} = o + p
\]

---

# Design Features

- Parameterized architecture
- Structural array multiplier implementation
- Half adder and full adder based arithmetic
- Modular Verilog design
- Parallel multiplication datapaths
- RTL simulation and waveform verification
- GTKWave visualization support

---

# Architecture Overview

The design consists of:

1. Half Adder
2. Full Adder
3. Parameterized Array Multiplier
4. Complex Multiplier Top Module

Four array multipliers operate in parallel to compute intermediate multiplication terms.

---

# Module Hierarchy

```text
complex_multiplier
│
├── array_multiplier (a_real × b_real)
├── array_multiplier (a_img × b_img)
├── array_multiplier (a_real × b_img)
└── array_multiplier (a_img × b_real)
