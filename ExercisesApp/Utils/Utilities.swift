

import UIKit
import Nuke
// MARK: Core Image Integrations

/// Blurs image using CIGaussianBlur filter. Only blurs first scans of the
/// progressive JPEG.
struct _ProgressiveBlurImageProcessor: ImageProcessing, Hashable {
    func process(_ image: PlatformImage) -> PlatformImage? {
        return image
    }

    func process(_ container: ImageContainer, context: ImageProcessingContext) -> ImageContainer? {
        // CoreImage is too slow on simulator.
        #if targetEnvironment(simulator)
        return container
        #else
        guard !context.isFinal else {
            return container // No processing.
        }

        guard let scanNumber = container.userInfo[ImageDecoder.scanNumberKey] as? Int else {
            return container
        }

        // Blur partial images.
        if scanNumber < 5 {
            // Progressively reduce blur as we load more scans.
            let radius = max(2, 14 - scanNumber * 4)
            let filter = CIFilter(name: "CIGaussianBlur", parameters: ["inputRadius" : radius])
            return container.map {
                ImageProcessors.CoreImageFilter.apply(filter: filter, to: $0)
            }
        }

        // Scans 5+ are already good enough not to blur them.
        return container
        #endif
    }

    let identifier: String = "_ProgressiveBlurImageProcessor"

    var hashableIdentifier: AnyHashable {
        return self
    }
}

