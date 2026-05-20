import SwiftUI
import WeatherFeature
import WeatherCore

struct ContentView: View {
    @State private var viewModel = WeatherViewModel()

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    ProgressView("Fetching Australian weather…")
                } else if let error = viewModel.errorMessage {
                    ContentUnavailableView(error, systemImage: "cloud.bolt")
                } else {
                    List(viewModel.readings) { reading in
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(reading.city.name)
                                    .font(.headline)
                                Text(reading.weatherDescription)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            Text(reading.temperatureDisplay)
                                .font(.title2)
                                .bold()
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("🇦🇺 Weather Board")
            .task {
                await viewModel.fetchAll()
            }
        }
    }
}
