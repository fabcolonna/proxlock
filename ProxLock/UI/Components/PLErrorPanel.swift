import SwiftUI

struct PLErrorPanel: View {
    let errorKey: String

    var body: some View {
        HStack {
            Image(systemName: "exclamationmark.triangle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 30, height: 30)

            VStack(alignment: .leading) {
                Text("error.title").font(.system(size: 14, weight: .bold))

                Text(LocalizedStringKey(errorKey))
                    .frame(alignment: .leading)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.leading)
            }
        }
    }
}
