import SwiftUI

struct PaywallView: View {
    @EnvironmentObject var purchases: PurchaseManager
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            VStack(spacing: 20) {
                Image(systemName: "bolt.fill")
                    .font(.system(size: 48))
                    .foregroundStyle(Theme.accent2)
                Text("Depostrack Pro")
                    .font(Theme.titleFont)
                    .foregroundStyle(Theme.ink)
                Text("Auto-reconcile deposits against final invoice totals")
                    .font(Theme.bodyFont)
                    .foregroundStyle(Theme.inkMuted)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                if let product = purchases.product {
                    Button {
                        Task { await purchases.purchase() }
                    } label: {
                        Text("Unlock for \(product.displayPrice)")
                            .font(Theme.headlineFont)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Theme.accent)
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                    .accessibilityIdentifier("purchaseButton")
                    .padding(.horizontal)
                } else {
                    ProgressView()
                }
                Button("Restore Purchases") {
                    Task { await purchases.restore() }
                }
                .font(Theme.captionFont)
                Button("Not Now") { dismiss() }
                    .font(Theme.captionFont)
                    .foregroundStyle(Theme.inkMuted)
                    .accessibilityIdentifier("dismissPaywallButton")
            }
            .padding()
        }
    }
}
