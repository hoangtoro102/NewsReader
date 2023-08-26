//
//  DetailRow.swift
//  NewsReader
//
//  Created by MacBook on 26/08/2023.
//

import SwiftUI

struct DetailRow: View {
    let titleLabel: Text
    let dateLabel: Text
    let imageView: ImageView
    
    init(titleLabel: Text, dateLabel: Text, imageView: ImageView) {
        self.titleLabel = titleLabel
        self.dateLabel = dateLabel
        self.imageView = imageView
    }
    
    var body: some View {
        HStack {
            imageView
                .frame(width: 120, height: 120)
            VStack(alignment: .leading) {
                titleLabel
                    .font(.headline)
                    .truncationMode(.tail)
                Spacer()
                dateLabel
                    .font(.callout)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: 120, alignment: .leading)
    }
}

#if DEBUG
struct DetailRow_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = ImageView.ViewModel(imageURL: URL(string: NetworkConstants.defaultImageUrl)!)
        DetailRow(titleLabel: Text("4,000 Beagles Are Being Rescued From a Virginia Facility. Now They Need New Homes."), dateLabel: Text("12/12/2022"), imageView: ImageView(viewModel: viewModel))
            .previewLayout(.fixed(width: 375, height: 60))
    }
}
#endif
