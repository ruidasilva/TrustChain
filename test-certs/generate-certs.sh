#!/bin/bash

# Exit on any error
set -e

echo "Generating test certificates for PassportCertValidator..."

# Generate CSCA (Country Signing CA) certificate
echo "1. Generating CSCA certificate..."
openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:4096 -out csca.key
openssl req -x509 -new -key csca.key -outform DER -out csca.cer -days 3650 \
    -subj "/C=XX/O=Test CSCA/CN=Test Country Signing CA"

# Generate DSC (Document Signer Certificate)
echo "2. Generating DSC certificate..."
openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:2048 -out dsc.key
openssl req -new -key dsc.key -out dsc.csr \
    -subj "/C=XX/O=Test DSC/CN=Test Document Signer"
openssl x509 -req -in dsc.csr -CA csca.cer -CAform DER -CAkey csca.key \
    -CAcreateserial -outform DER -out dsc.cer -days 1825

# Clean up intermediate files
rm -f dsc.csr csca.srl

# Convert CSCA to PEM for verification
openssl x509 -inform DER -in csca.cer -out csca.pem

# Verify the certificate chain
echo "3. Verifying certificate chain..."
openssl verify -CAfile csca.pem <(openssl x509 -inform DER -in dsc.cer)
rm csca.pem  # Clean up temporary PEM file

echo "Done! Test certificates generated successfully."
echo "Files created:"
echo "  - csca.cer: Country Signing CA certificate (DER format)"
echo "  - csca.key: Country Signing CA private key"
echo "  - dsc.cer:  Document Signer Certificate (DER format)"
echo "  - dsc.key:  Document Signer private key"
echo
echo "You can now test the validator with:"
echo ".build/release/PassportCertValidator test-certs/dsc.cer test-certs/csca.cer" 