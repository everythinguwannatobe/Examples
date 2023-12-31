import SwiftUI
import Northwind

@available(iOS 16.0, macOS 13, *)
struct MainView: View {

  enum Section: String {
    case products
  }
  enum Detail {
    case product(Product)
  }
  
  /// The active section in the sidebar
  @State private var section : Section? = .products

  /// The array of products that got fetched
  @State private var products : [ Product ] = []

  /// We track the currently selected product
  @State private var selectedProductID : Product.ID?

  
  private var selectedProduct : Product? {
    selectedProductID.flatMap { id in products.first(where: { $0.id == id })}
  }
  
  private func updateSavedProduct(_ product: Product) {
    guard let idx = products.firstIndex(where: { $0.id == product.id }) else {
      return // not in the list?
    }
    products[idx] = product
  }
  

  var body: some View {
    NavigationSplitView(
      
      sidebar: {
        Sidebar(section: $section)
      },
      
      content: {
        switch section {
          case .products:
            ProductsList(products: $products,
                         selectedProduct: $selectedProductID)
              #if os(macOS)
                .frame(minWidth: 274) // otherwise overlaps on macOS 13
              #endif
          
          case .none:
            Text("No section is selected")
        }
      },
      
      detail: {
        if let product = selectedProduct {
          ProductPage(snapshot: product, onSave: updateSavedProduct)
        }
        else {
          Text("Nothing Selected")
            .font(.title)
            .foregroundColor(.accentColor)
        }
      }
    )
  }
}
