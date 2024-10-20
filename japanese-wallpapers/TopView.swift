struct TopView: View {
    @State private var wallpaperController = WallpaperController()

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 20) {
                    ForEach(wallpaperController.categoriesLight) { category in
                        CategoryWallpaperView(category: category)
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Wallpapers")
        }
        .refreshable {
            await wallpaperController.fetchCategoriesLight()
        }
        .task {
            await wallpaperController.fetchCategoriesLight()
        }
    }
}
