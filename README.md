# AES-256-GCM Circom

A complete implementation of AES-256-GCM (Galois/Counter Mode) authenticated encryption in Circom for zero-knowledge proof applications.

## Features

- **Full AES-256-GCM Support**: Complete implementation including encryption, decryption, and authentication
- **Multiple Key Sizes**: Support for AES-128, AES-192, and AES-256
- **Flexible Parameters**: Configurable plaintext, IV, and AAD (Additional Authenticated Data) lengths
- **Galois Field Arithmetic**: Optimized GF(2^128) multiplication for GHASH
- **Counter Mode**: Efficient CTR mode encryption/decryption
- **Well-Tested**: Comprehensive test suite with various configurations
- **Documented**: Clear inline documentation for all components

## Installation

```bash
npm install aes256-gcm-circom
```

Or using pnpm:

```bash
pnpm add aes256-gcm-circom
```

## Quick Start

### Basic Encryption

```circom
pragma circom 2.2.2;

include "aes256-gcm-circom/circuits/aesGcm/gcmEncrypt.circom";

template Main() {
    // Encrypt 16 bytes with AES-256, 12-byte IV, 0-byte AAD
    var keyBits = 256;
    var ivLength = 12;
    var textLength = 16;
    var aadLength = 0;

    signal input {byte} plaintext[textLength];
    input Word() key[8];  // 8 words for 256-bit key
    signal input {byte} iv[ivLength];
    signal input {byte} aad[aadLength];

    signal output {byte} ciphertext[textLength];
    signal output {byte} authTag[16];

    (ciphertext, authTag) <== GcmEncrypt(keyBits, ivLength, textLength, aadLength)(
        plaintext, key, iv, aad
    );
}

component main = Main();
```

### Basic Decryption

```circom
pragma circom 2.2.2;

include "aes256-gcm-circom/circuits/aesGcm/gcmDecrypt.circom";

template Main() {
    var keyBits = 256;
    var ivLength = 12;
    var textLength = 16;
    var aadLength = 0;

    signal input {byte} ciphertext[textLength];
    input Word() key[8];
    signal input {byte} iv[ivLength];
    signal input {byte} aad[aadLength];
    signal input {byte} authTag[16];

    signal output {byte} plaintext[textLength];
    signal output isValid;

    (plaintext, isValid) <== GcmDecrypt(keyBits, ivLength, textLength, aadLength)(
        ciphertext, key, iv, aad, authTag
    );
}

component main = Main();
```

## API Reference

### Main Templates

#### `GcmEncrypt(keyBits, ivLength, textLengthBytes, aadLengthBytes)`

Performs AES-GCM authenticated encryption.

**Parameters:**
- `keyBits`: AES key size (128, 192, or 256)
- `ivLength`: IV length in bytes (typically 12 for standard mode)
- `textLengthBytes`: Plaintext length in bytes
- `aadLengthBytes`: Additional authenticated data length in bytes

**Inputs:**
- `plaintext[textLengthBytes]`: Input plaintext
- `key[Nk]`: AES key (Nk = 4/6/8 for 128/192/256-bit keys)
- `iv[ivLength]`: Initialization vector
- `aad[aadLengthBytes]`: Additional authenticated data

**Outputs:**
- `ciphertext[textLengthBytes]`: Encrypted output
- `authTag[16]`: 128-bit authentication tag

#### `GcmDecrypt(keyBits, ivLength, textLengthBytes, aadLengthBytes)`

Performs AES-GCM authenticated decryption and verification.

**Parameters:** Same as `GcmEncrypt`

**Inputs:**
- `ciphertext[textLengthBytes]`: Input ciphertext
- `key[Nk]`: AES key
- `iv[ivLength]`: Initialization vector
- `aad[aadLengthBytes]`: Additional authenticated data
- `authTag[16]`: Authentication tag to verify

**Outputs:**
- `plaintext[textLengthBytes]`: Decrypted output
- `isValid`: 1 if authentication succeeds, 0 otherwise

### Component Templates

#### `CtrEncrypt(keyBits, textLengthBytes)`
Counter mode encryption (can also be used for decryption).

#### `EncryptBlock(keyBits)`
Single AES block encryption (16 bytes).

#### `GHash(numBlocks)` / `GHashOptimized(numBlocks)`
GHASH authentication function using Galois field arithmetic.

#### `GF128Multiply()` / `GF128MultiplyOptimized()`
Galois field GF(2^128) multiplication for GHASH.

#### `IncrementCounter()` / `IncrementCounterOptimized()`
Counter increment for CTR mode.

## Examples

### Encrypt with AAD

```circom
pragma circom 2.2.2;

include "aes256-gcm-circom/circuits/aesGcm/gcmEncrypt.circom";

template EncryptWithAAD() {
    var keyBits = 256;
    var ivLength = 12;
    var textLength = 32;
    var aadLength = 16;  // Include AAD

    signal input {byte} plaintext[textLength];
    input Word() key[8];
    signal input {byte} iv[ivLength];
    signal input {byte} aad[aadLength];  // Metadata to authenticate

    signal output {byte} ciphertext[textLength];
    signal output {byte} authTag[16];

    (ciphertext, authTag) <== GcmEncrypt(keyBits, ivLength, textLength, aadLength)(
        plaintext, key, iv, aad
    );
}

component main = EncryptWithAAD();
```

### Verify and Decrypt

```circom
pragma circom 2.2.2;

include "aes256-gcm-circom/circuits/aesGcm/gcmDecrypt.circom";

template VerifyAndDecrypt() {
    var keyBits = 256;
    var ivLength = 12;
    var textLength = 32;
    var aadLength = 16;

    signal input {byte} ciphertext[textLength];
    input Word() key[8];
    signal input {byte} iv[ivLength];
    signal input {byte} aad[aadLength];
    signal input {byte} authTag[16];

    signal output {byte} plaintext[textLength];
    signal output isValid;

    (plaintext, isValid) <== GcmDecrypt(keyBits, ivLength, textLength, aadLength)(
        ciphertext, key, iv, aad, authTag
    );

    // Assert authentication succeeded
    isValid === 1;
}

component main = VerifyAndDecrypt();
```

## Testing

Run the test suite:

```bash
npm test
```

The tests cover:
- Block encryption (single AES block)
- CTR mode encryption/decryption
- Galois field arithmetic
- Counter increment operations
- Full GCM encryption/decryption
- Various key sizes (128, 192, 256 bits)
- Different IV lengths
- AAD authentication

## Project Structure

```
aes256-gcm-circom/
├── circuits/
│   ├── aesGcm/
│   │   ├── gcmEncrypt.circom      # Main GCM encryption
│   │   ├── gcmDecrypt.circom      # Main GCM decryption
│   │   ├── ctrEncrypt.circom      # CTR mode encryption
│   │   ├── ctrDecrypt.circom      # CTR mode decryption
│   │   ├── encryptBlock.circom    # AES block cipher
│   │   ├── galoisField.circom     # GF(2^128) operations
│   │   └── counter.circom         # Counter operations
│   └── utils/
│       ├── arithmetic.circom      # Arithmetic utilities
│       ├── bits.circom            # Bit manipulation
│       └── bus.circom             # Bus/Word operations
├── tests/
│   ├── gcmEncrypt.test.ts
│   ├── gcmDecrypt.test.ts
│   ├── ctrEncrypt.test.ts
│   ├── encryptBlock.test.ts
│   └── galoisField.test.ts
├── package.json
└── README.md
```

## Constraints

Approximate constraint counts:

| Operation | Key Size | Text Length | Constraints |
|-----------|----------|-------------|-------------|
| Block Encrypt | 256-bit | 16 bytes | ~50K |
| CTR Encrypt | 256-bit | 16 bytes | ~50K |
| CTR Encrypt | 256-bit | 32 bytes | ~100K |
| GCM Encrypt | 256-bit | 16 bytes, 0 AAD | ~150K |
| GCM Encrypt | 256-bit | 32 bytes, 16 AAD | ~300K |

*Note: Constraint count scales with plaintext and AAD length. Each additional 16-byte block adds approximately 50K constraints.*

## Performance Tips

1. **Minimize text length**: Use the smallest plaintext size that fits your use case
2. **Standard IV**: Use 12-byte IV for optimal performance (avoids GHASH computation)
3. **Limit AAD**: Additional authenticated data increases constraint count
4. **Memory allocation**: Increase Node.js heap for large circuits:
   ```bash
   NODE_OPTIONS='--max-old-space-size=8192' npm test
   ```

## Technical Details

### AES Implementation
- Supports AES-128, AES-192, and AES-256
- Full key expansion with Rijndael S-box
- Standard AES rounds (10/12/14 for 128/192/256-bit keys)

### GCM Mode
- CTR mode for confidentiality
- GHASH for authentication
- Supports standard (12-byte) and non-standard IV lengths
- Authenticated encryption with additional data (AEAD)

### Galois Field Arithmetic
- GF(2^128) multiplication for GHASH
- Optimized implementations available
- Reduction polynomial: x^128 + x^7 + x^2 + x + 1

## Security Notes

- This implementation is for zero-knowledge proof circuits
- Side-channel resistance is not applicable in ZK context
- Authentication tag verification is enforced in decryption circuits
- Key should be kept private (used as witness input, not public signal)

## Dependencies

- `circomlib`: Standard Circom library
- `circom_tester`: Testing framework
- `snarkjs`: Proof generation and verification

## Contributing

Contributions are welcome! Please submit issues or pull requests.

## License

MIT License - see LICENSE file for details

## References

- [NIST SP 800-38D](https://nvlpubs.nist.gov/nistpubs/Legacy/SP/nistspecialpublication800-38d.pdf) - GCM Specification
- [FIPS 197](https://nvlpubs.nist.gov/nistpubs/FIPS/NIST.FIPS.197.pdf) - AES Specification
- [Circom Documentation](https://docs.circom.io/)

## Author

June

## Acknowledgments

Built for zero-knowledge proof applications requiring authenticated encryption within circuits.
