import 'package:flutter/foundation.dart';

import '../core/errors/data_exception.dart';
import 'load_state.dart';

/// Helper bersama untuk controller role (Guru, Orang Tua, Kepala Sekolah).
///
/// Setiap layar punya pasangan field `xxxState` + `xxxError`. Mixin ini
/// menyatukan alur standar agar tiap method controller cukup berisi
/// logika bisnisnya saja:
///
/// 1. set `loading`, hapus error lama, beri tahu UI
/// 2. jalankan [task]
/// 3. set `ready` / `empty` / `error` sesuai hasil, beri tahu UI lagi
mixin AsyncRunner on ChangeNotifier {
  /// Menjalankan proses baca data (fetch) untuk satu bagian layar.
  ///
  /// [update] menulis hasil ke field state & error milik controller.
  /// [task] mengembalikan [LoadState] akhir (biasanya `ready` atau `empty`).
  /// [stateOnError] dipakai bila kode error tertentu harus tampil sebagai
  /// kondisi lain, mis. `no_linked_child` ditampilkan sebagai `empty`.
  @protected
  Future<void> runLoad({
    required void Function(LoadState state, String? error) update,
    required Future<LoadState> Function() task,
    required String fallbackError,
    LoadState Function(DataException error)? stateOnError,
  }) async {
    update(LoadState.loading, null);
    notifyListeners();
    try {
      update(await task(), null);
    } on DataException catch (error) {
      update(stateOnError?.call(error) ?? LoadState.error, error.message);
    } catch (_) {
      update(LoadState.error, fallbackError);
    }
    notifyListeners();
  }

  /// Menjalankan aksi tulis (simpan/ubah) yang menampilkan indikator sibuk.
  ///
  /// Berbeda dengan [runLoad], error tetap dilempar ulang supaya layar bisa
  /// menampilkan snackbar. Error non-[DataException] dibungkus agar UI
  /// cukup menangani satu tipe exception.
  @protected
  Future<T> runAction<T>({
    required void Function(bool busy) setBusy,
    required void Function(String? error) setError,
    required Future<T> Function() task,
    required String fallbackError,
  }) async {
    setBusy(true);
    setError(null);
    notifyListeners();
    try {
      return await task();
    } on DataException catch (error) {
      setError(error.message);
      rethrow;
    } catch (_) {
      setError(fallbackError);
      throw DataException(fallbackError, code: 'unknown');
    } finally {
      setBusy(false);
      notifyListeners();
    }
  }

  /// `empty` jika daftar kosong, selain itu `ready`.
  @protected
  LoadState stateForList(Iterable<Object?> items) {
    return items.isEmpty ? LoadState.empty : LoadState.ready;
  }
}
