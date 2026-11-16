library;

/// Barrel model domain yang dipakai UI/repository.
/// Sumber definisi masih di `dummy_data.dart` agar role lain tidak rusak;
/// DummyData (seed statis) sengaja tidak diekspor dari sini.
export '../data/dummy_data.dart'
    show
        AnnouncementItem,
        AppNotice,
        AttendanceHistoryItem,
        AttendanceSlice,
        AttendanceStatus,
        AttendanceStatusStyle,
        ChildAttendanceDay,
        ClassItem,
        NoticeKind,
        NoticeKindLabel,
        ScheduleItem,
        StudentItem,
        WeekDay;
