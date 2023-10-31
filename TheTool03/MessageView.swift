import SwiftUI

struct MessageView: View {
    @Binding var showMessage: Bool
    var message: String
    
    var body: some View {
        VStack {
            Text(message)
                .padding()
                .background(Color.black.opacity(0.5))
                .foregroundColor(.white)
                .cornerRadius(10)
            Spacer()
        }
        .offset(y: showMessage ? 0 : -200)
        .animation(.easeInOut(duration: 0.16), value: showMessage)
    }
}

