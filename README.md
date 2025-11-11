# AES-256-GCM Circom

A complete implementation of AES-256-GCM (Galois/Counter Mode) authenticated encryption in Circom for zero-knowledge proof applications.

## Background

This project is part of [zkWill](https://github.com/june-in-exile/zkWill), which implements sealed wills using zero-knowledge proofs. The zkWill project demonstrates how ZKPs can be used to create cryptographically sealed testaments that preserve privacy while ensuring verifiability.

For comprehensive test data and results related to AES-CTR and AES-GCM implementations, including performance benchmarks and validation tests, please refer to the [zkWill repository](https://github.com/june-in-exile/zkWill).

## Features

- **Full AES-256-GCM Support**: Complete implementation including encryption, decryption, and authentication
- **Multiple Key Sizes**: Support for AES-128, AES-192, and AES-256
- **Flexible Parameters**: Configurable plaintext, IV, and AAD (Additional Authenticated Data) lengths
- **Galois Field Arithmetic**: Optimized GF(2^128) multiplication for GHASH
- **Counter Mode**: Efficient CTR mode encryption/decryption
- **Documented**: Clear inline documentation for all components

## Installation

Clone or download this repository to your project:

```bash
git clone https://github.com/june-in-exile/aes256-gcm-circom.git
```

Or add it as a git submodule:

```bash
git submodule add https://github.com/june-in-exile/aes256-gcm-circom.git
```

Usage

Include the circuits in your Circom project using relative paths:

```circom
include "../aes256-gcm-circom/circuits/aesGcm/gcmEncrypt.circom";
```

Or compile with the -l flag to specify the library path:

```bash
circom your_circuit.circom -l ./aes256-gcm-circom/circuits -o ./build
```

## Constraints

Approximate constraint counts: (1 block = 16 bytes)

| Operation           | Key Size | Constraints per block |
| ------------------- | -------- | --------------------- |
| CTR Encrypt/Decrypt | 128-bit  | ~86K                  |
| CTR Encrypt/Decrypt | 192-bit  | ~100K                 |
| CTR Encrypt/Decrypt | 256-bit  | ~120K                 |
| GCM Encrypt/Decrypt | 128-bit  | ~294K                 |
| GCM Encrypt/Decrypt | 192-bit  | ~333K                 |
| GCM Encrypt/Decrypt | 256-bit  | ~394K                 |

## Dependencies

- `circomlib`: Standard Circom library
- `snarkjs`: Proof generation and verification

## References

- [NIST SP 800-38D](https://nvlpubs.nist.gov/nistpubs/Legacy/SP/nistspecialpublication800-38d.pdf) - GCM Specification
- [FIPS 197](https://nvlpubs.nist.gov/nistpubs/FIPS/NIST.FIPS.197.pdf) - AES Specification
- [Circom Documentation](https://docs.circom.io/)
