# Use of Cryptography in the Tiqr core library

This document describes how the Tiqr core library uses cryptography. It describes which cryptographic standards are implemented in the library, and for which cryptographic functionality the library uses the platform's (i.e. iOS's) implementation. The goal of this document is to help responsible persons navigate import and export requirements regarding the use of cryptography.

The Tiqr core library implements authenticator functionality using the OATH Challenge-Response Algorithm (OCRA) defined in RFC 6287 (https://www.rfc-editor.org/rfc/rfc6287.txt). The Tiqr core library contains a mechanism to encrypt the secret that is used by the OCRA protocol using a PIN that is provided by the user and/or a key stored in the platform's secure enclave.

* The Tiqr core library uses the platform's implementation for all encryption / decryption.

* The Tiqr core library is open source software. See https://github.com/Tiqr/tiqr-app-core-ios

* The Tiqr core library implements a client in the Tiqr protocol described on https://tiqr.org/technical/

* The Tiqr core library sends messages over HTTPS using the platform's APIs

* The Tiqr core library contains an implementation of OCRA (RFC 6287). This OCRA implementation uses the platform's HMAC (RFC 2104) implementation with the platform's implementation of the SHA-1 and SHA-2 family of hashing algorithms (FIPS 180-4).

* OCRA uses a shared secret between the Tiqr client and the Tiqr server. The Tiqr core library can store this secret in two ways:
  1. The OCRA secret is stored encrypted with an encryption key that is stored in the secure enclave
  2. The OCRA secret is stored encrypted with a PIN that is provided by the user. The encryption key is derived from the PIN using the platform's implementation of PBKDF2 (RFC 2898) with the platform's implementation of SHA256 (FIPS 180-4)

  The shared secret is encrypted with the (derived) encryption key using the platforms implementation of AES CBC (FIPS 197)
* The Tiqr core library contains an implementation of HOTP (RFC 4226). This HOTP implementation uses the platform's HMAC (RFC 2104) implementation with the platform's implementation of the SHA-1 hashing algorithm (FIPS 180-4).