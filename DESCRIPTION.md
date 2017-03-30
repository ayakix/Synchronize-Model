お気に入り状態などを複数の画面で同期させる方法

## 概要
アイテムをテーブルビューで一覧表示し、タップすると詳細画面に飛ぶ。
詳細画面でアイテムを「お気に入り」して、前の画面に戻ると、一覧ではお気に入りになってない。
みたいなパターンをよく作ると思います。

また、NSNotificationを使って「お気に入り」イベントを通知し、ビューの状態を変更しても、元のモデルが変更されていないため、テーブルビューをスクロールして再描画した時に、お気に入り状態が戻ってしまったりします。

このような場合には、「モデルを修正→モデルに基づいてビューを再描画する」という手順を守る必要があります。

## 動作例
<img src="https://github.com/ayakix/Synchronize-Model/raw/master/images/animation.gif" alt="animation" width="300">

## 目指すべき形
下記ViewControllerでは、viewDidLoadでモデルの変更通知を受け取ります。
ModelChangeableを実装することで、モデルの変更を受け取り、modelsを変更すること、テーブルビューを再描画します。
こうすることで、データとビューに差が生まれることを防げきます。

```swift
class ViewController: UIViewController {
    @IBOutlet fileprivate weak var tableView: UITableView!

    var models = [Model]() {
        didSet {
            tableView?.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        addDidChangeModelObserver()
    }

    deinit {
        removeDidChangeModelObserver()
    }
}

extension ViewController: ModelChangeable {
    func updateModel(_ model: Model) {
        models = models.map({ $0.id == model.id ? model : $0 })
    }

    func deleteModel(_ model: Model) {
        models = models.filter({ $0.id != model.id })
    }
}
```

## 構成
### Model
サンプルのモデルではidとお気に入り状態を保持します。

```swift
struct Model {
    let id: Int
    var isFavorite: Bool
}
```

### ModelChangeable
変更されたモデル受け取るクラスが実装すべきプロトコルを宣言します。
今回のサンプルでは、モデルのUpdateとDelete操作に対応するとします。

```swift
protocol ModelChangeable {
    func updateModel(_ model: Model)
    func deleteModel(_ model: Model)
}
```

### ModelNotification
通知を送信したり、受信した通知のペイロードから値を取得するUtilityです。

```swift
enum NotificationEventType: Int {
    case update
    case delete
}

private enum NotificationInfoKey: String {
    case model
    case eventType
}

extension NSNotification.Name {
    static let didChangeModel = Notification.Name(rawValue: "changed_model")
}

struct ModelNotification {
    static func update(model: Model) {
        post(model: model, eventType: .update)
    }

    static func delete(model: Model) {
        post(model: model, eventType: .delete)
    }

    private static func post(model: Model, eventType: NotificationEventType) {
        let userInfo: [String: Any] = [
            NotificationInfoKey.model.rawValue: model,
            NotificationInfoKey.eventType.rawValue: eventType
        ]
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: .didChangeModel, object: nil, userInfo: userInfo)
        }
    }

    static func getModel(from notification: Notification) -> Model? {
        guard
            let userInfo = notification.userInfo,
            let model = userInfo[NotificationInfoKey.model.rawValue] as? Model else {
                return nil
        }
        return model
    }

    static func getEventType(from notification: Notification) -> NotificationEventType? {
        guard
            let userInfo = notification.userInfo,
            let eventType = userInfo[NotificationInfoKey.eventType.rawValue] as? NotificationEventType else {
                return nil
        }
        return eventType
    }
}
```

### ModelObserving
モデル変更を受け取りたいクラスが実装すべき関数を定義したプロトコルです。
例では、ViewControllerについて実装しています。

```swift
protocol ModelObserving {
    func addDidChangeModelObserver(notificationCenter: NotificationCenter)
    func removeDidChangeModelObserver(notificationCenter: NotificationCenter)
    func didChangeModel(_ notification: Notification)
}

// MARK: - UIViewController

extension UIViewController: ModelObserving {
    func addDidChangeModelObserver(notificationCenter: NotificationCenter = NotificationCenter.default) {
        notificationCenter.addObserver(self, selector: #selector(didChangeModel(_:)), name: .didChangeModel, object: nil)
    }

    func removeDidChangeModelObserver(notificationCenter: NotificationCenter = NotificationCenter.default) {
        notificationCenter.removeObserver(self, name: .didChangeModel, object: nil)
    }

    func didChangeModel(_ notification: Notification) {
        guard
            let modelChangeableThing = self as? ModelChangeable,
            let model = ModelNotification.getModel(from: notification),
            let eventType = ModelNotification.getEventType(from: notification) else {
                return
        }

        switch eventType {
        case .update:
            modelChangeableThing.updateModel(model)
        case .delete:
            modelChangeableThing.deleteModel(model)
        }
    }
}
```

### 通知の発行
詳細画面において、モデルの状態に変更があった時に、通知を発行します。
そうすると、ModelChangeableを実装したViewControllerのupdateModelやdeleteModelが呼び出されます。

```swift
class DetailViewController: UIViewController {    
    @IBAction private func onFavoriteButtonClick(_ sender: UIButton) {
        ModelNotification.update(model: model)
    }

    @IBAction private func onDeleteButtonClick(_ sender: UIButton) {
        ModelNotification.delete(model: model)
    }
}
```

## サンプル
[Synchronize-Model@github](https://github.com/ayakix/Synchronize-Model)に動作するプロジェクトがあります。
