//
//  ContentView.swift
//  BuyMe
//
//  Created by Γιάννης on 20/9/24.
//

import SwiftUI
import AppKit
import CoreData


struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
            entity: Product.entity(),
            sortDescriptors: [NSSortDescriptor(keyPath: \Product.name, ascending: true)]
        ) private var products: FetchedResults<Product>
    
    @State private var showAddProductForm = false
    @State private var productName = ""
    @State private var productLink = ""
    @State private var productPrice = "" // Keep this as String
    @State private var productImage: NSImage = NSImage(named: NSImage.Name("placeholder")) ?? NSImage(size: NSSize(width: 100, height: 100))
    
    
    var totalPrice: Double {
           products.reduce(0) { $0 + $1.price }
    }

    var body: some View {
        VStack {
            // Total Price Display
            Text("Total: €\(totalPrice, specifier: "%.2f")")
                .font(.headline)
                .padding()

            // Grid of products
            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 5), spacing: 20) {
                    ForEach(products) { product in
                        // Wrap the square in a button to make it clickable
                        Button(action: {
                            openLink(url: product.link ?? "https://www.google.com") // Open the link when the square is clicked
                        }) {
                            VStack {
                                if let imageData = product.image, let image = NSImage(data: imageData) {
                                    Image(nsImage: image)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 100, height: 100)
                                }else {
                                    // Display a placeholder image or text if no image is available
                                    Text("No Image")
                                        .frame(width: 100, height: 100)
                                        .background(Color.gray.opacity(0.2)) // Optional background color for better visibility
                                        .cornerRadius(10)
                                        .foregroundColor(.gray)
                                }
                                
                                Text(product.name ?? "")
                                
                                // Display the price here
                                Text(String(format: "€%.2f", product.price)) // Format the price
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .cornerRadius(10)
                            .onHover { inside in
                                if inside {
                                    NSCursor.pointingHand.push()
                                } else {
                                    NSCursor.pop()
                                }
                            }
                            .contextMenu {
                                Button(action: {
                                    deleteProduct(product)
                                }) {
                                    Text("Delete")
                                    Image(systemName: "trash")
                                }
                            }
                        }
                    }
                }
                
                .padding()
            }
        }
        .toolbar {
            ToolbarItem(placement: .automatic) {
                Button(action: {
                    showAddProductForm.toggle()
                }) {
                    Image(systemName: "plus")
                        .font(.system(size: 20, weight: .bold))
                }
            }
        }
        .sheet(isPresented: $showAddProductForm) {
            AddProductForm(productName: $productName, productLink: $productLink, productPrice: $productPrice, productImage: $productImage,onAddProduct: {
                addProduct()
                showAddProductForm = false  // Dismiss the form after adding
            }, onCancel: {
                productName = ""
                productLink = ""
                productPrice = ""
                productImage = NSImage(named: NSImage.Name("placeholder")) ?? NSImage(size: NSSize(width: 100, height: 100))

                showAddProductForm = false
            })
        }
        .frame(minWidth: 400, minHeight: 400) // Set minimum size for the window
    }

    func addProduct() {
       if let price = Double(productPrice) {
           // Create a new product entity
           let newProductEntity = Product(context: viewContext)
           newProductEntity.id = UUID() // Ensure unique ID
           newProductEntity.name = productName
           newProductEntity.link = productLink
           newProductEntity.price = price
           newProductEntity.image = productImage.tiffRepresentation // Convert NSImage to Data

           // Save to Core Data
           PersistenceController.shared.saveContext()

           productName = ""
           productLink = ""
           productPrice = ""
           productImage = NSImage(named: NSImage.Name("placeholder")) ?? NSImage(size: NSSize(width: 100, height: 100))
       }
   }



    func deleteProduct(_ product: Product) {
           viewContext.delete(product)
           PersistenceController.shared.saveContext()
       }
   }

    // Function to open a link
    func openLink(url: String) {
        if let productURL = URL(string: url) {
            NSWorkspace.shared.open(productURL)
        }
    }

