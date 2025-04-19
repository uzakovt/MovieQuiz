import UIKit

final class AlertPresenter: AlertPresenterProtocol {
    weak var delegate: AlertPresenterDelegate?
    func showAlert(alertData: AlertModel?, id: String) {
        guard let alertData else {
            delegate?.didPresentAlert(alert: nil)
            return
        }
        let alert = UIAlertController(
            title: alertData.title,
            message: alertData.text,
            preferredStyle: .alert)
        let action = UIAlertAction(title: alertData.buttonText, style: .default){
            _ in
            alertData.completion()
        }
        alert.addAction(action)
        alert.view.accessibilityIdentifier = id
        delegate?.didPresentAlert(alert: alert)
    }
}
