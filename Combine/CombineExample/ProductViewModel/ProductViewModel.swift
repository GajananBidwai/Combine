//
//  ProductViewModel.swift
//  CombineExample
//
//  Created by Neosoft on 10/09/25.
//

import Foundation
import Combine

class ProductViewModel{
    
    var productData: [Product] = []
    var cancellables: Set<AnyCancellable> = []
    
    func getProductData(){
        ApiHelper.shared.getData(url: Constant.Api.product.rawValue, type: Product.self)
            .sink { (completion) in
                switch completion{
                    
                case .failure(let error):
                    print("Error \(error.localizedDescription)")
                case .finished:
                    print("Finished")
                }
            } receiveValue: { [weak self] product in
                self?.productData = product
                //print(self?.productData)
            }
            .store(in: &cancellables)

        

    }
    
}
