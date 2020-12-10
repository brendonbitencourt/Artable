//
//  CheckoutViewController.swift
//  Artable
//
//  Created by Brendon Bitencourt Braga on 2020-12-08.
//  Copyright © 2020 Brendon Bitencourt Braga. All rights reserved.
//

import UIKit
import Stripe
import FirebaseFunctions

class CheckoutViewController: UIViewController {
    
    // Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var paymentMethodButton: UIButton!
    @IBOutlet weak var shippingMethodButton: UIButton!
    @IBOutlet weak var subtotalLabel: UILabel!
    @IBOutlet weak var processingFeeLabel: UILabel!
    @IBOutlet weak var shippingCostLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // Variables
    var paymentContext: STPPaymentContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupTableView()
        self.setupPaymentInfo()
        self.setupStripeConfig()
    }
    
    func setupTableView() {
        let identifier = Identifiers.CartItemTableViewCell
        let nib = UINib(nibName: identifier, bundle: nil)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(nib, forCellReuseIdentifier: identifier)
    }
    
    func setupPaymentInfo() {
        subtotalLabel.text = StripeCart.subtotal.penniesToFormattedCurrency()
        processingFeeLabel.text = StripeCart.processingFees.penniesToFormattedCurrency()
        shippingCostLabel.text = StripeCart.shippingFees.penniesToFormattedCurrency()
        totalLabel.text = StripeCart.total.penniesToFormattedCurrency()
    }
    
    func setupStripeConfig() {
        let config = STPPaymentConfiguration.shared()
        config.createCardSources = true
        config.requiredBillingAddressFields = .none
        config.requiredShippingAddressFields = [.postalAddress]
        let customerContext = STPCustomerContext(keyProvider: StripeApi)
        paymentContext = STPPaymentContext(customerContext: customerContext, configuration: config, theme: .default())
        paymentContext?.paymentAmount = StripeCart.total
        paymentContext?.delegate = self
        paymentContext?.hostViewController = self
    }
    
    @IBAction func placeOrderClicked(_ sender: Any) {
        activityIndicator.startAnimating()
        paymentContext?.requestPayment()
    }
    
    @IBAction func paymentMethodClicked(_ sender: Any) {
        paymentContext?.pushPaymentOptionsViewController()
    }
    
    @IBAction func shippingMethodClicked(_ sender: Any) {
        paymentContext?.pushShippingViewController()
    }

}

extension CheckoutViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StripeCart.cartItem.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.CartItemTableViewCell, for: indexPath) as? CartItemTableViewCell {
            
            let product = StripeCart.cartItem[indexPath.row]
            cell.setupCell(product: product, delegate: self)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}

extension CheckoutViewController: CartItemDelegate {
    func removeProduct(product: Product) {
        StripeCart.removeItemFromCart(item: product)
        tableView.reloadData()
        setupPaymentInfo()
        paymentContext?.paymentAmount = StripeCart.total
    }
}

extension CheckoutViewController: STPPaymentContextDelegate {
    
    func paymentContextDidChange(_ paymentContext: STPPaymentContext) {
        if let paymentMethod = paymentContext.selectedPaymentOption {
            paymentMethodButton.setTitle(paymentMethod.label, for: .normal)
        } else {
            paymentMethodButton.setTitle("Select Method", for: .normal)
        }
        
        if let shippingMethod = paymentContext.selectedShippingMethod {
            shippingMethodButton.setTitle(shippingMethod.label, for: .normal)
            StripeCart.shippingFees = Int(Double(truncating: shippingMethod.amount) * 100)
            setupPaymentInfo()
        } else {
            shippingMethodButton.setTitle("Select Method", for: .normal)
        }
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFailToLoadWithError error: Error) {
        activityIndicator.stopAnimating()
        
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            self.navigationController?.popViewController(animated: true)
        }
        
        let retry = UIAlertAction(title: "Retry", style: .default) { (action) in
            self.paymentContext?.retryLoading()
        }
        
        alertController.addAction(cancel)
        alertController.addAction(retry)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didCreatePaymentResult paymentResult: STPPaymentResult, completion: @escaping STPErrorBlock) {
        
        let idempotency = UUID().uuidString.replacingOccurrences(of: "-", with: "")
        let data: [String: Any] = [
            "total": StripeCart.total,
            "customer_id": UserService.user.stripeId,
            "idempotency": idempotency
        ]
            
        Functions.functions().httpsCallable("createCharge").call(data) { (result, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
                self.simpleAlert(title: "Error", message: "Unable to call the function")
                completion(error)
                return
            }
            
            StripeCart.clearCart()
            self.tableView.reloadData()
            self.setupPaymentInfo()
            completion(nil)
        }
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFinishWith status: STPPaymentStatus, error: Error?) {
        
        let title: String?
        let message: String?
        
        activityIndicator.stopAnimating()
        
        switch status {
            case .success:
                title = "Sucess"
                message = "Thank you for your purchase."
            case .error:
                title = "Error"
                message = error?.localizedDescription
            case .userCancellation:
                return
            @unknown default:
                return
        }
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default) { (action) in
            self.navigationController?.popViewController(animated: true)
        }
        
        alertController.addAction(action)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didUpdateShippingAddress address: STPAddress, completion: @escaping STPShippingMethodsCompletionBlock) {
        
        let upsGround = PKShippingMethod()
        upsGround.amount = 0
        upsGround.label = "UPS Ground"
        upsGround.detail = "Arrives in 3-5 days"
        upsGround.identifier = "ups_ground"
        
        let fedEx = PKShippingMethod()
        fedEx.amount = 6.99
        fedEx.label = "FedEx"
        fedEx.detail = "Arrives tomorrow"
        fedEx.identifier = "fedex"
        
        if address.country == "US" {
            completion(.valid, nil, [upsGround, fedEx], fedEx)
        } else {
            completion(.invalid, nil, nil, nil)
        }
    }
    
}
