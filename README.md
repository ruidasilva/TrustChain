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
git clone [repository-url]
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

## Output

- If validation succeeds, the tool prints: "DSC is valid against CSCA"
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

## License

MIT License
