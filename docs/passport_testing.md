# Testing with Real Passports

## Security Warning ⚠️

- Never share your passport's private keys or sensitive data
- Only extract public certificates
- Keep your passport's chip secure and only read it using official apps
- Follow your country's regulations regarding passport data access

## Prerequisites

1. NFC-enabled device (iPhone or Android)
2. Passport with chip (indicated by this symbol: 📘)
3. Access to your country's CSCA certificates (public)

## Getting the Certificates

### 1. CSCA Certificate

The Country Signing CA (CSCA) certificate should be obtained from your country's official source:

- Usually available on government PKD (Public Key Directory) websites
- Can be requested from your country's passport issuing authority
- Some countries publish them in official gazettes

Example sources:

- ICAO PKD: https://pkddownloadsg.icao.int/
- EU DSC/CSCA repository: https://ec.europa.eu/assets/eu-pki/

### 2. Document Signer Certificate (DSC)

The DSC is stored in your passport's chip. You can extract it using:

#### Official Apps

- Many countries provide official passport verification apps
- These apps can often export the DSC
- Check your country's passport authority website

#### Third-Party Apps (Use with caution)

Some apps can read passport certificates:

- "ReadID" (iOS/Android)
- "NFC Tools" (iOS/Android)
- "NFC TagInfo" (Android)

## Testing Process

1. Save the certificates:

```bash
# Place your certificates in test-certs directory
cp path/to/your/dsc.cer test-certs/
cp path/to/your/csca.cer test-certs/
```

2. Run the validator:

```bash
.build/release/PassportCertValidator test-certs/dsc.cer test-certs/csca.cer
```

## Troubleshooting

If validation fails, check:

1. Certificate format (must be DER/CER)
2. Certificate chain (DSC must be signed by CSCA)
3. Certificate dates (not expired)
4. Certificate revocation status

## Legal Notice

- Check your local laws regarding passport data extraction
- Some countries restrict access to passport chip data
- Only use official channels when possible
- This tool is for educational purposes only
