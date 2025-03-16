import UIKit

final class ResultAlertPresenter: AlertPresenterProtocol {
    weak var delegate: AlertPresenterDelegate?
    func showAlert(alertData: AlertModel?) {
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
        delegate?.didPresentAlert(alert: alert)
    }
}
