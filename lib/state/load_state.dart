/// Status pemuatan data satu bagian layar.
///
/// `idle` = belum pernah dimuat, `empty` = berhasil tetapi tanpa data.
/// Ditampilkan oleh `AsyncStateView`.
enum LoadState { idle, loading, ready, empty, error }
