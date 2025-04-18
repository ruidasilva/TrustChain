// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import Security

// MARK: - Error Types
enum CertificateError: Error {
    case invalidPath
    case failedToLoadCertificate
    case failedToCreateTrust
    case invalidCertificate
    case trustEvaluationFailed(String)
}

// MARK: - Certificate Loading Functions
func loadCertificate(from path: String) throws -> SecCertificate {
    guard let certData = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
        throw CertificateError.invalidPath
    }
    
    guard let certificate = SecCertificateCreateWithData(nil, certData as CFData) else {
        throw CertificateError.failedToLoadCertificate
    }
    
    return certificate
}

// MARK: - Certificate Validation
func validateDSC(_ dscPath: String, against cscaPath: String) throws {
    print("Loading certificates...")
    // Load certificates
    let dscCertificate = try loadCertificate(from: dscPath)
    let cscaCertificate = try loadCertificate(from: cscaPath)
    
    print("Creating trust evaluation...")
    // Create trust with DSC certificate
    var trust: SecTrust?
    let policy = SecPolicyCreateBasicX509()
    let status = SecTrustCreateWithCertificates(
        dscCertificate,
        policy,
        &trust
    )
    
    guard status == errSecSuccess, let trustObj = trust else {
        throw CertificateError.failedToCreateTrust
    }
    
    print("Setting trust anchors...")
    // Set CSCA as trusted anchor
    let anchorCertificates = [cscaCertificate] as CFArray
    SecTrustSetAnchorCertificates(trustObj, anchorCertificates)
    SecTrustSetAnchorCertificatesOnly(trustObj, true)
    
    print("Evaluating trust...")
    // Evaluate trust
    var error: CFError?
    let trustResult = SecTrustEvaluateWithError(trustObj, &error)
    
    if trustResult {
        print("✅ DSC is valid against CSCA")
    } else {
        let errorMessage = error.map { String(describing: $0) } ?? "Unknown error"
        throw CertificateError.trustEvaluationFailed(errorMessage)
    }
}

// MARK: - Main
func main() {
    guard CommandLine.arguments.count == 3 else {
        print("Usage: PassportCertValidator <dsc-path> <csca-path>")
        print("  dsc-path:  Path to Document Signer Certificate (.cer or .der)")
        print("  csca-path: Path to Country Signing CA Certificate (.cer or .der)")
        exit(1)
    }
    
    let dscPath = CommandLine.arguments[1]
    let cscaPath = CommandLine.arguments[2]
    
    print("Starting certificate validation...")
    do {
        try validateDSC(dscPath, against: cscaPath)
    } catch CertificateError.invalidPath {
        print("❌ Error: Invalid certificate file path")
        exit(1)
    } catch CertificateError.failedToLoadCertificate {
        print("❌ Error: Failed to load certificate - make sure the files are in DER format (.cer or .der)")
        exit(1)
    } catch CertificateError.failedToCreateTrust {
        print("❌ Error: Failed to create trust evaluation")
        exit(1)
    } catch CertificateError.trustEvaluationFailed(let message) {
        print("❌ Error: Trust evaluation failed - \(message)")
        exit(1)
    } catch {
        print("❌ Error: Unexpected error occurred - \(error)")
        exit(1)
    }
}

main()
