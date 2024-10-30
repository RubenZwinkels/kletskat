import SwiftUI

struct BondStatusBarView: View {
    var bondLevel: Int // Moet tussen 0 en 100 liggen

    var body: some View {
        VStack(alignment: .leading) {
            Text("Band")
                .font(.headline)
            
            ZStack(alignment: .leading) {
                // Achtergrond van de balk met rand
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.black, lineWidth: 5) // Zwarte rand om de balk
                    .frame(height: 20)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                
                // Gevulde balk op basis van bondLevel
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: CGFloat(bondLevel) * 4.0, height: 20)
                    .foregroundColor(bondLevel > 50 ? .green : .orange)
            }
            .animation(.easeInOut(duration: 0.5), value: bondLevel) // Animatie bij verandering
        }
        .padding()
    }
}

#Preview {
    BondStatusBarView(bondLevel: 5)
}
