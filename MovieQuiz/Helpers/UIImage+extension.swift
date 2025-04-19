import UIKit

extension UIImage {
    public static func loadFromData(data: Data) throws -> UIImage{
        guard let imageData = UIImage(data: data) else { throw ImageError.imageLoadFromDataError }
        return imageData
    }
}

private enum ImageError: Error{
    case imageLoadFromDataError
}
