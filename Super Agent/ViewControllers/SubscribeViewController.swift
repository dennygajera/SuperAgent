
import UIKit
import StoreKit

class SubscribeViewController: UIViewController, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    var productIdentifiers: Set<String> = [Config.App.subscribeProductId]
    var productID = ""
    var productsRequest = SKProductsRequest()
    var iapProducts = [SKProduct]()
    var delegate: SubscribeViewControllerDelegate?
    
    var purchasingProduct1: SKProduct?
    var purchasingProduct2: SKProduct?
    
    var tempId: Int = 0
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print(response.products)
        if response.products.count > 0 {
            iapProducts = response.products
            self.showProducts()
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        print("paymentQueue")
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchasing:
                print("purchasing")
            case .purchased:
                self.complitePurchase()
                print("purchased")
            case .failed:
                print("failed")
            case .restored:
                self.complitePurchase()
                print("restored")
            case .deferred:
                print("deferred")
            }
        }
    }
    
    func complitePurchase() {
//        UserDefaults.standard.set(true, forKey: "isBuyed")
        self.delegate?.subscribed()
        self.dismiss(animated: true, completion: nil)
    }
    
    func compare(_ date: Date) {
        let comp = Date().compare(date)
        print("compare: \(comp == .orderedAscending)")
        if (comp == .orderedAscending) {
            self.complitePurchase()
        }
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        for transaction in queue.transactions {
            let t: SKPaymentTransaction = transaction
            let prodID = t.payment.productIdentifier as String
            if t.transactionState == .restored || t.transactionState == .purchased {
                switch prodID {
                case Config.App.subscribeProductId:
                    print(1)
                    if let date1 = t.transactionDate?.add(years: 0, months: 0, days: 7, hours: 0, minutes: 0, seconds: 0) {
                        self.compare(date1)
                    }
                    
                default:
                    print("paymentQueueRestoreCompletedTransactionsFinished error")
                }
            }
        }
            
    }
    
    func canMakePurchases() -> Bool {
        return SKPaymentQueue.canMakePayments()
    }
    
    func purchaseProduct(product: SKProduct) {
        if self.canMakePurchases() {
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(payment)
            SKPaymentQueue.default().add(self)
            productID = product.productIdentifier //also show loader
        }
    }
    
    func restorePurchases() {
        SKPaymentQueue.default().add(self)
        if (SKPaymentQueue.canMakePayments()) {
            print("restore")
            SKPaymentQueue.default().restoreCompletedTransactions()
        }
    }
    
    func showProducts() {
        DispatchQueue.main.async {
            self.iapProducts.forEach({print($0.productIdentifier)})
            if let product1 = self.iapProducts.first(where: {$0.productIdentifier == Config.App.subscribeProductId}) {
                self.purchasingProduct1 = product1
                self.label1.text = product1.priceLocale.currencySymbol! + product1.price.description(withLocale: product1.priceLocale)
            }
        }
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.fetchAvailableProducts()
    }
    
    func fetchAvailableProducts() {
        productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
        productsRequest.delegate = self
        productsRequest.start()
    }
    
    @IBOutlet weak var label1: UILabel!
    

    @IBAction func card1Action() {
        if self.purchasingProduct1 != nil {
            self.purchaseProduct(product: self.purchasingProduct1!)
        }
    }
    
    @IBAction func close() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func privacyAction() {
        if let url = URL(string: Constants.Links.privacyPolicy) {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func termsAction() {
        if let url = URL(string: Constants.Links.termsOfUse) {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func restoreAction() {
        self.restorePurchases()
    }
}

protocol SubscribeViewControllerDelegate {
    func subscribed()
}
