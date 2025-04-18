# PassportCertValidator

A Swift command-line tool that validates a passport's Document Signer Certificate (DSC) against a trusted Country Signing Certificate Authority (CSCA) certificate using Apple's Security framework.

## Features

- Loads DER-encoded X.509 certificates (.cer or .der format)
- Validates DSC against a trusted CSCA certificate
- Uses Apple's Security framework for robust certificate validation
- Provides clear error messages for common failure cases

## Requirements

- macOS 10.15 or later
- Swift 5.0 or later
- Xcode 11.0 or later (for development)

## Installation

1. Clone the repository:

```bash
git clone https://github.com/ruidasilva/TrustChain.git
cd PassportCertValidator
```

2. Build the project:

```bash
swift build -c release
```

3. The executable will be created in `.build/release/PassportCertValidator`

## Usage

```bash
PassportCertValidator <dsc-path> <csca-path>
```

Arguments:

- `dsc-path`: Path to the Document Signer Certificate file (.cer or .der format)
- `csca-path`: Path to the Country Signing CA Certificate file (.cer or .der format)

Example:

```bash
.build/release/PassportCertValidator /path/to/dsc.cer /path/to/csca.cer
```

## Testing Options

1. [Test with Generated Certificates](test-certs/README.md)

   - Use the provided script to generate test certificates
   - Good for development and initial testing

2. [Test with Real Passports](docs/passport_testing.md)
   - Instructions for testing with actual passport certificates
   - Security considerations and legal notices
   - Links to official certificate sources

## Output

- If validation succeeds, the tool prints: "✅ DSC is valid against CSCA"
- If validation fails, the tool prints an error message explaining the reason

## Error Handling

The tool handles the following error cases:

- Invalid certificate file paths
- Failed certificate loading
- Trust evaluation failures
- Invalid certificate format
- Certificate chain validation errors

## Security Considerations

- The tool only accepts DER-encoded X.509 certificates
- CSCA certificate is set as the only trusted anchor
- Full certificate chain validation is performed
- Clear error messages without exposing sensitive information

## Legal Notice

This tool is for educational and testing purposes only. When working with real passport data:

- Follow your country's regulations regarding passport data access
- Only use official channels to obtain CSCA certificates
- Never share private keys or sensitive passport data
- Keep your passport's chip secure

## License

MIT License
