//
//  PayWallView.swift
//  japanese-wallpapers
//
//  Created by Julian Beck on 25.09.25.
//

import RevenueCat
import SwiftUI

struct PayWallView: View {
    @EnvironmentObject var globalViewModel: GlobalViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var showCloseButton = false
    @State private var closeButtonProgress: CGFloat = 0.0
    private let allowCloseAfter: CGFloat = 4.0
    @State private var animateGradient = false
    @State private var isFreeTrialEnabled: Bool = true

    var calculateSavedPercentage: Int {
        guard let lifetime = globalViewModel.offering?.lifetime,
              let weekly = globalViewModel.offering?.weekly else {
            return 75 // Default savings percentage
        }

        let lifetimePrice = NSDecimalNumber(decimal: lifetime.storeProduct.price).doubleValue
        let weeklyYearlyPrice = NSDecimalNumber(decimal: weekly.storeProduct.price).doubleValue * 52

        if weeklyYearlyPrice > 0 {
            return Int((100 - ((lifetimePrice / weeklyYearlyPrice) * 100)).rounded())
        }
        return 75 // Default savings percentage
    }

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [Color.black, Color.black.opacity(0.9), Color.red.opacity(0.7)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            // Gradient orb in background (Japanese aesthetic)
            GeometryReader { geometry in
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.red.opacity(0.6),
                                Color.orange.opacity(0.3)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: geometry.size.width * 0.8)
                    .position(x: geometry.size.width * 0.5, y: geometry.size.height * 0.3)
                    .blur(radius: 60)
            }
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {
                    // Close button with progress circle
                    HStack {
                        Spacer()
                        Button(action: {
                            if showCloseButton {
                                presentationMode.wrappedValue.dismiss()
                            }
                        }) {
                            ZStack {
                                Circle()
                                    .stroke(lineWidth: 2)
                                    .opacity(0.3)
                                    .foregroundColor(.white)

                                Circle()
                                    .trim(from: 0, to: closeButtonProgress)
                                    .stroke(style: StrokeStyle(lineWidth: 2, lineCap: .round))
                                    .foregroundColor(.white)
                                    .rotationEffect(.degrees(-90))

                                Image(systemName: "xmark")
                                    .foregroundColor(showCloseButton ? .white : .white.opacity(0.5))
                                    .font(.system(size: 12, weight: .bold))
                            }
                            .frame(width: 30, height: 30)
                        }
                        .disabled(!showCloseButton)
                    }
                    .padding(.horizontal)

                    // Header
                    VStack(spacing: 16) {
                        Image(systemName: "photo.artframe")
                            .font(.system(size: 48))
                            .foregroundColor(.white)

                        Text("Japan Art Premium")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.3), radius: 3, x: 0, y: 2)
                    }

                    // Features list
                    VStack(alignment: .leading, spacing: 20) {
                        FeatureRow(icon: "infinity", text: "Unlimited wallpaper downloads")
                        FeatureRow(icon: "tv.slash.fill", text: "No ads ever")
                        FeatureRow(icon: "calendar.badge.plus", text: "New wallpapers added weekly")
                        FeatureRow(icon: "sparkles", text: "Premium Japanese AI artwork")
                    }
                    .padding(.vertical, 16)
                    .padding(.horizontal, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.black.opacity(0.5))
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(.ultraThinMaterial)
                            )
                    )
                    .padding(.horizontal)

                    if let offering = globalViewModel.offering,
                       let lifetime = offering.lifetime,
                       let weekly = offering.weekly {

                        VStack(spacing: 8) {
                            // Lifetime option (primary) - compact
                            Button(action: { isFreeTrialEnabled = false }) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 2) {
                                        HStack {
                                            Text("Lifetime Access")
                                                .font(.system(size: 16, weight: .bold))
                                                .foregroundColor(.white)

                                            Text("SAVE 90%")
                                                .font(.system(size: 10, weight: .bold))
                                                .padding(.horizontal, 6)
                                                .padding(.vertical, 2)
                                                .background(Color.red)
                                                .foregroundColor(.white)
                                                .cornerRadius(4)
                                        }

                                        Text("\(lifetime.localizedPriceString)")
                                            .font(.system(size: 18, weight: .bold))
                                            .foregroundColor(.white)
                                    }
                                    Spacer()

                                    Circle()
                                        .stroke(!isFreeTrialEnabled ? Color.white : Color.white.opacity(0.3), lineWidth: 2)
                                        .frame(width: 20, height: 20)
                                        .overlay(
                                            Circle()
                                                .fill(!isFreeTrialEnabled ? Color.white : Color.clear)
                                                .frame(width: 12, height: 12)
                                        )
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.black.opacity(0.7))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(Color.orange, lineWidth: !isFreeTrialEnabled ? 2 : 1)
                                        )
                                )
                            }

                            // Weekly with trial option - compact
                            Button(action: { isFreeTrialEnabled = true }) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 2) {
                                        HStack {
                                            Text("3-Day Trial")
                                                .font(.system(size: 16, weight: .bold))
                                                .foregroundColor(.white)

                                            Text("FREE")
                                                .font(.system(size: 10, weight: .bold))
                                                .padding(.horizontal, 6)
                                                .padding(.vertical, 2)
                                                .background(Color.green)
                                                .foregroundColor(.white)
                                                .cornerRadius(4)
                                        }

                                        Text("then \(weekly.localizedPriceString) per week")
                                            .font(.system(size: 14, weight: .medium))
                                            .foregroundColor(.white.opacity(0.8))
                                    }
                                    Spacer()

                                    Circle()
                                        .stroke(isFreeTrialEnabled ? Color.white : Color.white.opacity(0.3), lineWidth: 2)
                                        .frame(width: 20, height: 20)
                                        .overlay(
                                            Circle()
                                                .fill(isFreeTrialEnabled ? Color.white : Color.clear)
                                                .frame(width: 12, height: 12)
                                        )
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.black.opacity(0.7))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(Color.green, lineWidth: isFreeTrialEnabled ? 2 : 1)
                                        )
                                )
                            }

                            // Free Trial Toggle - compact
                            HStack {
                                Text("Free Trial Enabled")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.white)
                                Spacer()
                                Toggle("", isOn: $isFreeTrialEnabled)
                                    .tint(.green)
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.black.opacity(0.7))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                                    )
                            )

                            // Purchase button
                            Button(action: {
                                let package = isFreeTrialEnabled ? weekly : lifetime
                                globalViewModel.purchase(package: package)
                            }) {
                                HStack {
                                    if globalViewModel.isPurchasing {
                                        ProgressView()
                                            .tint(.white)
                                            .padding(.trailing, 8)
                                    }

                                    Text(isFreeTrialEnabled ? "Start Free Trial" : "Unlock Lifetime Access")
                                        .fontWeight(.semibold)
                                        .font(.system(.body, design: .rounded))

                                    if !globalViewModel.isPurchasing {
                                        Image(systemName: "chevron.right")
                                    }
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Color.red)
                                .foregroundColor(.white)
                                .cornerRadius(25)
                                .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 2)
                            }
                            .disabled(globalViewModel.isPurchasing)
                            .padding(.top, 2)
                        }
                        .padding(.horizontal)
                    } else {
                        ProgressView()
                            .tint(.white)
                            .padding()
                    }

                    // Error message
                    if let errorMessage = globalViewModel.errorMessage {
                        Text(errorMessage)
                            .font(.callout)
                            .foregroundColor(.red)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.black.opacity(0.5))
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(.ultraThinMaterial)
                                    )
                            )
                            .padding(.horizontal)
                    }

                    // Footer links
                    HStack(spacing: 16) {
                        Button("Restore Purchases") {
                            globalViewModel.restorePurchase()
                        }
                        .font(.footnote)
                        .foregroundColor(.white)

                        Divider()
                            .frame(height: 12)
                            .background(Color.white.opacity(0.3))

                        Link("Terms", destination: URL(string: "https://juli.sh/terms")!)
                            .font(.footnote)
                            .foregroundColor(.white)

                        Divider()
                            .frame(height: 12)
                            .background(Color.white.opacity(0.3))

                        Link("Privacy", destination: URL(string: "https://juli.sh/privacy")!)
                            .font(.footnote)
                            .foregroundColor(.white)
                    }
                    .padding(.bottom, 24)
                }
                .padding(.vertical)
                .frame(maxWidth: min(UIScreen.main.bounds.width, 600))
                .padding(.horizontal)
            }
        }
        .onAppear {
            startCloseButtonTimer()
            Plausible.shared.trackPageview(path: "/paywall")
        }
        .interactiveDismissDisabled(!showCloseButton)
    }

    private func startCloseButtonTimer() {
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            if closeButtonProgress < 1.0 {
                closeButtonProgress += 0.1 / allowCloseAfter
            } else {
                showCloseButton = true
                timer.invalidate()
            }
        }
    }
}

struct FeatureRow: View {
    let icon: String
    let text: String

    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(Color.red.opacity(0.2))
                    .frame(width: 36, height: 36)

                Image(systemName: icon)
                    .foregroundColor(.white)
                    .font(.system(size: 18))
            }

            Text(text)
                .font(.system(size: 17, weight: .semibold, design: .rounded))
                .foregroundColor(.white)
            Spacer()
        }
        .padding(.horizontal)
    }
}

#Preview {
    PayWallView()
        .environmentObject(GlobalViewModel())
}