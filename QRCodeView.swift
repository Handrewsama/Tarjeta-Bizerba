import SwiftUI
import CoreImage.CIFilterBuiltins

struct QRCodeView: View {
    let value: String
    private let context = CIContext()

    var body: some View {
        Group {
            if let image = makeQR(from: value) {
                Image(uiImage: image)
                    .interpolation(.none)
                    .resizable()
                    .scaledToFit()
                    .padding(16)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(radius: 8)
            } else {
                ContentUnavailableView("QR unavailable", systemImage: "qrcode")
            }
        }
    }

    private func makeQR(from string: String) -> UIImage? {
        let filter = CIFilter.qrCodeGenerator()
        filter.message = Data(string.utf8)
        filter.correctionLevel = "M"
        guard let output = filter.outputImage else { return nil }
        let scaled = output.transformed(by: CGAffineTransform(scaleX: 12, y: 12))
        guard let cgImage = context.createCGImage(scaled, from: scaled.extent) else { return nil }
        return UIImage(cgImage: cgImage)
    }
}
