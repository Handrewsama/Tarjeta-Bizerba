import SwiftUI
import UIKit

struct ContentView: View {
    @EnvironmentObject private var store: CardStore
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            CardHomeView()
                .tabItem { Label("Tarjeta", systemImage: "person.text.rectangle") }
                .tag(0)

            QRScreenView()
                .tabItem { Label("QR", systemImage: "qrcode") }
                .tag(1)

            EditCardView()
                .tabItem { Label("Editar", systemImage: "pencil") }
                .tag(2)
        }
        .tint(.primary)
    }
}

struct CardHomeView: View {
    @EnvironmentObject private var store: CardStore
    @State private var showingShare = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 18) {
                    VStack(spacing: 6) {
                        Text(store.card.company)
                            .font(.system(size: 26, weight: .bold))
                        Text(store.card.fullName)
                            .font(.system(size: 30, weight: .bold))
                        Text(store.card.jobTitle)
                            .font(.headline)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.top, 20)

                    contactRows

                    NavigationLink {
                        QRScreenView()
                    } label: {
                        Label("MOSTRAR QR", systemImage: "qrcode")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)

                    Button {
                        showingShare = true
                    } label: {
                        Label("COMPARTIR CONTACTO", systemImage: "square.and.arrow.up")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.large)
                }
                .padding()
            }
            .navigationTitle("Mi tarjeta")
            .sheet(isPresented: $showingShare) {
                ShareSheet(items: [VCardFile.create(from: store.card)])
            }
        }
    }

    private var contactRows: some View {
        VStack(alignment: .leading, spacing: 12) {
            if !store.card.phone.isEmpty { Label(store.card.phone, systemImage: "phone.fill") }
            if !store.card.email.isEmpty { Label(store.card.email, systemImage: "envelope.fill") }
            if !store.card.website.isEmpty { Label(store.card.website, systemImage: "globe") }
            if !store.card.address.isEmpty { Label(store.card.address, systemImage: "mappin.and.ellipse") }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 18))
    }
}

struct QRScreenView: View {
    @EnvironmentObject private var store: CardStore
    @State private var fairMode = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                if fairMode {
                    Text(store.card.fullName)
                        .font(.system(size: 30, weight: .bold))
                    Text(store.card.company)
                        .font(.title3.weight(.semibold))
                } else {
                    Text("Escanea para guardar mi contacto")
                        .font(.headline)
                }

                QRCodeView(value: store.card.vCard)
                    .frame(maxWidth: fairMode ? 380 : 320, maxHeight: fairMode ? 380 : 320)

                if fairMode {
                    Text("ESCANÉAME")
                        .font(.title2.bold())
                }

                Toggle("Modo feria", isOn: $fairMode)
                    .padding(.horizontal)
            }
            .padding()
            .navigationTitle("QR")
        }
    }
}

struct EditCardView: View {
    @EnvironmentObject private var store: CardStore
    @State private var showResetAlert = false

    var body: some View {
        NavigationStack {
            Form {
                Section("Identidad") {
                    TextField("Nombre", text: $store.card.firstName)
                    TextField("Apellidos", text: $store.card.lastName)
                    TextField("Cargo", text: $store.card.jobTitle)
                    TextField("Empresa", text: $store.card.company)
                }

                Section("Contacto") {
                    TextField("Móvil", text: $store.card.phone)
                        .keyboardType(.phonePad)
                    TextField("Teléfono trabajo", text: $store.card.workPhone)
                        .keyboardType(.phonePad)
                    TextField("Email", text: $store.card.email)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                    TextField("Web", text: $store.card.website)
                        .keyboardType(.URL)
                        .textInputAutocapitalization(.never)
                    TextField("Dirección", text: $store.card.address, axis: .vertical)
                }

                Section {
                    Button("Restaurar datos iniciales", role: .destructive) {
                        showResetAlert = true
                    }
                }
            }
            .navigationTitle("Editar tarjeta")
            .alert("Restaurar datos", isPresented: $showResetAlert) {
                Button("Cancelar", role: .cancel) {}
                Button("Restaurar", role: .destructive) { store.reset() }
            } message: {
                Text("Se sustituirán tus datos actuales por los datos de ejemplo iniciales.")
            }
        }
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

#Preview {
    ContentView().environmentObject(CardStore())
}


private enum VCardFile {
    static func create(from card: ContactCard) -> URL {
        let url = FileManager.default.temporaryDirectory
            .appendingPathComponent("\(card.fullName.replacingOccurrences(of: " ", with: "_"))_contact.vcf")
        try? card.vCard.data(using: .utf8)?.write(to: url)
        return url
    }
}
