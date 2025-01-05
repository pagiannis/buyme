//
//  AddProductForm.swift
//  BuyMe
//
//  Created by Γιάννης on 20/9/24.
//
import SwiftUI
import AppKit

struct AddProductForm: View {
    @Binding var productName: String
    @Binding var productLink: String
    @Binding var productPrice: String // Keep this as a String
    @Binding var productImage: NSImage
    
    var onAddProduct: () -> Void
    var onCancel: () -> Void // Closure for cancel action

    var body: some View {
        VStack {
            TextField("Product Name", text: $productName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.top, 25)
                .padding(8)

            TextField("Product Link", text: $productLink)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(8)

            TextField("Product Price", text: $productPrice)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(8)
            
            Button(action: {
                selectImage()
            }) {
                Text("Select Product Image")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(5)
            }
            .buttonStyle(PlainButtonStyle()) // Remove default button border
            .frame(maxWidth: 300)
            
            Image(nsImage: productImage)
               .resizable()
               .aspectRatio(contentMode: .fit)
               .frame(width: 100, height: 100)
               .padding(8)
            
            // Buttons in a horizontal stack
            HStack {
                Button(action: {
                    onCancel() // Call onCancel to dismiss the form
                }) {
                    Text("Cancel")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(5)
                }
                .buttonStyle(PlainButtonStyle()) // Remove default button border
                
                Button(action: {
                    onAddProduct()
                }) {
                    Text("Add Product")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(5)
                }
                .buttonStyle(PlainButtonStyle()) // Remove default button border
            }
            .padding(.top, 15)
            .padding()

            Spacer()
        }
        .frame(width: 600, height: 450)
        .padding()
    }
    
    // Image selection logic using NSOpenPanel
    func selectImage() {
        let panel = NSOpenPanel()
        panel.allowedFileTypes = ["png", "jpg", "jpeg","hec"]
        panel.canChooseFiles = true
        panel.canChooseDirectories = false
        panel.allowsMultipleSelection = false
        
        if panel.runModal() == .OK, let url = panel.url, let selectedImage = NSImage(contentsOf: url) {
            productImage = selectedImage
        }
    }
}
