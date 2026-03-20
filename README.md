This esolang turned out to be a bit of a disaster. I'm planning to push some major fixes as soon as possible.

where is my stack
H input : ++--1 5 ?r=^

output : H

Fibonacci sequence

input : ++++++++++^

output : 1 1 2 3 5 8 13 21 34 55 89 144

---

# Whereismystack (Language Specification)

**Whereismystack** is a stack-based esoteric programming language that challenges the programmer to manipulate a string-array memory. Unlike traditional stack languages, its output is determined by a unique "Last-Two-Digits" consolidation rule, where only the final part of a concatenated memory string is preserved.

---

## Architecture

* **Memory (Stack):** A dynamic array of strings, initialized as `["1", "1"]`.
* **Output Buffer:** A separate integer array that stores values processed by the `=` operator.
* **Execution:** The interpreter processes each line independently, resetting the memory to its initial state for every new line.

---

## Commands

| Command | Name | Description |
| :--- | :--- | :--- |
| `+` | **Add** | Adds the last two elements from memory and pushes the result back. |
| `-` | **Sub** | Subtracts the top element from the second-to-last element. If the result is negative, the absolute value is pushed. |
| `*` | **Mul** | Multiplies the last two elements and pushes the result. |
| `/` | **Div** | Divides the second-to-last element by the top element. Division by zero terminates the program. |
| `=` | **Consolidate** | 1. Concatenates all strings in memory into one.<br>2. Takes the **last two characters**, converts them to an integer, and applies **modulo 128**.<br>3. Pushes this integer to the **Output Buffer**.<br>4. Resets memory to `["1", "1"]`. |
| `MN?` | **Range Combine** | Accesses a predefined sequence from index `M` to `N-1`. Sums these values into the memory state. The result **modulo 128** is pushed to memory. (Constraint: `N - M ≥ 2`). |
| `r` | **Reverse** | Swaps the positions of the top and second-to-last elements. |
| `^` | **Print/Flush** | **If after `=`**: Prints the Output Buffer as ASCII characters.<br>**Otherwise**: Dumps raw memory elements as literals. |

---

## Implementation Details

* **Initial State:** Every line starts with `memory = {"1", "1"}`.
* **Numeric Conversion:** Strings are converted to integers for calculation and back to strings for storage.
* **ASCII Standard:** All conversions follow the 7-bit standard (0-127) via modulo 128.
* **Core Mechanic:** The "Last Two Digits" logic is the primary way to generate specific ASCII values.

---

## Examples

### 1) Printing "H"
* **Input:** `++--? 1 5 r=^`
* **Output:** `H`
* *Note: The range and arithmetic operations result in the value 72 (ASCII for 'H') being consolidated.*

### 2) Fibonacci Sequence
* **Input:** `+++++++++++^`
* **Output:** `1 1 2 3 5 8 13 21 34 55 89 144`
* *Note: Since there is no `=` before the `^`, it performs a raw memory dump.*

---

## 🔗 Links
* **Compiler/Source:** [GitHub - whereismystack](https://github.com/realgitman1/whereismystack/tree/master)
esolang wiki :  [https://esolangs.org/wiki/Whereismystack]
---
**Categories:** `Stack-based` | `Esoteric languages` | `String-based`

Would you like me to help you write a specific script or explain how a certain mathematical value would be processed through the "Last-Two-Digits" rule?
